Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5108648A2C0
	for <lists+netdev@lfdr.de>; Mon, 10 Jan 2022 23:30:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345441AbiAJWae (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jan 2022 17:30:34 -0500
Received: from mout.gmx.net ([212.227.17.20]:48763 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345419AbiAJWad (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 10 Jan 2022 17:30:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1641853824;
        bh=0v4YvqADVAYjymB3HVw6Y10EaBdeYrxs5ug8qzWR6Qg=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date:In-Reply-To:References;
        b=Sql3grBtskA4DwbZ8wOy8QlXOrsYADcf6l4rf/Se3PSgmOHnZ/wjNB8GKl5mzNrzL
         A3GhQLsMXdGl6hGVkqwB+loHAvDbk/QDTtcHFOawFdiA0aqYev32l+CZtpbqhqtkp2
         2cyxJMnpHs3QloOmxBaIYgKwjYAGfCLtt4euQy9k=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from localhost.fritz.box ([62.216.209.151]) by mail.gmx.net
 (mrgmx104 [212.227.17.168]) with ESMTPSA (Nemesis) id
 1MSc1B-1mwMqM40V7-00St49; Mon, 10 Jan 2022 23:30:24 +0100
From:   Peter Seiderer <ps.report@gmx.net>
To:     linux-wireless@vger.kernel.org
Cc:     Jiri Slaby <jirislaby@kernel.org>,
        Nick Kossifidis <mickflemm@gmail.com>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Kalle Valo <kvalo@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v1 2/5] ath5k: remove unused ah_txq_isr_qcburn member from struct ath5k_hw
Date:   Mon, 10 Jan 2022 23:30:18 +0100
Message-Id: <20220110223021.17655-2-ps.report@gmx.net>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220110223021.17655-1-ps.report@gmx.net>
References: <20220110223021.17655-1-ps.report@gmx.net>
MIME-Version: 1.0
Content-Transfer-Encoding: base64
X-Provags-ID: V03:K1:3erQf5xbsLKf6pQyN6y96AR+2l2JqvlcvYy3sQSCCM4x5jdpeYc
 h73svbWvkbzqThogJSXp+Kkom7S57PNyLO6eO2mfV7Zhrx3EDaNUCGpv5FsG58gkwyvtmIV
 aGXSuy6pdeG6ldbbc+OV67ezRcjLeqZ/CPbFK6GPJdl8LpZuN+CW9wUrwpF02p7efIwTAEE
 sPXvlcDahR73dQUDam23w==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:bVHFk1kJ6FA=:IKgbmY/PojXk7pyL3rD7Ns
 6f6WVZxuoMpBu6MJNmkT/P0URYzLDkR63jn5fnDDcqV7wRavXXR5iwSlN/4+zC9FS4SRKX0tw
 eBiECQxMSUQFeiwtaFHapMXNrJYzO8tYCeRXZHYwidqqIb3IAdT9e0+g8cujMz/1LwhvfpL13
 wIFowilSekOB6ivnQ2PwZ4Ta1Z93ajphoNGDLLn2NDtf6qDDaAHu4QWhoScf4dPS/S+yHO0An
 RffIIRTUizG/aikeoKrE8e0MfgJL5yHQRHO6EwKeuqlwg0Y8ocPK0FT0x9vYuIi3rmXq3seGf
 r8ogDUrISDshqYweYH0iKgYI5AwZwxcI164Z/v+01YBu0oA3H5Ap662iwfWdePRkmEv04jIPl
 yAKy606uINRudZkJtk6aGdkhrJH2492CFNaF7gqms6vk/7iw9S+JrPRbvEKEQ/eQx9H5wGYPT
 JTX/5ymkwpbByyP2ckbuHJii8z7vkzvBronj/gin3P4PIaVHBY3ukiPeYKcZuZPibS3g1W1Xr
 SotLelaagnxhcQbfj6EdQ2AoB+lhzNnQ1IkfbjHciM5U3cEOq4VfY3sYBUwEG4+HzMHv/reUD
 ZgHPeS5zN5cinBayghXhVVlvGngS6FQa2Uat+TmbloEL0sVz4szI0H/nTDrtjzTkduRQzYm9e
 lGue1iE5XDX6tiLzwvPVBtURpR8mW4Xnumj3WxiDyoTLLopiR5jZkinXvyRIHMzNSvCD9p1SL
 nAurY839OcsNNJ1Pcg5go7ZTSMiXDEzpYK4GsUHK2BBdStQ2B/Pvq9ysHdMMCmYlDLoppeBA0
 hgrZ0XWRMXngopLS63SGQIL+wk7xtejtQIUys9TatLHUnueR1m/8Tm0tGKGUos5tJ8v6AXshp
 wQx9MZc9Aj67qSDBuqocc7leup99dBYbUjljbVDk/6lUWyFFR7wy31Lkl/Y0eR6hFSqghDx2M
 5fBFbzFsh3UY0QL+pd3HGe3C2+fk1v1dm7AvueUnZ+ItZr9GosuRAEsKBL9XjMxdZ2V6VPFdB
 rpj/YC4FIQu+0hxIm7lAtoA8JpR8u0h0jCK+w7RMKWm5bgMCCGcmRYW0PKypHAIVp1/Acy0WB
 hHIeAyT/uIxTss=
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

UmVtb3ZlIHVudXNlZCBhaF90eHFfaXNyX3FjYnVybiBtZW1iZXIgZnJvbSBzdHJ1Y3QgYXRoNWtf
aHcgKHNldCBpbgphdGg1a19od19nZXRfaXNyKCkgYnV0IG5ldmVyIHVzZWQgYW55d2hlcmUpLgoK
U2lnbmVkLW9mZi1ieTogUGV0ZXIgU2VpZGVyZXIgPHBzLnJlcG9ydEBnbXgubmV0PgotLS0KIGRy
aXZlcnMvbmV0L3dpcmVsZXNzL2F0aC9hdGg1ay9hdGg1ay5oIHwgMSAtCiBkcml2ZXJzL25ldC93
aXJlbGVzcy9hdGgvYXRoNWsvZG1hLmMgICB8IDUgKy0tLS0KIDIgZmlsZXMgY2hhbmdlZCwgMSBp
bnNlcnRpb24oKyksIDUgZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvd2ly
ZWxlc3MvYXRoL2F0aDVrL2F0aDVrLmggYi9kcml2ZXJzL25ldC93aXJlbGVzcy9hdGgvYXRoNWsv
YXRoNWsuaAppbmRleCBkYjZiYTQzM2MwNWQuLjcyYmEzNmEwNDgzNyAxMDA2NDQKLS0tIGEvZHJp
dmVycy9uZXQvd2lyZWxlc3MvYXRoL2F0aDVrL2F0aDVrLmgKKysrIGIvZHJpdmVycy9uZXQvd2ly
ZWxlc3MvYXRoL2F0aDVrL2F0aDVrLmgKQEAgLTEzOTcsNyArMTM5Nyw2IEBAIHN0cnVjdCBhdGg1
a19odyB7CiAJdTMyCQkJYWhfdHhxX2lzcl90eG9rX2FsbDsKIAl1MzIJCQlhaF90eHFfaXNyX3R4
dXJuOwogCXUzMgkJCWFoX3R4cV9pc3JfcWNib3JuOwotCXUzMgkJCWFoX3R4cV9pc3JfcWNidXJu
OwogCiAJdTMyCQkJKmFoX3JmX2JhbmtzOwogCXNpemVfdAkJCWFoX3JmX2JhbmtzX3NpemU7CmRp
ZmYgLS1naXQgYS9kcml2ZXJzL25ldC93aXJlbGVzcy9hdGgvYXRoNWsvZG1hLmMgYi9kcml2ZXJz
L25ldC93aXJlbGVzcy9hdGgvYXRoNWsvZG1hLmMKaW5kZXggNzhiODczNzJkYTk1Li5mYWVhMzI2
MjM2OGYgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvbmV0L3dpcmVsZXNzL2F0aC9hdGg1ay9kbWEuYwor
KysgYi9kcml2ZXJzL25ldC93aXJlbGVzcy9hdGgvYXRoNWsvZG1hLmMKQEAgLTcxNiwxMSArNzE2
LDggQEAgYXRoNWtfaHdfZ2V0X2lzcihzdHJ1Y3QgYXRoNWtfaHcgKmFoLCBlbnVtIGF0aDVrX2lu
dCAqaW50ZXJydXB0X21hc2spCiAJCX0KIAogCQkvKiBBIHF1ZXVlIGdvdCBDQlIgdW5kZXJydW4g
Ki8KLQkJaWYgKHVubGlrZWx5KHBpc3IgJiAoQVI1S19JU1JfUUNCUlVSTikpKSB7CisJCWlmICh1
bmxpa2VseShwaXNyICYgKEFSNUtfSVNSX1FDQlJVUk4pKSkKIAkJCSppbnRlcnJ1cHRfbWFzayB8
PSBBUjVLX0lOVF9RQ0JSVVJOOwotCQkJYWgtPmFoX3R4cV9pc3JfcWNidXJuIHw9IEFSNUtfUkVH
X01TKHNpc3IzLAotCQkJCQkJQVI1S19TSVNSM19RQ0JSVVJOKTsKLQkJfQogCiAJCS8qIEEgcXVl
dWUgZ290IHRyaWdnZXJlZCAqLwogCQlpZiAodW5saWtlbHkocGlzciAmIChBUjVLX0lTUl9RVFJJ
RykpKQotLSAKMi4zNC4xCgo=
