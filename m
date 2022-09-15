Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A57695BA011
	for <lists+netdev@lfdr.de>; Thu, 15 Sep 2022 18:54:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230059AbiIOQyb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Sep 2022 12:54:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230006AbiIOQy3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Sep 2022 12:54:29 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA447C3;
        Thu, 15 Sep 2022 09:54:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:
        Content-Transfer-Encoding:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=diXc3LXsUDGl5au3FNEuJUoVaXbl1VPKJscQCCr7EWo=; b=Vg8bHpaD+U0nIeyNRafjbzIcDh
        PgUC1qR8Dw47tZnwqOt9O9MxumBvtnwXUpyYCevsst/QlSkl4K/zIuyRgNX+N5eOFP9YyKuQcGSS/
        JaRzgLRBEu1GheS/aqh/eywpuTatMQ7xo/VeThPlNSboBNuyXUxtrdtqSfaB09jVODT91W5HLZ2i0
        +l2Lf1aXIq8QrtGlYOO30WgAWuxEa532Bs4qkgNMuOEoGCO3J9xYdqpkmCV1TBO18BJFQWuftxZJJ
        VugIL1HfIlHi11293FOLf0OOU9NBGqlRTq68aBvWvaiuI95FN0HfQOTz0K50LtGnxalw1Cc5wb7fr
        kfbQ/eNg==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:34350)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1oYs80-0005rT-RO; Thu, 15 Sep 2022 17:54:16 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1oYs7w-0002ku-0u; Thu, 15 Sep 2022 17:54:12 +0100
Date:   Thu, 15 Sep 2022 17:54:11 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Alvin =?utf-8?Q?=C5=A0ipraga?= <ALSI@bang-olufsen.dk>
Cc:     Arend van Spriel <aspriel@gmail.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Alyssa Rosenzweig <alyssa@rosenzweig.io>,
        "asahi@lists.linux.dev" <asahi@lists.linux.dev>,
        "brcm80211-dev-list.pdl@broadcom.com" 
        <brcm80211-dev-list.pdl@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Hector Martin <marcan@marcan.st>,
        Jakub Kicinski <kuba@kernel.org>,
        Kalle Valo <kvalo@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rafa__ Mi__ecki <zajec5@gmail.com>,
        Rob Herring <robh+dt@kernel.org>,
        "SHA-cyfmac-dev-list@infineon.com" <SHA-cyfmac-dev-list@infineon.com>,
        Sven Peter <sven@svenpeter.dev>
Subject: Re: [PATCH wireless-next v2 11/12] brcmfmac: pcie: Add
 IDs/properties for BCM4378
Message-ID: <YyNYs5Acdl8/zazb@shell.armlinux.org.uk>
References: <Yx8BQbjJT4I2oQ5K@shell.armlinux.org.uk>
 <E1oXg8C-0064vf-SN@rmk-PC.armlinux.org.uk>
 <20220915153459.oytlibhzbngczsuo@bang-olufsen.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220915153459.oytlibhzbngczsuo@bang-olufsen.dk>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 15, 2022 at 03:34:59PM +0000, Alvin Šipraga wrote:
> On Mon, Sep 12, 2022 at 10:53:32AM +0100, Russell King wrote:
> > From: Hector Martin <marcan@marcan.st>
> > 
> > This chip is present on Apple M1 (t8103) platforms:
> > 
> > * atlantisb (apple,j274): Mac mini (M1, 2020)
> > * honshu    (apple,j293): MacBook Pro (13-inch, M1, 2020)
> > * shikoku   (apple,j313): MacBook Air (M1, 2020)
> > * capri     (apple,j456): iMac (24-inch, 4x USB-C, M1, 2020)
> > * santorini (apple,j457): iMac (24-inch, 2x USB-C, M1, 2020)
> > 
> > Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
> > Signed-off-by: Hector Martin <marcan@marcan.st>
> > Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
> > ---
> 
> Reviewed-by: Alvin Šipraga <alsi@bang-olufsen.dk>
> 
> >  drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c   | 2 ++
> >  drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c   | 8 ++++++++
> >  .../net/wireless/broadcom/brcm80211/include/brcm_hw_ids.h | 2 ++
> >  3 files changed, 12 insertions(+)
> > 
> > diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c
> > index 23295fceb062..3026166a56c1 100644
> > --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c
> > +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c
> > @@ -733,6 +733,8 @@ static u32 brcmf_chip_tcm_rambase(struct brcmf_chip_priv *ci)
> >  		return 0x160000;
> >  	case CY_CC_43752_CHIP_ID:
> >  		return 0x170000;
> > +	case BRCM_CC_4378_CHIP_ID:
> > +		return 0x352000;
> >  	default:
> >  		brcmf_err("unknown chip: %s\n", ci->pub.name);
> >  		break;
> > diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
> > index 269a516ae654..0c627f33049e 100644
> > --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
> > +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
> > @@ -59,6 +59,7 @@ BRCMF_FW_DEF(4365C, "brcmfmac4365c-pcie");
> >  BRCMF_FW_DEF(4366B, "brcmfmac4366b-pcie");
> >  BRCMF_FW_DEF(4366C, "brcmfmac4366c-pcie");
> >  BRCMF_FW_DEF(4371, "brcmfmac4371-pcie");
> > +BRCMF_FW_CLM_DEF(4378B1, "brcmfmac4378b1-pcie");
> >  
> >  /* firmware config files */
> >  MODULE_FIRMWARE(BRCMF_FW_DEFAULT_PATH "brcmfmac*-pcie.txt");
> > @@ -88,6 +89,7 @@ static const struct brcmf_firmware_mapping brcmf_pcie_fwnames[] = {
> >  	BRCMF_FW_ENTRY(BRCM_CC_43664_CHIP_ID, 0xFFFFFFF0, 4366C),
> >  	BRCMF_FW_ENTRY(BRCM_CC_43666_CHIP_ID, 0xFFFFFFF0, 4366C),
> >  	BRCMF_FW_ENTRY(BRCM_CC_4371_CHIP_ID, 0xFFFFFFFF, 4371),
> > +	BRCMF_FW_ENTRY(BRCM_CC_4378_CHIP_ID, 0xFFFFFFFF, 4378B1), /* 3 */
> 
> What is /* 3 */?

Hector says that it was mentioned in the prior review round as well.
It's the revision ID. The mask allows all IDs for chips where no
split has been seen, but if a new one comes up that comment is there
so we know where to split the mask.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
