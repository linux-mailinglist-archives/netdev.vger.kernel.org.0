Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DEEF48A2CD
	for <lists+netdev@lfdr.de>; Mon, 10 Jan 2022 23:30:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345511AbiAJWaq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jan 2022 17:30:46 -0500
Received: from mout.gmx.net ([212.227.17.21]:37767 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345434AbiAJWae (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 10 Jan 2022 17:30:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1641853825;
        bh=+BEMjZgHov6GI+pbRQ/61AK7GFOe1ZiB6QyOW7gVx9Y=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date:In-Reply-To:References;
        b=Dm92lJlco/v679Qp3Y0gIY74qDzvxTY+8cXYrHfhVSDesK22DxlOKyKLSFE+mWX2P
         vuSAGUQ+rPqFQa1wtETISXV0J9Md7IinaZWCTKl4OI1hWhSh6TOvTvbb4FoChov96z
         ThLerCFKzh0qvPkxMUm082quuIzguGu4bfD7oXsk=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from localhost.fritz.box ([62.216.209.151]) by mail.gmx.net
 (mrgmx104 [212.227.17.168]) with ESMTPSA (Nemesis) id
 1MkYXm-1mdjzD04hq-00m3yc; Mon, 10 Jan 2022 23:30:25 +0100
From:   Peter Seiderer <ps.report@gmx.net>
To:     linux-wireless@vger.kernel.org
Cc:     Jiri Slaby <jirislaby@kernel.org>,
        Nick Kossifidis <mickflemm@gmail.com>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Kalle Valo <kvalo@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v1 4/5] ath5k: remove unused ah_txq_isr_txurn member from struct ath5k_hw
Date:   Mon, 10 Jan 2022 23:30:20 +0100
Message-Id: <20220110223021.17655-4-ps.report@gmx.net>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220110223021.17655-1-ps.report@gmx.net>
References: <20220110223021.17655-1-ps.report@gmx.net>
MIME-Version: 1.0
Content-Transfer-Encoding: base64
X-Provags-ID: V03:K1:KQ19AMCrNOiO4RXxL9JHJN9emp9Al1pNhGS32fQHrDEywqhyOoR
 fB6QC0cnLpZxVzku75NnBIf2Y5fs5ZOv7ljHmUaIAuDwJbm0HsTZD28IsztP3rmOQdzOgi5
 WfzamsdgUwCqR0EDRepXgyzUYNs2CGcgA0Yj5sa88xAH09FrYuR+fhrZOmxKy86ILYaYroQ
 93h+mXhgd4kYV8PmsiGiw==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:Yf91gQZTrgQ=:rIznZJItYOCDika25WmZ5Z
 mWZnh/LZdI9EvRfSwUiQsCrH/BxDJ4Dh8q+pBEBD90+fKwfMJvA4c9wUefslqhly49Nw78p9x
 5sMSym1Hr3ToHrDTlX/WN/FiDiD0ORsNsAHnDTG6GsvzYrQp/qUuiKSfr0U/86sip1jyEJWHC
 4zbbrA+r09zzd1QQ/IrPAV0c7HtuIi6KWFujbDZ1u9iijA90Nz8fHPJ9cx3nfQ1vlE5t6NS8X
 lw20SfMDRhHDaO+Tf1Gfnycmi21Gy+zvFA1j3nXFNSTVZN0PHmSp6pSRh028WikKiatAi1U9c
 EjmsU/TyYgtN0K8DRSnDSIxb70mbVS2OG+oZn13vm9s4EJqPjiJ9CX0TGVqBp0Ho1rKAvizxe
 jRy0Zzbkn21bWTts/2cmSviAI5hJ7lLZt7Q2CPVPZm7lFkhz5Nj7LYeXNKUw2XKRc25EaTGJb
 /yo5IjyT3Zwgy3KLbyNnHnbegayzBHKZRHB4qEJMdDoC4JsTz/1blYZ5cAI/vnFzGkLDWqlPC
 pd2aS+utiji5/kbFpUcT8yBggFbOV/dJgjhNbOJhk/lGLfuon++V6wN5MyWXnlLdgrNENeX6p
 8P31xXmQvMuA1o1dBNJc7z5vqZSaVlLlX1lFp2FivcG3SQbdJktGdnFmYCIcIsZRsw7Kh4EaK
 zXVkGH6wqiOULU+LweL8005iHY+Ge2g/NDKnR50CwMffPcUP679RVcl1f1yLByqWK8h7sJkxw
 UurENvKckkiaAoCg2pC8p5/HmdFFhm5rNsOvk16M3C05N1MA9PTM6lFPIWLtENjGQ0lj1ouE4
 iFduqPfUqVWJ8KhkgEcQMIiMhAv3LgwB/bvBy0UZkYgySpLBX0hrYznHSnOud3A1z05E33/c9
 Y9VRY1TiMBC9tPS7GEccSVKHH/g3Gl6VRRWw3X3/XQsI43r/6pkHsgq0wjCuDyP07LvZzGu3l
 OIFpXlbMJGzOqR+CD5B1GHxvo49bcQ9fngKguF2I+CpNladss/z+xwCJC1/f+JbKxm3J6UNIZ
 3T8yKqtrYp1eUoxaGhWDADlfsCblx2A4N3hHFuxv/8q/XH+rpMF71LsH05rD7nZYMnIAnHWes
 dibVg9vg49qzMo=
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

UmVtb3ZlIHVudXNlZCBhaF90eHFfaXNyX3R4dXJuIG1lbWJlciBmcm9tIHN0cnVjdCBhdGg1a19o
dyAoc2V0IGluCmF0aDVrX2h3X2dldF9pc3IoKSBidXQgbmV2ZXIgdXNlZCBhbnl3aGVyZSkuCgpT
aWduZWQtb2ZmLWJ5OiBQZXRlciBTZWlkZXJlciA8cHMucmVwb3J0QGdteC5uZXQ+Ci0tLQogZHJp
dmVycy9uZXQvd2lyZWxlc3MvYXRoL2F0aDVrL2F0aDVrLmggfCAxIC0KIGRyaXZlcnMvbmV0L3dp
cmVsZXNzL2F0aC9hdGg1ay9kbWEuYyAgIHwgNyAtLS0tLS0tCiAyIGZpbGVzIGNoYW5nZWQsIDgg
ZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvd2lyZWxlc3MvYXRoL2F0aDVr
L2F0aDVrLmggYi9kcml2ZXJzL25ldC93aXJlbGVzcy9hdGgvYXRoNWsvYXRoNWsuaAppbmRleCBh
YzMyMTFiMWViMGMuLmY1OTUyMDRmNDkzZCAxMDA2NDQKLS0tIGEvZHJpdmVycy9uZXQvd2lyZWxl
c3MvYXRoL2F0aDVrL2F0aDVrLmgKKysrIGIvZHJpdmVycy9uZXQvd2lyZWxlc3MvYXRoL2F0aDVr
L2F0aDVrLmgKQEAgLTEzOTUsNyArMTM5NSw2IEBAIHN0cnVjdCBhdGg1a19odyB7CiAJdTMyCQkJ
YWhfdHhxX2ltcl9ub2ZybTsKIAogCXUzMgkJCWFoX3R4cV9pc3JfdHhva19hbGw7Ci0JdTMyCQkJ
YWhfdHhxX2lzcl90eHVybjsKIAogCXUzMgkJCSphaF9yZl9iYW5rczsKIAlzaXplX3QJCQlhaF9y
Zl9iYW5rc19zaXplOwpkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvd2lyZWxlc3MvYXRoL2F0aDVr
L2RtYS5jIGIvZHJpdmVycy9uZXQvd2lyZWxlc3MvYXRoL2F0aDVrL2RtYS5jCmluZGV4IDBlZTQ2
ZjgxMThiYi4uMmIxMzVhNjI4NGEwIDEwMDY0NAotLS0gYS9kcml2ZXJzL25ldC93aXJlbGVzcy9h
dGgvYXRoNWsvZG1hLmMKKysrIGIvZHJpdmVycy9uZXQvd2lyZWxlc3MvYXRoL2F0aDVrL2RtYS5j
CkBAIC02NzAsMTMgKzY3MCw2IEBAIGF0aDVrX2h3X2dldF9pc3Ioc3RydWN0IGF0aDVrX2h3ICph
aCwgZW51bSBhdGg1a19pbnQgKmludGVycnVwdF9tYXNrKQogCQkJYWgtPmFoX3R4cV9pc3JfdHhv
a19hbGwgfD0gQVI1S19SRUdfTVMoc2lzcjEsCiAJCQkJCQlBUjVLX1NJU1IxX1FDVV9UWEVPTCk7
CiAKLQkJLyogQ3VycmVudGx5IHRoaXMgaXMgbm90IG11Y2ggdXNlZnVsIHNpbmNlIHdlIHRyZWF0
Ci0JCSAqIGFsbCBxdWV1ZXMgdGhlIHNhbWUgd2F5IGlmIHdlIGdldCBhIFRYVVJOICh1cGRhdGUK
LQkJICogdHggdHJpZ2dlciBsZXZlbCkgYnV0IHdlIG1pZ2h0IG5lZWQgaXQgbGF0ZXIgb24qLwot
CQlpZiAocGlzciAmIEFSNUtfSVNSX1RYVVJOKQotCQkJYWgtPmFoX3R4cV9pc3JfdHh1cm4gfD0g
QVI1S19SRUdfTVMoc2lzcjIsCi0JCQkJCQlBUjVLX1NJU1IyX1FDVV9UWFVSTik7Ci0KIAkJLyog
TWlzYyBCZWFjb24gcmVsYXRlZCBpbnRlcnJ1cHRzICovCiAKIAkJLyogRm9yIEFSNTIxMSAqLwot
LSAKMi4zNC4xCgo=
