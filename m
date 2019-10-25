Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E6462E4A41
	for <lists+netdev@lfdr.de>; Fri, 25 Oct 2019 13:46:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2502153AbfJYLqi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Oct 2019 07:46:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54328 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2502108AbfJYLqg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 25 Oct 2019 07:46:36 -0400
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com [209.85.221.72])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 1544781F10
        for <netdev@vger.kernel.org>; Fri, 25 Oct 2019 11:46:36 +0000 (UTC)
Received: by mail-wr1-f72.google.com with SMTP id 92so969982wro.14
        for <netdev@vger.kernel.org>; Fri, 25 Oct 2019 04:46:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=cFHU09wBjpsgLwHf44LiEP8jLq8cbX4indFXQskgc2E=;
        b=Qv+GsdGTq0r4LHPIyvQ5lknsqk4dlg6HFC+0INHOcqX5xnYzfVM1H+knBgxRehEtAz
         venbJgPLUwpuIth7V/6nC8eOU3fRq2TPW1vYb1QzlEQC7WKUNL478GRcpFNLA5x+aPo7
         yUIzSb5ft4TgE8g48A68ylBQPN0WdB78VYTNJ9sXI7cHdJWKEc1E0xVvuMwQF0ZEgqXI
         SxR1GsNsPqDkcOTA/K5zbGKdSG3h6gOw64xB0GrCzSi6bfcSR/+G1aNqgsrHTkAwGWyv
         D8ykzpdtPtrm5b0lemDKlxghJPClJkjnU2tX2oKrcy7PcN3gjY5Lia69LXJkSjcuup74
         F+nQ==
X-Gm-Message-State: APjAAAXkwWIu/i3NZxb7W6VkIYsYVS211xk81pEICOpHbJOJRGl58gmf
        NqlkPKbxojRn0CJgGaDRTfCvIbnTdWemfEk4FRvDuweUP2r/XC1niGDyfKcMW0a64jP2MXUzoLe
        MKnYE+XkUzNeb51PY
X-Received: by 2002:adf:ce87:: with SMTP id r7mr2609084wrn.307.1572003994711;
        Fri, 25 Oct 2019 04:46:34 -0700 (PDT)
X-Google-Smtp-Source: APXvYqwV6LS+tmeIOc2lcvag9+NUuWfiCs6yqLkqltANJQ0kynAe2xikLzXKtfuLR4ip3sF2hZMT4Q==
X-Received: by 2002:adf:ce87:: with SMTP id r7mr2609039wrn.307.1572003994334;
        Fri, 25 Oct 2019 04:46:34 -0700 (PDT)
