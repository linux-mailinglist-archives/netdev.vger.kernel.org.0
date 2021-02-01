Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8485830A43C
	for <lists+netdev@lfdr.de>; Mon,  1 Feb 2021 10:20:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232851AbhBAJS7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Feb 2021 04:18:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232758AbhBAJRe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Feb 2021 04:17:34 -0500
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F34CCC061573
        for <netdev@vger.kernel.org>; Mon,  1 Feb 2021 01:16:49 -0800 (PST)
Received: by mail-ej1-x631.google.com with SMTP id r12so23158352ejb.9
        for <netdev@vger.kernel.org>; Mon, 01 Feb 2021 01:16:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=TGBP+ZjXPuDvGpC3xfl8rdE2HayPf1vRxXL8YAOht7E=;
        b=Yrou9hgO9Ztz6dLY72ZqFQc2aQmkT2F1taw8In/zlYDOezbBO0B9rooI2qNPaVlq/6
         2RxxCvwhFosd6pelzN7krKgg0Sjxa97PW33GhOGorhtQt8ggWpPuaIiEKwE12EVLids4
         zxEaJn3sznDTuwlPwCjBrK4n30LRHTYrHgpn0OhA1vCA5v2w3Sth2SnlwZu0Z4L1H69f
         w82ODVleEIWSudwMFXnNwYX2GwlN0LOJ1bogsTiUAK39limNKUxdW8Dthil4jHvMBnQQ
         0b3cvFawaKtAp6DmV4Y11ABU4guPkpDqaKOc7w1TjolMRJHQFCfWum1jOQcanFR/Cmgx
         hXJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=TGBP+ZjXPuDvGpC3xfl8rdE2HayPf1vRxXL8YAOht7E=;
        b=f0ntPS74XO9Kf26liCQ6yA6nJr4IyrcbeKdVuUFiv/ms0rvVcb8KL1pwxI9dAvlZ0E
         jvfkaK5Yk7K0GJbzmzkGRLlqhdPXOXNI+mda56gwz6FH1CiceDob82oS6awD+yZ3jNAK
         fg4fUCBShh7n+gjBsxfGJcX3AQkVkIfuXNNV9kHqze1F0982IXt6k9KlzR4KDABbIdwF
         2d3kRKpOwRv84q+O7/nH4P8P6H7xOk7/LFiYqexIWpmyptiFf9ny1B/Fnu3wHT2jA6IQ
         NHuwexWzZKtMDVWz2ApGIuBOEpoG2kDL9fw37OGEQYuWAot07hwHLjZ5n4wirekZi57n
         IeoQ==
X-Gm-Message-State: AOAM530IzmKDlOQe2SZQjRHt/lltXpen2nhh8N8QsBdtbZgi0foNt2tY
        a3TaPa5T5u815oPNrFak9weYTiVIKd89vperSc2Z4FqA55g=
X-Google-Smtp-Source: ABdhPJzXwFFHPXPjczo4o5baIDRO8jUnBTE0ID+8DN7wZCC8uvwAqEv5LoNKTANdEjjWw+uWXZRIukvd2KArb7WCPNM=
X-Received: by 2002:a17:906:1c17:: with SMTP id k23mr16513211ejg.255.1612171008538;
 Mon, 01 Feb 2021 01:16:48 -0800 (PST)
MIME-Version: 1.0
References: <1611766877-16787-1-git-send-email-loic.poulain@linaro.org>
 <1611766877-16787-3-git-send-email-loic.poulain@linaro.org> <87ft2izdtw.fsf@miraculix.mork.no>
In-Reply-To: <87ft2izdtw.fsf@miraculix.mork.no>
From:   Loic Poulain <loic.poulain@linaro.org>
Date:   Mon, 1 Feb 2021 10:23:56 +0100
Message-ID: <CAMZdPi-7NYL3+baxfqSVsQ+X7QdQv4zou-=p_Y8cLSTya3YSjQ@mail.gmail.com>
Subject: Re: [PATCH net-next 3/3] net: mhi: Add mbim proto
To:     =?UTF-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Network Development <netdev@vger.kernel.org>,
        =?UTF-8?B?Q2FybCBZaW4o5q635byg5oiQKQ==?= <carl.yin@quectel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 30 Jan 2021 at 15:42, Bj=C3=B8rn Mork <bjorn@mork.no> wrote:
>
> Loic Poulain <loic.poulain@linaro.org> writes:
>
> > MBIM has initially been specified by USB-IF for transporting data (IP)
> > between a modem and a host over USB. However some modern modems also
> > support MBIM over PCIe (via MHI). In the same way as QMAP(rmnet), it
> > allows to aggregate IP packets and to perform context multiplexing.
> >
> > This change adds minimal MBIM support to MHI, allowing to support MBIM
> > only modems. MBIM being based on USB NCM, it reuses some helpers from
> > the USB stack, but the cdc-mbim driver is too USB coupled to be reused.
>
> Sure, the guts of the MBIM protocol is in cdc_ncm. But you did copy most
> of cdc_mbim_rx_fixup() from cdc_mbim.c so this comment doesn't make
> much sense...

