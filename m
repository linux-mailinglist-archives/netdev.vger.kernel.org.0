Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AFC5C6323E4
	for <lists+netdev@lfdr.de>; Mon, 21 Nov 2022 14:37:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230290AbiKUNhR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Nov 2022 08:37:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230432AbiKUNgr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Nov 2022 08:36:47 -0500
Received: from relay3-d.mail.gandi.net (relay3-d.mail.gandi.net [217.70.183.195])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63F5CC4956;
        Mon, 21 Nov 2022 05:36:43 -0800 (PST)
Received: (Authenticated sender: didi.debian@cknow.org)
        by mail.gandi.net (Postfix) with ESMTPSA id 8FEA860012;
        Mon, 21 Nov 2022 13:36:37 +0000 (UTC)
From:   Diederik de Haas <didi.debian@cknow.org>
To:     carnil@debian.org
Cc:     davem@davemloft.net, edumazet@google.com,
        johannes@sipsolutions.net, kuba@kernel.org,
        linux-kernel@vger.kernel.org, linuxwwan@intel.com,
        loic.poulain@linaro.org, m.chetan.kumar@intel.com,
        netdev@vger.kernel.org, pabeni@redhat.com, ryazanov.s.a@gmail.com
Subject: Re: drivers/net/wwan/iosm/iosm_ipc_protocol.c:244:36: error: passing argument 3 of 'dma_alloc_coherent' from incompatible pointer type [-Werror=incompatible-pointer-types]
Date:   Mon, 21 Nov 2022 14:36:36 +0100
Message-ID: <2951107.mvXUDI8C0e@bagend>
Organization: Connecting Knowledge
In-Reply-To: <Y3aKqZ5E8VVIZ6jh@eldamar.lan>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart12392105.O9o76ZdvQC"; micalg="pgp-sha256"; protocol="application/pgp-signature"
X-Spam-Status: No, score=-0.1 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SORTED_RECIPS,SPF_HELO_NONE,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--nextPart12392105.O9o76ZdvQC
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"; protected-headers="v1"
From: Diederik de Haas <didi.debian@cknow.org>
To: carnil@debian.org
Date: Mon, 21 Nov 2022 14:36:36 +0100
Message-ID: <2951107.mvXUDI8C0e@bagend>
Organization: Connecting Knowledge
In-Reply-To: <Y3aKqZ5E8VVIZ6jh@eldamar.lan>
MIME-Version: 1.0

The same error occurred with 6.1-rc6, again on armhf.

Cheers,
  Diederik
--nextPart12392105.O9o76ZdvQC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQT1sUPBYsyGmi4usy/XblvOeH7bbgUCY3t+5AAKCRDXblvOeH7b
bt4ZAQCNn+JFvtlRmgVSibbCZPs8CVNPFaZo1/G6LLqi46Oj+gD+LZnF/iyKuu9d
vCBFWOtAT5r3gRfAjWUqjLEeux7QAA8=
=1WJr
-----END PGP SIGNATURE-----

--nextPart12392105.O9o76ZdvQC--



