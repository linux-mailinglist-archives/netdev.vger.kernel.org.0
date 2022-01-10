Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E63B48A2C5
	for <lists+netdev@lfdr.de>; Mon, 10 Jan 2022 23:30:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345432AbiAJWah (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jan 2022 17:30:37 -0500
Received: from mout.gmx.net ([212.227.17.20]:39123 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345433AbiAJWad (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 10 Jan 2022 17:30:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1641853823;
        bh=pq3G8YNOhj4t7nDtwp3ftybIIxEtEenASnHUGrCP1U8=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date;
        b=IGZqpnN+CladoaCkxLf2HpZrldlIuveOyqE0zAtDlJQldI7ygcJBNewmaz/rx4OLU
         PvVAofhYcixo9Xs1X8rD5bOTzugb+szJrvzCN2m0jrDuX58YD/piMBIG1fQqiepYeC
         hlhUi/TxOLCGQRb7OOqzWxj8IEvef3UjAWQ9bSbg=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from localhost.fritz.box ([62.216.209.151]) by mail.gmx.net
 (mrgmx104 [212.227.17.168]) with ESMTPSA (Nemesis) id
 1N8obG-1mJz9V1rPS-015nmM; Mon, 10 Jan 2022 23:30:23 +0100
From:   Peter Seiderer <ps.report@gmx.net>
To:     linux-wireless@vger.kernel.org
Cc:     Jiri Slaby <jirislaby@kernel.org>,
        Nick Kossifidis <mickflemm@gmail.com>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Kalle Valo <kvalo@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v1 1/5] ath5k: remove unused ah_txq_isr_qtrig member from struct ath5k_hw
Date:   Mon, 10 Jan 2022 23:30:17 +0100
Message-Id: <20220110223021.17655-1-ps.report@gmx.net>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: base64
X-Provags-ID: V03:K1:d5g9VGq2YYCdJZbuUoG8tfgp837QNFH7tHCixBv85xAi5Ge94DM
 PiKn7g8qPMv2zD0wvM8jRW0/cofi4jqQU0TUm9d8Dv0PWoyCk9YY/jf3QC9vlcgo5DqRTqu
 ys0lOqSXroVQdvNqBXhQClpcB1iDUvljHb7EoTFiMwE6+/hvVCNfTri9h95NYHWNdWaamwC
 90dcwdtKLLE5JMhCVLQxA==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:Eo/s0/EISKw=:m6zrDnwVio5PNQiVTZNzvg
 39OQXget1cXi7qp/NqgoQrqpSKOPD2FBkmfWAOqKD0l3IRLiqowk6GrCfXPUVF6i1tHKOKcHn
 tzSL5AEbXuLytt6NIfbCdb/+DSZeHfH6uRiNWTW3QBrCRGxtPMshpmdnGwcZa40omxuQtJGaB
 87xqgyncBwjx6zxySnDKU7gGzwRx5dEZaYf0W4XyOedcK+5fBVR84oPKZyU8hHwXeeWfDr8iN
 r4EiemufDj9hQ4+AnmnoqAiKFgB/QHX0p3mcjnlLUED21dx9Zp3vjTYufk/MS9wItoC7ElOmr
 hHwqFXkOIZJtFx0R/BP4+OC1MSZVG1RXZRFlG+LaAlDuWpb5iFx0vj31K+YPtqS9OP5CbRyGh
 ZDCZxrvwKxm7fV2DyT0W8bQ9S5qC6MI5Lempa5HOhjCiGhvehEGDFx5y4B+vbeVNtKv65aTpi
 ElvRenR47BJnyQL86mDk0VBUVDXtLWGLme+bjt1ZKbFq1XmodGlpoxbmN9bWap9GBuDV/+C0H
 cg0ZRBH3Qhr72hwcaFAXODt7a1AZr82mg07JeMpLv9zHy/Wrl6sdlwGfULOk6arvlb+w9+cNR
 nzduFs0n7gYRPzRNbHFFIOQxnLzA3+DNoR2XWw6EOScrsjeLb6X5hq7P8rEBD0wehH4wweKW+
 BO/673coT+yKxzxWO65yDykbjH3URt2cUWfcIsLB1keOaXTFqx9RB29lob3aYX6KEqPv7NDo2
 bRtJlVuB2I3bbylvudhXJ2jerm6cclT1b+wPkp1CRZ6Wo8NOsREBVOjO1dE7+ZfTAvHcJ1dPm
 bTVI9gR5rJIA3+DaF7o7efd2AK5tldtZkFxo6ZzoXMHoF4bGd8P/p9q/I/CpiJYPGw3cYOo1Z
 VD9G2nIpMJ9z2CwHX7hGPrSS3IKqASyAxQD0+QbJDwysRxT/48QZLGyKWvzsb/TuxukwTNXN8
 E33IzcCBAdGtrDXAr+rQGCGa8G5E2EiTf9RyjpoAVjMGEvUDfSJ5mnWomdNrdIF2IgMOD1Xy/
 38B7O8u/JoqS9cq7fteEf6uQoqLESHFr24ZD09yheQfpBxDC/URfim7/o6/GiIMXBGZswaoxJ
 fYuy259Q9KIBe4=
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

UmVtb3ZlIHVudXNlZCBhaF90eHFfaXNyX3F0cmlnIG1lbWJlciBmcm9tIHN0cnVjdCBhdGg1a19o
dyAoc2V0IGluCmF0aDVrX2h3X2dldF9pc3IoKSBidXQgbmV2ZXIgdXNlZCBhbnl3aGVyZSkuCgpT
aWduZWQtb2ZmLWJ5OiBQZXRlciBTZWlkZXJlciA8cHMucmVwb3J0QGdteC5uZXQ+Ci0tLQogZHJp
dmVycy9uZXQvd2lyZWxlc3MvYXRoL2F0aDVrL2F0aDVrLmggfCAxIC0KIGRyaXZlcnMvbmV0L3dp
cmVsZXNzL2F0aC9hdGg1ay9kbWEuYyAgIHwgNSArLS0tLQogMiBmaWxlcyBjaGFuZ2VkLCAxIGlu
c2VydGlvbigrKSwgNSBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC93aXJl
bGVzcy9hdGgvYXRoNWsvYXRoNWsuaCBiL2RyaXZlcnMvbmV0L3dpcmVsZXNzL2F0aC9hdGg1ay9h
dGg1ay5oCmluZGV4IDIzNGVhOTM5ZDMxNi4uZGI2YmE0MzNjMDVkIDEwMDY0NAotLS0gYS9kcml2
ZXJzL25ldC93aXJlbGVzcy9hdGgvYXRoNWsvYXRoNWsuaAorKysgYi9kcml2ZXJzL25ldC93aXJl
bGVzcy9hdGgvYXRoNWsvYXRoNWsuaApAQCAtMTM5OCw3ICsxMzk4LDYgQEAgc3RydWN0IGF0aDVr
X2h3IHsKIAl1MzIJCQlhaF90eHFfaXNyX3R4dXJuOwogCXUzMgkJCWFoX3R4cV9pc3JfcWNib3Ju
OwogCXUzMgkJCWFoX3R4cV9pc3JfcWNidXJuOwotCXUzMgkJCWFoX3R4cV9pc3JfcXRyaWc7CiAK
IAl1MzIJCQkqYWhfcmZfYmFua3M7CiAJc2l6ZV90CQkJYWhfcmZfYmFua3Nfc2l6ZTsKZGlmZiAt
LWdpdCBhL2RyaXZlcnMvbmV0L3dpcmVsZXNzL2F0aC9hdGg1ay9kbWEuYyBiL2RyaXZlcnMvbmV0
L3dpcmVsZXNzL2F0aC9hdGg1ay9kbWEuYwppbmRleCBlNmM1MmY3YzI2ZTcuLjc4Yjg3MzcyZGE5
NSAxMDA2NDQKLS0tIGEvZHJpdmVycy9uZXQvd2lyZWxlc3MvYXRoL2F0aDVrL2RtYS5jCisrKyBi
L2RyaXZlcnMvbmV0L3dpcmVsZXNzL2F0aC9hdGg1ay9kbWEuYwpAQCAtNzIzLDExICs3MjMsOCBA
QCBhdGg1a19od19nZXRfaXNyKHN0cnVjdCBhdGg1a19odyAqYWgsIGVudW0gYXRoNWtfaW50ICpp
bnRlcnJ1cHRfbWFzaykKIAkJfQogCiAJCS8qIEEgcXVldWUgZ290IHRyaWdnZXJlZCAqLwotCQlp
ZiAodW5saWtlbHkocGlzciAmIChBUjVLX0lTUl9RVFJJRykpKSB7CisJCWlmICh1bmxpa2VseShw
aXNyICYgKEFSNUtfSVNSX1FUUklHKSkpCiAJCQkqaW50ZXJydXB0X21hc2sgfD0gQVI1S19JTlRf
UVRSSUc7Ci0JCQlhaC0+YWhfdHhxX2lzcl9xdHJpZyB8PSBBUjVLX1JFR19NUyhzaXNyNCwKLQkJ
CQkJCUFSNUtfU0lTUjRfUVRSSUcpOwotCQl9CiAKIAkJZGF0YSA9IHBpc3I7CiAJfQotLSAKMi4z
NC4xCgo=
