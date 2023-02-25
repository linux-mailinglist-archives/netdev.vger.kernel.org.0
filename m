Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A755E6A2B71
	for <lists+netdev@lfdr.de>; Sat, 25 Feb 2023 20:12:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229662AbjBYTMR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Feb 2023 14:12:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229458AbjBYTMQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Feb 2023 14:12:16 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B0A1136C9
        for <netdev@vger.kernel.org>; Sat, 25 Feb 2023 11:12:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=ehYtjN5CZeUvK2Vk+Sr5h+rU0UfW3i1Sw0qdtskSkww=; b=TsFTaEMNxnretKmFsnkHA7QgmE
        RiPnJOkEtzPBADPvihuji//flzqjNOtVJBL/M1qRL/wglTt6uof20tqrf9t+NnLMiLKYX6OBj6xmD
        FlzzX6J/X8ASIHslft7DA3GT3+8oYGWUlTZS9Xj3lnrR8RwVBtODmLZiHR+3+/s3MOmWrz233Apk5
        2pNpA0k8Okz2pGgxoTyMzJhKF1mgatAblLBeZi4iN+g755f7tab0jjL7iHa4TpAxAN2pGHsB8Y9Sv
        Xp5AQoS1wjdHF12sGVG6FG/fNGM+3e5YlfYRDuA+UnXQGLe5kA/jsRonrq1sqXieAPaR5vb8aWTU6
        VT6k0qMw==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:46530)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1pVzxW-0001lq-LO; Sat, 25 Feb 2023 19:11:50 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1pVzxQ-0008PB-7F; Sat, 25 Feb 2023 19:11:44 +0000
Date:   Sat, 25 Feb 2023 19:11:44 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Simon Horman <simon.horman@corigine.com>
Cc:     Daniel Golle <daniel@makrotopia.org>, Felix Fietkau <nbd@nbd.name>,
        John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: Re: [PATCH RFC net-next 4/4] net: mtk_eth_soc: note interface modes
 not set in supported_interfaces
Message-ID: <Y/pdcIKpM1QjdUdI@shell.armlinux.org.uk>
References: <Y/ivHGroIVTe4YP/@shell.armlinux.org.uk>
 <E1pVXJK-00CTAl-V7@rmk-PC.armlinux.org.uk>
 <Y/o8DkLO9CY+ROkH@corigine.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y/o8DkLO9CY+ROkH@corigine.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Feb 25, 2023 at 05:49:18PM +0100, Simon Horman wrote:
> On Fri, Feb 24, 2023 at 12:36:26PM +0000, Russell King (Oracle) wrote:
> 
> Hi Russell,
> 
> I think it would be good to add a patch description here.
> 
> Code change looks good to me.

As noted in the cover message, this is to highlight the issue to
hopefully get folk to think what we should do about RMII and REVMII
in this driver - basically, should we continue to support them, or
remove it completely.

Either way, this patch won't hit net-next in its current form.

Essentially, the choice is either we remove these two switch cases,
or we add these interface modes to the supported_interfaces array.

I'd rather those with mtk_eth_soc made the decision, even though it
is highly unlikely that these modes are used on the hardware they
have - as I don't have any mediatek hardware.

Thanks.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
