Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70F87421AFD
	for <lists+netdev@lfdr.de>; Tue,  5 Oct 2021 02:12:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229741AbhJEAOM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Oct 2021 20:14:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229564AbhJEAOL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Oct 2021 20:14:11 -0400
X-Greylist: delayed 39946 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 04 Oct 2021 17:12:22 PDT
Received: from mx1.uni-regensburg.de (mx1.uni-regensburg.de [IPv6:2001:638:a05:137:165:0:3:bdf7])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A471C061745
        for <netdev@vger.kernel.org>; Mon,  4 Oct 2021 17:12:22 -0700 (PDT)
Received: from mx1.uni-regensburg.de (localhost [127.0.0.1])
        by localhost (Postfix) with SMTP id B8BAC600004E;
        Tue,  5 Oct 2021 02:12:12 +0200 (CEST)
Received: from smtp2.uni-regensburg.de (smtp2.uni-regensburg.de [194.94.157.130])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client CN "smtp.uni-regensburg.de", Issuer "DFN-Verein Global Issuing CA" (not verified))
        by mx1.uni-regensburg.de (Postfix) with ESMTPS id A0119600004D;
        Tue,  5 Oct 2021 02:12:12 +0200 (CEST)
From:   "Andreas K. Huettel" <andreas.huettel@ur.de>
To:     Jakub Kicinski <kubakici@wp.pl>,
        Hisashi T Fujinaka <htodd@twofifty.com>
Cc:     netdev@vger.kernel.org, intel-wired-lan@lists.osuosl.org
Subject: Re: [EXT] Re: [Intel-wired-lan] Intel I350 regression 5.10 -> 5.14 ("The NVM Checksum Is Not Valid") [8086:1521]
Date:   Tue, 05 Oct 2021 02:12:07 +0200
Message-ID: <1763660.QCnGb9OGeP@pinacolada>
Organization: Universitaet Regensburg
In-Reply-To: <7064659e-fe97-f222-5176-844569fb5281@twofifty.com>
References: <1823864.tdWV9SEqCh@kailua> <20211004074814.5900791a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com> <7064659e-fe97-f222-5176-844569fb5281@twofifty.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart1830747.g5d078U9FE"; micalg="pgp-sha512"; protocol="application/pgp-signature"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--nextPart1830747.g5d078U9FE
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"; protected-headers="v1"
From: "Andreas K. Huettel" <andreas.huettel@ur.de>
To: Jakub Kicinski <kubakici@wp.pl>, Hisashi T Fujinaka <htodd@twofifty.com>
Cc: netdev@vger.kernel.org, intel-wired-lan@lists.osuosl.org
Subject: Re: [EXT] Re: [Intel-wired-lan] Intel I350 regression 5.10 -> 5.14 ("The NVM Checksum Is Not Valid") [8086:1521]
Date: Tue, 05 Oct 2021 02:12:07 +0200
Message-ID: <1763660.QCnGb9OGeP@pinacolada>
Organization: Universitaet Regensburg
In-Reply-To: <7064659e-fe97-f222-5176-844569fb5281@twofifty.com>
References: <1823864.tdWV9SEqCh@kailua> <20211004074814.5900791a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com> <7064659e-fe97-f222-5176-844569fb5281@twofifty.com>

> >> 
> >> Any advice on how to proceed? Willing to test patches and provide
> >> additional debug info.
> Sorry to reply from a non-Intel account. I would suggest first
> contacting Dell, and then contacting DeLock. This sounds like an
> issue with motherboard firmware and most of what I can help with
> would be with the driver. I think the issues are probably before
> things get to the driver.

Ouch. OK. Can you think of any temporary workaround?

(Other than downgrading to 5.10 again, which I can't since it fails
at the graphics (i915) modesetting...)

--nextPart1830747.g5d078U9FE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQKTBAABCgB9FiEE6W4INB9YeKX6Qpi1TEn3nlTQogYFAmFbmFdfFIAAAAAALgAo
aXNzdWVyLWZwckBub3RhdGlvbnMub3BlbnBncC5maWZ0aGhvcnNlbWFuLm5ldEU5
NkUwODM0MUY1ODc4QTVGQTQyOThCNTRDNDlGNzlFNTREMEEyMDYACgkQTEn3nlTQ
ogbdshAAuFBG8OIaWdfgGHuHTh6dT2hK03IkqtfT5NqHtB7LenaU2tddBmFcm44k
8/Moh1sI7E0YJDf5Ae35sN5qryl6iX+4NM0pnpoR769Blfs777FkUclA/4Arn5xG
HVuBg/QUd53sPqvvbJ9JNTlt4oriaVQRmIPcBEQRJw0AJl8sgjU3ddAVhmbjZ2uF
apBEjVup8oq8qDs3gOMyICX7eT0vcR4KL+pRJo525Y9btnVa4T1pBFXSMhSx/egg
3Z6z//ufoyfaWPbCa5l7UmgLnysMwnuDVkZ5U7EKoQT4zXWuaHkmxyKiM72vt90u
pU+bB55nLzMNvN93ROClscIk49tlgUMqTBS0GkfkGbSMNF2fpzCmSERYlt3UpVRJ
lXf6+LljAtxAo4UgGOHCt4k3fqns+IKWW4qH0E5B1giGY7CJ1cgmPZlH9MYn0KK7
a+G/xvPQKHuAwEYD44CE09UbHJF25JHNLxrx9H+v44j6oNTSeeXEtYIyBnt0rC53
Sqn7Qt8y3s8UJ5lazUKWhSTXw3HKuYolscoag0wJaiKL98dUrroeQqH7XxK5Nabk
vz66yjZevR/MGHgVO/+/0+vq2FuIeHpjq4j5MqRsyHLkemlkqBWJ2u82H9Angndl
DJYuMLIxhOghlgVPQo6iNylr2l1RPq9rq7GqRpi16oHQmHnGgSM=
=G/5u
-----END PGP SIGNATURE-----

--nextPart1830747.g5d078U9FE--



