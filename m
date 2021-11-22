Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0075A458FF6
	for <lists+netdev@lfdr.de>; Mon, 22 Nov 2021 15:07:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231856AbhKVOLA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Nov 2021 09:11:00 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:45512 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229984AbhKVOK7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Nov 2021 09:10:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=upueizCiMQuEceGsQAkUcPYoBnUQX/FnhfGm4yPF4Ew=; b=wqvlkKesOkzRaE1mbhhtICnk0R
        dx1qFizFYxDRWgfbk63DZSp4Gk/ba3+VkZ6BBe0tRHdKMGZftD5WUyq4O4F2/imKWnWXpqqK35gCG
        OOHO2zeTRs0eda1CRPqzK9obwUY4Ly8lc5hQRA/dyjIDvoBGGw1v6hco5szZWap131bg=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mp9ym-00EIVH-SB; Mon, 22 Nov 2021 15:07:32 +0100
Date:   Mon, 22 Nov 2021 15:07:32 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Yinbo Zhu <zhuyinbo@loongson.cn>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Michal Marek <michal.lkml@markovi.net>,
        Nick Desaulniers <ndesaulniers@google.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kbuild@vger.kernel.org
Subject: Re: [PATCH v1 1/2] modpost: file2alias: fixup mdio alias garbled
 code in modules.alias
Message-ID: <YZukJBsf3qMOOK+Y@lunn.ch>
References: <1637583298-20321-1-git-send-email-zhuyinbo@loongson.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1637583298-20321-1-git-send-email-zhuyinbo@loongson.cn>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 22, 2021 at 08:14:57PM +0800, Yinbo Zhu wrote:
> After module compilation, module alias mechanism will generate a ugly
> mdio modules alias configure if ethernet phy was selected, this patch
> is to fixup mdio alias garbled code.
> 
> In addition, that ugly alias configure will cause ethernet phy module
> doens't match udev, phy module auto-load is fail, but add this patch
> that it is well mdio driver alias configure match phy device uevent.

What PHY do you have problems with? What is the PHY id and which
driver should be loaded.

This code has existed a long time, so suddenly saying it is wrong and
changing it needs a good explanation why it is wrong. Being ugly is
not a good reason.

    Andrew
