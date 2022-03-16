Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E1BB4DB836
	for <lists+netdev@lfdr.de>; Wed, 16 Mar 2022 19:52:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245718AbiCPSxu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Mar 2022 14:53:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238326AbiCPSxs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Mar 2022 14:53:48 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0121F6BDE0
        for <netdev@vger.kernel.org>; Wed, 16 Mar 2022 11:52:33 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 96D57210F0;
        Wed, 16 Mar 2022 18:52:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1647456752; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=lnkKOOiU1ETiY0y3zxpYvKjnp4Sb3EQiWIiknCU8CQ8=;
        b=LafSDfycolytbYjiKn5hfbYme9YbT5vAPiU35KJEGWi5L7txBtbylxyn6JNOtX4rjX4VxR
        vvwcODMqqfZ3AeRnbIHG3gAL+uSppf1Z3GT4l2Bml+dkTh6GcHbQ21zcS5O7iz3BA2nN9/
        cug3ENtvc4EBoNPPxLlBmSaZ2Qoj4hc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1647456752;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=lnkKOOiU1ETiY0y3zxpYvKjnp4Sb3EQiWIiknCU8CQ8=;
        b=Dvih3qncc7Q137BrOoxqM720wkXZUSB12aYFK0v+NrtbkhHcch6PpT84YcWA2ajKcHDvwN
        0gviuCsJzOstFbAA==
Received: from lion.mk-sys.cz (unknown [10.100.200.14])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 63C71A3B81;
        Wed, 16 Mar 2022 18:52:32 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id 3B303602FD; Wed, 16 Mar 2022 19:52:32 +0100 (CET)
Date:   Wed, 16 Mar 2022 19:52:32 +0100
From:   Michal Kubecek <mkubecek@suse.cz>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Manish Chopra <manishc@marvell.com>,
        Paul Menzel <pmenzel@molgen.mpg.de>,
        Ariel Elior <aelior@marvell.com>,
        Sudarsana Reddy Kalluru <skalluru@marvell.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "it+netdev@molgen.mpg.de" <it+netdev@molgen.mpg.de>
Subject: Re: [EXT] Re: bnx2x: ppc64le: Unable to set message level greater
 than 0x7fff
Message-ID: <20220316185232.ttsuvp4wbdxztned@lion.mk-sys.cz>
References: <0497a560-8c7b-7cf8-84ee-bde1470ae360@molgen.mpg.de>
 <20220315183529.255f2795@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <db796473-69cf-122e-ec40-de62659517b0@molgen.mpg.de>
 <ade0ed87-be4f-e3c7-5e01-4bfdb78fae07@molgen.mpg.de>
 <BY3PR18MB4612AD5E7F7D59233990A21DAB119@BY3PR18MB4612.namprd18.prod.outlook.com>
 <20220316111754.5316bfb5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="sqphjpr54tkrt3wv"
Content-Disposition: inline
In-Reply-To: <20220316111754.5316bfb5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--sqphjpr54tkrt3wv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Mar 16, 2022 at 11:17:54AM -0700, Jakub Kicinski wrote:
> On Wed, 16 Mar 2022 11:49:39 +0000 Manish Chopra wrote:
> > As ethtool over netlink has some limitations of the size,
> > I believe you can configure ethtool with "--disable-netlink" and set th=
ose message levels fine
>=20
> Yup, IIUC it works for Paul on a 5.17 system, that system likely has
> old ethtool user space tool which uses ioctls instead of netlink.
>=20
> What makes the netlink path somewhat non-trivial is that there is=20
> an expectation that the communication can be based on names (strings)
> as well as bit positions. I think we'd need a complete parallel
> attribute to carry vendor specific bits :S

Yes, that would be a way to go. However, in such case I would prefer
separating these driver/device specific message flags completely rather
then letting drivers grab currently unused flags (as is the case here,
IIUC) as those are likely to collide with future global ones.

Michal

--sqphjpr54tkrt3wv
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEWN3j3bieVmp26mKO538sG/LRdpUFAmIyMeoACgkQ538sG/LR
dpXXDwf+MojGtSLGC/uC3T0dwdw0tEaK0rWjy4+paRSL68FUFIFNkP4hQbyKbujD
v69NqqPWru5/3ayVmr+/CXLxajEcX35+bgcPQctyO98ktgqeFlyp3oMUfLbRwIQE
U2kD4diA9lZoQR+AsSy7wubP4TsIT7LtU37XErA3bKsIlPM3UKl1oty0+eh2FxAb
oBlyGHaREIkQdDfbMoCfkYJkx8sWUtMHlw3KE7NoHnPqzRiRtqRt07z2ww/SmBkT
+Bsxs3Q4dAKsbLH2jWHLU3v2zWKkaBwrEaIAyvX/v/PZqJdN9XxJZD9frKUH1rZq
YxZwuCG6FWtc8VT44sDzrIgPRa22WQ==
=MW/+
-----END PGP SIGNATURE-----

--sqphjpr54tkrt3wv--
