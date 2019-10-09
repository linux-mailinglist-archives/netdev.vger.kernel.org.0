Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CCE34D04C2
	for <lists+netdev@lfdr.de>; Wed,  9 Oct 2019 02:29:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729708AbfJIA3M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Oct 2019 20:29:12 -0400
Received: from mail-qk1-f195.google.com ([209.85.222.195]:36466 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727051AbfJIA3M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Oct 2019 20:29:12 -0400
Received: by mail-qk1-f195.google.com with SMTP id y189so641788qkc.3
        for <netdev@vger.kernel.org>; Tue, 08 Oct 2019 17:29:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=vMfnOWFS7hoWopzdoB/oP+pX4lMqDN2ogIeLAMjJGpM=;
        b=If0hR/JnkxYsI1Z4+aQDuJsc7pPcOuPTjovsySgEzTR4B3O0xKQ4yCLqc9vEg0ccJr
         LQLZDlOGBkfL8d+Z4M/3P+eYUbNtvcwt3RItgkkuO4WasVlNdGJDzz4Ncb7/mFshlRxc
         DBYrZvDlXLHlPjKoC99DM+anc75DH1mDFD7vBfBxRmr1dfBsFr/yBN9Ma2iz/v7sLofo
         AMgLRfmhjmasCGAWKC92AGecDYvl8hGeT22WF6b9rT0EI/eDlK6YKUhaHR1/WGC7mUuk
         fRd5oxpVFaDn2MmgdaPP8r8GeOzRd8za+Pk29f6t1RtgK2GMPl4IL9BZOx1zSxD89NRn
         3JMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=vMfnOWFS7hoWopzdoB/oP+pX4lMqDN2ogIeLAMjJGpM=;
        b=W9C0br+SJn+Qhu1aNon00a6nP8icsRLekyWmB4A3VVFsDX2AspFWzGkekaBvbTKQYZ
         4e2+jGZOXB8jN4d2yRERe8eIjkhleshDpbRwJxS0XMJNi2WUfEb0H5sMMwi7xI2JnKoS
         cXtdNI3tA/qvy0mLV1acyRi05izat+iz8bXIJKmL0yENyijZjt0fEbvTdnvu4vzYO9MB
         7L9378McHcAbt1EltX0Nx7gDgcXZNf4jfJABAD1NVyWPjZf0OY4FyxldTPCQSX1gu3pD
         bygnyZgQ1Dnbg58BbyOwGg6WwLX5LGog5QzeOJpUY4GhmfYDIkUY6bVCK0aOymKewgX7
         pwQw==
X-Gm-Message-State: APjAAAVdcqSkGHxj2TR1rmf+l/GfHL0p6qKgU2REeQ32sMpbgeuMPtli
        88c5kBVAm2L6gyVfCKUP7pb5Kw==
X-Google-Smtp-Source: APXvYqwQ+sdgsS7xDoPKiu50I19WbFiRgi00VyFLOHwL2uyul3taQAjfTRkwnAgc9Z1koRFgNmhSZQ==
X-Received: by 2002:a37:a546:: with SMTP id o67mr1029746qke.392.1570580951221;
        Tue, 08 Oct 2019 17:29:11 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id a11sm193305qkc.123.2019.10.08.17.29.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Oct 2019 17:29:10 -0700 (PDT)
Date:   Tue, 8 Oct 2019 17:28:58 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Huazhong Tan <tanhuazhong@huawei.com>
Cc:     <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <salil.mehta@huawei.com>,
        <yisen.zhuang@huawei.com>, <linuxarm@huawei.com>
Subject: Re: [PATCH net-next 0/6] net: hns3: add some new feature
Message-ID: <20191008172858.44fd300a@cakuba.netronome.com>
In-Reply-To: <1570497609-36349-1-git-send-email-tanhuazhong@huawei.com>
References: <1570497609-36349-1-git-send-email-tanhuazhong@huawei.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 8 Oct 2019 09:20:03 +0800, Huazhong Tan wrote:
> This patch-set includes some new features for the HNS3 ethernet
> controller driver.
> 
> [patch 01/06] adds support for configuring VF link status on the host.
> 
> [patch 02/06] adds support for configuring VF spoof check.
> 
> [patch 03/06] adds support for configuring VF trust.
> 
> [patch 04/06] adds support for configuring VF bandwidth on the host.
> 
> [patch 05/06] adds support for configuring VF MAC on the host.
> 
> [patch 06/06] adds support for tx-scatter-gather-fraglist.

Applied.
