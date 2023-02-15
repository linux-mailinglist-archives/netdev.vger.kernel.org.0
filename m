Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 25515698553
	for <lists+netdev@lfdr.de>; Wed, 15 Feb 2023 21:14:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229664AbjBOUOT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Feb 2023 15:14:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229493AbjBOUOR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Feb 2023 15:14:17 -0500
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BB4E2597E;
        Wed, 15 Feb 2023 12:14:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
        Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
        Resent-Cc:Resent-Message-ID; bh=KTlTAcnnps0b16Yws00zOb99uOLiCxawW9/JhtKdpKA=;
        t=1676492056; x=1677701656; b=DdCyDIJYygyOIlJ1rGY5OV5OxVy7eC9pmuc16c36M6+m1gW
        DHVIpCfE1SjbYhKIjh58W+VJSNbBb/dn+tPKl0eW5w4dpyDvn3iIdu1CheXQq4V1/tvoc9q6vdKpE
        AxUc0zFyX46kGJltzxBd+zDn7drztVTXe1VyDwTIR0fhJ6t4IJlxbbc71B4PnccA/SZ1VdObPxn6C
        x/2yIV4aOBfqzXzpxoHN6at+4drQ5fLQPpONQy5V4FwHDO31lgOM52FU75LWEsGZKMkDWetwP5BM3
        dLtfH2dNWB6ohCcu58XbauCg3ThdpUUf9TxmR2NNnIsiRJCVHOh42LYXDONN/fnA==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.96)
        (envelope-from <johannes@sipsolutions.net>)
        id 1pSOAO-00DCw2-1K;
        Wed, 15 Feb 2023 21:14:12 +0100
Message-ID: <e455e26830a0d8f2ce728461b74e6dbd4b315df5.camel@sipsolutions.net>
Subject: Re: wilc1000 MAC address is 00:00:00:00:00:00
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Dan Williams <dcbw@redhat.com>, Ajay.Kathat@microchip.com,
        kvalo@kernel.org, heiko.thiery@gmail.com
Cc:     michael@walle.cc, kuba@kernel.org, Claudiu.Beznea@microchip.com,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        Amisha.Patel@microchip.com, thaller@redhat.com,
        bgalvani@redhat.com, Sripad.Balwadgi@microchip.com
Date:   Wed, 15 Feb 2023 21:14:10 +0100
In-Reply-To: <aef63f6a367896950f9e61041cfcff4b99bd6c7d.camel@redhat.com>
References: <CAEyMn7aV-B4OEhHR4Ad0LM3sKCz1-nDqSb9uZNmRWR-hMZ=z+A@mail.gmail.com>
         <e027bfcf-1977-f2fa-a362-8faed91a19f9@microchip.com>
         <20230209094825.49f59208@kernel.org>
         <51134d12-1b06-6d6f-e798-7dd681a8f3ae@microchip.com>
         <20230209130725.0b04a424@kernel.org>
         <2d548e01b266f7b1ad19a5ea979d00bf@walle.cc>
         <CAEyMn7bpwusVarzHa262maJHf6XTpCW4SL0-o+YH4DGZx94+hw@mail.gmail.com>
         <87bkm1x47n.fsf@kernel.org>
         <2c2e656e-6dad-67d9-8da0-d507804e7df3@microchip.com>
         <aef63f6a367896950f9e61041cfcff4b99bd6c7d.camel@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.3 (3.46.3-1.fc37) 
MIME-Version: 1.0
X-malware-bazaar: not-scanned
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2023-02-10 at 15:28 -0600, Dan Williams wrote:
> >=20
> > In wilc1000, the bus interface is up in probe but we don't have
> > access
> > to mac address via register until the driver starts the wilc firmware
> > because of design limitation. This information is only available
> > after
> > the MAC layer is initialized.
>=20
> So... initialize the MAC layer and read the address, then stop the card
> until dev open which reloads and reinits? That's what eg Atmel does

For a more modern example, iwlwifi also ;-)

You should also load the firmware async, so it becomes:

probe
 -> load firmware

firmware success callback
 - boot device
 - read information
 - register with mac80211
 - shut down device

mac80211 start callback
 - boot device again
 - etc.

johannes
