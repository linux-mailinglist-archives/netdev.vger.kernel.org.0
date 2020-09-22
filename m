Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84B892748D6
	for <lists+netdev@lfdr.de>; Tue, 22 Sep 2020 21:11:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726650AbgIVTLE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Sep 2020 15:11:04 -0400
Received: from mail.interlinx.bc.ca ([69.165.217.196]:52690 "EHLO
        server.interlinx.bc.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726563AbgIVTLE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Sep 2020 15:11:04 -0400
X-Greylist: delayed 310 seconds by postgrey-1.27 at vger.kernel.org; Tue, 22 Sep 2020 15:11:03 EDT
Received: from pc.interlinx.bc.ca (pc.interlinx.bc.ca [IPv6:fd31:aeb1:48df:0:3b14:e643:83d8:7017])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by server.interlinx.bc.ca (Postfix) with ESMTPSA id BAAFA259DF
        for <netdev@vger.kernel.org>; Tue, 22 Sep 2020 15:05:22 -0400 (EDT)
Message-ID: <fe60df0562f7822027f253527aef2187afdfe583.camel@interlinx.bc.ca>
Subject: RTNETLINK answers: Permission denied
From:   "Brian J. Murrell" <brian@interlinx.bc.ca>
To:     netdev@vger.kernel.org
Date:   Tue, 22 Sep 2020 15:04:43 -0400
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-WeURuhAwfU85tHLp4xJ0"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--=-WeURuhAwfU85tHLp4xJ0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

What are the possible causes of:

# ip route get 2001:4860:4860::8844
RTNETLINK answers: Permission denied

when

# ip route get fd31:aeb1:48df::99
fd31:aeb1:48df::99 from :: dev br-lan proto static src fd31:aeb1:48df::1 me=
tric 1024 pref medium

works just fine?

Using iproute2 5.0.0.

Cheers,
b.


--=-WeURuhAwfU85tHLp4xJ0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEE8B/A+mOVz5cTNBuZ2sHQNBbLyKAFAl9qSssACgkQ2sHQNBbL
yKCoEgf+IWd0WGUom3x46pRewTac+rph/nreShdHwF75COH41Y6lJ1JkIORvKhVx
A+qvDQDGslDJBTbstfZWOk929QCO0dUShom2kY0tDZaKDw9Z0Qbmzb3g2yE4jp1k
AViGTU2Wg1K+kNQv8LfqvopjayjPLJ/8St11s9BLirBt2sTeU775u3YUyRahvao9
SmonasLGjNdfPuCR3jNhdIjIgMzwfMpSHMetUjeZQtUkgGOlONx34k/0m9XxeOVO
3+7cdl7E++Kq1P+N92wd+CHAaTS2fV+NAVOlxKrUe0DWuBsqFuXtDlJxdIYBvxvs
pC8xb2YoZ33IoSukfbmeR8xTXrd+kw==
=vMfs
-----END PGP SIGNATURE-----

--=-WeURuhAwfU85tHLp4xJ0--