Received: from localhost.localdomain (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.gmail.com with ESMTPSA id q14sm2521539wre.27.2019.10.25.04.46.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Oct 2019 04:46:33 -0700 (PDT)
Date:   Fri, 25 Oct 2019 13:46:31 +0200
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Lorenzo Bianconi <lorenzo@kernel.org>, kvalo@codeaurora.org,
        linux-wireless@vger.kernel.org, nbd@nbd.name, sgruszka@redhat.com,
        oleksandr@natalenko.name, netdev@vger.kernel.org,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        sean.wang@mediatek.com, ryder.lee@mediatek.com, royluo@google.com
Subject: Re: [PATCH wireless-drivers 1/2] mt76: mt76x2e: disable pcie_aspm by
 default
Message-ID: <20191025114631.GB2898@localhost.localdomain>
References: <cover.1571868221.git.lorenzo@kernel.org>
 <fec60f066bab1936d58b2e69bae3f20e645d1304.1571868221.git.lorenzo@kernel.org>
 <5924c8eb-7269-b8ef-ad0e-957104645638@gmail.com>
 <20191024215451.GA30822@lore-desk.lan>
 <9cac34a5-0bfe-0443-503f-218210dab4d6@gmail.com>
 <20191024230747.GA30614@lore-desk.lan>
 <1de75f53-ab28-9951-092c-19a854ef4907@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="cmJC7u66zC7hs+87"
Content-Disposition: inline
In-Reply-To: <1de75f53-ab28-9951-092c-19a854ef4907@gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--cmJC7u66zC7hs+87
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> On 25.10.2019 01:07, Lorenzo Bianconi wrote:
> >> On 24.10.2019 23:54, Lorenzo Bianconi wrote:
> >>>> On 24.10.2019 00:23, Lorenzo Bianconi wrote:
> >>>>> On same device (e.g. U7612E-H1) PCIE_ASPM causes continuous mcu han=
gs and
> >>>>> instability and so let's disable PCIE_ASPM by default. This patch h=
as
> >>>>> been successfully tested on U7612E-H1 mini-pice card
> >>>>>
> >>>>> Signed-off-by: Felix Fietkau <nbd@nbd.name>
> >>>>> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> >>>>> ---
> >>>>>  drivers/net/wireless/mediatek/mt76/mmio.c     | 47 +++++++++++++++=
++++
> >>>>>  drivers/net/wireless/mediatek/mt76/mt76.h     |  1 +
> >>>>>  .../net/wireless/mediatek/mt76/mt76x2/pci.c   |  2 +
> >>>>>  3 files changed, 50 insertions(+)
> >>>>>
> >>>
> >>> [...]
> >>>
> >>>>> +
> >>>>> +	if (parent)
> >>>>> +		pcie_capability_clear_word(parent, PCI_EXP_LNKCTL,
> >>>>> +					   aspm_conf);
> >>>>
> >>>> + linux-pci mailing list
> >>>
> >>> Hi Heiner,
> >>>
> >>>>
> >>>> All this seems to be legacy code copied from e1000e.
> >>>> Fiddling with the low-level PCI(e) registers should be left to the
> >>>> PCI core. It shouldn't be needed here, a simple call to
> >>>> pci_disable_link_state() should be sufficient. Note that this functi=
on
> >>>> has a return value meanwhile that you can check instead of reading
> >>>> back low-level registers.
> >>>
> >>> ack, I will add it to v2
> >>>
> >>>> If BIOS forbids that OS changes ASPM settings, then this should be
> >>>> respected (like PCI core does). Instead the network chip may provide
> >>>> the option to configure whether it activates certain ASPM (sub-)stat=
es
> >>>> or not. We went through a similar exercise with the r8169 driver,
> >>>> you can check how it's done there.
> >>>
> >>> looking at the vendor sdk (at least in the version I currently have) =
there are
> >>> no particular ASPM configurations, it just optionally disables it wri=
ting directly
> >>> in pci registers.
> >>> Moreover there are multiple drivers that are currently using this app=
roach:
> >>> - ath9k in ath_pci_aspm_init()
> >>> - tg3 in tg3_chip_reset()
> >>> - e1000e in __e1000e_disable_aspm()
> >>> - r8169 in rtl_enable_clock_request()/rtl_disable_clock_request()
> >>>
> >> All these drivers include quite some legacy code. I can mainly speak f=
or r8169:
> >> First versions of the driver are almost as old as Linux. And even thou=
gh I
> >> refactored most of the driver still some legacy code for older chip ve=
rsions
> >> (like the two functions you mentioned) is included.
> >>
> >>> Is disabling the ASPM for the system the only option to make this min=
ipcie
> >>> work?
> >>>
> >>
> >> No. What we do in r8169:
> >>
> >> - call pci_disable_link_state(pdev, PCIE_LINK_STATE_L0S | PCIE_LINK_ST=
ATE_L1)
> >> - If it returns 0, then ASPM (including the L1 sub-states) is disabled.
> >> - If it returns an errno, then disabling ASPM failed (most likely due =
to
> >>   BIOS forbidding ASPM changes - pci_disable_link_state will spit out
> >>   a related warning). In this case r8169 configures the chip to not in=
itiate
> >>   transitions to L0s/L1 (the other end of the link may still try to en=
ter
> >>   ASPM states). See rtl_hw_aspm_clkreq_enable(). That's sufficient
> >>   to avoid the ASPM-related problems with certain versions of this chi=
p.
> >>   Maybe your HW provides similar functionality.
> >=20
> > yep, I looked at rtl_hw_aspm_clkreq_enable. This is more or less what I=
 did but
> > unfortunately there is no specific code or documentation I can use for =
mt76x2e.
> > So as last chance I decided to disable ASPM directly (in this way the c=
hip is
> > working fine).
> > Do you think a kernel parameter to disable ASPM directly would be accep=
table?
> >=20
> Module parameters are not the preferred approach, even though some mainta=
iners
> may consider it acceptable. I think it should be ok if you disable ASPM p=
er
> default. Who wants ASPM can enable the individual states via brand-new
> sysfs attributes (provided BIOS allows OS to control ASPM).
> However changing ASPM settings via direct register writes may cause
> inconsistencies between PCI core and actual settings.
> I'm not sure whether there's any general best practice how to deal with t=
he
> scenario that a device misbehaves with ASPM enabled and OS isn't allowed =
to
> change ASPM settings.=20
> Maybe the PCI guys can advise on these points.

Hi Heiner,

I reviewed the mtk sdk and it seems mt7662/mt7612/mt7602 series does not
have hw pcie ps support (not sure if it just not implemented or so). In my
scenario without disabling ASPM the card does not work at all, so I guess we
can proceed with current approach and then try to understand if we can do
something better. What do you think?

@Ryder, Sean: do you have any hint on this topic?

Regards,
Lorenzo

>=20
> > Regards,
> > Lorenzo
> >=20
> Heiner
>=20
> >>
> >>> Regards,
> >>> Lorenzo
> >>>
> >> Heiner
> >>
> >>>>
> >>>>> +}
> >>>>> +EXPORT_SYMBOL_GPL(mt76_mmio_disable_aspm);
> >>>>> +
> >>>>>  void mt76_mmio_init(struct mt76_dev *dev, void __iomem *regs)
> >>>>>  {
> >>>>>  	static const struct mt76_bus_ops mt76_mmio_ops =3D {
> >>>>> diff --git a/drivers/net/wireless/mediatek/mt76/mt76.h b/drivers/ne=
t/wireless/mediatek/mt76/mt76.h
> >>>>> index 570c159515a0..962812b6247d 100644
> >>>>> --- a/drivers/net/wireless/mediatek/mt76/mt76.h
> >>>>> +++ b/drivers/net/wireless/mediatek/mt76/mt76.h
> >>>>> @@ -578,6 +578,7 @@ bool __mt76_poll_msec(struct mt76_dev *dev, u32=
 offset, u32 mask, u32 val,
> >>>>>  #define mt76_poll_msec(dev, ...) __mt76_poll_msec(&((dev)->mt76), =
__VA_ARGS__)
> >>>>> =20
> >>>>>  void mt76_mmio_init(struct mt76_dev *dev, void __iomem *regs);
> >>>>> +void mt76_mmio_disable_aspm(struct pci_dev *pdev);
> >>>>> =20
> >>>>>  static inline u16 mt76_chip(struct mt76_dev *dev)
> >>>>>  {
> >>>>> diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/pci.c b/driv=
ers/net/wireless/mediatek/mt76/mt76x2/pci.c
> >>>>> index 73c3104f8858..264bef87e5c7 100644
> >>>>> --- a/drivers/net/wireless/mediatek/mt76/mt76x2/pci.c
> >>>>> +++ b/drivers/net/wireless/mediatek/mt76/mt76x2/pci.c
> >>>>> @@ -81,6 +81,8 @@ mt76pci_probe(struct pci_dev *pdev, const struct =
pci_device_id *id)
> >>>>>  	/* RG_SSUSB_CDR_BR_PE1D =3D 0x3 */
> >>>>>  	mt76_rmw_field(dev, 0x15c58, 0x3 << 6, 0x3);
> >>>>> =20
> >>>>> +	mt76_mmio_disable_aspm(pdev);
> >>>>> +
> >>>>>  	return 0;
> >>>>> =20
> >>>>>  error:
> >>>>>
> >>>>
> >>
>=20

--cmJC7u66zC7hs+87
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCXbLgkwAKCRA6cBh0uS2t
rHfnAQCLoD02kio19gy+U8XToasZDcPIadAlFlX2/iy9cPWZRgEAnbBv05bpmG/K
f3evMl5rOPE8S4PDCo5o/s6KV1rCHgg=
=06x3
-----END PGP SIGNATURE-----

--cmJC7u66zC7hs+87--
