Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 98F96134FC6
	for <lists+netdev@lfdr.de>; Thu,  9 Jan 2020 00:06:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727466AbgAHXGs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jan 2020 18:06:48 -0500
Received: from sonic313-15.consmr.mail.ne1.yahoo.com ([66.163.185.38]:38882
        "EHLO sonic313-15.consmr.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727224AbgAHXGs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jan 2020 18:06:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1578524806; bh=+gP0bVWOMlt6ojwE+p2V9Wm2H5HXQ4U7t+Tzz3SGMDA=; h=Subject:To:Cc:References:From:Date:In-Reply-To:From:Subject; b=g7mKtWgsSLZRgMaLqJCl7vdmBRFew00ht7CyrcQ0JsqgAee/Wz3t7dU8jvuEFI0c/ymwuTyM8uYSeHb9Y+e/zoUR32rk0EpmYAhQCy4l9fI5V+D14vxFr2/0jqyOTdPObDxMyKlihls8ccdEebX3a8EyyCyWE+tvMq1nkKzTE+1Wwm6vKY+jpBMshQWqUA3PXWPTWLWxnu2CW1mn14nF/kpAnSV3ctFu36dS66PX9lfCRqXPKVeAchy10noGdGqcXldaBC3VI7a3dhWT6rsiikPloFsM0J9qxVqVJm+LrNHrQ5IubEPo94gSeEgKnxL494bHEKTys2HRblpGdkvQJA==
X-YMail-OSG: K9sOqgYVM1kA3QcLkitA8Xq5PvNwxUpo0L7LRpSquwucLAXQt4voQfUulHw0fW0
 CNM85C9UwKaQBJq2JXmf8Y9Xjul6OE9EepH75Sp8ri5LVS3HtC0N9q6DvoSRJHOaTaZb7Fct7cry
 GSiRPXIcYzNChEqLuybXVM4FjhRTmU2k8UqYWcNlyoERdeHJUqiwh8R_XVf.rEz2Y48eCs1kBBAg
 sHFhU9iP7b0cLDqjnYgTiGtXQdrHL5sqVRBzooDv78Bmc6qYeG8UaxaNbacYn3S94fffQ3Z1QKQt
 azUBZHSBLm33NSVGtA.GE4bAl3x9j5GWBdfqCshGNiGe4n1J7c0UosDA55GVMm7A.jnjRNIE41XV
 t78ixnA4sfhCPd3rqsjugQG8lFDyD_b1BtgrsjplcfPgZ.tzGfP7dzHse7CQj_.ly9mb5NI3IvPV
 5lPvsr4RJW8_6UZSP57pn5QcenfJNDRvOUox41tnXPuQWwBVeq2LKkC6uNwIglH3z8F_501I4IBI
 b0IyKLHJ1DYFZTJy8cBvHIBEvZJ1DK5dh_kKM34H_5Lez5_NgV9FJsI3KpiWUtu0ibu52u8cEsHP
 9z09D4cDBVCNE.gsLyu6jKEGR3Cxe9YgqQDPg5MP5sRb2XdOB0YJYIvQ23sA.Yxk3ZEu5CmrCHjd
 W66c4eILl_aCWImvSLyYdgf.LBEqL7MpYFborTQoKeVzzjQ9DyErZHWymPlU1X0C4gBx9p6DKHfr
 q8wKMVcHBRynpkPBMvp2QPV68pe6Q.SsVJoctTpd3JJqB0tOsA8h5olkJAVVWP444d9lQwGgU.M3
 j5ezjz8qb3YQ5kc1TMjAA6MIF25FTIISDIuIiAdBZnzfYO.chfn012PuUncr7wAOb9PpsLaySWat
 kRb1vrYN1qQ.k6tltxZGeQ5J4WgiIfj4WavUqHveRRFUqeOQOao5EXRNQvbzDBpCmndbp_WLK0IF
 uAnHtqbMf20xdHkVegG8yiO0ijXwNAVQLeJ3fGnFh11EzM_jum.7zgLhfo.lc8z_XE4d0vDEd9Rn
 yt3K82QFW6OiYaksWlqYY1n4saC_jtolKWbXUGyX_kcE7T0EZRNjtd7I673QiJK4j5.FmN.gvFkM
 c3eUCjxkNafrAYryqc6lkzTbiOAtzhY44ugYGHnaEXonGgJjA7Fe9HqzuhRRdQwfJefAgA3dgwYL
 9Vp7crw1JU3jFxDJzv1PFuYHX5ugH9Z9xUfVR3b0DYJku4SgoTuArhFZlZpKGZMBI.UQePxv1uPr
 6fTNmCy9zP2tD2LQyRw3lMDMzSx2DZ1YWr4lI1Qqb5Zi0AM0N_LHDzY6zst_0zIW7dhPQ57dA5TU
 FMPrUSGxoqA7Alql3CIQOcpbCgNbQYv3w6KVNMZRsCHY2paqmwGa3aBgsHRwoqpaJMsC7YQljqFh
 lwWp89cDr3flLhjxSiGLaCoBpc465_N9u
Received: from sonic.gate.mail.ne1.yahoo.com by sonic313.consmr.mail.ne1.yahoo.com with HTTP; Wed, 8 Jan 2020 23:06:46 +0000
Received: by smtp423.mail.ne1.yahoo.com (Oath Hermes SMTP Server) with ESMTPA ID 7ea02ed07afee2905eb5b64ae69a292e;
          Wed, 08 Jan 2020 23:06:44 +0000 (UTC)
Subject: Re: commit b9ef5513c99b breaks ping to ipv6 linklocal addresses on
 debian buster
To:     David Ahern <dsahern@gmail.com>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Casey Schaufler <casey@schaufler-ca.com>
References: <90fbf526-9edc-4e38-f4f7-a4c9e4aff42f@gmail.com>
 <202001060351.0063pLqJ023952@www262.sakura.ne.jp>
 <c0c9ee18-98f6-9888-4b80-c6e3e5a4a4f4@gmail.com>
 <a2612f24-00b7-7e9e-5a9e-d0d82b22ea8e@i-love.sakura.ne.jp>
 <d8bc9dce-fba2-685b-c26a-89ef05aa004a@gmail.com>
 <153de016-8274-5d62-83fe-ce7d8218f906@i-love.sakura.ne.jp>
 <3bafff5a-f404-e559-bfd6-bb456a923525@schaufler-ca.com>
 <8e0fd132-4574-4ae7-45ea-88c4a2ec94b2@gmail.com>
 <a730696a-9361-d39e-5dc1-280dc8d0f052@gmail.com>
From:   Casey Schaufler <casey@schaufler-ca.com>
Openpgp: preference=signencrypt
Autocrypt: addr=casey@schaufler-ca.com; keydata=
 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
 abzjfg==
Message-ID: <44c7cd8a-7383-dada-e193-bcd79852912d@schaufler-ca.com>
Date:   Wed, 8 Jan 2020 15:06:43 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
MIME-Version: 1.0
In-Reply-To: <a730696a-9361-d39e-5dc1-280dc8d0f052@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Mailer: WebService/1.1.14873 hermes Apache-HttpAsyncClient/4.1.4 (Java/1.8.0_181)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This version should work, I think. Please verify. Thank you.

----
 security/smack/smack_lsm.c | 19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
index 50c536cad85b..75b3953212e2 100644
--- a/security/smack/smack_lsm.c
+++ b/security/smack/smack_lsm.c
@@ -2857,10 +2857,13 @@ static int smack_socket_connect(struct socket *sock, struct sockaddr *sap,
 		rc = smack_netlabel_send(sock->sk, (struct sockaddr_in *)sap);
 		break;
 	case PF_INET6:
-		if (addrlen < SIN6_LEN_RFC2133 || sap->sa_family != AF_INET6)
-			return -EINVAL;
+		if (addrlen < SIN6_LEN_RFC2133)
+			return 0;
 #ifdef SMACK_IPV6_SECMARK_LABELING
-		rsp = smack_ipv6host_label(sip);
+		if (sap->sa_family != AF_INET6)
+			rsp = NULL;
+		else
+			rsp = smack_ipv6host_label(sip);
 		if (rsp != NULL)
 			rc = smk_ipv6_check(ssp->smk_out, rsp, sip,
 						SMK_CONNECTING);
@@ -3694,11 +3697,13 @@ static int smack_socket_sendmsg(struct socket *sock, struct msghdr *msg,
 		break;
 #if IS_ENABLED(CONFIG_IPV6)
 	case AF_INET6:
-		if (msg->msg_namelen < SIN6_LEN_RFC2133 ||
-		    sap->sin6_family != AF_INET6)
-			return -EINVAL;
+		if (msg->msg_namelen < SIN6_LEN_RFC2133)
+			return 0;
 #ifdef SMACK_IPV6_SECMARK_LABELING
-		rsp = smack_ipv6host_label(sap);
+		if (sap->sin6_family != AF_INET6)
+			rsp = NULL;
+		else
+			rsp = smack_ipv6host_label(sap);
 		if (rsp != NULL)
 			rc = smk_ipv6_check(ssp->smk_out, rsp, sap,
 						SMK_CONNECTING);

