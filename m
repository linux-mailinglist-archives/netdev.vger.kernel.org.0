Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 67C238C4B7
	for <lists+netdev@lfdr.de>; Wed, 14 Aug 2019 01:20:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726530AbfHMXUp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Aug 2019 19:20:45 -0400
Received: from mail-qk1-f193.google.com ([209.85.222.193]:37661 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726365AbfHMXUo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Aug 2019 19:20:44 -0400
Received: by mail-qk1-f193.google.com with SMTP id s14so10713766qkm.4
        for <netdev@vger.kernel.org>; Tue, 13 Aug 2019 16:20:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=J0DMpyYyM3X6Hvz3/EVS8w8HC8xNXRwl/8MCGxONgsQ=;
        b=l43c+Lr097hHOe77FVahq5jTGhcXtuXJmnTDdYiR6t4mn7Hpjshju36xxYIZ57c9jS
         F7K+hc2LE6RICrZBBpO1KmYy3+MhySPju5ICzs1vfEyjPg8dSayL63wMN+xdbpoyUN8K
         KVdCL7+vvHghknhAOduZaqP8FuOc7Zgy6O7c0TVj24hegyTQqHVZCxCongZKublLkjgc
         3xTKi/hQAStvpTg4IvTLBuAgR3uauDCSsiOZWfdjukpwXC+qPmH79IPZKn5wnpFmcruk
         KrMT7JjPPh5aa+uAOXXiqFl+Q/y9rGAVl7cGLteVrrnAjhWtuBQTkTnHrmW8QeGccMH3
         i9FA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=J0DMpyYyM3X6Hvz3/EVS8w8HC8xNXRwl/8MCGxONgsQ=;
        b=Iyc+y132uplspM3DuCAXvk0eLYVCtsVLB1DkKberFLRxn1QCL1Et/Dvgtgliz6y6vY
         R3u6G2wfbMr9N4idp8LuKGzd2KN1J+BS56u0yLBJ+p6UKOwMqzq0SBu9EkgdhOMMR7B0
         0I481I1wFAC9lS1APA6o2nLsqMff2nk95a1raKlCkstFs35NblgpVjuJV7QYNgIrko4h
         iEzKYZTZ7SJPHEtLipZC9aaQDyBvPbmblTct26ZGMYb5snlDnSdUm24rKLl6tZ0BZQyK
         9cP4eS5y5LLzVG59TiCuwiqJ6DaaLeGoTJR4FYIdeXC/hAWV6wvi7Pou1Th0bXcUATzP
         aMOg==
X-Gm-Message-State: APjAAAV8jPKxICJspg+F4zHZgzlmuvoPevmeWB9Km+OdECGAgUMC3zj2
        7VuvPUn1iNvyLBgGrUiEEtjm4g==
X-Google-Smtp-Source: APXvYqwQwnfwv4BerGOU33PwhMvvICCI+FWrwGm8PP+HOE9gmQCYt/v/uagXW7XBS8FLnV5yGyOcuQ==
X-Received: by 2002:a37:2f05:: with SMTP id v5mr35886331qkh.143.1565738444060;
        Tue, 13 Aug 2019 16:20:44 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id d22sm3018679qto.45.2019.08.13.16.20.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Aug 2019 16:20:43 -0700 (PDT)
Date:   Tue, 13 Aug 2019 16:20:34 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     YueHaibing <yuehaibing@huawei.com>
Cc:     <yisen.zhuang@huawei.com>, <salil.mehta@huawei.com>,
        <davem@davemloft.net>, <lipeng321@huawei.com>,
        <tanhuazhong@huawei.com>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next] net: hns3: Make hclge_func_reset_sync_vf
 static
Message-ID: <20190813162034.4aada930@cakuba.netronome.com>
In-Reply-To: <20190812144156.70020-1-yuehaibing@huawei.com>
References: <20190812144156.70020-1-yuehaibing@huawei.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 12 Aug 2019 22:41:56 +0800, YueHaibing wrote:
> Fix sparse warning:
> 
> drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c:3190:5:
>  warning: symbol 'hclge_func_reset_sync_vf' was not declared. Should it be static?
> 
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>

Applied, thanks.
