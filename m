Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 971AC44B467
	for <lists+netdev@lfdr.de>; Tue,  9 Nov 2021 22:02:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244847AbhKIVFL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Nov 2021 16:05:11 -0500
Received: from smtp-out2.suse.de ([195.135.220.29]:60560 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244824AbhKIVFK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Nov 2021 16:05:10 -0500
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id F1B8D1FD59
        for <netdev@vger.kernel.org>; Tue,  9 Nov 2021 21:02:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1636491742; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
         mime-version:mime-version:content-type:content-type;
        bh=sSFP0KEcTCKx46JUUjd3ZUUAf42Y7qIjHHAEkod9NGo=;
        b=YKQ2O8YV6gKRYk2xjY8m2t4oRxP+mAR49gMeqwm2UKJXl4QzpgTIVjvvZtBfCR7Aer0F5U
        3N+r6Bx15RRyKbjmzbjR0INKYi1vl/QPME3eTBOcSsbv7i8px1v1OWFyclxpCm56KTdlLv
        EvXAf9apn4OZcwOE0LI66C0Ucva5wSc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1636491742;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
         mime-version:mime-version:content-type:content-type;
        bh=sSFP0KEcTCKx46JUUjd3ZUUAf42Y7qIjHHAEkod9NGo=;
        b=VL3az3sOZJJMlrd3pmA8k1aHL2zWOGcUhHGtih4q+/3lr9q1I5CtwmHiWIvRKmyEYqY81i
        tSZD1Ov0lD2KK6BA==
Received: from lion.mk-sys.cz (unknown [10.100.200.14])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id E9D84A3B83
        for <netdev@vger.kernel.org>; Tue,  9 Nov 2021 21:02:22 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id D2B3E602D1; Tue,  9 Nov 2021 22:02:22 +0100 (CET)
Date:   Tue, 9 Nov 2021 22:02:22 +0100
From:   Michal Kubecek <mkubecek@suse.cz>
To:     netdev@vger.kernel.org
Subject: ethtool 5.15 released
Message-ID: <20211109210222.oofsxukjmxgebunw@lion.mk-sys.cz>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="epu27kyqf6mdfo4x"
Content-Disposition: inline
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--epu27kyqf6mdfo4x
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hello,

ethtool 5.15 has been released.

Home page: https://www.kernel.org/pub/software/network/ethtool/
Download link:
https://www.kernel.org/pub/software/network/ethtool/ethtool-5.15.tar.xz

Relase notes:

	* Feature: new extended link substates for bad signal (no arg)
	* Feature: coalesce cqe mode attributes (-c and -C)
	* Fix: multiple fixes of EEPROM module data parsing (-m)
	* Fix: fix condition to display MDI-X info (no arg)

Michal

--epu27kyqf6mdfo4x
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEWN3j3bieVmp26mKO538sG/LRdpUFAmGK4c4ACgkQ538sG/LR
dpU0pAf/faTCNtQphlTlqX1X6I4BX8Vv7Y7mLWStb3R4zzObFZ10KcauuOj6RWU9
z6YTgDJeCpmSD3FLn/VUNjc+BPHCmhtNkmNecBZSgDolQee2JVTDQ74WHnK2s/qz
GJUtsCggFdjs1JtWrMA1Sqlc6ZLVi2wPBOpbHmcw3pspDlKm/f/7DnoWn8A22CjH
9DHdES1zOtAHm+xao9SgEidvrYWwEea6cDlsfVMnHIN0kYSrOzSkP4S1UlAlgxls
qzjElAzScK5q2ZCtW5aYp+SbQAuSeirWcnPk2uqCNVEoBUa1hK4qMrsaaFVVWAhT
x849+nJ5vCszzoiV/LJRzgctcW5a4Q==
=Kfz+
-----END PGP SIGNATURE-----

--epu27kyqf6mdfo4x--
