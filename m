Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1EA9A17AA1E
	for <lists+netdev@lfdr.de>; Thu,  5 Mar 2020 17:05:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727061AbgCEQFa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Mar 2020 11:05:30 -0500
Received: from mout.gmx.net ([212.227.15.19]:47063 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726067AbgCEQF3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 5 Mar 2020 11:05:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1583424319;
        bh=8uJEz8SxR/5Zt1ShH9ynYppvJQmMU/6FJapFJHKn1vU=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date;
        b=f8kXGOVcz379w3Kr1j1byOWK8hmJsa7pQgd1xb7H42R6HNbrdfNIzMNhQdGyH3ahi
         0N9tFE2CjLC8LKJogEz/GVD1JnJctPlY3GbGl3HPOBdThHugvs3m3IByLRloSwDk50
         Z2mIb7xRvPggefUJNlpY740jLdr23A/D65q7ab14=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from longitude ([5.146.195.153]) by mail.gmx.com (mrgmx005
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1MfHAH-1jq7Qi0Jkh-00gp98; Thu, 05
 Mar 2020 17:05:19 +0100
From:   =?UTF-8?q?Jonathan=20Neusch=C3=A4fer?= <j.neuschaefer@gmx.net>
To:     netdev@vger.kernel.org
Cc:     =?UTF-8?q?Jonathan=20Neusch=C3=A4fer?= <j.neuschaefer@gmx.net>,
        Thomas Graf <tgraf@suug.ch>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] rhashtable: Document the right function parameters
Date:   Thu,  5 Mar 2020 17:05:16 +0100
Message-Id: <20200305160516.10396-1-j.neuschaefer@gmx.net>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:M0xU9lRualVtaLC3+OZVk0teQpKet35DJNoLSI4g3k2ZuHWUtaW
 3i8fQjU612PPQBlnu0WFaCbcfCsvjlgdA2JdiyYKVCgmxqnTuA+OXXvY2qvfgl/VgSiTDc0
 jnU7LF/PPS2s/b454LmJKNFxmZ14cOTuSLSRkRtKC8CgiJP/f5yFlOh0zG9ITHtmJSCXaiT
 hsvJE1CVR2IWqvgT8qNUg==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:4jYTrDQFuJw=:HzO88RK6LW1RQ2a521nIpR
 i1v7PQ90RYxsCX3KPrIfgqbkHmhaHDEkcouJY0uyNZtQUWuSzisDhJIFBOrU4md8bkou4iS4R
 /Q9SzycKHD5hURNNfO5RJ4qJGsz+CQu3RPe90lSv8zyW8SvgZEm/x9o8OktuglD8BjnA1+fMX
 px+mtNb9rZN8IcvJC7n6Si/AvMdlW4rzKNGH9uYVsPwvHxVUfknms7bYbIzwT2Ax58S+OKFul
 vXJBWq9Xj0sU8+WFd8AYLPAZ7WWtpfo0GrJ+dOOZegDDSJhdi9Bb2HO0r4KmX8U40JJahj3r4
 14xEl1V7T/lJT04w8ofRujl2CZOI8speEh/ehkAGcg7+G2nDbNT3w4G6HfZWHs2k9JTipgaTG
 dcMNcaEPoNV003EgNyq09O1+R3iEjUuDTDAUVs+/t/4dslBFOViBYS3qUfFw5jWVCeua6zOcz
 K775m3KCdf/XUeWUmCXNxw+aVOmsCfbJnQTIJjrmHuhCg+UesJJGanfqnBmnRT5UZX7BIAflc
 ZwIoMZMrHD2LuZX1lEBgJ8NxhzNq3d5lkz8VdyDPNvtpMG0gC/9YSLGw1Q2aamfb/5WcY62mQ
 NljyMw6WeVSCwk3qs0pCP/827TERI5Ykk/RTBur2OPSGtyiePd6yAPVhLBqbW1lRT/EiSP1ES
 XJ93v0kq2bqGwACYgfqDyF3jqiVei5RNzBymq0XKN5uON2fBjzxUOpM9FNDwwysf//2wyKXQ1
 9h1lrHLgzSxiXINNfaM/dqUwOjycz3fLyNo/c6JUaylbaDsTchiDAkA0meHtEYJNo9UWEVOlH
 TIyUbCW86nuHb8Qso+CeyZU2HqO/cHDkaiodF3LxODUbGYOc3ocfGM40h/vn5FKotroToS54H
 VflE6ViLiyyG/OfVo4/7waQYwFu95zqqGua0NCFshNhrulwNJlaeDM5rVbC4lZuRYxGziLrL+
 H7XBUqzzXYM7RJGdKmalcgQYMsF2xGbOkcEKpK1FaF3K4FiHizpPxs6COuWktJb6lZbhJ3fvc
 0MQclPy4M2bX1HB8Is65FeJC/TfH8g9NQOo8BOVLDees60nFsnQlTyHmv7PY2xaBNaf56/jFz
 9hfsdCMAB4CwNVZ9VE/vf3YQ5/jT+DgN1VRT54pDWU/RWMWVzW4asXsECFYi6c3MwqeVyK1wp
 zBenMW4LHHsrOoaceY7d4GvGGjvsf342ZQI4HAKilnfOD1CV8Y8YE5PSTgsHWoBcWE6iIkx5d
 sYjTgVZhP8ozfSTS7
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

rhashtable_lookup_get_insert_key doesn't have a parameter `data`. It
does have a parameter `key`, however.

Signed-off-by: Jonathan Neusch=C3=A4fer <j.neuschaefer@gmx.net>
=2D--
 include/linux/rhashtable.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/rhashtable.h b/include/linux/rhashtable.h
index beb9a9da1699..70ebef866cc8 100644
=2D-- a/include/linux/rhashtable.h
+++ b/include/linux/rhashtable.h
@@ -972,9 +972,9 @@ static inline int rhashtable_lookup_insert_key(
 /**
  * rhashtable_lookup_get_insert_key - lookup and insert object into hash =
table
  * @ht:		hash table
+ * @key:	key
  * @obj:	pointer to hash head inside object
  * @params:	hash table parameters
- * @data:	pointer to element data already in hashes
  *
  * Just like rhashtable_lookup_insert_key(), but this function returns th=
e
  * object if it exists, NULL if it does not and the insertion was success=
ful,
=2D-
2.20.1

