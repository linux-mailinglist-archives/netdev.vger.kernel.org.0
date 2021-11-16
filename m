Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 017AF453C27
	for <lists+netdev@lfdr.de>; Tue, 16 Nov 2021 23:13:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231953AbhKPWPv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Nov 2021 17:15:51 -0500
Received: from mout.gmx.net ([212.227.15.18]:34037 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230484AbhKPWPv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Nov 2021 17:15:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1637100766;
        bh=BccBlK1Ruuzqsg+QAu3HJjwlyo+NyXNPJ95yePLNa4Y=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date;
        b=BAus9mz4Z11wS0n5FERhJMqvlp3EQcJw/nldMzOiJZlHDOEM6jt69FXg4NFpDQmyL
         64eezF6p4HsY8T7F8CqmvVEqWAL2oTTZrDwqVxUQQDUhQLZW1hypiXUCImILfPZumD
         U84xRlWAePv9WIMFKbXygyI0tza20FXSWNA62U1M=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from localhost.fritz.box ([62.216.209.243]) by mail.gmx.net
 (mrgmx005 [212.227.17.190]) with ESMTPSA (Nemesis) id
 1MGQjH-1msqvI3gdx-00GsE8; Tue, 16 Nov 2021 23:12:46 +0100
From:   Peter Seiderer <ps.report@gmx.net>
To:     linux-wireless@vger.kernel.org
Cc:     Johannes Berg <johannes@sipsolutions.net>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH v1] mac80211: minstrel_ht: remove unused SAMPLE_SWITCH_THR define
Date:   Tue, 16 Nov 2021 23:12:44 +0100
Message-Id: <20211116221244.30844-1-ps.report@gmx.net>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
Content-Transfer-Encoding: base64
X-Provags-ID: V03:K1:dpQUTq3IL3tnxxKPwfQypVkgjv7WAgl2Q41kibAYmwcWlJiatee
 eRZ/Dag1uyG8ORAwK6GTYsIzjZbFMyY0O21xrQunHO5My2orvChN8e+FBIBOLgyuHHIzR27
 9iTXNrqnnQ5dHRqw4Zti0ReqtRi9l5lSa/B9oIc/NWzxPXNniqV2jMcj7NHwpmxKNaNxUTQ
 seN7t0U22fz7QeKWHtZBw==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:qzCgml5Qd1Y=:xIYRCfAGKdS4O/D4JXvMNQ
 VLPh46VXzPhQ6c4K29HpuJRzE5YZRCR3FiIDzwoTDzpu4rwiYEOBh4VCX+41qL2X7bJL1sF3U
 Yh3LE3Pji0kFiM2cPNJGWaIpGZNzOx3+qoZa6uDXPACFdij5sCbmfX/X/fueyvBSF1RwffslM
 tfe9RmhktvVUNjC86tljJ5ZBq6nP29MJjMf3UrqOZumHDx2dRTY27+7KvyvMEndFQ7+/VrXO2
 Z8tYm+N0Ersu2RXu82mKSgPZ8DKjA2yLsnOizjxpx+BPlwBXGBIKznltarHv1C9xLZko9cLqV
 YBZLp/dPCgsI4/WYSJ4ZbxB1uHJEDVoblzc0KPRlIMVdTBeOW2mAKeqRpGr24aOVy20n1kvNJ
 /mJACSukC1UFssCRdK7ifvDqK2QkO5pjSZKajm+8CKPDY9Mjd3yQSg2h5pW83lTjtaFGK6znt
 7yfRVL2eaLLdWEnj7HLwvXygcjbo4wtZMh6hOCq8LH9mvrc2UbkxuJwRwpGiMKQnc4BGfAua/
 1AMl9Z8UCco8G59veqx1tn0DezOYeegOG8DxsbUsMGsI3ZDx9qcX0nZPwxYVxnaKdNcmi5GFM
 VEBOV2tOuECRPiJXF8cm/9/FvU4oltceW/M1P6+t1DpzdI6yYIuzesQwnmWZ7S9zNhmCHUUpV
 2lB4cdWGTeWd/AQnSuq3kM66OlJJz/R+xkkJrbOsJvBVK/152sVr1MiVtPEsvJlfjBuo+OieX
 ojXrvy9iTxu6ew+lD2vcu0JgFPb0bw8KCyRizBq1FByUEGOia2+QdkXMVJTRmimCeaLQOj/Ll
 U6eOq16j4Kuc4HESnsjbWSQz3C513sgCgJtMUprnJXVdboXJSWl+JWwhaxJ1H7wRTwX9l9dfb
 Vuqy9jWzv1hULvnGolrzhD/gHn5livf3IZOGhTQCt2wc+YkCWZ1aSSmlYefldrTvNomnjxmEW
 3p9ptLVk0bMFAoTwbAjpCSEi4LKbjsgqvVugPZjCculdT8f/6sJuRXvCrh0OR/X1olqJEX8VY
 cGmhoVUwIJBoI9SVYVladYZcjMCaahC9+sZWY/kjdCe8ZRZbLNBupPuu8x3uPm3Oobu124L+J
 FMz1WNrn/jWMqI=
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

UmVtb3ZlIHVudXNlZCBTQU1QTEVfU1dJVENIX1RIUiBkZWZpbmUuCgpTaWduZWQtb2ZmLWJ5OiBQ
ZXRlciBTZWlkZXJlciA8cHMucmVwb3J0QGdteC5uZXQ+Ci0tLQogbmV0L21hYzgwMjExL3JjODAy
MTFfbWluc3RyZWxfaHQuYyB8IDIgLS0KIDEgZmlsZSBjaGFuZ2VkLCAyIGRlbGV0aW9ucygtKQoK
ZGlmZiAtLWdpdCBhL25ldC9tYWM4MDIxMS9yYzgwMjExX21pbnN0cmVsX2h0LmMgYi9uZXQvbWFj
ODAyMTEvcmM4MDIxMV9taW5zdHJlbF9odC5jCmluZGV4IDcyYjQ0ZDRjNDJkMC4uOWMzYjdmYzM3
N2MxIDEwMDY0NAotLS0gYS9uZXQvbWFjODAyMTEvcmM4MDIxMV9taW5zdHJlbF9odC5jCisrKyBi
L25ldC9tYWM4MDIxMS9yYzgwMjExX21pbnN0cmVsX2h0LmMKQEAgLTE4LDggKzE4LDYgQEAKICNk
ZWZpbmUgQVZHX0FNUERVX1NJWkUJMTYKICNkZWZpbmUgQVZHX1BLVF9TSVpFCTEyMDAKIAotI2Rl
ZmluZSBTQU1QTEVfU1dJVENIX1RIUgkxMDAKLQogLyogTnVtYmVyIG9mIGJpdHMgZm9yIGFuIGF2
ZXJhZ2Ugc2l6ZWQgcGFja2V0ICovCiAjZGVmaW5lIE1DU19OQklUUyAoKEFWR19QS1RfU0laRSAq
IEFWR19BTVBEVV9TSVpFKSA8PCAzKQogCi0tIAoyLjMzLjEKCg==
