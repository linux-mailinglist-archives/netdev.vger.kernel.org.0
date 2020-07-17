Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC8DD223F15
	for <lists+netdev@lfdr.de>; Fri, 17 Jul 2020 17:05:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726867AbgGQPFi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jul 2020 11:05:38 -0400
Received: from mout.gmx.net ([212.227.17.20]:52477 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726071AbgGQPFh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 17 Jul 2020 11:05:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1594998336;
        bh=PXOm9Zw4ESdHwjagKvpER50i70YzN8dxtD3osZbetpg=;
        h=X-UI-Sender-Class:Date:From:To:Subject;
        b=ZgTOAIVfDhvTWWgMuQb7UvJ9bpxm6m1bBcrDBJTtzMLJ822ErMvZSVrsy6TX6IqEG
         iEWvP7TfB/9RZ7N4xbIKj4BllFPLtld3cDGfRnmjSzDErys0Mu15SyYdhuNQbB0chn
         cJxQF61wWEUlrokd3vYvxokBZzYSbppsR7dVltHQ=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from defense.gouv.fr ([161.0.159.189]) by mail.gmx.com (mrgmx104
 [212.227.17.174]) with ESMTPSA (Nemesis) id 1MWAOQ-1kLCjN3oWA-00XfJL for
 <netdev@vger.kernel.org>; Fri, 17 Jul 2020 17:05:36 +0200
Date:   Fri, 17 Jul 2020 11:05:30 -0400
From:   Jamie Gloudon <jamie.gloudon@gmx.fr>
To:     netdev@vger.kernel.org
Subject: [PATCH iproute2] tc/m_estimator: Print proper value for estimator
 interval in raw.
Message-ID: <20200717150530.GA2987@defense.gouv.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Provags-ID: V03:K1:zNIq08aCgWub3e53cVRpyXayrCZCqvKpGi70P9+WGm4UIC2xzLE
 6wsaA6UN5k8+AA2dAD+iN09sr5OJkjwf0BbS29pgg8IIiku2eTLT0w4XF1vk6BTWliw0rx+
 9Vom6vFek+dLl8dNVbYcwMhRDI7ikIpABFaznhzNzTBOFJvISMcMETleHA01+dQVFeBiLsk
 GSziTlEmX01Ii2XAyzIhw==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:5YCntfoUhU4=:PCt+Ao8l5+7eGlujy7LelW
 ism+sZbfHLfAI8b4ugKEvB97kLg+94jfY4tQR2MFCn8L+chvgOQDz9TxvA6F4F4oxF7FGNK3F
 hO20ErQYfuN79MIthZcd1DrOpYPIUYCDSKrPUMFqI8SRbbL2IkCjCNgmhigrMF6NdInhyebC+
 KMPH0IUtnZ8tkcmR5H8IoN1sLLUnuLqMXX0yqLUswYR7MaInPkbVpbRnwCjJuT8kZAgTqwwg9
 1i0fSdfzrJTCnOp863VeOBMlgjGqU9o/SVnuoWmy5BwcYP8WtZ3Uibgq2b5tNihhaTdHd0gVC
 JLTcj+dNnP6JQo1rMQyk51LO6u/tFfL98Gp81UW0vc2aesGPYQhgvTdWjjwAUfhCvSKubFBMl
 Z6Dc5jqxv0nIBJsnJsIfQ5QEDYn6p1439DpW8MfgQ6fSvlJzXOgpMy7tA7BC/NrfQTHXci1cL
 zzGjidgw1EtGpFoKHLrJhsovlfOdjIGJoxuqKNehMbyIqSsGOeFvONGBr2Hdvz7FF5TEIJVOo
 dKRjkW80pvUNxrClURPJuX1Jm4zW8vuYJXV2l7PZIkib08fpzAIZN2S0NWLGhNwqVIVl6wCsW
 ZfWPOLogjsQ9K2PYDtBbXXCViSYLvOY4gMm5IbrqL/mehaBZX36nTW2Jhcs1P9EuJ0oU4zzjI
 f7HgYoaTJ6353XALZowXQO2mTBx7aol8fDIek7IqBnZlcN4F48MaaT6H6PxXHtEh+bFgAT041
 88nk60CC1VyuTQaXYPd22Stf2Gs+f5CGBPrXvjNYG33qC4IEdOsQsxXcsdhcMEX29les9yRpW
 0YW5K1DzQ3MSOxMQDqDJBTGt2QQndJ/OtrpDo9jXgCsdsYRo5h8PCjuN6Fim1B+udLuWJeqp3
 nKin6X5ftgLOV/CSgIb7vlgytwxcRUEY1W3BkWIUEo+x9Jb0VWJpz+H1Duj/gpblCUNUcrZ6z
 Pt0lzUdN7pUKkR06zXtPn3DClxL1dGyo/JKC4eL3F7vbxQ7DZxlcKQaIrmVr/VH7ekgXLBQ6v
 FBVf+tioJNwRq0jVdLEBooia95zBt76SsFgKAlWGcPoEuNfE5TrdaDLBA1Rz5esJfM1ShLgFI
 4V+4Kc1RcSF8fJuJ5XFg1yMEdYreZBZ99+NWdE/22/joTXOgiCOidUjIepIdV4HSh7H/NiCQO
 icWPb52S04MggvhtlRZuBC75ytHaqqRhtQ1wqbYwB7JCWuG7LS3ZAlzYnQp2nklJCmbOXJBD5
 9CE0wrm8vfHf1jsINE6hwpj4Xou3tSxp+8TV02Q==
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

While looking at the estimator code, I noticed an incorrect interval
number printed in raw for the handles. This patch fixes the formatting.

Before patch:

root@bytecenter.fr:~# tc -r filter add dev eth0 ingress estimator
250ms 999ms matchall action police avrate 12mbit conform-exceed drop
[estimator i=3D4294967294 e=3D2]

After patch:

root@bytecenter.fr:~# tc -r filter add dev eth0 ingress estimator
250ms 999ms matchall action police avrate 12mbit conform-exceed drop
[estimator i=3D-2 e=3D2]

Signed-off-by: Jamie Gloudon <jamie.gloudon@gmx.fr>
=2D--
 tc/m_estimator.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tc/m_estimator.c b/tc/m_estimator.c
index ef62e1bb..b5f4c860 100644
=2D-- a/tc/m_estimator.c
+++ b/tc/m_estimator.c
@@ -57,7 +57,7 @@ int parse_estimator(int *p_argc, char ***p_argv, struct =
tc_estimator *est)
 		return -1;
 	}
 	if (show_raw)
-		fprintf(stderr, "[estimator i=3D%u e=3D%u]\n", est->interval, est->ewma=
_log);
+		fprintf(stderr, "[estimator i=3D%hhd e=3D%u]\n", est->interval, est->ew=
ma_log);
 	*p_argc =3D argc;
 	*p_argv =3D argv;
 	return 0;
=2D-
2.17.5

