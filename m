Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DC05F88B49
	for <lists+netdev@lfdr.de>; Sat, 10 Aug 2019 14:18:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726246AbfHJMS3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 10 Aug 2019 08:18:29 -0400
Received: from mout.gmx.net ([212.227.15.18]:52629 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725862AbfHJMS2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 10 Aug 2019 08:18:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1565439477;
        bh=NL9xpuLCPw2UG54ukrtShb+O4fzltpo4dN4xnfCDCyM=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date;
        b=CdH0XEmIu0hzeCVHGf9Sekbf4nWTBdwvMV6lYwFcHuEf7w61qKOJN+x4p0XC4oEUh
         o1ubxjlPWBDGW9lK0EUDbX/jLDrFAA7zreWIllgJjAcymt1t78Rv+SgZFb4aIc9kAF
         XlvKDEg8c5qUSGG49ZUirQMtQ2XBHQHA0ZXFHUa4=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from longitude ([109.90.233.87]) by mail.gmx.com (mrgmx004
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1M9Wuk-1hzhZJ0nx6-005cHp; Sat, 10
 Aug 2019 14:17:57 +0200
From:   =?UTF-8?q?Jonathan=20Neusch=C3=A4fer?= <j.neuschaefer@gmx.net>
To:     linux-doc@vger.kernel.org
Cc:     =?UTF-8?q?Jonathan=20Neusch=C3=A4fer?= <j.neuschaefer@gmx.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jonathan Corbet <corbet@lwn.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        netdev@vger.kernel.org, xdp-newbies@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] Documentation/networking/af_xdp: Inhibit reference to struct socket
Date:   Sat, 10 Aug 2019 14:17:37 +0200
Message-Id: <20190810121738.19587-1-j.neuschaefer@gmx.net>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:cgePj4l+CjuwW5sL+l5xjBAo2oA6r0xqbKiNRsIcFbb/Me+bhcP
 3okZNFqCTQzPdqhA1VRGhKi7JyaYkSVm1/rWGrS8Sr0WzeTxenTfgx6hO6gFxbwvyKX+qoA
 nJkpSeaoEiYXoXhGN0qmnMPVC71bFcTbvX/1+GvMCK8oARXi4O6agBDTPm2/6KNPvWOpCsk
 +EX8gcUCw3RN8IIryApSg==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:mD4RS0ZWWFM=:zsgdsjRIOwcW3rld9Y+v/d
 HEOmA4JSUMWkBK3ld9Ng2Jv1NrpAzmXwTj70+1lJYZod8ohd2/Zj6FWKjt7R5NNZyoiQ4YchW
 KalfaK+NjUF4aIB+J47kMZY54V4sgZLFcsCOHvBEcHiOTl8zx3bPCDo2XrO3a+XRe/hSX6Z+f
 EJDawmm1MM9U7T/F7rMXrJ/hAsAdymuYW27sNfHhDx/YbZuOJV/WdS0q20SSWLFNRO6qIPcrM
 80ako/3DCjjD993TK8rXOth2i6luMQzw5K4dwYkNz6QQ1zkspzok1uoVE00o1yvh/o8K3o3H9
 JPNyKUKvBQy01lKoLy2GUVGK0h6IT+G+VvR5zvUfeu33YMef+afpyruIB3yT6ia6kIBqi8C2i
 ku/Vz0S5FFWM5GkefyxmGJQB4R7EpNvfPL+Zgmehzf59Bf98KoV+leyStcEpfM+ckKOMjc0M0
 qcQ0ZIjBDJr5s+25MiMVIT14EMQVi4M4Xe76SBOMcaRiwlFPHAzsPcSZ1Cr/bea5z992Uk+nJ
 uEumN7DkLx3mthCiqjOmg8G6kwdgL16LrWk5gROTIo4AceS6+Ka1iEgq+h4CQElixlSE8ktMz
 8nDBYdGPKg3eG9JmMc9S5/+RJKKnVdr2Hnz8xUujpyjQfOBp0qtos+evgXwSqRwdk8Xj4Zhe8
 p+EXlnZD0jYEIwSowH2mnvDiSBiEhLepcKIc6k3uYRJSAqZaKYH6LaO6Lpkfc/s3qJVgovuB9
 exBngWYPzms1MgetLT7vJ3eBQJwib/ujfpYrBTo5LPvmigvMx07tpZZz+i8ZQilhvPm+ehRRZ
 +MA7V9/EbSFBERnqhil7h3LrP6V9VmtDI41xCFDxLqkZUKLAdQafSInMDyjckKT/+e+ycxjgi
 x9pq85R2tsfkYNQjBWPphyNkAtJm8PsF6Dn5aSmtC/BRHsRA0UsnFdFQi8e7mkfubhOEQ6vqR
 LPthj0OK0NbqN3Zruv2i2KYymvzLy+eNeO3N3xMzKzLYaTEgDS4J/Vr70A6Y0BEdF2r75hNPx
 gcns0DO3Ip0dxb3JYPTQD0v3x63ANrI1GcPxr1C2UvhsQnEbQGLTayEiJKjNTRGtSd28EY+2E
 lukB0VFVn44wkM5+jmMWsQnb9QSC9qcDjd7Qn05swmuCGs2D5wc45KqPxqpijRvpsgvRFS86e
 znFDk=
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

With the recent change to auto-detect function names, Sphinx parses
socket() as a reference to the in-kernel definition of socket. It then
decides that struct socket is a good match, which was obviously not
intended in this case, because the text speaks about the syscall with
the same name.

Prevent socket() from being misinterpreted by wrapping it in ``inline
literal`` quotes.

Signed-off-by: Jonathan Neusch=C3=A4fer <j.neuschaefer@gmx.net>
=2D--
 Documentation/networking/af_xdp.rst | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/networking/af_xdp.rst b/Documentation/networkin=
g/af_xdp.rst
index eeedc2e826aa..54f179ee6c33 100644
=2D-- a/Documentation/networking/af_xdp.rst
+++ b/Documentation/networking/af_xdp.rst
@@ -20,7 +20,7 @@ bpf_redirect_map() function. AF_XDP sockets enable the p=
ossibility for
 XDP programs to redirect frames to a memory buffer in a user-space
 application.

-An AF_XDP socket (XSK) is created with the normal socket()
+An AF_XDP socket (XSK) is created with the normal ``socket()``
 syscall. Associated with each XSK are two rings: the RX ring and the
 TX ring. A socket can receive packets on the RX ring and it can send
 packets on the TX ring. These rings are registered and sized with the
=2D-
2.20.1

