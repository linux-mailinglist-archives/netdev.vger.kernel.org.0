Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7170D4CBA53
	for <lists+netdev@lfdr.de>; Thu,  3 Mar 2022 10:33:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231961AbiCCJd4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Mar 2022 04:33:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231718AbiCCJdv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Mar 2022 04:33:51 -0500
Received: from gandalf.ozlabs.org (mail.ozlabs.org [IPv6:2404:9400:2221:ea00::3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53B742E0B9;
        Thu,  3 Mar 2022 01:33:06 -0800 (PST)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4K8Ql42Lbbz4xPv;
        Thu,  3 Mar 2022 20:33:04 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1646299985;
        bh=zB1rt3zvUYOpLIIQyWGRlPSN53imFyGRFWlvIg4BBVA=;
        h=Date:From:To:Cc:Subject:From;
        b=oKRMUxIGWodX098W6LnlLbt9/UI6ugfaKk+5+oQUeSBUghkSP96UKpmGRpDzK7dwc
         jFO9pQNryWI/ok8LBjBMsGQCSef9r+MnfmjRhY+vkitU/2aiTI4Z1clIbxiMhLgR5h
         3SZl6+g+Jdoyu+nKjyIKJmFMFhR0rrq5pMPCv8UED6IvKEb+A/MKEOTkZNbi5u/3bA
         3FRW6drTjbjosMtyUmuCoVVMGe8zNbWZhhCMjvBQL1rEY5PCm5uixAidvkOyXJXrNN
         zFR6Sv8Wy032/WmSiC2LIk3JJYj4ndHq5zDO+SG+FHT5eYDe9TjEsdJC9GIPIP1Kun
         yBvxv7GeJXXsA==
Date:   Thu, 3 Mar 2022 20:33:03 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Randy Dunlap <rdunlap@infradead.org>,
        Johannes Berg <johannes.berg@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: linux-next: Fixes tag needs some work in the net tree
Message-ID: <20220303203303.2e59c643@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/WuOx/LZAXxXM4L9s_Wxd8fV";
 protocol="application/pgp-signature"; micalg=pgp-sha256
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/WuOx/LZAXxXM4L9s_Wxd8fV
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

In commit

  875ad0601532 ("iwlwifi: fix build error for IWLMEI")

Fixes tag

  Fixes: 977df8bd5844 ("wlwifi: work around reverse dependency on MEI")

has these problem(s):

  - Subject does not match target commit subject
    Just use
	git log -1 --format=3D'Fixes: %h ("%s")'

--=20
Cheers,
Stephen Rothwell

--Sig_/WuOx/LZAXxXM4L9s_Wxd8fV
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmIgi08ACgkQAVBC80lX
0GyFKwf/ep0aTMcEt41fSFQyLyRXq0hERCHs0ut/4+ED2gcvbQSyb1DV6QzupNR/
t1+O6EkJYv/mGY+uBkhDWpAWoM1aL29YvGAvGfnUN8hG7BMNZPnYS4Lu6F9ei9cF
VK2AH3HvHIctCNUq+nAKs0zClj//5PE+/XQ06fAQ+r9lyjRWR51N8BSFHzQEi2Et
hwOg32yS35Y0XlCjrj2HjEGBgFmPQXBeNxR/4i85QezjrSUWH+82OD6AqaWxDh2O
NO4Au2tyD4o19qTzis6nCv7EEole8/NJBUmK9RuYzeEiXX//zt+IOe/eJNoMJJmQ
MeHh2F6/Hs9KFpd6Sxk9PIvB1SOAbQ==
=eGa9
-----END PGP SIGNATURE-----

--Sig_/WuOx/LZAXxXM4L9s_Wxd8fV--
