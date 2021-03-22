Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75E0A34392C
	for <lists+netdev@lfdr.de>; Mon, 22 Mar 2021 07:05:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229872AbhCVGFO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Mar 2021 02:05:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230171AbhCVGE5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Mar 2021 02:04:57 -0400
Received: from ozlabs.org (ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6CD7C061574;
        Sun, 21 Mar 2021 23:04:56 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4F3kVY588Rz9sVS;
        Mon, 22 Mar 2021 17:04:52 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1616393094;
        bh=Myu0vOYFSqcDLN3mfnCapzsQ3L0Z0ScLw/ZEBmT7QFI=;
        h=Date:From:To:Cc:Subject:From;
        b=YfZdc9WKYha2OO31Gj0h0EElnjJ0xMt41WgYOlzhil1Ebyf1tWqE/oHDaDBECmzZr
         psqjTn0AgdgI+bfPV9w8FpprutpPD23rn+eFabsc0QmqXCzXqGb7IwgbL5FAcjQYzg
         18m7rZcHcoIsJSetUrNBRJ1nnSUaRVkJbUa+iHAjUy8FsH5s/zSMF7yDBxKNmTNS79
         dLwrn0vDVGVpQ/luisfNe1l5OBuY9lcPqNcB3w9bKjbvvHRBJWsaLydjDBXiY2HaGb
         6b6+ViB0fTgQhAyf9j+DSqE2gp0VrVZDH1GE2JMpFzlIcGAbxY0olGV3BrqOsWtKoh
         ML/CjpePRxwWQ==
Date:   Mon, 22 Mar 2021 17:04:52 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Eric Dumazet <edumazet@google.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: linux-next: build warning after merge of the net-next tree
Message-ID: <20210322170452.726525e8@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/yrUYYJSO8MQl7qTwMw0u8/H";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/yrUYYJSO8MQl7qTwMw0u8/H
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the net-next tree, today's linux-next build (htmldocs)
produced this warning:

include/linux/netdevice.h:2191: warning: Function parameter or member 'dev_=
refcnt' not described in 'net_device'

Introduced by commit

  919067cc845f ("net: add CONFIG_PCPU_DEV_REFCNT")

--=20
Cheers,
Stephen Rothwell

--Sig_/yrUYYJSO8MQl7qTwMw0u8/H
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmBYM4QACgkQAVBC80lX
0GwR6wf/Ts2LpPZjN1joMtId9vG+1R2G8OglPXJ/H4bRQrWLEeL5IMzD1aWysVH6
Sp/r5pHWLbPWMz5WsNQBAbtqG/PZrlDwn1J/ZlEovdip2YtSDu5TIgFj4xvIxxm3
dwdfLr+nS+NeQhQTM2v+CbSFVnCGEmY8dF1iSSRc0tqiwxZTzLiCoZuYMnoNa7vy
qukYiESzpZSc3BgLUjV3t58JLzZfjGzE7JMBa6uErEbDwpuRJoxoMlZf7dtl7ASr
oDd7H7jn//IoE7qXZwBYO4ToOPjTWSFU8153tokYigWHpQJHkX1pCmOmUfUuhAI7
F0Z9NHSKpub6iHNGtD6vHOB8Gh/r0Q==
=Gf2L
-----END PGP SIGNATURE-----

--Sig_/yrUYYJSO8MQl7qTwMw0u8/H--
