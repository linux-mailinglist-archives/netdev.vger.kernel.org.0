Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9DFE350E47F
	for <lists+netdev@lfdr.de>; Mon, 25 Apr 2022 17:34:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242953AbiDYPhw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Apr 2022 11:37:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242896AbiDYPhh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Apr 2022 11:37:37 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68BDF433A6
        for <netdev@vger.kernel.org>; Mon, 25 Apr 2022 08:34:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=vc1vJetyCALjeiVyC0eBJf01H1rtj5i6FT62DV6fiXA=; b=TKYbrZFLIVsze4hCpmbRBoe78z
        HlDjS593V41cZQVGLcjZMXK5EBrDCqk2f8wQjJb7LLAv0KMP6p9ZX/f4s1GJXJbGs747UEU+oRuX2
        KmZcIou0hLP96N8mzzIW0FXKmqk0B03X/xViKbRVl7KJO54ixzyKKNSJukPVi1Ey2++4F5QMVzl6c
        05fqvEufdg2wdoaEF2A5r+uzgmoFb0o2/N4mVnR4IucLaaN8d0O7gIATEFYnbytLpFkSzUN3Y9Ylm
        iLAvVgMhejqcb6E04mij6W1tFF2Y3lcMZtwEDkLGJCOdUveG4HOGt2m5UhcUsksNblIE+Nc6R6YwC
        i6RzWq7Q==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:58400)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1nj0jL-0007RU-RN; Mon, 25 Apr 2022 16:34:27 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1nj0jJ-0006ez-7A; Mon, 25 Apr 2022 16:34:25 +0100
Date:   Mon, 25 Apr 2022 16:34:25 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Baruch Siach <baruch@tkos.co.il>
Cc:     Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>,
        netdev@vger.kernel.org, Baruch Siach <baruch.siach@siklu.com>
Subject: Re: [PATCH] net: phy: marvell10g: fix return value on error
Message-ID: <Yma/gSb2bRYMflV0@shell.armlinux.org.uk>
References: <f47cb031aeae873bb008ba35001607304a171a20.1650868058.git.baruch@tkos.co.il>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f47cb031aeae873bb008ba35001607304a171a20.1650868058.git.baruch@tkos.co.il>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 25, 2022 at 09:27:38AM +0300, Baruch Siach wrote:
> From: Baruch Siach <baruch.siach@siklu.com>
> 
> Return back the error value that we get from phy_read_mmd().
> 
> Fixes: c84786fa8f91 ("net: phy: marvell10g: read copper results from CSSR1")
> Signed-off-by: Baruch Siach <baruch.siach@siklu.com>

Reviewed-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>

Thanks!

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
