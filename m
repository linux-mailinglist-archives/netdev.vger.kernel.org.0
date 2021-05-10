Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 591EF37970E
	for <lists+netdev@lfdr.de>; Mon, 10 May 2021 20:32:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232602AbhEJSdL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 May 2021 14:33:11 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:58149 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231400AbhEJSdK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 May 2021 14:33:10 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id A4CF95C0059;
        Mon, 10 May 2021 14:32:04 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Mon, 10 May 2021 14:32:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=aOuFH0
        WYG7OLoDZYT2WsE8sb6UDPB+uWwy6WV5ejnUY=; b=r9of+koFcZeIECKV/m5Az/
        20yNDdgPap1GQd4u/RysICY2u90EGJ6mone6051he+xtDt8+aqmE3+Rs1KgBiXn7
        GZXdSJp5hhJc4O949gzcgzRmOr5Chjn8LrQPzWnILSjMniD5LcP7jZ2edR3XtrPa
        9A2LC7AwNgaBJMOe73XyjmMFgBxg/uaexaCx6xlXoKUsslm1qCZbhjfKUN6aIZQe
        /I3yamW35qCGPukto1NS9oDAcjHYjAKCGpfF4NlFrmHK/OU9oMQ5xOZu17+UR2P+
        XTMpShP3TVQWmxLwYH5KIuO8MYONqoxNtX29GE+Ifs6J1LQD9v8DzG6ofkbcI4Kg
        ==
X-ME-Sender: <xms:JHyZYOF9oGa0R_3xdkj2MVUZYMluNIX-veUCo0jp3RM-SfFTR2vp7Q>
    <xme:JHyZYPXaz1S1RFQLr_PtGrLZco_VN7aO-I4HudOKv6c5ZsciXWgoVhAl3oBL9vhGa
    0D5issB3WI1dQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdegkedguddviecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvuffkfhggtggujgesghdtreertddtjeenucfhrhhomhepofgrrhgv
    khcuofgrrhgtiiihkhhofihskhhiqdfikphrvggtkhhiuceomhgrrhhmrghrvghksehinh
    hvihhsihgslhgvthhhihhnghhslhgrsgdrtghomheqnecuggftrfgrthhtvghrnhepteev
    ffeigffhkefhgfegfeffhfegveeikeettdfhheevieehieeitddugeefteffnecukfhppe
    eluddrieejrdejledrgeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgr
    ihhlfhhrohhmpehmrghrmhgrrhgvkhesihhnvhhishhisghlvghthhhinhhgshhlrggsrd
    gtohhm
X-ME-Proxy: <xmx:JHyZYIKwdCLclEikCJ7gw3h59PVxkuUlQtcWrInR2jytX0M2O-jItg>
    <xmx:JHyZYIFf_zqu7J_e-F3dhpsuRZpZY88nIsiDNspK1vZeYwt7ic_IYw>
    <xmx:JHyZYEVUubPhukPrWMNharCLpRK8XRZe2F4kVLfOvLZAMWHOLXQdAA>
    <xmx:JHyZYBjF_gsDAC1jUet5rzoBhFBHjqhXjwfsbakPs-dXPgAvnjKFxQ>
Received: from mail-itl (ip5b434f04.dynamic.kabel-deutschland.de [91.67.79.4])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Mon, 10 May 2021 14:32:03 -0400 (EDT)
Date:   Mon, 10 May 2021 20:32:00 +0200
From:   Marek =?utf-8?Q?Marczykowski-G=C3=B3recki?= 
        <marmarek@invisiblethingslab.com>
To:     Michael Brown <mbrown@fensystems.co.uk>
Cc:     paul@xen.org, xen-devel@lists.xenproject.org,
        netdev@vger.kernel.org, wei.liu@kernel.org, pdurrant@amazon.com
Subject: Re: [PATCH] xen-netback: Check for hotplug-status existence before
 watching
Message-ID: <YJl8IC7EbXKpARWL@mail-itl>
References: <54659eec-e315-5dc5-1578-d91633a80077@xen.org>
 <20210413152512.903750-1-mbrown@fensystems.co.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="4nndLI8LmWn0yaOQ"
Content-Disposition: inline
In-Reply-To: <20210413152512.903750-1-mbrown@fensystems.co.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--4nndLI8LmWn0yaOQ
Content-Type: text/plain; protected-headers=v1; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Date: Mon, 10 May 2021 20:32:00 +0200
From: Marek =?utf-8?Q?Marczykowski-G=C3=B3recki?= <marmarek@invisiblethingslab.com>
To: Michael Brown <mbrown@fensystems.co.uk>
Cc: paul@xen.org, xen-devel@lists.xenproject.org, netdev@vger.kernel.org,
	wei.liu@kernel.org, pdurrant@amazon.com
