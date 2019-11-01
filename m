Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 998ECEC3F8
	for <lists+netdev@lfdr.de>; Fri,  1 Nov 2019 14:45:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727411AbfKANpE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Nov 2019 09:45:04 -0400
Received: from mail-wr1-f50.google.com ([209.85.221.50]:36774 "EHLO
        mail-wr1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727297AbfKANpD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Nov 2019 09:45:03 -0400
Received: by mail-wr1-f50.google.com with SMTP id w18so9738620wrt.3
        for <netdev@vger.kernel.org>; Fri, 01 Nov 2019 06:45:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=dcM+hZJgHuMWPr9eUUiXCshJPPn9/4d6JINM/NEG7JA=;
        b=sspuLcn5IkI2o8z8LU6RmB5h+5hXqfhUXVmkUT05czJkUtsVKDfRbEbUvlL/sFoaF+
         /lQesnahNrTfU0inGN8tKaiXYk9Pl11Iu1nGhdlHMl3+YvKxmmMOdDWiC2nTYHpRzdA0
         EE5ToHJz3KcC7Av+XftNU7pQ+lPU1eNP1zzO5MWiEJ5Rb2UdgHSjEB+5ZaWYV5iCDxWD
         ZUtgSICxAgnXTNRYH41r2rAByRIOzQX6hAnnphkEFCOWmJHECkkcSVxS4kBHnpDYVJ22
         teEachdno/y4dsajxbOtKgwHFsLCHxI2ZCys1O+povwd6Pr4lgtrQyEO3d0nM4F3/V4v
         sSgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=dcM+hZJgHuMWPr9eUUiXCshJPPn9/4d6JINM/NEG7JA=;
        b=jXt9UoaGyVJS8rvR7OdpACLZal1euzSUx1uIKNhsiyFv2+cfB1l7j8mbLDbdJttaVT
         wOPWR0YW0XNuq/Sf07oClRf03Ldg+TylGNdCDLZdIz8+EF/E0XItyu0+7pQggLWqMt5/
         TJ/9Kf4Uc8HtbFGvcOlbfifkppIDN9LfeIqZOKsKVHkG6IYZEKTveFwKpua4bpatfd6G
         aRX2UYKI/FKR+uicSPdUuLylkDbYrzsGyyRk6t8JERJMvy+GAW54a8HMDdJdLAbV79cW
         ZQHuuV01KlH/6RaJrgEoXta6Rt16BU/s3Bx+SFmZpwmvYoZKPKV6PLINHSTa+/AfEd6L
         TUZQ==
X-Gm-Message-State: APjAAAXzCsDJVdk10X66RygmKzb/iCBw0v0E4aGIVU8woGi4c0AU/n24
        vDg6yFHvxTwtEKHajnEFkUe6pg==
X-Google-Smtp-Source: APXvYqwNa7hiw3fnsUuEvNLdsGN6pp59JJojpN4MasMayYWbV5bUNevmAckRi6pejkJZJxxnEUqkXw==
X-Received: by 2002:adf:fec7:: with SMTP id q7mr11071979wrs.267.1572615900359;
        Fri, 01 Nov 2019 06:45:00 -0700 (PDT)
Received: from netronome.com (fred-musen.rivierenbuurt.horms.nl. [2001:470:7eb3:404:a2a4:c5ff:fe4c:9ce9])
        by smtp.gmail.com with ESMTPSA id j22sm10213673wrd.41.2019.11.01.06.44.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Nov 2019 06:44:59 -0700 (PDT)
Date:   Fri, 1 Nov 2019 14:44:57 +0100
From:   Simon Horman <simon.horman@netronome.com>
To:     zhong jiang <zhongjiang@huawei.com>
Cc:     kvalo@codeaurora.org, stas.yakovlev@gmail.com,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH v2 0/3] wireless: remove unneeded variable and return 0
Message-ID: <20191101134456.GA5859@netronome.com>
References: <1572611621-13280-1-git-send-email-zhongjiang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1572611621-13280-1-git-send-email-zhongjiang@huawei.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 01, 2019 at 08:33:38PM +0800, zhong jiang wrote:
> The issue is detected with help of coccinelle.
> 
> v1 -> v2:
>    libipw_qos_convert_ac_to_parameters() make it void.

Reviewed-by: Simon Horman <simon.horman@netronome.com>
