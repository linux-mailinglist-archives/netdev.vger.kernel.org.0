Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9824A26974E
	for <lists+netdev@lfdr.de>; Mon, 14 Sep 2020 23:03:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726062AbgINVC4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Sep 2020 17:02:56 -0400
Received: from mout.gmx.net ([212.227.17.21]:33853 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726153AbgINVCD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 14 Sep 2020 17:02:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1600117317;
        bh=tI6OyP55k9be/vAgh7c36RYZohxKQJrFTIwOD9mKkbY=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date:In-Reply-To:References;
        b=OQjNArPWVctTJGGPYLXqPOknWGeMn7RU5HpU1qtsp8uJCuKESgoG9jpKycyK3npb9
         0w7TvyHXI2zBTwRcrYmBULVofAANRQFPCWgiSkDjRY7eAud6qe+rKDkBjFHGfMkQkx
         dzYSAkKUy20/zhP0Ij2WubDhyHCN4CZPvXAInNwA=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from mx-linux-amd.fritz.box ([79.242.188.32]) by mail.gmx.com
 (mrgmx104 [212.227.17.168]) with ESMTPSA (Nemesis) id
 1MF3DM-1kK8Y11252-00FPEZ; Mon, 14 Sep 2020 23:01:57 +0200
From:   Armin Wolf <W_Armin@gmx.de>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org
Subject: [PATCH net-next v5 4/6] 8390: Include necessary libraries
Date:   Mon, 14 Sep 2020 23:01:26 +0200
Message-Id: <20200914210128.7741-5-W_Armin@gmx.de>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200914210128.7741-1-W_Armin@gmx.de>
References: <20200914210128.7741-1-W_Armin@gmx.de>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:2j9FkQitFK2Fau0BP9EqcSLEdLccczOUICx3hH8DQtR1+IFQbRw
 X9t5hjaf+7NDmQQPjo0js5rv7arECTSWh7xY0EcVoj41lcexvGXOOJAEjPQSTrzjRmofwtL
 c9Leo8+raOxzcD4sazUSabNoDtNGk7xEAfP86s/FoFhfRRuXJ/fp8wp+96HBnAZeZOvK2n8
 yAwEeB6EVIndUOH1/kzSA==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:pqKXfOlRqXs=:C+JvWkr3jRONNLX+PmzGj9
 Hg0qpsS/aRIADr+B5hxWcQPR5bmCG7TFz+suDafHM0xEbLQeJFZNJfDlKigvHM94FX93riqw9
 OyPzCKjRhzmO91muOB4RRpVeP5wjqN/Zj9l+2J8crp6dlwNDldHFGplvf12kAt/n2bhc5GmK2
 mACFbdETqacV62NikwAYPm0yes+e02vNTYgAaibNpk8nqA/JMCxWPNhme5tgaFSFf5magMqbD
 AjHInaDV/r9vNFBqpz0voODUqjdWxwvlXSM9hm4I1+AlPQ1YUz/a/wFMxcO/dCaAoEBXso/LA
 h+fFEIyAs+SC3KFngGuWOGzHwFq5ObH/7mjBKnJyoIgFpzlZkKmREHDNBCerRmj9+493CMPFt
 P+lgKHVe5uC6GYAujFysZKfdx4/jTaILTXAhejbgRcz+umxoKdE0zMDdhrV/cf59wYsWfHKqB
 2OhqULRqvOjVOTlJCMrjH6A3a4bLlsBTO8PUjFoz9DDBYzuotiuTdYyEtMv+ywkiYGQoyD8L2
 w8OeVdlqs1WZj6/4cy0PYPQWiV/SezE216uNId4TOjTTU4cUGMmAUJhzos2zm9nqdkdMbK+lF
 1Jv8dlb2qFcz5DqaboTH3Aq538NqsermlJM80mOMsYcXIjAjoAYWjKibFz5cy61vbsStiALvc
 vOuVSQCWvGLWxCk+honEqg92xw4ZI5J6LGZreW+BzMS2ET4lRETZqh4gh05YwKF9E9WfsTCl6
 2K8TlCJZKOzese5OwEvsa8OeGlfLkYbbIGLKmm2Ul4t4afKrLhEn9Cum8JsghitVCgjT1HMMp
 LyJNhxMTuj4zkUvMJKuGNO+PmtYnu8TjD8r8Vw8zIfaqTWyoW0mLNB4ayySxuoGlhvDCLTCRX
 4JmAb9QMwIciW2qmQIPzdceZSuKky5vF6AS4JE6OwLRQQCRHW3eZKa22roz6nzAOTaOFy2ueE
 sYpr+6BJzROkeLQiZICfiVbUlSU5Wj2j2HwF0Bkk74lWX8vwFd63eD+Y5oT7Q2Ykktj/xPy0C
 RAzuR3lWV9BQV54PDnK7vR6qsPPuVT0Icz3MxWndbXMgwSDRvL5xB3rBt1cgmO3Cxa4l8eWhB
 QuOGl6hyE0qk9ZnbIMUsqXkdv9dQ+5QvnQ/Hll3Eyq75WZFt6JkC3Y9hYmiNj61DouXT/AMUP
 1avf+p9x5yy4ozog24CHu4spR4JEeiTIOfRkybHYG78O6KgZgautGPT8Rk3J5b3BeskABKFlJ
 IWiYj3/hHg3txK38S
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Include necessary libraries.

Signed-off-by: Armin Wolf <W_Armin@gmx.de>
=2D--
 drivers/net/ethernet/8390/8390.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/net/ethernet/8390/8390.c b/drivers/net/ethernet/8390/=
8390.c
index 318f827cc085..911fad7af3bd 100644
=2D-- a/drivers/net/ethernet/8390/8390.c
+++ b/drivers/net/ethernet/8390/8390.c
@@ -3,6 +3,13 @@
 #define DRV_DESCRIPTION "8390 core for usual drivers"
 #define DRV_AUTHOR "Donald Becker (becker@cesdis.gsfc.nasa.gov)"

+#include <linux/etherdevice.h>
+#include <linux/export.h>
+#include <linux/init.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/netdevice.h>
+
 #include "lib8390.c"

 MODULE_AUTHOR(DRV_AUTHOR);
=2D-
2.20.1

