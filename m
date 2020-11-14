Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82ED62B2F3B
	for <lists+netdev@lfdr.de>; Sat, 14 Nov 2020 18:51:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726181AbgKNRuR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Nov 2020 12:50:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:40400 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726150AbgKNRuQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 14 Nov 2020 12:50:16 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (c-67-180-217-166.hsd1.ca.comcast.net [67.180.217.166])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EEDAA22252;
        Sat, 14 Nov 2020 17:50:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605376215;
        bh=SWL+ZL/QchtfDwjUMZodHvzkWbW19llhLzd7xEw15z8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=eXkJ/JG/lb8AHgkwSG1/YYNwVsROtJ2Ib1RDHuDO2fcFmOO6Szur85ri6Et2qy1iZ
         a+I5boo0OZro7KlX/QafbTO6LweuSI+3l08NAZDypYbLfdrQmfgtV06VMEGhjHtfjU
         HgxgCXinhQWkEqNMX+YVKkqggbmW87p0a9NRQw1E=
Date:   Sat, 14 Nov 2020 09:50:14 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Zou Wei <zou_wei@huawei.com>
Cc:     <vishal@chelsio.com>, <davem@davemloft.net>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -next] cxgb4: Remove unused variable ret
Message-ID: <20201114095014.4b3fc7c6@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1605346706-23782-1-git-send-email-zou_wei@huawei.com>
References: <1605346706-23782-1-git-send-email-zou_wei@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 14 Nov 2020 17:38:26 +0800 Zou Wei wrote:
> This patch fixes below warning reported by coccicheck:
> 
> ./drivers/net/ethernet/chelsio/cxgb4/t4_hw.c:3284:5-8: Unneeded variable: "ret". Return "0" on line 3301
> 
> Signed-off-by: Zou Wei <zou_wei@huawei.com>

Some macro uses it implicitly, this breaks the build.
