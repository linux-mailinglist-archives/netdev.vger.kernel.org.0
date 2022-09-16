Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A85DD5BA780
	for <lists+netdev@lfdr.de>; Fri, 16 Sep 2022 09:32:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229896AbiIPHcO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Sep 2022 03:32:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229787AbiIPHcN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Sep 2022 03:32:13 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E30D69F62;
        Fri, 16 Sep 2022 00:32:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 38D5BCE1CEC;
        Fri, 16 Sep 2022 07:32:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17F4DC433D7;
        Fri, 16 Sep 2022 07:32:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663313525;
        bh=kIN7QfExsQx+UqdmpMBdIeRw4B5bb5Sxm5kWFcM1KzI=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=BYLEcH7VikUqQp6Ol63pR9weKaq6Ds4LJ34NFHxXEZIr0SUBjr8aZfiA1z8v9ONKu
         eJ2UtDydVvWa/8BA95GnRWYK+B75UK55ccY+EIrEG3brSst7DtWLammK0h26MPVJpp
         ygs72WHLbgL+t14iN8YNFmuisOZZMUCHN6jEh51GuUjpT9SO5pbEQibe9pctMGVPwF
         8/CvdxTkeXG2IyO1BYC95aMphvizJ+LoNNhbkRpRjg6gcmLTegH9pbmK6/MLwQCp1g
         AI0KOXGwXJ3AGtbAVwXDaBw0iG0pODqammiL+6NbirOjgfyg5uFMA9wjwdfptkGRlv
         vhOKkxtMrrtLw==
From:   Kalle Valo <kvalo@kernel.org>
To:     Alvin =?utf-8?Q?=C5=A0ipraga?= <ALSI@bang-olufsen.dk>
Cc:     "Russell King \(Oracle\)" <linux@armlinux.org.uk>,
        Arend van Spriel <aspriel@gmail.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Alyssa Rosenzweig <alyssa@rosenzweig.io>,
        "asahi\@lists.linux.dev" <asahi@lists.linux.dev>,
        "brcm80211-dev-list.pdl\@broadcom.com" 
        <brcm80211-dev-list.pdl@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>,
        "devicetree\@vger.kernel.org" <devicetree@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Hector Martin <marcan@marcan.st>,
        Jakub Kicinski <kuba@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        "linux-arm-kernel\@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev\@vger.kernel.org" <netdev@vger.kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rafa__ Mi__ecki <zajec5@gmail.com>,
        Rob Herring <robh+dt@kernel.org>,
        "SHA-cyfmac-dev-list\@infineon.com" 
        <SHA-cyfmac-dev-list@infineon.com>, Sven Peter <sven@svenpeter.dev>
Subject: Re: [PATCH wireless-next v2 11/12] brcmfmac: pcie: Add IDs/properties for BCM4378
References: <Yx8BQbjJT4I2oQ5K@shell.armlinux.org.uk>
        <E1oXg8C-0064vf-SN@rmk-PC.armlinux.org.uk>
        <20220915153459.oytlibhzbngczsuo@bang-olufsen.dk>
        <YyNYs5Acdl8/zazb@shell.armlinux.org.uk>
        <20220915165943.pwhxg6yqsiapm2qx@bang-olufsen.dk>
