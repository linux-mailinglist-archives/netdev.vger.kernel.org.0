Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0B6578A2F3
	for <lists+netdev@lfdr.de>; Mon, 12 Aug 2019 18:08:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726786AbfHLQH7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Aug 2019 12:07:59 -0400
Received: from mout.gmx.net ([212.227.17.20]:56593 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725843AbfHLQH7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Aug 2019 12:07:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1565626054;
        bh=x7tRP3TUDgUF+IKb4TvatQotKrueobFDeaa3admljZw=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date:In-Reply-To:References;
        b=a0Q7VXbYNp3W+/Ei587ZUwIEgJhelIsUA+4wVX4pWFGA0hEamcXv0uz1hPIJOfnNC
         /ROv+Y466tpf+uY7RitJLB9SkWwHAM60Y1ZgmGRyuZlKhRRgxV1wU2MRE4+7AaPgTn
         2L2f0q5XJSdZhkeyuOIIXlwsRWXt+y5em8Xccel0=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from longitude ([78.34.97.158]) by mail.gmx.com (mrgmx103
 [212.227.17.168]) with ESMTPSA (Nemesis) id 0McUnM-1hffyH2C0W-00HfT8; Mon, 12
 Aug 2019 18:07:34 +0200
From:   =?UTF-8?q?Jonathan=20Neusch=C3=A4fer?= <j.neuschaefer@gmx.net>
To:     linux-doc@vger.kernel.org
Cc:     =?UTF-8?q?Jonathan=20Neusch=C3=A4fer?= <j.neuschaefer@gmx.net>,
        Jonathan Corbet <corbet@lwn.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        xdp-newbies@vger.kernel.org, bpf@vger.kernel.org
Subject: [PATCH v2 2/2] Documentation: sphinx: Don't parse socket() as identifier reference
Date:   Mon, 12 Aug 2019 18:07:05 +0200
Message-Id: <20190812160708.32172-2-j.neuschaefer@gmx.net>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190812160708.32172-1-j.neuschaefer@gmx.net>
References: <20190812160708.32172-1-j.neuschaefer@gmx.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:YIa4yoGa5k1pGA+d7OBh3A+7OXq84EhShBQ46Qu+a2q+YkaL/P1
 kPZybaGZw6dvvKRAcQtyZRduiFmRE3Edt5WyEK6kKMX5B1WNKC2U7F6KPsKj2oZ8l2U4r98
 QktXu2o627d+wTSTI52UwxF/STzMSqZrL3m919Sg6CEigkiARRBnLf/NR+v7ifMCz4jpg8Y
 XexE38mtQM2zm8OTrceEA==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:0Ri/pCH+kAs=:n9wc26zEgmVw/wT6M6uL0y
 TBWFVv0FXVbthr4k+9RWqHS4wRlLTdo1Vu8cQfPlUnysLCuOYpQ1ES0d03mbPIZ6XN9JSuBBQ
 UcdT5ifhXONfOfkXtAVu6gA+jj1s3hfz6G5aSLFBykoRCLdmddckyAvegB0SGYc6U8FhL6W9j
 PsPvu9Pv4Q7l41UatOht4B1pqWg6tCRggyH0gGBYYzHZQpenF1Mb81r1GbL2fBFZlaflO3eOx
 M5N3+EPkAqgxBgzu2z0ZGtF8frK2ilKRRwtElxSNvribd66HMeTz9FqqEMwANeUhV9OA+jzO5
 nqSMhN6a9BLans4+vmV/fQmLEKTwBLtuRtzunecfaXUZNIBN0M9byHmsKJHrufYz0jRmfXzpk
 fD6fi5KGcOBhE0fWCuqEYxF+pDKdRED1XTAvppwA0X5p84lUKIsbAUUVR8WeAF817gYstjZy6
 RP0sxG01yGV0oTtosmLYtkijRJGheJtoR3napY3lKzS2VbE63tRGYX21mwILpawZdOcrY5jIy
 6E14P1GJujwATdmnp9Tb5eqgLq5+5Tlf3Ujh8Mu4toV3Kmn7/oHln2a7uNAYzbtwRJIDXip58
 RAFWQVndyF4JJ6U8md034hS0gYAc8hrSJEe5Ecb3pajPVyaEfnXMauJodymNjL1xk2uGhT8aA
 R2d+GEJClxjZOjsl3ONM7Spmqhk1uQh8CchJFZu61SxIu60OjCaQshO1A67abXaevMtYAKBy/
 AobQSwXmabuEpt4ZDqeQnZzBgaX3l5evYP/eR7a17ZMLEg45cZU2bp2KUaQ+KGqK4T5/N1SPD
 D7HOD/fJABoc/pPvrd5N6eoBjIG5oUPxYdcEDP6sScP8pNPMOYPlJP8hR+cYMO9WcxFhYH2Z1
 YqdqFNiE6fALEssBOgnd9ZkkOLDBRkzLOQNZ5aQTpIo15SKCD7qIr9xyTciokKr5S36GilBki
 tXh5OGf3qmFnzPApT9fBggMHJ7BZIc9a9/2MNSP6u7iFJwPfmODiBszhEDv6f5HIqrpkO9LTq
 yVPBv/iWDFnnQe8F14D3TiYldrSiTaArlM5hA8BSyUtJIiLhOoSGLkVwvdpZaK5l/MsdqXPKS
 oLscBqV/cWReQ4WmxHIUxPsJ5AK6aUGb467ATEligOpYbwR7p4LtfbUjSxKkHL3wrh5BdSEbm
 fVaTk=
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

With the introduction of Documentation/sphinx/automarkup.py, socket() is
parsed as a reference to the in-kernel definition of socket. Sphinx then
decides that struct socket is a good match, which is usually not
intended, when the syscall is meant instead. This was observed in
Documentation/networking/af_xdp.rst.

Prevent socket() from being misinterpreted by adding it to the Skipfuncs
list in automarkup.py.

Signed-off-by: Jonathan Neusch=C3=A4fer <j.neuschaefer@gmx.net>
=2D--

v2:
- block socket() in Documentation/sphinx/automarkup.py, as suggested by
  Jonathan Corbet

v1:
- https://lore.kernel.org/lkml/20190810121738.19587-1-j.neuschaefer@gmx.ne=
t/
=2D--
 Documentation/sphinx/automarkup.py | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/Documentation/sphinx/automarkup.py b/Documentation/sphinx/aut=
omarkup.py
index a8798369e8f7..5b6119ff69f4 100644
=2D-- a/Documentation/sphinx/automarkup.py
+++ b/Documentation/sphinx/automarkup.py
@@ -26,7 +26,8 @@ RE_function =3D re.compile(r'([\w_][\w\d_]+\(\))')
 # just don't even try with these names.
 #
 Skipfuncs =3D [ 'open', 'close', 'read', 'write', 'fcntl', 'mmap',
-              'select', 'poll', 'fork', 'execve', 'clone', 'ioctl']
+              'select', 'poll', 'fork', 'execve', 'clone', 'ioctl',
+              'socket' ]

 #
 # Find all occurrences of function() and try to replace them with
=2D-
2.20.1

