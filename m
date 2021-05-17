Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 509F9386C81
	for <lists+netdev@lfdr.de>; Mon, 17 May 2021 23:44:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238139AbhEQVpY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 May 2021 17:45:24 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:58637 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230508AbhEQVpW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 May 2021 17:45:22 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id E9AD25C0172;
        Mon, 17 May 2021 17:44:04 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Mon, 17 May 2021 17:44:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=tlZBfa
        KRDABNllg2+fYxJA26vcxtyQM/CjtTLSQKZrM=; b=wmVUTuSrwBIVD7qZwtTXXJ
        fjslq3lomOz3PPW4idFTqChNCAD87/t0a8guBGZnKurQc77OcSekraUKD/2nZKmP
        /kS5rJ6OJofq8LznRv1uwrQU7eNq2BC4KjX6Zv09rcCy8TsSWzIvcSA6fyzyNgVt
        nZKMmk0oGACUfpzw/NApWIMcAjwkF0Mm4VZSK9roLWcnB50chVO+Z5k5jfGqtJoX
        lhwz3v4rp0PB+h/c47vuh1urr0UIwJznczuHg4kJ+73RWDMebDpTKUG8FY42Jw+E
        XVvjkJTmrqRBQT24hBz4TyCmR1FaJqBb+wezpVyd5W0Wx4mI/dmTNc2aqHoG2ejg
        ==
X-ME-Sender: <xms:pOOiYChedNEkEWou1mpGuigpM6k-D_vi2AQRjwdmiMfsc6NAcSTJGA>
    <xme:pOOiYDAj-n8vVld6WLCqWAVnM0EBkurCK43h5pCfSGCX_hd0JUUJSXPIhoyTDTzzO
    zshQKdBMiLLUw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdeihedgudeigecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvuffkfhggtggujgesghdtreertddtjeenucfhrhhomhepofgrrhgv
    khcuofgrrhgtiiihkhhofihskhhiqdfikphrvggtkhhiuceomhgrrhhmrghrvghksehinh
    hvihhsihgslhgvthhhihhnghhslhgrsgdrtghomheqnecuggftrfgrthhtvghrnhepkeeg
    tdfgvdeihefhhedtvdelieeiueetveehteffjeejjedvieejvefhueeffeegnecuffhomh
    grihhnpehgihhthhhusgdrtghomhenucfkphepledurdeijedrjeelrdegnecuvehluhhs
    thgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepmhgrrhhmrghrvghkse
    hinhhvihhsihgslhgvthhhihhnghhslhgrsgdrtghomh
X-ME-Proxy: <xmx:pOOiYKFzvkC1uenmtT0zvUAm6JqNUmLYitaTxurgJ-h_vlBy92rGqw>
    <xmx:pOOiYLRNSSjS09hu-plzFv6O2-M3bz4-3_-RaKUkuEcbTzSlF_1cww>
    <xmx:pOOiYPyROfmJjGKeG6WqB_ho4GsWglGJWBVhUqjKEQH68PCVBxZ1EQ>
    <xmx:pOOiYKqQIZ5VBnBjYPQGZ71ZiEB1dPVT6FU0xS9Q_IrC41cgvZZPZA>
Received: from mail-itl (ip5b434f04.dynamic.kabel-deutschland.de [91.67.79.4])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Mon, 17 May 2021 17:44:03 -0400 (EDT)
Date:   Mon, 17 May 2021 23:43:59 +0200
From:   Marek =?utf-8?Q?Marczykowski-G=C3=B3recki?= 
        <marmarek@invisiblethingslab.com>
To:     "Durrant, Paul" <pdurrant@amazon.co.uk>
Cc:     Michael Brown <mbrown@fensystems.co.uk>,
        "paul@xen.org" <paul@xen.org>,
        "xen-devel@lists.xenproject.org" <xen-devel@lists.xenproject.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "wei.liu@kernel.org" <wei.liu@kernel.org>,
        Ian Jackson <iwj@xenproject.org>, Wei Liu <wl@xen.org>,
        Anthony PERARD <anthony.perard@citrix.com>
Subject: Re: [PATCH] xen-netback: Check for hotplug-status existence before
 watching
Message-ID: <YKLjoALdw4oKSZ04@mail-itl>
References: <20210413152512.903750-1-mbrown@fensystems.co.uk>
 <YJl8IC7EbXKpARWL@mail-itl>
 <404130e4-210d-2214-47a8-833c0463d997@fensystems.co.uk>
 <YJmBDpqQ12ZBGf58@mail-itl>
 <21f38a92-c8ae-12a7-f1d8-50810c5eb088@fensystems.co.uk>
 <YJmMvTkp2Y1hlLLm@mail-itl>
 <df9e9a32b0294aee814eeb58d2d71edd@EX13D32EUC003.ant.amazon.com>
 <YJpfORXIgEaWlQ7E@mail-itl>
 <YJpgNvOmDL9SuRye@mail-itl>
 <9edd6873034f474baafd70b1df693001@EX13D32EUC003.ant.amazon.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="k7Ovt1DhdVgIdtca"
