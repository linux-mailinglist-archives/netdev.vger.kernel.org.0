Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D65E654511E
	for <lists+netdev@lfdr.de>; Thu,  9 Jun 2022 17:44:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344596AbiFIPoD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jun 2022 11:44:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344598AbiFIPoB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jun 2022 11:44:01 -0400
Received: from relay11.mail.gandi.net (relay11.mail.gandi.net [IPv6:2001:4b98:dc4:8::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15E9261297;
        Thu,  9 Jun 2022 08:43:57 -0700 (PDT)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 4B3B9100003;
        Thu,  9 Jun 2022 15:43:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1654789436;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Wzn0dSk7sTnqEZx4z9CaE8/FtseNf8JIbK+ha/JH5FA=;
        b=QLZmKLNRVIFRBA06DhfANov76DNrx5OtAPSWQwySUWvJUa+kwzhkHw9UX8y4k0Tql7ncP5
        we86E5RkUFyWu4eXi0R3u9dden21429ePy+spg3aTMdFSDlCte5zKy9zO3LwWTYDrDnr+u
        HhlUhuX3elSBXC53M5fVVWuBlDk5a7PCwMlpyakkNdGFvZ/YOzbs+lQ93EXZXgcipar0NA
        +2+j8AcBJdoob/Z5mCITRZXn/jL/LgxWZ8SDhHFxOrXpcEbNc0fW1h9mkQ78Z6O474knwl
        WlZlyIhOED7BX84q4HNKDweXgQqeXNcTV6nEmHzys7rEhoxHZMRfjb1WDQ/f1w==
Date:   Thu, 9 Jun 2022 17:43:53 +0200
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Alexander Aring <aahringo@redhat.com>
Cc:     Alexander Aring <alex.aring@gmail.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        linux-wpan - ML <linux-wpan@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Network Development <netdev@vger.kernel.org>,
        David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Nicolas Schodet <nico@ni.fr.eu.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Subject: Re: [PATCH wpan-next 1/6] net: ieee802154: Drop coordinator
 interface type
Message-ID: <20220609174353.177daddb@xps-13>
In-Reply-To: <CAK-6q+gBCakX8Vm1SHuLfex5jBqLKySUiaZKg3So+zjeJaSehw@mail.gmail.com>
References: <20220603182143.692576-1-miquel.raynal@bootlin.com>
        <20220603182143.692576-2-miquel.raynal@bootlin.com>
        <CAK-6q+hAZMqsN=S9uWAm4rTN+uZwz7_L42=emPHz7+MvfW6ZpQ@mail.gmail.com>
        <20220606174319.0924f80d@xps-13>
        <CAK-6q+itswJrmy-AhZ5DpnHH0UsfAeTPQTmX8WfG8=PteumVLg@mail.gmail.com>
        <20220607181608.609429cb@xps-13>
        <20220608154749.06b62d59@xps-13>
        <20220608163708.26ccd4cc@xps-13>
        <CAK-6q+iD0_bS2z_BdKsyeqYvzxj2x-v+SWAo2UO02j7yGtEcEg@mail.gmail.com>
        <CAK-6q+gBCakX8Vm1SHuLfex5jBqLKySUiaZKg3So+zjeJaSehw@mail.gmail.com>
Organization: Bootlin
X-Mailer: Claws Mail 4.0.0 (GTK+ 3.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Alex,

> > >
> > >   - How is chosen the beacon order? Should we have a default value?
> > >     Should we default to 15 (not on a beacon enabled PAN)? Should we =
be
> > >     able to update this value during the lifetime of the PAN?
> > > =20
> >
> > Is there no mib default value for this?

I didn't find anything. I suppose we can ask for that parameter at PAN
creation, but otherwise I'll keep a backward compatible value: 15,
which means that the PAN is not beacon enabled (like today, basically).

> > =20
> > >   - The spec talks about the cluster topology, where a coordinator th=
at
> > >     just associated to a PAN starts emitting beacons, which may enable
> > >     other devices in its range to ask to join the PAN (increased area
> > >     coverage). But then, there is no information about how the newly
> > >     added device should do to join the PAN coordinator which is anyway
> > >     out of range to require the association, transmit data, etc. Any
> > >     idea how this is supposed to work?
> > > =20
> >
> > I think we should maybe add a feature for this later if we don't know
> > how it is supposed to work or there are still open questions and first
> > introduce the manual setup. After that, maybe things will become
> > clearer and we can add support for this part. Is this okay? =20
>=20
> *I also think that this can be done in user space by a daemon by
> triggering netlink commands for scan/assoc/etc. (manual setup) and
> providing such functionality as mentioned by the spec (auto creation
> of pan, assoc with pan). Things which are unclear here are then moved
> to the user as the operations for scan/assoc/etc. will not be
> different or at least parameterized. The point here is that providing
> the minimum basic functionality should be done at first, then we can
> look at how to realize such handling (either in kernel or user space).

Actually this is none of the 802.15.4 MAC layer business. I believe
this is the upper layer duty to make this interoperability work,
namely, 6lowpan?

Thanks,
Miqu=C3=A8l
