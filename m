Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F16C4F0D2E
	for <lists+netdev@lfdr.de>; Mon,  4 Apr 2022 02:14:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356905AbiDDAQJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 Apr 2022 20:16:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240577AbiDDAQI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 3 Apr 2022 20:16:08 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D7EF63A9
        for <netdev@vger.kernel.org>; Sun,  3 Apr 2022 17:14:13 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id AC0F91F37F
        for <netdev@vger.kernel.org>; Mon,  4 Apr 2022 00:14:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1649031251; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
         mime-version:mime-version:content-type:content-type;
        bh=Frb7DnYcNNCJ6lfyfsfNjGX8HRiM0a9M3t2pgQtZWDw=;
        b=eb5LzQmbUUWRzdPEePe9czPhxBIvWdFjdlz+hQmHY2zqnPxgphnmjf0+un71d5AQ0GOowG
        eERGsgv2uNQtzeGasDo5kSKKK9lVDseSzH0GlH69BuYdca34yjHzBcZQEecVXSs7qxwiE2
        HaJxC8gh78Y3hw/nyx9UiNY/1yzehBY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1649031251;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
         mime-version:mime-version:content-type:content-type;
        bh=Frb7DnYcNNCJ6lfyfsfNjGX8HRiM0a9M3t2pgQtZWDw=;
        b=TI+x8jS/3geIorsUzVCW20sMGrMBUBKVAAzS56vf9/7zZ6O/E4Vh6KohEf+7eljEtOYhb2
        X8gZ9aV0DIiCd9AA==
Received: from lion.mk-sys.cz (unknown [10.100.200.14])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id A3D2DA3B83
        for <netdev@vger.kernel.org>; Mon,  4 Apr 2022 00:14:11 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id 7BE3A607A1; Mon,  4 Apr 2022 02:14:11 +0200 (CEST)
Date:   Mon, 4 Apr 2022 02:14:11 +0200
From:   Michal Kubecek <mkubecek@suse.cz>
To:     netdev@vger.kernel.org
Subject: ethtool 5.17 released
Message-ID: <20220404001411.cmd3f5gzbr73kzso@lion.mk-sys.cz>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="kpvwrhqfhhn2qbfh"
Content-Disposition: inline
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--kpvwrhqfhhn2qbfh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hello,

ethtool 5.17 has been released.

Home page: https://www.kernel.org/pub/software/network/ethtool/
Download link:
https://www.kernel.org/pub/software/network/ethtool/ethtool-5.17.tar.xz

Release notes:

	* Feature: transceiver module power mode (--set-module)
	* Feature: transceiver module extended state (--show-module)
	* Feature: get/set rx buffer length (-g and -G)
	* Feature: tx copybreak buffer size (--get-tunable and --set-tunable)
	* Feature: JSON output for features (-k)
	* Feature: support OSFP transceiver modules (-m)
	* Fix: add missing free() calls (--get-tunable and --set-tunable)

Michal

--kpvwrhqfhhn2qbfh
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEWN3j3bieVmp26mKO538sG/LRdpUFAmJKOE4ACgkQ538sG/LR
dpX17AgAueMdisuXPHztCiX76lwB7BI6O6LT6d3WhYTJOucX8BvuKnBLZ+ymmREJ
hEDtoRxYHKgLpzFo+8WR2qDrCV7Lhv8TZObfrwBC4C2fTCbh4EEax9zrRJdCu2G2
42rcF7SsU2dI5BJvhAEIkqoier8Z62Qy4uEjXq3Jh7LHAmXG9COH7HBYLwoA9Vap
/IR4815DaUuHOQO9G7BwhtjaOWcxmaUmqKmXT13FHkYZqvrf6WdlSpo2fjyXogXC
VahAhd0YopmFNH+UpLMWFzAZIy4Y/LcMbykFIwpqp46CCFmjwpA2XnzqFeo5KcBH
sy0iV/EK0mKI47A6DYODcGYKF7MfSg==
=Cuco
-----END PGP SIGNATURE-----

--kpvwrhqfhhn2qbfh--
