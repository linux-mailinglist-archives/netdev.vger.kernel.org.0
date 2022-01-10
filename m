Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C46BE48A2C9
	for <lists+netdev@lfdr.de>; Mon, 10 Jan 2022 23:30:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345459AbiAJWag (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jan 2022 17:30:36 -0500
Received: from mout.gmx.net ([212.227.17.22]:57173 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345431AbiAJWad (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 10 Jan 2022 17:30:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1641853824;
        bh=k/tTrIjFeCXvZqfaQTrSCH6RUwILOWRvkqA3YG0MfJ0=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date:In-Reply-To:References;
        b=RuY58ohDZI4IPDoL4HnzP+grczAjb5/IZBdJ7qHyT3A/4GAOpxLQOZP3N/DtfCw0d
         0+qMkQM2pRSmdbBNV3Ues+UtzvORif4SDhlAWynaBRltZefHigbCGf58zKOpMhThtS
         3VxN7+m0qPVN1zPgAdRIS0j+IrlldIygyEXbaD3Y=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from localhost.fritz.box ([62.216.209.151]) by mail.gmx.net
 (mrgmx104 [212.227.17.168]) with ESMTPSA (Nemesis) id
 1Mqs4f-1mcKwb1yJl-00mtqn; Mon, 10 Jan 2022 23:30:24 +0100
From:   Peter Seiderer <ps.report@gmx.net>
To:     linux-wireless@vger.kernel.org
Cc:     Jiri Slaby <jirislaby@kernel.org>,
        Nick Kossifidis <mickflemm@gmail.com>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Kalle Valo <kvalo@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v1 3/5] ath5k: remove unused ah_txq_isr_qcborn member from struct ath5k_hw
Date:   Mon, 10 Jan 2022 23:30:19 +0100
Message-Id: <20220110223021.17655-3-ps.report@gmx.net>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220110223021.17655-1-ps.report@gmx.net>
References: <20220110223021.17655-1-ps.report@gmx.net>
MIME-Version: 1.0
Content-Transfer-Encoding: base64
X-Provags-ID: V03:K1:BDrmtIihdsTJpnywmYDxM9n1+px3iDoKOC1yRzRM2G0W3e3Bbgm
 /xgn7kL0NSXNIf64qiHCrg2XML7aKNSB4FKLZpiHdscygxsQkKsid6tXRq9Ocb8Xo93aXEo
 1rwWEr0eZDjwMOsV3RuH0t2U7KwIQ8CjKbJBZ0aa7BJhZeloLast5DgKT/hsc+x7LhgtHeM
 XsOjDOrA697sGkTcGBcmw==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:zplG+idIBZE=:+ccWOgDgT3zGeogJ2W5sxp
 dwXbIa2VF3mrs3iBy/8tpVpxGTMQYBMj6+66R6GziCJvETAEa0joxBQjbbqV01yzPgS32upub
 XFMSwqifOUb9pHR9QN1uhD4/JEXULi5YjIs2w6vdCPMrmQSaW9yTPJGceoEudChUUue4W0K7k
 aT7VoUJWD3MXcn7rrhcOVDnpXavRU8jnNHNIGOXijsIbG9sjN1RDLO4emA1zU2xxn4/Vo+WRt
 +p97zlY/4t+wYb02oo4B8zfdgvehLwR3w8njviKCPn90jkLRGYqeKbd3QNUpYbG6tDqELHOVX
 hsLuo0L0JxDOhjesSHnuHb95GOXUoc0ngr/IcasjXGAtSJj/7wipbfv3pCG+TT9XuFbi+qKy+
 fdtlGH+qf0by/Olh3glsv9ML79hBPcHDIsEkBB/rrEQ/vQ+KHDOarL9xDVisp8HRkpdE5/ESV
 SVIJONnz1GfkLBNwxDGgpspXXacpNJGAqkDKEiGChPmfYO23+pa03Uuv18Vrw80jrCRJBQX8D
 YMvLgr2oJdUMNM4JAOd+w+CBhCeZwdn3MrHZoNQ/lyJBR5mnrsVY/2uJkwZysE2oWlKZnNOWA
 TF6KYUcosuDci810SPStmf6DnG8WobpxmZ49f3bfBY58vHuSGLR2QE+X4z/HrC0oOnSOylmVE
 vjCpyXvLco1ieY82GmzSAv83h/E75dO5J77QNYNsHUnpmeNCfZ5tozBAioooMLevXAqRiBZVX
 rCdNfqEF5D+Q/QzcoCI3e0Sv2gUgqHhZLKyCj72zSEdyyAUkvbUCcVGQPoUb6/O+heEkhDFFm
 5WRjSipT6uHge3fEWTpNa+NTNgKwbKeKGDJcM/rbXFoMDtSEjHEmT3cB8hLRV/gIuWVIX23au
 YMIt+aFSBcZP4mss4GMo3HzXb8m3M4W24tKXkI1YBfR75luqymclAMlVl4nyl+TsFgqWxDFz3
 iaTTzd+u8hy3mmdGCH0pAHMiOv5fvXw6A2vTgp5bwtrSqIA2P6te8Ksci7HeONUYEEpaF3Btz
 puT80G0CX3QaB1Xkf817yK+btz/fFOY/YD2k+bIh4fHOawo88qpF7zdzTgWxh0OHRQ9luOjRS
 1HDCKt9XWSKfQQ=
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

UmVtb3ZlIHVudXNlZCBhaF90eHFfaXNyX3FjYm9ybiBtZW1iZXIgZnJvbSBzdHJ1Y3QgYXRoNWtf
aHcgKHNldCBpbgphdGg1a19od19nZXRfaXNyKCkgYnV0IG5ldmVyIHVzZWQgYW55d2hlcmUpLgoK
U2lnbmVkLW9mZi1ieTogUGV0ZXIgU2VpZGVyZXIgPHBzLnJlcG9ydEBnbXgubmV0PgotLS0KIGRy
aXZlcnMvbmV0L3dpcmVsZXNzL2F0aC9hdGg1ay9hdGg1ay5oIHwgMSAtCiBkcml2ZXJzL25ldC93
aXJlbGVzcy9hdGgvYXRoNWsvZG1hLmMgICB8IDUgKy0tLS0KIDIgZmlsZXMgY2hhbmdlZCwgMSBp
bnNlcnRpb24oKyksIDUgZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvd2ly
ZWxlc3MvYXRoL2F0aDVrL2F0aDVrLmggYi9kcml2ZXJzL25ldC93aXJlbGVzcy9hdGgvYXRoNWsv
YXRoNWsuaAppbmRleCA3MmJhMzZhMDQ4MzcuLmFjMzIxMWIxZWIwYyAxMDA2NDQKLS0tIGEvZHJp
dmVycy9uZXQvd2lyZWxlc3MvYXRoL2F0aDVrL2F0aDVrLmgKKysrIGIvZHJpdmVycy9uZXQvd2ly
ZWxlc3MvYXRoL2F0aDVrL2F0aDVrLmgKQEAgLTEzOTYsNyArMTM5Niw2IEBAIHN0cnVjdCBhdGg1
a19odyB7CiAKIAl1MzIJCQlhaF90eHFfaXNyX3R4b2tfYWxsOwogCXUzMgkJCWFoX3R4cV9pc3Jf
dHh1cm47Ci0JdTMyCQkJYWhfdHhxX2lzcl9xY2Jvcm47CiAKIAl1MzIJCQkqYWhfcmZfYmFua3M7
CiAJc2l6ZV90CQkJYWhfcmZfYmFua3Nfc2l6ZTsKZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L3dp
cmVsZXNzL2F0aC9hdGg1ay9kbWEuYyBiL2RyaXZlcnMvbmV0L3dpcmVsZXNzL2F0aC9hdGg1ay9k
bWEuYwppbmRleCBmYWVhMzI2MjM2OGYuLjBlZTQ2ZjgxMThiYiAxMDA2NDQKLS0tIGEvZHJpdmVy
cy9uZXQvd2lyZWxlc3MvYXRoL2F0aDVrL2RtYS5jCisrKyBiL2RyaXZlcnMvbmV0L3dpcmVsZXNz
L2F0aC9hdGg1ay9kbWEuYwpAQCAtNzA5LDExICs3MDksOCBAQCBhdGg1a19od19nZXRfaXNyKHN0
cnVjdCBhdGg1a19odyAqYWgsIGVudW0gYXRoNWtfaW50ICppbnRlcnJ1cHRfbWFzaykKIAkJCSpp
bnRlcnJ1cHRfbWFzayB8PSBBUjVLX0lOVF9CTlI7CiAKIAkJLyogQSBxdWV1ZSBnb3QgQ0JSIG92
ZXJydW4gKi8KLQkJaWYgKHVubGlrZWx5KHBpc3IgJiAoQVI1S19JU1JfUUNCUk9STikpKSB7CisJ
CWlmICh1bmxpa2VseShwaXNyICYgKEFSNUtfSVNSX1FDQlJPUk4pKSkKIAkJCSppbnRlcnJ1cHRf
bWFzayB8PSBBUjVLX0lOVF9RQ0JST1JOOwotCQkJYWgtPmFoX3R4cV9pc3JfcWNib3JuIHw9IEFS
NUtfUkVHX01TKHNpc3IzLAotCQkJCQkJQVI1S19TSVNSM19RQ0JST1JOKTsKLQkJfQogCiAJCS8q
IEEgcXVldWUgZ290IENCUiB1bmRlcnJ1biAqLwogCQlpZiAodW5saWtlbHkocGlzciAmIChBUjVL
X0lTUl9RQ0JSVVJOKSkpCi0tIAoyLjM0LjEKCg==
