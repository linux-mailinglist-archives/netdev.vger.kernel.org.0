Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC5CD692941
	for <lists+netdev@lfdr.de>; Fri, 10 Feb 2023 22:29:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233497AbjBJV3J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Feb 2023 16:29:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232339AbjBJV3I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Feb 2023 16:29:08 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E96FF795D0
        for <netdev@vger.kernel.org>; Fri, 10 Feb 2023 13:28:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1676064501;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=emHwsodllOkuyVjMjvO0SHgoih+fJ42fp4Uiicf9tRA=;
        b=YjKYTxXM2XkVwA2HHzgFjn92EFQUnKDChtAVUNGNsOFz6w45PsKdm2BdX5fOgPh+UpxyU8
        u5MZiaa7EcfXro35A++kRL1RiwE0KeNxxNYnzwcp0yu8A7udd9TvJwD69tKvNbjZH9XtHZ
        5HoZj0FALukBTKWF8+AKEWTXt9k7JaI=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-656-v1iELsYWPRyX1AI8fbKj0Q-1; Fri, 10 Feb 2023 16:28:17 -0500
X-MC-Unique: v1iELsYWPRyX1AI8fbKj0Q-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CCA5C811E6E;
        Fri, 10 Feb 2023 21:28:16 +0000 (UTC)
Received: from localhost.localdomain (ovpn-0-12.rdu2.redhat.com [10.22.0.12])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2EA791121318;
        Fri, 10 Feb 2023 21:28:14 +0000 (UTC)
Message-ID: <aef63f6a367896950f9e61041cfcff4b99bd6c7d.camel@redhat.com>
Subject: Re: wilc1000 MAC address is 00:00:00:00:00:00
From:   Dan Williams <dcbw@redhat.com>
To:     Ajay.Kathat@microchip.com, kvalo@kernel.org, heiko.thiery@gmail.com
Cc:     michael@walle.cc, kuba@kernel.org, Claudiu.Beznea@microchip.com,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        Amisha.Patel@microchip.com, thaller@redhat.com,
        bgalvani@redhat.com, Sripad.Balwadgi@microchip.com
Date:   Fri, 10 Feb 2023 15:28:14 -0600
In-Reply-To: <2c2e656e-6dad-67d9-8da0-d507804e7df3@microchip.com>
References: <CAEyMn7aV-B4OEhHR4Ad0LM3sKCz1-nDqSb9uZNmRWR-hMZ=z+A@mail.gmail.com>
         <e027bfcf-1977-f2fa-a362-8faed91a19f9@microchip.com>
         <20230209094825.49f59208@kernel.org>
         <51134d12-1b06-6d6f-e798-7dd681a8f3ae@microchip.com>
         <20230209130725.0b04a424@kernel.org>
         <2d548e01b266f7b1ad19a5ea979d00bf@walle.cc>
         <CAEyMn7bpwusVarzHa262maJHf6XTpCW4SL0-o+YH4DGZx94+hw@mail.gmail.com>
         <87bkm1x47n.fsf@kernel.org>
         <2c2e656e-6dad-67d9-8da0-d507804e7df3@microchip.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.3 (3.46.3-1.fc37) 
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2023-02-10 at 19:12 +0000, Ajay.Kathat@microchip.com wrote:
> Hi Kalle,
>=20
> On 2/10/23 02:25, Kalle Valo wrote:
> > EXTERNAL EMAIL: Do not click links or open attachments unless you
> > know the content is safe
> >=20
> > Heiko Thiery <heiko.thiery@gmail.com> writes:
> >=20
> > > HI,
> > >=20
> > > Am Do., 9. Feb. 2023 um 22:19 Uhr schrieb Michael Walle
> > > <michael@walle.cc>:
> > > >=20
> > > > Am 2023-02-09 22:07, schrieb Jakub Kicinski:
> > > > > On Thu, 9 Feb 2023 18:51:58 +0000
> > > > > Ajay.Kathat@microchip.com=C2=A0wrote:
> > > > > > > netdev should be created with a valid lladdr, is there
> > > > > > > something
> > > > > > > wifi-specific here that'd prevalent that? The canonical
> > > > > > > flow is
> > > > > > > to this before registering the netdev:
> > > > > >=20
> > > > > > Here it's the timing in wilc1000 by when the MAC address is
> > > > > > available
> > > > > > to
> > > > > > read from NV. NV read is available in "mac_open"
> > > > > > net_device_ops
> > > > > > instead
> > > > > > of bus probe function. I think, mostly the operations on
> > > > > > netdev which
> > > > > > make use of mac address are performed after the "mac_open"
> > > > > > (I may be
> > > > > > missing something).
> > > > > >=20
> > > > > > Does it make sense to assign a random address in probe and
> > > > > > later read
> > > > > > back from NV in mac_open to make use of stored value?
> > > > >=20
> > > > > Hard to say, I'd suspect that may be even more confusing than
> > > > > starting with zeroes. There aren't any hard rules around the
> > > > > addresses AFAIK, but addrs are visible to user space. So user
> > > > > space will likely make assumptions based on the most commonly
> > > > > observed sequence (reading real addr at probe).
> > > >=20
> > > > Maybe we should also ask the NetworkManager guys. IMHO random
> > > > MAC address sounds bogus.
> > >=20
> > > Maybe it would be a "workaround" with loading the firmware while
> > > probing the device to set the real hw address.
> > >=20
> > > probe()
> > > =C2=A0 load_fw()
> > > =C2=A0 read_hw_addr_from_nv()
> > > =C2=A0 eth_hw_addr_set(ndev, addr)
> > > =C2=A0 unload_fw()
> > >=20
> > > mac_open()
> > > =C2=A0 load_fw()
> > >=20
> > > mac_close()
> > > =C2=A0 unload_fw()
> >=20
> > This is exactly what many wireless drivers already do and I
> > recommend
> > that wilc1000 would do the same.
> >=20
>=20
> In wilc1000, the bus interface is up in probe but we don't have
> access
> to mac address via register until the driver starts the wilc firmware
> because of design limitation. This information is only available
> after
> the MAC layer is initialized.

So... initialize the MAC layer and read the address, then stop the card
until dev open which reloads and reinits? That's what eg Atmel does
(though it has a special "read the MAC only" firmware to do that):

	/* No stored firmware so load a small stub which just
	   tells us the MAC address */
	int i;
	priv->card_type =3D CARD_TYPE_EEPROM;
	atmel_write16(dev, BSR, BSS_IRAM);
	atmel_copy_to_card(dev, 0, mac_reader, sizeof(mac_reader));
	atmel_set_gcr(dev, GCR_REMAP);
	atmel_clear_gcr(priv->dev, 0x0040);
	atmel_write16(dev, BSR, BSS_SRAM);
	for (i =3D LOOP_RETRY_LIMIT; i; i--)
		if (atmel_read16(dev, MR3) & MAC_BOOT_COMPLETE)
			break;
	if (i =3D=3D 0) {
		printk(KERN_ALERT "%s: MAC failed to boot MAC address reader.\n", dev->na=
me);
	} else {

		atmel_copy_to_host(dev, addr, atmel_read16(dev, MR2), 6);
		eth_hw_addr_set(dev, addr);
		/* got address, now squash it again until the network
		   interface is opened */
		if (priv->bus_type =3D=3D BUS_TYPE_PCCARD)
			atmel_write16(dev, GCR, 0x0060);
		atmel_write16(dev, GCR, 0x0040);
		rc =3D 1;
	}

Dan

>=20
>=20
> Regards,
> Ajay

