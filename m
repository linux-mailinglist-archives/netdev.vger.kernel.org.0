Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A00D4AEBF7
	for <lists+netdev@lfdr.de>; Wed,  9 Feb 2022 09:14:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239374AbiBIINj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Feb 2022 03:13:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232976AbiBIINh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Feb 2022 03:13:37 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77D03C0613CA;
        Wed,  9 Feb 2022 00:13:41 -0800 (PST)
From:   Kurt Kanzenbach <kurt@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1644394417;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=55uGoGOXVXr/CU8B27DFis8x7dmdIhagfD04+QtdGKE=;
        b=3+yEFeh10cYu5vUeIpDHieFs5MceAnDxBorFsWmfogLGt0eWfHb59KdEbEM0DWc0KAaton
        xzwSjOicl+6G+7jsTAXnTA+5uAh9Q8ffun8gLTjrA/Rqq+9jDO/xJME528y15Bhe7HH0mO
        jYiPo7TPKCv8P9ofBhxg52OHDSkTjoz+HlXvAszQcP7kMI5mddlOp02ysf2gDm8JJuccKW
        H6mb/dDFm3DEtBbKtJdewebRqGxsD2PtWQac7e0VN1XMuYqjELzTqibdMrWo4Cny/dgVfg
        Q/jBXW5eHOj+oeFcqA9tvptq9Rm5mVKNF0AYuWYkYUx7yh6LKrroLLiZzwnnXg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1644394417;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=55uGoGOXVXr/CU8B27DFis8x7dmdIhagfD04+QtdGKE=;
        b=wHScDZQ/cdiHJvpfbuvWktHrSwQyJTN7VtNF+NVmSCpBo+joZ0AEQBBt7B/KpIsOoTx6GN
        aKObuN34IrsnOxCQ==
To:     Jakub Kicinski <kuba@kernel.org>,
        Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, vinschen@redhat.com,
        maciej.fijalkowski@intel.com, magnus.karlsson@intel.com,
        ast@kernel.org, daniel@iogearbox.net, hawk@kernel.org,
        john.fastabend@gmail.com, bpf@vger.kernel.org
Subject: Re: [PATCH net-next 0/2][pull request] 1GbE Intel Wired LAN Driver
 Updates 2022-02-07
In-Reply-To: <20220208211305.47dc605f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20220207233246.1172958-1-anthony.l.nguyen@intel.com>
 <20220208211305.47dc605f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Date:   Wed, 09 Feb 2022 09:13:36 +0100
Message-ID: <87sfssv4nj.fsf@kurt>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha512; protocol="application/pgp-signature"
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi Tony,

On Tue Feb 08 2022, Jakub Kicinski wrote:
> On Mon,  7 Feb 2022 15:32:44 -0800 Tony Nguyen wrote:
>> Corinna Vinschen says:
>>=20
>> Fix the kernel warning "Missing unregister, handled but fix driver"
>> when running, e.g.,
>>=20
>>   $ ethtool -G eth0 rx 1024
>>=20
>> on igc.  Remove memset hack from igb and align igb code to igc.
>
> Why -next?

Can we get these patches into net, please? The mentioned igc problem
exists on v5.15-LTS too.

FWIW, Tested-by: Kurt Kanzenbach <kurt@linutronix.de>

Thanks,
Kurt

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQJHBAEBCgAxFiEEvLm/ssjDfdPf21mSwZPR8qpGc4IFAmIDd7ATHGt1cnRAbGlu
dXRyb25peC5kZQAKCRDBk9HyqkZzgsicD/4ycIDiu4QnmSz8HaG/e2dSm7sS/xul
CFKxPpWpqSBFNCEjEDy6BTE9eXjJNEw5qDDKwDQU7t8UpycwbEsfTc7rM505DZBP
t81ZpWia5RXXJgxBCpFaPebIflc8Uqx5hEZJCgEDyDZT+fxTp8toLx/zX+jvHeQC
UytdCOtIiTU2JNSVbDQSqcF7M3fIKCgqT0O01vDIzejF3e7o3iI5VDVH79RaW/Qj
wIjKFeQ9tJCLWMoabpH/O6AZo9veYrDE4EtxIGc4QwEeISrXJVqtXhU7keccQ/wk
echpZ0I+ai15jdBbfVAl6RA/cSefIQfVhhxC8ypaZ5xy2kLN0BCCK6z8Ytavx9La
ERLw1BW85s9r8KI5mbRBHdYx7WxZHtp3znCK26kGzsinAPCid48O1QwUkEqWrD0J
rKqYlOG/hvlt/1wDBVB8mpZDzuDphzgK+9lN9DUAi1TKQR0NWqXInaIVU+i8qU8Q
vrcMhTn9KrgVBU/UNhctCDjQ4SAv6zudIh1dKYSVdG7XtAjgsZPJU9WrqOIlXz7y
QWEyvUMJRFSNIjTEo7stx1RzjbulA5QPd3lazk0ko2fvW+Fgwu1pCnhDlcGBxmRN
16uFP7450SP4ky5iPy16xr5gc0IB7VJjz5MHiFQseMJWZlGimzwLNS/5RIdUWMF7
2rK+dk14l1Isvg==
=68Ih
-----END PGP SIGNATURE-----
--=-=-=--