Yes, just wanted to say that I have to duplicate mbim functions here
because of the USB coupling of the cdc_mbim.c version.

>
> > At some point it would be interesting to move on a factorized solution,
> > having a generic MBIM network lib or dedicated MBIM netlink virtual
> > interface support.
>
> I believe that is now or never.  Sorry.  No one is going to fix it
> later.
>
> > +static int mbim_rx_verify_nth16(struct sk_buff *skb)
> > +{
> > +     struct usb_cdc_ncm_nth16 *nth16;
> > +     int ret =3D -EINVAL;
> > +
> > +     if (skb->len < (sizeof(struct usb_cdc_ncm_nth16) +
> > +                     sizeof(struct usb_cdc_ncm_ndp16))) {
> > +             goto error;
> > +     }
> > +
> > +     nth16 =3D (struct usb_cdc_ncm_nth16 *)skb->data;
> > +
> > +     if (nth16->dwSignature !=3D cpu_to_le32(USB_CDC_NCM_NTH16_SIGN))
> > +             goto error;
> > +
> > +     ret =3D le16_to_cpu(nth16->wNdpIndex);
> > +error:
> > +     return ret;
> > +}
>
>
> This is a copy of  cdc_ncm_rx_verify_nth16() except that you've dropped
> the debug messages and verification of wBlockLength and wSequence.  It's
> unclear to me why you don't need to verify those fields?

Yes, I can probably re-introduce that, to be aligned with USB version
(I removed that because I initially had no context for mbim).

>
> This function could easily be shared with cdc_ncm instead of duplicating
> it.

Yes but that would request cdc_mbim changes since this function takes
a USB mbim context (cdc_ncm_ctx).

>
> > +static int mbim_rx_verify_ndp16(struct sk_buff *skb, int ndpoffset)
> > +{
> > +     struct usb_cdc_ncm_ndp16 *ndp16;
> > +     int ret =3D -EINVAL;
> > +
> > +     if ((ndpoffset + sizeof(struct usb_cdc_ncm_ndp16)) > skb->len)
> > +             goto error;
> > +
> > +     ndp16 =3D (struct usb_cdc_ncm_ndp16 *)(skb->data + ndpoffset);
> > +
> > +     if (le16_to_cpu(ndp16->wLength) < USB_CDC_NCM_NDP16_LENGTH_MIN)
> > +             goto error;
> > +
> > +     ret =3D ((le16_to_cpu(ndp16->wLength) -
> > +                                     sizeof(struct usb_cdc_ncm_ndp16))=
 /
> > +                                     sizeof(struct usb_cdc_ncm_dpe16))=
;
> > +     ret--; /* Last entry is always a NULL terminator */
> > +
> > +     if ((sizeof(struct usb_cdc_ncm_ndp16) +
> > +          ret * (sizeof(struct usb_cdc_ncm_dpe16))) > skb->len) {
> > +             ret =3D -EINVAL;
> > +     }
> > +error:
> > +     return ret;
> > +}
>
> This is an exact replica of cdc_ncm_rx_verify_ndp16() AFAICS, except for
> the removed debug messages.   You do know that netif_dbg() is
> conditional? There is nothing to be saved by removing those lines.

Yes, I tried to make this function generic, it only takes the
skb/offset as parameters, and lets the caller handling error as
desired. but I can certainly re-introduce dbg messages, along with a
ndev parameter (for the print context).

>
> FWIW, you will have to fix the copyright attribution of this file if you
> want to keep this copy here.  Otherwise it just looks like you are
> stealing. And I'll wonder where the rest of the code came from and
> whether you have the right to license that as GPL. Better be clear about
> where you found this and who owns the copyright.  There is no question
> about the rights to use, given the GPL license of the original.

I'll add the proper copyright from cdc-mbim since it's clearly a
partial-copy of it (and no will to hide that).