Content-Disposition: inline
In-Reply-To: <9edd6873034f474baafd70b1df693001@EX13D32EUC003.ant.amazon.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--k7Ovt1DhdVgIdtca
Content-Type: text/plain; protected-headers=v1; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Date: Mon, 17 May 2021 23:43:59 +0200
From: Marek =?utf-8?Q?Marczykowski-G=C3=B3recki?= <marmarek@invisiblethingslab.com>
To: "Durrant, Paul" <pdurrant@amazon.co.uk>
Cc: Michael Brown <mbrown@fensystems.co.uk>, "paul@xen.org" <paul@xen.org>,
	"xen-devel@lists.xenproject.org" <xen-devel@lists.xenproject.org>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	"wei.liu@kernel.org" <wei.liu@kernel.org>,
	Ian Jackson <iwj@xenproject.org>, Wei Liu <wl@xen.org>,
	Anthony PERARD <anthony.perard@citrix.com>
Subject: Re: [PATCH] xen-netback: Check for hotplug-status existence before
 watching

On Tue, May 11, 2021 at 12:46:38PM +0000, Durrant, Paul wrote:
> > -----Original Message-----
> > From: Marek Marczykowski-G=C3=B3recki <marmarek@invisiblethingslab.com>
> > Sent: 11 May 2021 11:45
> > To: Durrant, Paul <pdurrant@amazon.co.uk>
> > Cc: Michael Brown <mbrown@fensystems.co.uk>; paul@xen.org; xen-devel@li=
sts.xenproject.org;
> > netdev@vger.kernel.org; wei.liu@kernel.org
> > Subject: RE: [EXTERNAL] [PATCH] xen-netback: Check for hotplug-status e=
xistence before watching
> >=20
> > On Tue, May 11, 2021 at 12:40:54PM +0200, Marek Marczykowski-G=C3=B3rec=
ki wrote:
> > > On Tue, May 11, 2021 at 07:06:55AM +0000, Durrant, Paul wrote:
> > > > > -----Original Message-----
> > > > > From: Marek Marczykowski-G=C3=B3recki <marmarek@invisiblethingsla=
b.com>
> > > > > Sent: 10 May 2021 20:43
> > > > > To: Michael Brown <mbrown@fensystems.co.uk>; paul@xen.org
> > > > > Cc: paul@xen.org; xen-devel@lists.xenproject.org; netdev@vger.ker=
nel.org; wei.liu@kernel.org;
> > Durrant,
> > > > > Paul <pdurrant@amazon.co.uk>
> > > > > Subject: RE: [EXTERNAL] [PATCH] xen-netback: Check for hotplug-st=
atus existence before watching
> > > > >
> > > > > On Mon, May 10, 2021 at 08:06:55PM +0100, Michael Brown wrote:
> > > > > > If you have a suggested patch, I'm happy to test that it doesn'=
t reintroduce
> > > > > > the regression bug that was fixed by this commit.
> > > > >
> > > > > Actually, I've just tested with a simple reloading xen-netfront m=
odule. It
> > > > > seems in this case, the hotplug script is not re-executed. In fac=
t, I
> > > > > think it should not be re-executed at all, since the vif interface
> > > > > remains in place (it just gets NO-CARRIER flag).
> > > > >
> > > > > This brings a question, why removing hotplug-status in the first =
place?
> > > > > The interface remains correctly configured by the hotplug script =
after
> > > > > all. From the commit message:
> > > > >
> > > > >     xen-netback: remove 'hotplug-status' once it has served its p=
urpose
> > > > >
> > > > >     Removing the 'hotplug-status' node in netback_remove() is wro=
ng; the script
> > > > >     may not have completed. Only remove the node once the watch h=
as fired and
> > > > >     has been unregistered.
> > > > >
> > > > > I think the intention was to remove 'hotplug-status' node _later_=
 in
> > > > > case of quickly adding and removing the interface. Is that right,=
 Paul?
> > > >
> > > > The removal was done to allow unbind/bind to function correctly. II=
RC before the original patch
> > doing a bind would stall forever waiting for the hotplug status to chan=
ge, which would never happen.
> > >
> > > Hmm, in that case maybe don't remove it at all in the backend, and let
> > > it be cleaned up by the toolstack, when it removes other backend-rela=
ted
> > > nodes?
> >=20
> > No, unbind/bind _does_ require hotplug script to be called again.
> >=20
>=20
> Yes, sorry I was misremembering. My memory is hazy but there was definite=
ly a problem at the time with leaving the node in place.
>=20
> > When exactly vif interface appears in the system (starts to be available
> > for the hotplug script)? Maybe remove 'hotplug-status' just before that
> > point?
> >=20
>=20
> I really can't remember any detail. Perhaps try reverting both patches th=
en and check that the unbind/rmmod/modprobe/bind sequence still works (and =
the backend actually makes it into connected state).

