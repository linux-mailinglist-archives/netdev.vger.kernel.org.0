Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0B8D49317D
	for <lists+netdev@lfdr.de>; Wed, 19 Jan 2022 00:57:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349925AbiARX5J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jan 2022 18:57:09 -0500
Received: from smtp-out2.suse.de ([195.135.220.29]:54558 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238268AbiARX5J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jan 2022 18:57:09 -0500
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 130AC1F37E;
        Tue, 18 Jan 2022 23:57:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1642550228; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type;
        bh=fXyaxqjk/O3a+n31XUfy3MW22cqlrnm4Dsoc2Ap2ArY=;
        b=UPa5RLSAMDMZu4iA3mEP3NskgnWM8TEZ5J+d067uPY6V5fFvQl1bO5430hd9WPGa82dnGQ
        lFYdRrEOduSy+VcJ+m9uTbmSx2MucTs02XokfltYS7czD8YRaHRvHUrUGV7EHOLjVt//+d
        1gYUzuCQWraVFeFyC3fzx0Ook8XrDpc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1642550228;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type;
        bh=fXyaxqjk/O3a+n31XUfy3MW22cqlrnm4Dsoc2Ap2ArY=;
        b=/+1dx+sH72sejQSaTvB+4jBr7YH1adv4nrECFRRniTvymxAcaaeqKppbhO/7kD7Y9HWhW3
        yQTJfQbzfzz5T0AA==
Received: from lion.mk-sys.cz (unknown [10.100.200.14])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 03F10A3B83;
        Tue, 18 Jan 2022 23:57:08 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id E06BD6053D; Wed, 19 Jan 2022 00:57:07 +0100 (CET)
Date:   Wed, 19 Jan 2022 00:57:07 +0100
From:   Michal Kubecek <mkubecek@suse.cz>
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>, Ido Schimmel <idosch@idosch.org>,
        michel@fb.com, dcavalca@fb.com
Subject: ethtool 5.16 released
Message-ID: <20220118235707.mf2rrgijcq4kjsso@lion.mk-sys.cz>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="ffvkqp3xt5g7cmcy"
Content-Disposition: inline
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--ffvkqp3xt5g7cmcy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hello,

ethtool 5.16 has been released.

Home page: https://www.kernel.org/pub/software/network/ethtool/
Download link:
https://www.kernel.org/pub/software/network/ethtool/ethtool-5.16.tar.xz

Release notes:

	* Feature: use memory maps for module EEPROM parsing (-m)
	* Feature: show CMIS diagnostic information (-m)
	* Fix: fix dumping advertised FEC modes (--show-fec)
	* Fix: ignore cable test notifications from other devices (--cable-test)
	* Fix: do not show duplicate options in help text (--help)

Michal

--ffvkqp3xt5g7cmcy
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEWN3j3bieVmp26mKO538sG/LRdpUFAmHnU80ACgkQ538sG/LR
dpWdrQgAryUX79AXSFW2+EyXdlDocui+wLe7LJOIbd0RCyg/RF4R8TQBoyTTnIPW
NWq9E6feZDDlNNxXPJ7nmaW9AgPQXLWAFA111RRXvEtdzSHz/EMaI47XINeNII1k
QqvR9mS5aRdWjHrGAo32EpWFwPYB/yCY61d5b2H53JrL97dbL8BX85PXN9vdsydL
b/6IrVgb8oQHXerRTD5zS5XTPfGFQxmf/8lQqtHxb+P2NjxYv0D0NfMnSkCmcEVc
cO7WZumKJ16sKGooo+IICTB4HKH+BNzDufvfsowXv6cT9aaifINKqk7RsSB+RhWQ
kmXOl/2cjrT0UWdamTJAAnA3hjNbjQ==
=9bxf
-----END PGP SIGNATURE-----

--ffvkqp3xt5g7cmcy--