> > +static int mbim_rx_fixup(struct net_device *ndev, struct sk_buff *skb)
> > +{
> > +     int ndpoffset;
> > +
> > +     /* Check NTB header signature and retrieve first NDP offset */
> > +     ndpoffset =3D mbim_rx_verify_nth16(skb);
> > +     if (ndpoffset < 0) {
> > +             netdev_err(ndev, "MBIM: Incorrect NTB header\n");
> > +             goto error;
> > +     }
> > +
> > +     /* Process each NDP */
> > +     while (1) {
> > +             struct usb_cdc_ncm_ndp16 *ndp16;
> > +             struct usb_cdc_ncm_dpe16 *dpe16;
> > +             int nframes, n;
> > +
> > +             /* Check NDP header and retrieve number of datagrams */
> > +             nframes =3D mbim_rx_verify_ndp16(skb, ndpoffset);
> > +             if (nframes < 0) {
> > +                     netdev_err(ndev, "MBIM: Incorrect NDP16\n");
> > +                     goto error;
> > +             }
> > +
> > +             /* Only support the IPS session 0 for now */
> > +             ndp16 =3D (struct usb_cdc_ncm_ndp16 *)(skb->data + ndpoff=
set);
> > +             switch (ndp16->dwSignature & cpu_to_le32(0x00ffffff)) {
> > +             case cpu_to_le32(USB_CDC_MBIM_NDP16_IPS_SIGN):
> > +                     break;
> > +             default:
> > +                     netdev_err(ndev, "MBIM: Unsupported NDP type\n");
> > +                     goto next_ndp;
> > +             }
>
> You don't support DSS?  Why?  That's mandatory in the MBIM spec, isn't
> it?  Can we have an MBIM driver without that support?  And if so, should
> completely valid MBIM frames cause an error message?

Well, this is a subset of MBIM, since a lot of the MBIM/NCM does not
apply for MHI/PCIe. In MHI context, the IP channel is used for network
data transport only, and MBIM simply brings aggregation and
multiplexing. Other modem functions/services are exposed via other
dedicated MHI channels.

>
> And IP multiplexing isn't supported either?  And you simply ignore the
> session ID?  How is that intended to work?  What happens here when the
> driver receives IP packets from two different APNs?

You're Right, this is on purpose, I would like to keep the initial
implementation simple, working for the main use case. So multi-pdn
context is simply not supported in that series. Moreover, I can not
test multi-context for now, but I plan to add that in a follow-up
series/patch.

> But please, just implement the IP multiplexing.  You do that for rmnet,
> right?

I especially would like to discuss the implementation since the
architecture is quite different from rmnet netlink (do we want to
create additional ifaces or to align with the VLAN cdc-mbim trick...).

>
> At least provide some plan on how you want to add it. Don't paint
> yourself into a corner.  Userspace will need a way to manage the MBIM
> transport and the multiplexed IP sessions independently.  E.g. take down
> the netdev associated with IPS session 0 without breaking IPS session 1.
>
> Locking this netdev to one session will be a problem.  I know, because
> I've made that mistake.

I think it makes sense to align with cdc-mbim behavior here, for
compatiblity, so the lower transport interface will have to stay up
for the additional session/context interfaces. Let me know we should
do that in another way.

>
> > +
> > +             /* de-aggregate and deliver IP packets */
> > +             dpe16 =3D ndp16->dpe16;
> > +             for (n =3D 0; n < nframes; n++, dpe16++) {
> > +                     u16 dgram_offset =3D le16_to_cpu(dpe16->wDatagram=
Index);
> > +                     u16 dgram_len =3D le16_to_cpu(dpe16->wDatagramLen=
gth);
> > +                     struct sk_buff *skbn;
> > +
> > +                     if (!dgram_offset || !dgram_len)
> > +                             break; /* null terminator */
> > +
> > +                     skbn =3D netdev_alloc_skb(ndev, dgram_len);
> > +                     if (!skbn)
> > +                             continue;
> > +
> > +                     skb_put(skbn, dgram_len);
> > +                     memcpy(skbn->data, skb->data + dgram_offset, dgra=
m_len);
> > +
> > +                     switch (skbn->data[0] & 0xf0) {
> > +                     case 0x40:
> > +                             skbn->protocol =3D htons(ETH_P_IP);
> > +                             break;
> > +                     case 0x60:
> > +                             skbn->protocol =3D htons(ETH_P_IPV6);
> > +                             break;
> > +                     default:
> > +                             netdev_err(ndev, "MBIM: unknown protocol\=
n");
> > +                             continue;
> > +                     }
> > +
> > +                     netif_rx(skbn);
> > +             }
> > +next_ndp:
> > +             /* Other NDP to process? */
> > +             ndpoffset =3D le16_to_cpu(ndp16->wNextNdpIndex);
> > +             if (!ndpoffset)
> > +                     break;
> > +     }
> > +
> > +     /* free skb */
> > +     dev_consume_skb_any(skb);
> > +     return 0;
> > +error:
> > +     dev_kfree_skb_any(skb);
> > +     return -EIO;
> > +}
>
>
> Except for the missing feature, this is still mostly a copy
> cdc_mbim_rx_fixup(). Please respect the copyright on code you are
> copying.  You are obviously free to use this under the GPL, but the
> original author still retains copyright on it.

For sure, will do.

>
> FWIW, I can understand why you want to use a slightly modified copy in
> this case, since the original is tied both to usbnet and to the weird
> VLAN mapping.  So that's fine with me.
>
>
> Bj=C3=B8rn

Thanks,
Loic
