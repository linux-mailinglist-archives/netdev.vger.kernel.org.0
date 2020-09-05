Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DBDE825E9B4
	for <lists+netdev@lfdr.de>; Sat,  5 Sep 2020 20:33:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728507AbgIESdE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Sep 2020 14:33:04 -0400
Received: from mout.gmx.net ([212.227.15.18]:54569 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728463AbgIESdD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 5 Sep 2020 14:33:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1599330766;
        bh=OvFMm61xWOJK+m4Eg9CKLp3NOuU11kHpvcDmuO35iAo=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date;
        b=C5VAz00SZVXsMHTVHAF+uFMr06Y114nspe+M2mrYlxO7m+MmRpsO4yHtPcdqaoO34
         ls9Syoqki5RFUO4S6PXD+OP5iL26T+LBLRQbeHkckxTtWuDjNj2bTd4thbivlkgm0A
         B3+hECw4N4OPM8NdkuJNzlMYzqI2WZNs2wy2M2nE=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from longitude ([5.146.195.151]) by mail.gmx.com (mrgmx005
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1N6siz-1kcuNm3fUl-018I5E; Sat, 05
 Sep 2020 20:32:45 +0200
From:   =?UTF-8?q?Jonathan=20Neusch=C3=A4fer?= <j.neuschaefer@gmx.net>
To:     netdev@vger.kernel.org
Cc:     =?UTF-8?q?Jonathan=20Neusch=C3=A4fer?= <j.neuschaefer@gmx.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Jiri Pirko <jiri@mellanox.com>,
        Eric Dumazet <edumazet@google.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Taehee Yoo <ap420073@gmail.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] net: Add a missing word
Date:   Sat,  5 Sep 2020 20:32:18 +0200
Message-Id: <20200905183220.1272247-1-j.neuschaefer@gmx.net>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:lfMfLhr63vTE8l6pE4QXZdhBufLEXC47Gq61j68L4AqGN6gV2o1
 tEaz1dJRudTEsF4QV6mTVwGBW7TUouI1PiAuqYeUmcROrJFZNg4PGBaeKoLXgpe6En7xe2B
 t5aG9IMY6ncoIU3qGSplSlzsDb1ddg/nzLD/IfQEVeTLncbAgPpDdkvQ1ECcTpUZAx308cl
 qkr57o0RQ8xp1yGrexhTA==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:iTt+zZKptYE=:pQDo0RAj0vSBYf1kWy+b3T
 OssUsG3MGfI2I+YHjZAxV4O2sDglSwJzVGSZZcXUy7j5X0c89OThZqFKJLelaByg9830Zx+CN
 26K9ndEPS16Sq/QnN0XyAD4pb25yqYMWo+c8WReOIkc+4L1oF1gfWmpU70R76M8Udgz8QZW++
 MrypsmDpfNWQhPQRgc+bHIWS1KOCm3AqCMuddTfpGQkbDOD3seCk5OWOPMPNH0IhLAOnYJbMt
 /GrqRMQFejoRKvkyWas5B9QptExQQi9gjJJ/Tmw0YZ/KNUlQH2RZyXOfIkmKusmWrKxQXdO9W
 b+SN4TLGfwBNgT5zaBqst1YI+8ZtYKxmY1FhqJskbtrF8nQcE2Ehp51Q+fPtutAUWsZEtjKSx
 9z5g7eBB2PVoiv3KQbb9wbBlo2G49W4UaIPWjl1SbftuEU3rK5kuVnwJ7tITDgzLKopAWbgD/
 Vu0mPKrEvr+LRebeCNskI6zlLXEnp6o/If7Hu0GMUqoVOHggf8wNdqSrzBB4VmdhUkxRxVpez
 sucPDZEv0lKd6js0PrZij9S6Iti1ZNrN4aQubTZJ2GSHjM6lhs11l+f+TmDj4n5q9xYcJIUJC
 Eub9WYvEI1rMN+NkPT5jEZk8+CM0qBrGZVBcRJVhTYbD18gUNLdHUHdW4OyNlyZMEy4mGWtIF
 fTSkMKKF1FjgD8FOf98ahgIRSiy9BwL6ko/1U2hBqPOHBoo//sYebTgtVOZlSmFRWonvFhj6b
 gUfnCX1ARQm9Bp1A8N/iQJpZ8IScIk9FrKHnB6EEGsbBp+dYNUSW38qDuCy0cG2Jmej073D8U
 ZNm3/+LorRylTwRGz2W3PWy01Or0mk0Wa27HQKU0bkw+599opqHrdVSRuyGCZCMDPMu6CV4vh
 L5/WNOxvi0nbOktQ4jn+e9Z5nItZwkptYSBF8qCqSJmlRFb/X08BJ85F649vCNWujX5KSKMfL
 GIVBgEdn8OPjn6DcL2hi83x/wahZX6tofqQTSj3pR//zDvZ+9EHtF3DZOUk9oDt0PrylP546k
 8EX+WN9gjoUqvH/NkRK32xqjMlUZyjXocSyJyQD5HB2etNqFaIZhtjCzEvfl/ODh061XuOeTl
 sUFIs/q8WbnYJQCPZvkrVgc7RreYadlruCmxuDXvCwrNNeWfHSsi3NgK8gr7xBQ1V+5XaWRIP
 uGCm87Qe/kdeLbqje+He7LSldQZIQ2zyahp9Qqoyh9ZBr7yVLGi9NNJRq8X46xgJo5amVR8LC
 Eh+9qEp3QmEmKA05JZfGfw0LPpN383oC9uLGY1Q==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Signed-off-by: Jonathan Neusch=C3=A4fer <j.neuschaefer@gmx.net>
=2D--
 net/core/dev.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index b9c6f31ae96eb..36c22e60910c5 100644
=2D-- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -6293,7 +6293,7 @@ EXPORT_SYMBOL(__napi_schedule);
  *	@n: napi context
  *
  * Test if NAPI routine is already running, and if not mark
- * it as running.  This is used as a condition variable
+ * it as running.  This is used as a condition variable to
  * insure only one NAPI poll instance runs.  We also make
  * sure there is no pending NAPI disable.
  */
=2D-
2.28.0

