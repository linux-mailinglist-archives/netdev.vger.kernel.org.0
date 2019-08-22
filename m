Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DF635998D3
	for <lists+netdev@lfdr.de>; Thu, 22 Aug 2019 18:09:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389784AbfHVQJK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Aug 2019 12:09:10 -0400
Received: from mout.web.de ([217.72.192.78]:42781 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733169AbfHVQJJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Aug 2019 12:09:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
        s=dbaedf251592; t=1566490129;
        bh=VUcjr2Cof96KVPeedy+xoIMhTIz/ausJ0oZCbuvy7qo=;
        h=X-UI-Sender-Class:To:Cc:From:Subject:Date;
        b=LLxs7JY+RP78Wz/ZhGTkmkRKPJQg7/X5W5OR1DYAcDz7XLTdkmjiDIGcC3V5fW7nc
         xgpS/gaystoHdV6bQQ3aQkVpeekgIGl12GIfUcLI4SALpybVmrowhmIGV0MQsPGbd9
         rLxhHW7kCxMGAVOfsIL1vZW2mrf3DTddNZpV63LA=
X-UI-Sender-Class: c548c8c5-30a9-4db5-a2e7-cb6cb037b8f9
Received: from [192.168.1.2] ([78.49.181.43]) by smtp.web.de (mrweb102
 [213.165.67.124]) with ESMTPSA (Nemesis) id 0LoHgL-1iTXke2THN-00gHr6; Thu, 22
 Aug 2019 18:08:49 +0200
To:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        John Fastabend <john.fastabend@gmail.com>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
From:   Markus Elfring <Markus.Elfring@web.de>
Subject: =?UTF-8?Q?=5bPATCH=5d_net/core/skmsg=3a_Delete_an_unnecessary_check?=
 =?UTF-8?Q?_before_the_function_call_=e2=80=9cconsume=5fskb=e2=80=9d?=
Openpgp: preference=signencrypt
Autocrypt: addr=Markus.Elfring@web.de; prefer-encrypt=mutual; keydata=
 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 FEE=
Message-ID: <2755f638-7846-91f2-74f4-61031f3e34c8@web.de>
Date:   Thu, 22 Aug 2019 18:08:48 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:rFoS5Qm0zQNDxSjLaEBNG6/iaAo/0ONoL90ykaX+G3oV3ihK205
 mjpDpZlFYy64pWO7FtybVu+35tNaY74ag2c9Tf74WpyZR/ZjORdvHOkPm4RFZMX14VkN6/f
 D0AYWbtzxLoELcq1ZFR/4WugJ5yfeTTzBeKuNbA+az89DbiPF8PiFgDDltrqGllA6XOxXRx
 MBkBe7FoF1J9meYFo4TFw==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:TRhDJRjAWZM=:ho/iUd/R6wM9rcGnjnohUl
 FXdP7pPCa72rZp8HwietPZEPVpVBBn81i1ImQujHPblzHqCp9wQ6iB+KIivaqrVn3uwF1G8Yb
 QOnZcgBWldCQhZax/okYa3MmmTKWmox88xxRiAma0G5izeRfeMfC6qjCeamSVEZZc/KTJ0+Ij
 rlKMWJiJfJbVq3rqoh68uMNV0buT4XYYKbGM0mn36tD8EIHRlDEBeTNGojJ7SYJ2WrgkCQ1Zy
 z7cnXwart8QBVQP8U5O6Ezk2bVnyhNoM4vcPD0t/61T9gIerH32bkQIzGX5oCjHh35PLeAQ1G
 HsXV1y1FTYuQgVozx+t22AywNZcrnoB6sQkEE/N1VdVoxJvF3qD+yeMrfAYTjcFq3+fn/qA39
 wYj3XPeMavz5p9H8h9Ys7gtuit70bzzaOtWDStpt1U1zadSCUWwHkUyOUeaF++jiCU4NTTovd
 Uem/qGoFRdTVwdQNP2Y8vsScM2vdNdVeP3G3KWhAhKhoQpsMqNeHYL16jLh0HnxEYyA/RnJ4Y
 1Bf+WCp02/SVDnoiz6gZWwMlGeQJb0YyKuyoGFWUjhsF3TckFIt9jYRAKSwklXq/6mv+2+s3B
 8QGodkucKsACuaMnW31DSAfnOpQYsmKFzm2Jtia9ZbdacCPX3PZwwEWmbk44fpown+j5SJ+S9
 Z07azS5RLYdvBKUdm41/TpYckf4UJFfog22BKn0ySYx6NREUbhy0alQ4bRBHo5K+IHIgNHRX6
 NYyYJhuJi+3wy+sYRaTbDYfqa9pnXFZiOfLWqGFqq2s9+FJxpHBhVJIqXC5WFsfF1a7rGgToM
 Fl8SPPVJpOOyx6nEH1FXtYhfDx5qTCqzvWNUXNTkiFpp3rKqMAX+Al8qQD5nsuMHV9CavUUox
 9MRqwCCzgCd1i+6UetK9ehr7uBj0tIZSreSVPWLMim6cnjTQ/WnF0DjxXmKnT8Q7xHts0h7p8
 d8zUGAwBSZzaX7Wb8Ykkdwd3L/D5TWJUyoV8IXG4DnZmbIIRLP2TdNfc8SSAwLRgk5n+sf96D
 Kz5J0IqswNRCy4dkhVZqf3EDWYtjUD94UR75Yy7fMgsSugth09u2yF85H2gjmuyB2JTfIgawU
 i5u1oeHpQLl2ZMDtCIpm/4OtlD+VB7KfnMIFPenx8DnPphu11C93GUSKEbfDfsp/OYN8oWDsb
 OA9vo=
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Thu, 22 Aug 2019 18:00:40 +0200

The consume_skb() function performs also input parameter validation.
Thus the test around the call is not needed.

This issue was detected by using the Coccinelle software.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
=2D--
 net/core/skmsg.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/core/skmsg.c b/net/core/skmsg.c
index 6832eeb4b785..cf390e0aa73d 100644
=2D-- a/net/core/skmsg.c
+++ b/net/core/skmsg.c
@@ -190,8 +190,7 @@ static int __sk_msg_free(struct sock *sk, struct sk_ms=
g *msg, u32 i,
 		sk_msg_check_to_free(msg, i, msg->sg.size);
 		sge =3D sk_msg_elem(msg, i);
 	}
-	if (msg->skb)
-		consume_skb(msg->skb);
+	consume_skb(msg->skb);
 	sk_msg_init(msg);
 	return freed;
 }
=2D-
2.23.0