Ok, I've tried this. I've reverted both commits, then used your test
script from the 9476654bd5e8ad42abe8ee9f9e90069ff8e60c17:
   =20
    This has been tested by running iperf as a server in the test VM and
    then running a client against it in a continuous loop, whilst also
    running:
   =20
    while true;
      do echo vif-$DOMID-$VIF >unbind;
      echo down;
      rmmod xen-netback;
      echo unloaded;
      modprobe xen-netback;
      cd $(pwd);
      brctl addif xenbr0 vif$DOMID.$VIF;
      ip link set vif$DOMID.$VIF up;
      echo up;
      sleep 5;
      done
   =20
    in dom0 from /sys/bus/xen-backend/drivers/vif to continuously unbind,
    unload, re-load, re-bind and re-plumb the backend.
   =20
In fact, the need to call `brctl` and `ip link` manually is exactly
because the hotplug script isn't executed. When I execute it manually,
the backend properly gets back to working. So, removing 'hotplug-status'
was in the correct place (netback_remove). The missing part is the toolstack
calling the hotplug script on xen-netback re-bind.

In this case, I'm not sure what is the proper way. If I restart
xendriverdomain service (I do run the backend in domU), it properly
executes hotplug script and the backend interface gets properly
configured. But it doesn't do it on its own. It seems to be related to
device "state" in xenstore. The specific part of the libxl is
backend_watch_callback():
https://github.com/xen-project/xen/blob/master/tools/libs/light/libxl_devic=
e.c#L1664

    ddev =3D search_for_device(dguest, dev);
    if (ddev =3D=3D NULL && state =3D=3D XenbusStateClosed) {
        /*
         * Spurious state change, device has already been disconnected
         * or never attached.
         */
        goto skip;
    } else if (ddev =3D=3D NULL) {
        rc =3D add_device(egc, nested_ao, dguest, dev);
        if (rc > 0)
            free_ao =3D true;
    } else if (state =3D=3D XenbusStateClosed && online =3D=3D 0) {
        rc =3D remove_device(egc, nested_ao, dguest, ddev);
        if (rc > 0)
            free_ao =3D true;
        check_and_maybe_remove_guest(gc, ddomain, dguest);
    }

In short: if device gets XenbusStateInitWait for the first time (ddev =3D=3D
NULL case), it goes to add_device() which executes the hotplug script
and stores the device.
Then, if device goes to XenbusStateClosed + online=3D=3D0 state, then it
executes hotplug script again (with "offline" parameter) and forgets the
device. If you unbind the driver, the device stays in
XenbusStateConnected state (in xenstore), and after you bind it again,
it goes to XenbusStateInitWait. It don't think it goes through
XenbusStateClosed, and online stays at 1 too, so libxl doesn't execute
the hotplug script again.

Some solution could be to add an extra case at the end, like "ddev !=3D
NULL && state =3D=3D XenbusStateInitWait && hotplug-status !=3D connected".
And make sure xl devd won't call the same hotplug script multiple times
for the same device _at the same time_ (I'm not sure about the async
machinery here).

But even if xl devd (aka xendriverdomain service) gets "fixes" to
execute hotplug script in that case, I don't think it would work in
backend in dom0 case - there, I think nothing watches already configured
vif interfaces (there is no xl devd daemon in dom0, and xl background
process watches only domain death and cdrom eject events).=20

I'm adding toolstack maintainers, maybe they'll have some idea...

In any case, the issue is not calling the hotplug script, responsible
for configuring newly created vif interface. Not kernel waiting for it.
So, I think both commits should still be reverted.

--=20
Best Regards,
Marek Marczykowski-G=C3=B3recki
Invisible Things Lab

--k7Ovt1DhdVgIdtca
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhrpukzGPukRmQqkK24/THMrX1ywFAmCi46AACgkQ24/THMrX
1ywsqAf/VEiZIJ5Qxk9keLiV804ReqfQfqsC6iuj3exTvVtvR7hzRRe1nMxvuVS6
rjmYRoWYY5V36IH0GXaUb9wri7Kg8uBZ8J9fTsaq8sJTXj+Re0aFckoDTeTwkzJl
CdpdgL1meNwvE7znIpA92LsObRPKqFPzAYMzFNt7eoaFYA7Y81n4nBKbKLfI4PiS
r9mzZSevt3yzGnbU6thYvYbGfmlGYArgZZ2mKi8eaMfnh7lLtHBD692t6AARjce3
j897zPf44EisvYMowITaF1A/D1SVl8cOabPzVj/VC2NP0z2Hjl46aRwrqd5FAM3V
cVO/tttRGl7cxzMOexxRzyn3GeI2rg==
=5+LX
-----END PGP SIGNATURE-----

--k7Ovt1DhdVgIdtca--
