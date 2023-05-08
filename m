Return-Path: <netdev+bounces-974-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 73DBF6FB9BB
	for <lists+netdev@lfdr.de>; Mon,  8 May 2023 23:31:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A7525281151
	for <lists+netdev@lfdr.de>; Mon,  8 May 2023 21:31:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D72D211CAB;
	Mon,  8 May 2023 21:31:15 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC7C3111B9
	for <netdev@vger.kernel.org>; Mon,  8 May 2023 21:31:15 +0000 (UTC)
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 699ECDE
	for <netdev@vger.kernel.org>; Mon,  8 May 2023 14:31:14 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
	by smtp-out1.suse.de (Postfix) with ESMTP id 1F59921C6E
	for <netdev@vger.kernel.org>; Mon,  8 May 2023 21:31:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1683581473; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type;
	bh=2cMgCPmYQQYzSWbFwGhf8idXT2IDcM/GOX/JFfV/T/Y=;
	b=GYnCZ+Ted8V4OmNtLMVztqlcH67093IFMlWouskJJ9iO3h8Uwa6kNKiXYXK7TCOWRlmRoL
	ibd/BSdpGhx/HXT/B3MFCM0zvD9sTwYD2mRtWInd/OcrQbqlTFjVoSmUpmSuJOu9F3maJ3
	UbdO/usKFIQU0tBNTPWaLHDqq5zbQZo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1683581473;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type;
	bh=2cMgCPmYQQYzSWbFwGhf8idXT2IDcM/GOX/JFfV/T/Y=;
	b=PWrHcwUPvCtm6ErhaKkyYo6ZoMxBhNW1MUuXKoEwFu79s+sjm5gCavvcmkXgdmC6CU1if+
	EwaKd8GyCWgM+yAQ==
Received: from lion.mk-sys.cz (unknown [10.163.44.94])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by relay2.suse.de (Postfix) with ESMTPS id 14DB02C141
	for <netdev@vger.kernel.org>; Mon,  8 May 2023 21:31:13 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
	id E70C260926; Mon,  8 May 2023 23:31:11 +0200 (CEST)
Date: Mon, 8 May 2023 23:31:11 +0200
From: Michal Kubecek <mkubecek@suse.cz>
To: netdev@vger.kernel.org
Subject: ethtool 6.3 released
Message-ID: <20230508213111.z4vjg6gyrm7nwz4r@lion.mk-sys.cz>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="zvtfi4fi5ndjdsil"
Content-Disposition: inline
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
	SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net


--zvtfi4fi5ndjdsil
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hello,

ethtool 6.3 has been released.

Home page: https://www.kernel.org/pub/software/network/ethtool/
Download link:
https://www.kernel.org/pub/software/network/ethtool/ethtool-6.3.tar.xz

Release notes:
	* Feature: PLCA support (--[gs]et-plca-cfg, --get-plca-status)
	* Feature: MAC Merge layer support (--show-mm, --set-mm)
	* Feature: pass source of statistics for port stats
	* Feature: get/set rx push in ringparams (-g and -G)
	* Feature: coalesce tx aggregation parameters (-c and -C)
	* Feature: PSE and PD devices (--show-pse, --set-pse)
	* Fix: minor fixes of help text (--help)
	* Fix: fix build on systems with older system headers
	* Fix: fix netlink support when PLCA is not present (no option)
	* Fix: fixes for issues found with gcc13 -fanalyzer
	* Fix: fix return code in rxclass_rule_ins (-N)
	* Fix: more robust argc/argv handling

Michal

--zvtfi4fi5ndjdsil
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEWN3j3bieVmp26mKO538sG/LRdpUFAmRZahsACgkQ538sG/LR
dpVYcQf8DZXumW0s0b8BQcT4GVIaVkI9evKZEtb726Gf+TzRLCmvkyrjMY+2Isjx
DBZ1dM07qXJdyrhf1Q/vXW/R6h1RqpEAPqCDc+TNIdaWc1y6E6Ft4TCuaPDuvZA1
Z1HYlh+Q+cDN04eq1KymBM8koNcxV8IL/5L3GgYclkFusF8OU4feD1v64h94f7Wd
f+KCIdoj9j1eiqN+AykiQ09BjHftoDO+p5Hks74D9rqeK9POW5HG2oZJ4ltPXAxT
7H/KB4jn/giGgBgfR11b8QGEYkYfpj4IcE4sIaeRMl5ofAnSWWp48XexTUaEdV7Q
YtPCQVOR7Iv74MeqNtHmEmLX9T5l4w==
=ObAq
-----END PGP SIGNATURE-----

--zvtfi4fi5ndjdsil--

