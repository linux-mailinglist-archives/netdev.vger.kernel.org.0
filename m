Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C68034081E9
	for <lists+netdev@lfdr.de>; Sun, 12 Sep 2021 23:43:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236545AbhILVoe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Sep 2021 17:44:34 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:47236 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236427AbhILVo1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Sep 2021 17:44:27 -0400
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 04F2821E67;
        Sun, 12 Sep 2021 21:43:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1631482992; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type;
        bh=PuHw5xLu82SNCNuRYKn+QUbL1o/QBkuudwVecwQBT94=;
        b=bsFIJoKkke1JKSSzBNvFIY6cqRWdHnFHp2KcX4W+hb14k28f4BNdpwCcyoTHkxAJaNuTC/
        S01etygGngXv9sjEc2tODAMQgv8fP0F0OYXGHMjPhwmW4WlbxzbgxseoT1GA3Mx0/LHBHQ
        JPMhU3zohMLeyOntfcz08XqHTDeh19Y=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1631482992;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type;
        bh=PuHw5xLu82SNCNuRYKn+QUbL1o/QBkuudwVecwQBT94=;
        b=R37pXOU0EsitxJwnmgPLZCzHb57nZ9AjGRtNWCeYmP/ntQdSCz9w3jmmkOI58Cpzftj3vZ
        JFQnnxT0AD5HYzDQ==
Received: from lion.mk-sys.cz (unknown [10.100.200.14])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id F0293A3B81;
        Sun, 12 Sep 2021 21:43:11 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id CFCDE6085C; Sun, 12 Sep 2021 23:43:08 +0200 (CEST)
Date:   Sun, 12 Sep 2021 23:43:08 +0200
From:   Michal Kubecek <mkubecek@suse.cz>
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>
Subject: ethtool 5.14 released
Message-ID: <20210912214308.lwb6fibqbqygkwtf@lion.mk-sys.cz>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="lf2o2xxiujvyk4nx"
Content-Disposition: inline
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--lf2o2xxiujvyk4nx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hello,

ethtool 5.14 has been released.

Home page: https://www.kernel.org/pub/software/network/ethtool/
Download link:
https://www.kernel.org/pub/software/network/ethtool/ethtool-5.14.tar.xz

Release notes:

	* Feature: do not silently ignore --json if unsupported
	* Feature: support new message types in pretty print

Michal

--lf2o2xxiujvyk4nx
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEWN3j3bieVmp26mKO538sG/LRdpUFAmE+dGYACgkQ538sG/LR
dpWToQf/Xrxb6ZibktysxFA8eqrG5T7pfaH9c4Wx48HIZ+W7zZnXdbwiURrEhW4Q
ek+vuaiqW8AtX7+KgZy9ofx3/RdKjw7Pa1drAZydo1vMNvznQOr9iuN2qhNMvuTJ
7afUR5bgbkDzbJse0xaGZM15SYE5OFICVAD9S2G6sL8cMoUUrJThJdNbeTUfSeEb
yCv90LubH3FPgboG1s//o0WetnPFa09+EwSCbtEQtRjrfWGwCVPDABQ8fci1BHls
k/eCmLOWdnfbFW9BX+5u+leo+/7Y7wvyqCEyrsaGo1pLnufRFk3tswfK7HHDUSIl
jFDsaqFX2DGs/cTQWWcF+Yds9mF4QQ==
=YNOY
-----END PGP SIGNATURE-----

--lf2o2xxiujvyk4nx--
