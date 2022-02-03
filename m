Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC72F4A8896
	for <lists+netdev@lfdr.de>; Thu,  3 Feb 2022 17:32:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235414AbiBCQb0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Feb 2022 11:31:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352215AbiBCQbT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Feb 2022 11:31:19 -0500
Received: from mail.sf-mail.de (mail.sf-mail.de [IPv6:2a01:4f8:1c17:6fae:616d:6c69:616d:6c69])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C436C06173E
        for <netdev@vger.kernel.org>; Thu,  3 Feb 2022 08:31:18 -0800 (PST)
Received: (qmail 17234 invoked from network); 3 Feb 2022 16:22:54 -0000
Received: from p200300cf070ba5000c0051fffe8bdde4.dip0.t-ipconnect.de ([2003:cf:70b:a500:c00:51ff:fe8b:dde4]:41728 HELO eto.sf-tec.de) (auth=eike@sf-mail.de)
        by mail.sf-mail.de (Qsmtpd 0.38dev) with (TLS_AES_256_GCM_SHA384 encrypted) ESMTPSA
        for <netdev@vger.kernel.org>; Thu, 03 Feb 2022 17:22:54 +0100
From:   Rolf Eike Beer <eike-kernel@sf-tec.de>
To:     netdev@vger.kernel.org
Subject: sunhme: some cleanups
Date:   Thu, 03 Feb 2022 17:20:32 +0100
Message-ID: <4686583.GXAFRqVoOG@eto.sf-tec.de>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart1807599.tdWV9SEqCh"; micalg="pgp-sha1"; protocol="application/pgp-signature"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--nextPart1807599.tdWV9SEqCh
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

Hi,

it still matches my sense of humor to see fries offered in a network driver, 
so every now and then I point someone to the driver. This time I looked a bit 
more around and noticed some things I have already done wrong before myself. 
Time to clean them up so it's still funny while serving as a good example ;)

Things that are changed:

-drop unused tx_dump_ring()
-fix version number inconsistency
-forward error code from pci_enable_device()

Things that I may also do in the, but can't test because I don't have any 
hardware:

-switch to devres, which fixes a memleak of the dma_alloc_coherent() memory if 
register_netdev() fails [mostly done]
-use netdev_* print macros to print the device name in a consistent way

I can also send an immediate fix for the first one if you prefer.

Greetings,

Eike
--nextPart1807599.tdWV9SEqCh
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQSaYVDeqwKa3fTXNeNcpIk+abn8TgUCYfwA0AAKCRBcpIk+abn8
TrBsAJ4xj21wAXYi2LkwC6h7DumJvQ+qjgCfUu3mUQuCpg2pxAZoDaYQCLOExyk=
=36mO
-----END PGP SIGNATURE-----

--nextPart1807599.tdWV9SEqCh--



