Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5356F1B0441
	for <lists+netdev@lfdr.de>; Mon, 20 Apr 2020 10:23:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726228AbgDTIXD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Apr 2020 04:23:03 -0400
Received: from wnew1-smtp.messagingengine.com ([64.147.123.26]:33025 "EHLO
        wnew1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725773AbgDTIXD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Apr 2020 04:23:03 -0400
X-Greylist: delayed 558 seconds by postgrey-1.27 at vger.kernel.org; Mon, 20 Apr 2020 04:23:02 EDT
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailnew.west.internal (Postfix) with ESMTP id 2C9A7434;
        Mon, 20 Apr 2020 04:13:43 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Mon, 20 Apr 2020 04:13:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cerno.tech; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm2; bh=SXSTFribf+OBJQkU3j6jVIz3bY6
        eV4OkRjDaFUbGPVw=; b=dE5h4joV1X2zyfsk9mJ41dSV9Gw9Z/YVaMMRGJ820cJ
        NOM2XNUzGMrQc6ydYn/Zic69B5NNRAo6QYHu7GiXTukZObTUlEBXjml6kZ/h7tAT
        KMRH6rsLmKGHMxHRm7KJLGWmYRqhGKyvler6AycFGuPEGCumuG7dlYNh0te1Urjx
        B6h7D1L21WQxrWq9rbIg2awGPkD9xDLlas4gTjOZhaRUMmGgHQg+K1OSe1L7j+F6
        bmwm6FQYhRHRkEqK671hDPeOeYQIt9YyhceNDEnvh2vN6YHgeij3N4pO5N+DJN7w
        9V+2zj+aOoX22lyD9EziS9+y0v/eOMqyQ7U5xATaBqw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=SXSTFr
        ibf+OBJQkU3j6jVIz3bY6eV4OkRjDaFUbGPVw=; b=G23U+tfw+wQH0rkso4eEwx
        yQrM7P5msXz/OSSuwywZHpLw59W7M9piQzgYDymuZ/YKvqo9EW4FYeWdNyEoH+Ed
        qmqsr4Sy9SCUAWo+U7Xi8UaefRJgr1xVvCWCNwhs0s9c7HwcgF9NnbIaBi1jxF8Q
        z/QcFe7e+rHQBP1rEmpE2U43OrZLm5wRDGIiSoDuD1YdwkM+WbU5zoyBvHMF5KMW
        C7vFCc8JDlwMTEP39M/PyYTBAbvRGE/SyZ1pVAhaeuNueZSROb33Z+uvkYT1/7c3
        cpFJBI0Uq5E1XdygU8RLJ53HUPy2gALcm2KVAsWjq0oho1PeFfIGNg0GONbW7ZHA
        ==
X-ME-Sender: <xms:tFmdXrjoBzIgx--8HKQXgDrtxO5gVSCcQrfVsGCBN7W7YGtfh-qHEA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrgeefucetufdoteggodetrfdotffvucfrrh
    hofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgenuceurghi
    lhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujfgurh
    epfffhvffukfhfgggtuggjsehgtderredttddvnecuhfhrohhmpeforgigihhmvgcutfhi
    phgrrhguuceomhgrgihimhgvsegtvghrnhhordhtvggthheqnecukfhppeeltddrkeelrd
    eikedrjeeinecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhho
    mhepmhgrgihimhgvsegtvghrnhhordhtvggthh
X-ME-Proxy: <xmx:tFmdXix3P9qkRjDO69NN5eUQUL2gZwUhPrg6E8e4InQODtjq81Pbsw>
    <xmx:tFmdXp8VSgOzUNGzxjXDXf0hmnasH9Zn98KD4SKEGNOKFRqoWr01-w>
    <xmx:tFmdXvBn1GLk5m2Pm5avHEkDYkDZzYF2fWl4nUyo3FlyH1VrQfUqxg>
    <xmx:tlmdXt6FXLOMGmuXYEy2LsOWngKuRKcExd-_FWiOCNilGysnqab04_8LDgI>
Received: from localhost (lfbn-tou-1-1502-76.w90-89.abo.wanadoo.fr [90.89.68.76])
        by mail.messagingengine.com (Postfix) with ESMTPA id A92B33280060;
        Mon, 20 Apr 2020 04:13:40 -0400 (EDT)
Date:   Mon, 20 Apr 2020 10:13:39 +0200
From:   Maxime Ripard <maxime@cerno.tech>
To:     Alistair Francis <alistair@alistair23.me>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        marcel@holtmann.org, johan.hedberg@gmail.com,
        linux-bluetooth@vger.kernel.org, wens@csie.org, anarsoul@gmail.com,
        devicetree@vger.kernel.org, alistair23@gmail.com,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v3 3/3] arm64: allwinner: Enable Bluetooth and WiFi on
 sopine baseboard
Message-ID: <20200420081339.znoxmshq2z74slvg@gilmour.lan>
References: <20200412020644.355142-1-alistair@alistair23.me>
 <20200412020644.355142-3-alistair@alistair23.me>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="ejtot7cm3kxebrar"
Content-Disposition: inline
In-Reply-To: <20200412020644.355142-3-alistair@alistair23.me>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--ejtot7cm3kxebrar
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Sat, Apr 11, 2020 at 07:06:44PM -0700, Alistair Francis wrote:
> The sopine board has an optional RTL8723BS WiFi + BT module that can be
> connected to UART1. Add this to the device tree so that it will work
> for users if connected.
>=20
> Signed-off-by: Alistair Francis <alistair@alistair23.me>

Like Vasily said in a previous iteration, this should be an overlay.

Maxime

--ejtot7cm3kxebrar
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRcEzekXsqa64kGDp7j7w1vZxhRxQUCXp1ZswAKCRDj7w1vZxhR
xRHnAQDHNvHWo1zmq8o4pNF0FFVzFdG9ZW4B0hE0ap3rEg3u+QEAtFnUoV0c8i8g
nKNO32LMpG2lK/In+8B74ILYTIcZpAQ=
=IRUG
-----END PGP SIGNATURE-----

--ejtot7cm3kxebrar--