Date:   Fri, 16 Sep 2022 10:31:57 +0300
In-Reply-To: <20220915165943.pwhxg6yqsiapm2qx@bang-olufsen.dk> ("Alvin
        \=\?utf-8\?Q\?\=C5\=A0ipraga\=22's\?\= message of "Thu, 15 Sep 2022 16:59:45 +0000")
Message-ID: <875yhnai6q.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Alvin =C5=A0ipraga <ALSI@bang-olufsen.dk> writes:

> On Thu, Sep 15, 2022 at 05:54:11PM +0100, Russell King (Oracle) wrote:
>> On Thu, Sep 15, 2022 at 03:34:59PM +0000, Alvin =C5=A0ipraga wrote:
>> > On Mon, Sep 12, 2022 at 10:53:32AM +0100, Russell King wrote:
>> > > From: Hector Martin <marcan@marcan.st>
>> > >=20
>> > > This chip is present on Apple M1 (t8103) platforms:
>> > >=20
>> > > * atlantisb (apple,j274): Mac mini (M1, 2020)
>> > > * honshu    (apple,j293): MacBook Pro (13-inch, M1, 2020)
>> > > * shikoku   (apple,j313): MacBook Air (M1, 2020)
>> > > * capri     (apple,j456): iMac (24-inch, 4x USB-C, M1, 2020)
>> > > * santorini (apple,j457): iMac (24-inch, 2x USB-C, M1, 2020)
>> > >=20
>> > > Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
>> > > Signed-off-by: Hector Martin <marcan@marcan.st>
>> > > Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
>> > > ---
>> >=20
>> > Reviewed-by: Alvin =C5=A0ipraga <alsi@bang-olufsen.dk>
>> >=20
>> > >  drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c   | 2 ++
>> > >  drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c   | 8 +++++=
+++
>> > >  .../net/wireless/broadcom/brcm80211/include/brcm_hw_ids.h | 2 ++
>> > >  3 files changed, 12 insertions(+)
>> > >=20
>> > > diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c=
 b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c
>> > > index 23295fceb062..3026166a56c1 100644
>> > > --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c
>> > > +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c
>> > > @@ -733,6 +733,8 @@ static u32 brcmf_chip_tcm_rambase(struct brcmf_c=
hip_priv *ci)
>> > >  		return 0x160000;
>> > >  	case CY_CC_43752_CHIP_ID:
>> > >  		return 0x170000;
>> > > +	case BRCM_CC_4378_CHIP_ID:
>> > > +		return 0x352000;
>> > >  	default:
>> > >  		brcmf_err("unknown chip: %s\n", ci->pub.name);
>> > >  		break;
>> > > diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c=
 b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
>> > > index 269a516ae654..0c627f33049e 100644
>> > > --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
>> > > +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
>> > > @@ -59,6 +59,7 @@ BRCMF_FW_DEF(4365C, "brcmfmac4365c-pcie");
>> > >  BRCMF_FW_DEF(4366B, "brcmfmac4366b-pcie");
>> > >  BRCMF_FW_DEF(4366C, "brcmfmac4366c-pcie");
>> > >  BRCMF_FW_DEF(4371, "brcmfmac4371-pcie");
>> > > +BRCMF_FW_CLM_DEF(4378B1, "brcmfmac4378b1-pcie");
>> > >=20=20
>> > >  /* firmware config files */
>> > >  MODULE_FIRMWARE(BRCMF_FW_DEFAULT_PATH "brcmfmac*-pcie.txt");
>> > > @@ -88,6 +89,7 @@ static const struct brcmf_firmware_mapping brcmf_p=
cie_fwnames[] =3D {
>> > >  	BRCMF_FW_ENTRY(BRCM_CC_43664_CHIP_ID, 0xFFFFFFF0, 4366C),
>> > >  	BRCMF_FW_ENTRY(BRCM_CC_43666_CHIP_ID, 0xFFFFFFF0, 4366C),
>> > >  	BRCMF_FW_ENTRY(BRCM_CC_4371_CHIP_ID, 0xFFFFFFFF, 4371),
>> > > +	BRCMF_FW_ENTRY(BRCM_CC_4378_CHIP_ID, 0xFFFFFFFF, 4378B1), /* 3 */
>> >=20
>> > What is /* 3 */?
>>=20
>> Hector says that it was mentioned in the prior review round as well.
>> It's the revision ID. The mask allows all IDs for chips where no
>> split has been seen, but if a new one comes up that comment is there
>> so we know where to split the mask.
>
> Alright, makes sense. If you happen to re-spin the series then it would
> be nice to include this info in the commit message.

And maybe even change the comment to something like:

/* revision ID 3 */

--=20
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatc=
hes
