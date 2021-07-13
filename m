Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9286F3C77E3
	for <lists+netdev@lfdr.de>; Tue, 13 Jul 2021 22:21:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234957AbhGMUYj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Jul 2021 16:24:39 -0400
Received: from mx.ucr.edu ([138.23.62.67]:35430 "EHLO mx5.ucr.edu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234394AbhGMUYi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 13 Jul 2021 16:24:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=ucr.edu; i=@ucr.edu; q=dns/txt; s=selector3;
  t=1626207708; x=1657743708;
  h=from:subject:to:cc:message-id:date:mime-version;
  bh=WzlJ7A345q6jOqsIN3o7gRqpRPe8snJXGvo3AhrFKEE=;
  b=ZKBYC29o6n5JRbXBro1AsnhwF5OFTNkLSh3ZezFrLElVcmiUngYGxNBF
   dPTu34GPoSezUWk/v4hO9ClXY1zGIo21qwMXBhXxZs0EV7Pba9ujI7uP1
   IM8NP0r5UEngdAiq+BVqFy9+ceWCWnkJ9KbVsKwkP9hddoKepKgRd0bee
   pmVST09foKPM9ykMEmAATaDcndgRI4WmYPpRvFtqN8vziPgytP/cFUQGd
   rIfzaD4VOjHkqZNTVFG3Vn+MVJxLYs22uhkkXToqGrk8/2jxavfFofLwN
   bUPyIexri2JOh8fL9kO4wNU/t5ubQVPdU8EhhvfsUE1KJnx4+jWfJk/Zp
   g==;
IronPort-SDR: ihOqka+HkNnMhm7u7HLUuVQfwt+f3vWxk94U0eyp+A4+rG0ywX635aiF24UhGCLt9euewlxTNx
 gDFCnjUOLANOtw8QhszJGt3vZ9oPWlNh76xyKkIy3EQJ2lgee9lZI+rRyDRwwR2X9Nwiv/o8RI
 QOPKDlHsgdMYXgtDolJqdXhOqdezLStk8WX2Tr2d/VEl98GtJ82BJ+N/6ei2np/z9H5VNV6A22
 quISA4HQiLMzPYn0HjUP4XXv049tgPYFDR7tmHRQ41mQ9bhqmQ1VpGJ3OsvZJd8ku8reS5Z4Y6
 LNY=
X-IPAS-Result: =?us-ascii?q?A2E/BAAT9e1ghkXYVdFaHgEBCxIMgg4LgVOCJmuESJEwL?=
 =?us-ascii?q?YQZkgWHOwIJAQEBDQEBPwIEAQGEVAKCeAIlNwYOAgQBAQEBAwIDAQEBAQUBA?=
 =?us-ascii?q?QYBAQEBAQEFBAEBAhABAQEBbIUvRoI4IoN0AQIBFREEUiwDAQIrAgQyAQUBF?=
 =?us-ascii?q?BsGAgEBHoJPAYMHAQSbOIEEPYo4en8zgQGEZ4NRAQkNgVMQCQEIgSiOEoIpg?=
 =?us-ascii?q?RUnDIEIgiiEWwmCd4JkBIMWAYENFIJSQFMBAQGQVI1aDVCadoIPAQYCgwoch?=
 =?us-ascii?q?TiDBZVjBhQmg2ORWEKQXC2tBogmhTACCgcGECOBToF/MxolgWyBS1AZDohsh?=
 =?us-ascii?q?T8NCY5MITI4AgYKAQEDCXyGfQEB?=
IronPort-PHdr: A9a23:Av+DRRwSmDhJnmTXCzIPylBlVkEcU1XcAAcZ59Idhq5Udez7ptK+Z
 hSZvKgm3AaBHd2Cra4d2qyO6+GocFdDyK7JiGoFfp1IWk1NouQttCtkPvS4D1bmJuXhdS0wE
 ZcKflZk+3amLRodQ56mNBXdrXKo8DEdBAj0OxZrKeTpAI7SiNm82/yv95HJbAhEmiaxbalvI
 Bi2ognctdQaipZmJqot1xfFuHRFd/lSyG9yOV6fgxPw7dqs8ZB+9Chdp+gv/NNaX6XgeKQ4Q
 71YDDA4PG0w+cbmqxrNQxaR63UFSmkZnQZGDAbD7BHhQ5f+qTD6ufZn2CmbJsL5U7Y5Uim/4
 qhxSR/ojCAHNyMl8GzSl8d9gr5XrA6nqhdixYPffYObO+dkfq7Ffd0UWHRPUMVfWSNPDYyzc
 5ACD+8dMetCtYTxu1UDoBm4CAKxBO3v0DhIhnru0KI70uQuCwbG0xAgH90QtnTfsdb6NKAPU
 euoy6TJwjTCb/RL2Tvh9YTFcAssoeyQUrJqa8be11QgFx7cg1iWtIfqMC+b2P4XvGiH8+pvS
 /ivi2g/pgx+rTWixdsgh5XHi4wVyF3J8SF0zZg3KNO4SEN2f9GqHYZMuiyaKoZ7QN4vTW92t
 Sok1LALpIK3cDUXxZknyBPSbeGMfYaP4hLmTumRIDF4iWp5eLKlmha971KsyuviWcmo1ltBs
 ylLksHUu3wTyxDe7tKLR/h980u7xzqDygHe5vtFLE0wjabXNZ8szqIsmpcWsEnMAi/7lFjzg
 aKUbEop+Pan5uH6bbn6qJKRNYp5hw/iPaktlMGyBPk0PwoPUmSG/Omx1qHv8lHlT7hPk/E5j
 KrUv4vcKM8GvKC2GRVV3Zwm6xunCjem18kXkmcfIVJefRKHk5DpO1bTIPDkFfu/g0qjkDNsx
 /3eO73uGJTNLnzanLf5f7Zx9ldQyAQywN1b/Z5UBbYBIPX8Wk/1qtPUFAM2Mwuxw+r/CdV90
 J0RWX6XD6OHLK/ftUWE6+EvLuWWeoMZpTfwJ+Ik6vPqlXM5nEUSfait3ZsZcnC4GfFmLl2WY
 HvthdcBDHsGshc8QeHxlV2NTSRTa2ysUK0h+zE3EJimApvbRoCxnLyB2z+2HptIaWBaF1+DD
 2noep6aW/cDdi2SONVtkj8aWri7TY8uyxWuuBX9y7p9IeqHshEf4J352ddd5PfUnBF0/jtxX
 OqH1GTYf2B9mWgISjl+7qdi6Rht2FCeifEnq+FTD5pe6+4fAVRyDoLV0+EvU4O6YQnGZNrcE
 D6b
IronPort-HdrOrdr: A9a23:lr/g76AyYGXF39PlHemf55DYdb4zR+YMi2TDGXoBLSC9Afbo7f
 xG/c5rriMc5wxhPk3I9erwW5VoIkmsjaKdg7NhWotKNTOO0ADJEGgL1+rfKlbbak/DH4BmpM
 JdmuRFeaTN5JtB4PoSIjPTLz/t+ra6GWmT6Ynj80s=
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-AV: E=Sophos;i="5.84,237,1620716400"; 
   d="scan'208";a="225634630"
Received: from mail-pj1-f69.google.com ([209.85.216.69])
  by smtpmx5.ucr.edu with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 13 Jul 2021 13:21:47 -0700
Received: by mail-pj1-f69.google.com with SMTP id p22-20020a17090a9316b029016a0aced749so5482135pjo.9
        for <netdev@vger.kernel.org>; Tue, 13 Jul 2021 13:21:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:subject:to:cc:message-id:date:user-agent
         :mime-version:content-language;
        bh=fmIqQ9Udybx7MUcIYh78Frxz8dxd7XVLif52k+yQNpI=;
        b=fOQNuTd5mgDG8MjRk/60zCY+3caDZOc4ZENvkIlOOYic8GP6R8ghW4oE9yZAPa3PaG
         pJmf6upIHdbMKvawmJ2Awu6LnepA0SIHzOHHgLModB3hdHDoV5RlQueQocPs1Xi6XTYO
         vOpz35IIwnJwYiUNnAVHyIR2LBNCiaLwDmGIj1XScVOavTwRgL9dR1qKangia6lF4sAS
         KPJSu/+GuwjL4deYupQR+cv9QZL3pn3ZwxCCwG1faLXNQ5zjJV6IzsW0O2VHM/iTfnym
         7fwvtqcnwL7dpjoLfPa5tASFvviIe2PDZCyH81kyAEHkDpQS9w7R6KymWyQmOerBGGgt
         O+gg==
X-Gm-Message-State: AOAM530Snm3ktcu9obcPQf9O2hUfRtsR9P9YUR5wfvcD5oMlM3kMiJA/
        dH2BOZB/fYFJX40Gxw066trqyrgbPy6UHFOfSPJLPekIsYTDO+nwaWXsWMI0lr6ZRX12G6tLMKt
        nb/qjoKNb3IlntZ+8JA==
X-Received: by 2002:a17:902:b203:b029:127:16e0:286a with SMTP id t3-20020a170902b203b029012716e0286amr4927453plr.0.1626207706951;
        Tue, 13 Jul 2021 13:21:46 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwcvyTGQYVGPKVhWVZ/ghKGrI2DXRLJyl0cZhoFvNid6Pq+GmY5oD8zqIiBMbuCb8Y91DNMIA==
X-Received: by 2002:a17:902:b203:b029:127:16e0:286a with SMTP id t3-20020a170902b203b029012716e0286amr4927432plr.0.1626207706629;
        Tue, 13 Jul 2021 13:21:46 -0700 (PDT)
Received: from ?IPv6:2600:6c51:7a7e:d037:3c83:1761:70cc:1e8b? ([2600:6c51:7a7e:d037:3c83:1761:70cc:1e8b])
        by smtp.gmail.com with ESMTPSA id u16sm15204pfh.205.2021.07.13.13.21.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 13 Jul 2021 13:21:46 -0700 (PDT)
From:   Xiaochen Zou <xzou017@ucr.edu>
Subject: [PATCH 0/1] can: fix a potential UAF access in
 j1939_session_deactivate()
To:     greg@kroah.com
Cc:     stable@vger.kernel.org, netdev@vger.kernel.org,
        linux-can@vger.kernel.org
Message-ID: <aa64ef28-35d8-9deb-2756-8080296b7e3e@ucr.edu>
Date:   Tue, 13 Jul 2021 13:21:44 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------9FC6497483A83D5ACDE3F243"
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a multi-part message in MIME format.
--------------9FC6497483A83D5ACDE3F243
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit


Xiaochen Zou (1):
  can: fix a potential UAF access in j1939_session_deactivate(). Both
    session and session->priv may be freed in
    j1939_session_deactivate_locked(). It leads to potential UAF read
    and write in j1939_session_list_unlock(). The free chain is

j1939_session_deactivate_locked()->j1939_session_put()->__j1939_session_release()->j1939_session_destroy().
    To fix this bug, I moved j1939_session_put() behind
    j1939_session_deactivate_locked(), and guarded it with a check of
    active since the session would be freed only if active is true.

 net/can/j1939/transport.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

-- 
2.17.1

From 9c4733d093e05db22eb89825579c83e020c3c1a6 Mon Sep 17 00:00:00 2001
From: Xiaochen Zou <xzou017@ucr.edu>
Date: Tue, 13 Jul 2021 13:15:59 -0700
Subject: [PATCH 1/1] can: fix a potential UAF access in
 j1939_session_deactivate().
To: greg@kroah.com
Cc: stable@vger.kernel.org,netdev@vger.kernel.org,linux-can@vger.kernel.org
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="------------2.17.1"

This is a multi-part message in MIME format.

--------------9FC6497483A83D5ACDE3F243
Content-Type: text/plain; charset=UTF-8;
 name="Attached Message Part"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="Attached Message Part"

Qm90aCBzZXNzaW9uIGFuZCBzZXNzaW9uLT5wcml2IG1heSBiZSBmcmVlZCBpbg0KajE5Mzlf
c2Vzc2lvbl9kZWFjdGl2YXRlX2xvY2tlZCgpLiBJdCBsZWFkcyB0byBwb3RlbnRpYWwgVUFG
IHJlYWQgYW5kIHdyaXRlDQppbiBqMTkzOV9zZXNzaW9uX2xpc3RfdW5sb2NrKCkuIFRoZSBm
cmVlIGNoYWluIGlzDQpqMTkzOV9zZXNzaW9uX2RlYWN0aXZhdGVfbG9ja2VkKCktPmoxOTM5
X3Nlc3Npb25fcHV0KCktPl9fajE5Mzlfc2Vzc2lvbl9yZWxlYXNlKCktPmoxOTM5X3Nlc3Np
b25fZGVzdHJveSgpLg0KVG8gZml4IHRoaXMgYnVnLCBJIG1vdmVkIGoxOTM5X3Nlc3Npb25f
cHV0KCkgYmVoaW5kDQpqMTkzOV9zZXNzaW9uX2RlYWN0aXZhdGVfbG9ja2VkKCksIGFuZCBn
dWFyZGVkIGl0IHdpdGggYSBjaGVjayBvZiBhY3RpdmUNCnNpbmNlIHRoZSBzZXNzaW9uIHdv
dWxkIGJlIGZyZWVkIG9ubHkgaWYgYWN0aXZlIGlzIHRydWUuDQogDQpTaWduZWQtb2ZmLWJ5
OiBYaWFvY2hlbiBab3UgPHh6b3UwMTdAdWNyLmVkdT4NCi0tLQ0KIG5ldC9jYW4vajE5Mzkv
dHJhbnNwb3J0LmMgfCA4ICsrKysrKy0tDQogMSBmaWxlIGNoYW5nZWQsIDYgaW5zZXJ0aW9u
cygrKSwgMiBkZWxldGlvbnMoLSkNCg0KDQo=
--------------9FC6497483A83D5ACDE3F243
Content-Type: text/x-patch; charset=UTF-8;
 name="0001-can-fix-a-potential-UAF-access-in-j1939_session_deac.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0001-can-fix-a-potential-UAF-access-in-j1939_session_deac.pa";
 filename*1="tch"

diff --git a/net/can/j1939/transport.c b/net/can/j1939/transport.c
index c3946c355882..c64bd5e8118a 100644
--- a/net/can/j1939/transport.c
+++ b/net/can/j1939/transport.c
@@ -1067,7 +1067,6 @@ static bool j1939_session_deactivate_locked(struct j1939_session *session)
 
 		list_del_init(&session->active_session_list_entry);
 		session->state = J1939_SESSION_DONE;
-		j1939_session_put(session);
 	}
 
 	return active;
@@ -1080,6 +1079,8 @@ static bool j1939_session_deactivate(struct j1939_session *session)
 	j1939_session_list_lock(session->priv);
 	active = j1939_session_deactivate_locked(session);
 	j1939_session_list_unlock(session->priv);
+	if (active)
+		j1939_session_put(session);
 
 	return active;
 }
@@ -2127,6 +2128,7 @@ void j1939_simple_recv(struct j1939_priv *priv, struct sk_buff *skb)
 int j1939_cancel_active_session(struct j1939_priv *priv, struct sock *sk)
 {
 	struct j1939_session *session, *saved;
+	bool active;
 
 	netdev_dbg(priv->ndev, "%s, sk: %p\n", __func__, sk);
 	j1939_session_list_lock(priv);
@@ -2140,7 +2142,9 @@ int j1939_cancel_active_session(struct j1939_priv *priv, struct sock *sk)
 				j1939_session_put(session);
 
 			session->err = ESHUTDOWN;
-			j1939_session_deactivate_locked(session);
+			active = j1939_session_deactivate_locked(session);
+			if (active)
+				j1939_session_put(session);
 		}
 	}
 	j1939_session_list_unlock(priv);


--------------9FC6497483A83D5ACDE3F243--
