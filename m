Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C57C9132E9B
	for <lists+netdev@lfdr.de>; Tue,  7 Jan 2020 19:40:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728565AbgAGSkn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jan 2020 13:40:43 -0500
Received: from sonic306-27.consmr.mail.ne1.yahoo.com ([66.163.189.89]:39089
        "EHLO sonic306-27.consmr.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728425AbgAGSkm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jan 2020 13:40:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1578422441; bh=4JZ2RASqGQcuaMgrk84PYn1GgKlqXDyaDcskwFJGVxg=; h=Subject:To:Cc:References:From:Date:In-Reply-To:From:Subject; b=nXqAofZpoRbrCUv845urN8Tb6A85v1LmGOU4+ArfVlYXy3hWGHWMrtxVYIDRYIK2fHBh1Z5apMrgqgKL6yTBBC+fLP3Z/0hCOCbealJq51FoEJh5TILCrk82mihIHBrNBvRRTxb7eN+glDHOYPmtza9IRQI06tGl9BOaikrrlwhzZ5Bi82DGUvIgUyCOY/zuk2ByaYANEOvvAbnonSOJIghIvJCWCbZTx5YB1LgalasFIsfvufnAuCwPr1dEY11JiqbZQc0fcmQl08NtVnDrPK51ra3RUnm1yqQXNoFJKWkBlNPl+iO8eHcSXG9ll+aKNb770+gEYg1mrEqCUnE5jA==
X-YMail-OSG: kdfmA1cVM1nvaMb1jLyVwUAiAxIdnK7zL58wsVi5h4eq5rB1M8vEz9DKXoU.u9e
 N8iWf.D6BGd4N1JxiB8grvhxTR0pz4mpXxNPSB_4fL2DN.psmwVS6dvnkdb.0Vs5OF77tppp4Nka
 gYEBgvi2yeoO4frLd8BJvTMmjvodlUjplUqPOYA5mT8I83uK.mEX5Wr6JVy8epR9Io_33UaHr6ku
 SiTcCfhF356lFLywRcBCByy7Lri4ANszjdIBhLAWdfSdufOkjoaKlY9RbvCxJAm8_.LR8dFgC2Y0
 WS.fnZ3p0ixvY8vKk0Q3DlZc4QIjOwHv6veaLDGA0zo1aI2iEuTkqKZfo.U98YB9pm8N0wF3jGWI
 METT0spwIRJPBk_LRpqYgClTNmpHuTjUO10Lwj7f_7FEQoFnXAlJMCeogXQGXVX2p2yKkXOJpOac
 NR8GMLsmgdOfHRmH7TM5trCcuaFC7FEqD8kcLbmo0wB6heylmCrXWrKiJElzayi_5i97iVE9oQDg
 VA4khqg6P9VnGW7jIxKKNP62eVPh5JRWKc9nmEbDL5.jjz7xLDyx5rZymeKtpOYAYBpG679dKmr7
 rL5RuP.pqWxZqu0NKRNPVawYtanRiMm3du0xFsZY.VCw.wii2zwLyOnrOqXr8AJ4vPQfZA.g5eft
 Rt_TzR0BaugFQqI2GaIzRwnIH2aSvqFswmJnpCqgTddCnXbagnvSKxqSn7pi8petfLNSFKRwUlmF
 y4P4l8H8XQcDBtc_FAtveBmBkd1i1i4U46z2CrfTyjdaQD5_FIUv5Q5P4ONWtM2QqIZ4nmZ__O6f
 9CFThnGq2XHFHOSlgYId4HnKzOxDjc2KgqHZbfbh2NMo5irZd2KIn.lRB3S4PH6eMvuIuPvyIYRi
 XATPlue8iP2U4FvWOQlmSY_dKyD5ZtK9LFZIQ1.kM5Fg08EGNd6tOmwTXfZA6zY.TE44CJSddNrF
 AZbjsMq1t3avHOTReHX0yMonlOtWVkDrc1jeUmjT61JKK8DDrwcsEIAfkMhdiHegMp4klxnrTv_r
 kmt5r7WyLpSDnLvmHhTwLDpcNLtPF5ht6zFB7lBH0nX6Q4miE21lwDHHv4JYwfQOK8RGcoHsQTic
 ADtHk9sA4PVh1gQ6umX9jzeTsUHuv5uuDfbi11huDU3tfpyyEVeCRb0OM4Rn7O5ORghVG0pdbjYE
 yOrmeVZvnYR12BKQeOpU1nncphYcfvsW6YRP.SzD_72oDB.QQET3dHHjPH9ia6JJCBf_guNMEZ59
 GX.HzzIbLE8AUxwn4iBaf5xI8XWx4.ZlgGB9m4iNDR.oRhhgfLWjKSa4NBKGdzBzpreHgUfvgkDW
 w6TQwZma44k3SzjijqBKbNDUnJ6iQC.1MMCL5sftgrn1g3zIDzWRzRfdqzOtlZV5CQEZ79tG18ih
 W0c2LjXxdZn8gsju9AN.O52CNmid0
Received: from sonic.gate.mail.ne1.yahoo.com by sonic306.consmr.mail.ne1.yahoo.com with HTTP; Tue, 7 Jan 2020 18:40:41 +0000
Received: by smtp412.mail.ne1.yahoo.com (Oath Hermes SMTP Server) with ESMTPA ID 12c64241bbcf9d5db24824030719e0bc;
          Tue, 07 Jan 2020 18:40:38 +0000 (UTC)
Subject: Re: commit b9ef5513c99b breaks ping to ipv6 linklocal addresses on
 debian buster
To:     Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        David Ahern <dsahern@gmail.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Casey Schaufler <casey@schaufler-ca.com>
References: <90fbf526-9edc-4e38-f4f7-a4c9e4aff42f@gmail.com>
 <202001060351.0063pLqJ023952@www262.sakura.ne.jp>
 <c0c9ee18-98f6-9888-4b80-c6e3e5a4a4f4@gmail.com>
 <a2612f24-00b7-7e9e-5a9e-d0d82b22ea8e@i-love.sakura.ne.jp>
 <d8bc9dce-fba2-685b-c26a-89ef05aa004a@gmail.com>
 <153de016-8274-5d62-83fe-ce7d8218f906@i-love.sakura.ne.jp>
From:   Casey Schaufler <casey@schaufler-ca.com>
Openpgp: preference=signencrypt
Autocrypt: addr=casey@schaufler-ca.com; keydata=
 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
 abzjfg==
Message-ID: <3bafff5a-f404-e559-bfd6-bb456a923525@schaufler-ca.com>
Date:   Tue, 7 Jan 2020 10:40:38 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
MIME-Version: 1.0
In-Reply-To: <153de016-8274-5d62-83fe-ce7d8218f906@i-love.sakura.ne.jp>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Mailer: WebService/1.1.14873 hermes Apache-HttpAsyncClient/4.1.4 (Java/1.8.0_181)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Does this patch address the Debian issue? It works for the test program
and on my Fedora system.


 security/smack/smack_lsm.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
index 50c536cad85b..b0bb36419aeb 100644
--- a/security/smack/smack_lsm.c
+++ b/security/smack/smack_lsm.c
@@ -2857,7 +2857,9 @@ static int smack_socket_connect(struct socket *sock, struct sockaddr *sap,
 		rc = smack_netlabel_send(sock->sk, (struct sockaddr_in *)sap);
 		break;
 	case PF_INET6:
-		if (addrlen < SIN6_LEN_RFC2133 || sap->sa_family != AF_INET6)
+		if (addrlen < SIN6_LEN_RFC2133)
+			return 0;
+		if (sap->sa_family != AF_INET6)
 			return -EINVAL;
 #ifdef SMACK_IPV6_SECMARK_LABELING
 		rsp = smack_ipv6host_label(sip);
@@ -3694,8 +3696,9 @@ static int smack_socket_sendmsg(struct socket *sock, struct msghdr *msg,
 		break;
 #if IS_ENABLED(CONFIG_IPV6)
 	case AF_INET6:
-		if (msg->msg_namelen < SIN6_LEN_RFC2133 ||
-		    sap->sin6_family != AF_INET6)
+		if (msg->msg_namelen < SIN6_LEN_RFC2133)
+			return 0;
+		if (sap->sin6_family != AF_INET6)
 			return -EINVAL;
 #ifdef SMACK_IPV6_SECMARK_LABELING
 		rsp = smack_ipv6host_label(sap);

