Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CBFD3C1C17
	for <lists+netdev@lfdr.de>; Fri,  9 Jul 2021 01:29:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229592AbhGHXbv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Jul 2021 19:31:51 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:44440 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229491AbhGHXbu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Jul 2021 19:31:50 -0400
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 2D8732024F;
        Thu,  8 Jul 2021 23:29:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1625786947; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type;
        bh=jRM17MYEmPPMTOEJZ9cODH1z24/qIltFI0AoJ1Zy9qc=;
        b=m4bPGEHI7Zu/PYJSvxSL3L01mTQXeiXZ7JqYlaizPf3JGZEVTYkDwpSWM07JJXlAzVuhgZ
        52CR5D3VYyMWosyazv5RnsRxXVmu4Hkkl287OWhtA3gF2PWTxDU8qq4/wzK0XJJxptWH9M
        fpIdgu27FaAEkYMf65A9lry+aqkpbyQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1625786947;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type;
        bh=jRM17MYEmPPMTOEJZ9cODH1z24/qIltFI0AoJ1Zy9qc=;
        b=NZTXBmQWd8lZ2f45dLSnwJ2ej3E8qaxFBKBK0hDrYVmQ4eOs7KXUOlbtAv4S4ledGD0Lz3
        ctrRvMqNw50rceAw==
Received: from lion.mk-sys.cz (unknown [10.100.200.14])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 237ACA3B9E;
        Thu,  8 Jul 2021 23:29:07 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id 05A96607CD; Fri,  9 Jul 2021 01:29:07 +0200 (CEST)
Date:   Fri, 9 Jul 2021 01:29:07 +0200
From:   Michal Kubecek <mkubecek@suse.cz>
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>, Michel Salim <michel@fb.com>
Subject: ethtool 5.13 released
Message-ID: <20210708232907.5zfyq4ld2y6j5q4o@lion.mk-sys.cz>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="v25scly3nmwok4cg"
Content-Disposition: inline
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--v25scly3nmwok4cg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hello,

ethtool 5.13 has been released.

Home page: https://www.kernel.org/pub/software/network/ethtool/
Download link:
https://www.kernel.org/pub/software/network/ethtool/ethtool-5.13.tar.xz

Release notes:

	* Feature: netlink handler for FEC (--show-fec and --set-fec)
	* Feature: FEC stats support (--show-fec)
	* Feature: standard based stats support (-S)
	* Feature: netlink handler for module EEPROM dump (-m)
	* Feature: page, bank and i2c selection in module dump (-m)

Michal

--v25scly3nmwok4cg
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEWN3j3bieVmp26mKO538sG/LRdpUFAmDnijwACgkQ538sG/LR
dpVpwQf/fSBEj98nnV6OFZEOkZwucBhBUr0c1S9JYCnPcc0m/mf+dP+LjASiSth+
KxMly/I+TIJIT9MSbbyBePGs9rJ1mUjdIPR9wDJ7eIwoVfck5XfsuUnd+gYmbExe
/rzkMxqRQRO07dV3kas/A2ZY4x0RtevMoLltDaOkFRAWu3yC58Vh4eWpZRbz3T93
xdN7LSNR64fSVDjQ4iIaAjZ9jkilkqWxKUD3s8rafMwG6Z89SuOmT8jtjwtb0AIk
JQqkW/P1tLns7uL28lHPNj2/02M1/Shr1CyNmqlQ9fjq9DYJf76rt01ZKYAOuoUD
DaygwfIF6SPJWQmSU55LrcXdy6Nkeg==
=ySgx
-----END PGP SIGNATURE-----

--v25scly3nmwok4cg--
