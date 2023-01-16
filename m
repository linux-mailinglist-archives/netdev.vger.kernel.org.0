Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB5FA66BCFC
	for <lists+netdev@lfdr.de>; Mon, 16 Jan 2023 12:38:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229659AbjAPLis (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Jan 2023 06:38:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229701AbjAPLiq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Jan 2023 06:38:46 -0500
Received: from mail.katalix.com (mail.katalix.com [IPv6:2a05:d01c:827:b342:16d0:7237:f32a:8096])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id DB19F1A4A7
        for <netdev@vger.kernel.org>; Mon, 16 Jan 2023 03:38:45 -0800 (PST)
Received: from localhost (82-69-49-219.dsl.in-addr.zen.co.uk [82.69.49.219])
        (Authenticated sender: tom)
        by mail.katalix.com (Postfix) with ESMTPSA id F38037D3A9;
        Mon, 16 Jan 2023 11:38:44 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=katalix.com; s=mail;
        t=1673869125; bh=ySVKjeZr+8RKD6RtJRMerB+07lwPQKW8Eiu2QWPqNts=;
        h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
         Content-Disposition:In-Reply-To:From;
        z=Date:=20Mon,=2016=20Jan=202023=2011:38:44=20+0000|From:=20Tom=20P
         arkin=20<tparkin@katalix.com>|To:=20Cong=20Wang=20<xiyou.wangcong@
         gmail.com>|Cc:=20netdev@vger.kernel.org,=20saeed@kernel.org,=20gna
         ult@redhat.com,=0D=0A=09Cong=20Wang=20<cong.wang@bytedance.com>|Su
         bject:=20Re:=20[Patch=20net=20v3=200/2]=20l2tp:=20fix=20race=20con
         ditions=20in=0D=0A=20l2tp_tunnel_register()|Message-ID:=20<2023011
         6113844.GA14720@katalix.com>|References:=20<20230114030137.672706-
         1-xiyou.wangcong@gmail.com>|MIME-Version:=201.0|Content-Dispositio
         n:=20inline|In-Reply-To:=20<20230114030137.672706-1-xiyou.wangcong
         @gmail.com>;
        b=yeNFnFLHLEMOpwpiCRCfUKn0vvDME3pXQBWrS6z4njPNl8wyx0fdtpTgH9ARYzIfB
         CNsz5zg2UB4VIwTms8jKEn3bWg2nlXu/cCaw1ypQZy6Vy2FGep3aEaqm6ZF4YLYsmw
         d6peYjUYJCn314Lhe+Ie8Vm73mYUqg5481rt15EouOWSAx8LrqBT/kibayFcYCOfKl
         nbnJUBPGs0yUzc2aB8GouIYhKHF94cuYdOJ1JrO7tbOZoLb83d1NVv9lJiK1K7kEjJ
         um3Itg9MyJUSJ04IVgva5Nyzii/tVzNMx2cH1T4abs5S5C8h9AreDUz0NmnXwf4TTs
         /D4gYTwZJrWKQ==
Date:   Mon, 16 Jan 2023 11:38:44 +0000
From:   Tom Parkin <tparkin@katalix.com>
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     netdev@vger.kernel.org, saeed@kernel.org, gnault@redhat.com,
        Cong Wang <cong.wang@bytedance.com>
Subject: Re: [Patch net v3 0/2] l2tp: fix race conditions in
 l2tp_tunnel_register()
Message-ID: <20230116113844.GA14720@katalix.com>
References: <20230114030137.672706-1-xiyou.wangcong@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="82I3+IH0IqGh5yIs"
Content-Disposition: inline
In-Reply-To: <20230114030137.672706-1-xiyou.wangcong@gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--82I3+IH0IqGh5yIs
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On  Fri, Jan 13, 2023 at 19:01:35 -0800, Cong Wang wrote:
> From: Cong Wang <cong.wang@bytedance.com>
>=20
> This patchset contains two patches, the first one is a preparation for
> the second one which is the actual fix. Please find more details in
> each patch description.
>=20
> I have ran the l2tp test (https://github.com/katalix/l2tp-ktest),
> all test cases are passed.
>=20
> ---
> v3: preserve EEXIST errno for user-space
> v2: move IDR allocation to l2tp_tunnel_register()
>=20
> Cong Wang (2):
>   l2tp: convert l2tp_tunnel_list to idr
>   l2tp: close all race conditions in l2tp_tunnel_register()
>=20
>  net/l2tp/l2tp_core.c | 105 +++++++++++++++++++++----------------------
>  1 file changed, 52 insertions(+), 53 deletions(-)
>=20
> --=20
> 2.34.1
>=20

Thanks Cong, this looks good to me now.

Reviewed-by: Tom Parkin <tparkin@katalix.com>

--82I3+IH0IqGh5yIs
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEsUkgyDzMwrj81nq0lIwGZQq6i9AFAmPFN0AACgkQlIwGZQq6
i9CFaQf9GPDTLV22IOpsRPyT5t3KjEFtuG+QNuXwU4zO0+uSZfiv1Hxj9h9RbT+L
T1XY4y4228aiHGuY2TYLlNA+s+F8yv70A8r54dlM6GhHUdEHSZ3maXuXB5UQ/3Ai
cFb4WSuDP7xB1KkTwJEtoA1gC/5DqqB/RUs4q7nhamueAI8YhL2JIRtoe00k5tYy
0K78SeRb+qVATUpoCn0/QXVdFjO7FXW8pYgTolraIZmdpU6+qYPFKIjPYVqb+4pO
OQlOhvdOFbFUGAtCBjtFnbqAXKNUpM2qob8GTAn5gPLwF6qXJInrKQ189npKiiXL
cUDA0Cm7WtPan9N5+rzPosF1kwQkOQ==
=mYYP
-----END PGP SIGNATURE-----

--82I3+IH0IqGh5yIs--