Subject: Re: [PATCH] xen-netback: Check for hotplug-status existence before
 watching

On Tue, Apr 13, 2021 at 04:25:12PM +0100, Michael Brown wrote:
> The logic in connect() is currently written with the assumption that
> xenbus_watch_pathfmt() will return an error for a node that does not
> exist.  This assumption is incorrect: xenstore does allow a watch to
> be registered for a nonexistent node (and will send notifications
> should the node be subsequently created).
>=20
> As of commit 1f2565780 ("xen-netback: remove 'hotplug-status' once it
> has served its purpose"), this leads to a failure when a domU
> transitions into XenbusStateConnected more than once.  On the first
> domU transition into Connected state, the "hotplug-status" node will
> be deleted by the hotplug_status_changed() callback in dom0.  On the
> second or subsequent domU transition into Connected state, the
> hotplug_status_changed() callback will therefore never be invoked, and
> so the backend will remain stuck in InitWait.
>=20
> This failure prevents scenarios such as reloading the xen-netfront
> module within a domU, or booting a domU via iPXE.  There is
> unfortunately no way for the domU to work around this dom0 bug.
>=20
> Fix by explicitly checking for existence of the "hotplug-status" node,
> thereby creating the behaviour that was previously assumed to exist.

This change is wrong. The 'hotplug-status' node is created _only_ by a
hotplug script and done so when it's executed. When kernel waits for
hotplug script to be executed it waits for the node to _appear_, not
_change_. So, this change basically made the kernel not waiting for the
hotplug script at all.

Furthermore, there is an additional side effect: in case of a driver
domain, xl devd may be started after the backend node is created (this
may happen if you start the frontend domain in parallel with the
backend). In this case, 'xl devd' will see the vif backend in
XenbusStateConnected state already and will not execute hotplug script
at all.

I think the proper fix is to re-register the watch when necessary,
instead of not registering it at all.

> Signed-off-by: Michael Brown <mbrown@fensystems.co.uk>
> ---
>  drivers/net/xen-netback/xenbus.c | 12 ++++++++----
>  1 file changed, 8 insertions(+), 4 deletions(-)
>=20
> diff --git a/drivers/net/xen-netback/xenbus.c b/drivers/net/xen-netback/x=
enbus.c
> index a5439c130130..d24b7a7993aa 100644
> --- a/drivers/net/xen-netback/xenbus.c
> +++ b/drivers/net/xen-netback/xenbus.c
> @@ -824,11 +824,15 @@ static void connect(struct backend_info *be)
>  	xenvif_carrier_on(be->vif);
> =20
>  	unregister_hotplug_status_watch(be);
> -	err =3D xenbus_watch_pathfmt(dev, &be->hotplug_status_watch, NULL,
> -				   hotplug_status_changed,
> -				   "%s/%s", dev->nodename, "hotplug-status");
> -	if (!err)
> +	if (xenbus_exists(XBT_NIL, dev->nodename, "hotplug-status")) {
> +		err =3D xenbus_watch_pathfmt(dev, &be->hotplug_status_watch,
> +					   NULL, hotplug_status_changed,
> +					   "%s/%s", dev->nodename,
> +					   "hotplug-status");
> +		if (err)
> +			goto err;
>  		be->have_hotplug_status_watch =3D 1;
> +	}
> =20
>  	netif_tx_wake_all_queues(be->vif->dev);
> =20

--=20
Best Regards,
Marek Marczykowski-G=C3=B3recki
Invisible Things Lab

--4nndLI8LmWn0yaOQ
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhrpukzGPukRmQqkK24/THMrX1ywFAmCZfCAACgkQ24/THMrX
1yxSwQf/YTAGMutixak92lIstM43bfVn4H1cSkIJ6TWKGxS87n4SOfpSP8Az4BDY
TX0DYJt2Ud8zbNJtxo0NKTV7ITjyvXtmMRwqrEPo77N1PMD+Uz4/v9GWgcIJEWkI
FBypIxY/YIY/PswzoKeRDFvTOLg0hgdrtmWkrHI1qTofG7OERWYvLSqj2/5emVni
GuYgL8TrzyFrWZ30F0HR8scAYxONQAnBokhzqBN6Zf7wQukNOcHsx19PCUf7v2f5
jVE4GwOKda/+pAbpHlLZBNCiA4LK8fo74vwzqG1Xd1hFsRcEno/zKmPEKipIC9SC
wEY/Jy1iM5z/l80fEdGO4zic9Jl/Ew==
=Vf0i
-----END PGP SIGNATURE-----

--4nndLI8LmWn0yaOQ--
