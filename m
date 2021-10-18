Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69734431321
	for <lists+netdev@lfdr.de>; Mon, 18 Oct 2021 11:18:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231375AbhJRJUP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Oct 2021 05:20:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231230AbhJRJUO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Oct 2021 05:20:14 -0400
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65ED6C06161C;
        Mon, 18 Oct 2021 02:18:03 -0700 (PDT)
Received: by mail-pg1-x531.google.com with SMTP id t7so1048160pgl.9;
        Mon, 18 Oct 2021 02:18:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=TL8MKdaHHltkSLJJhEgpOYC4/+7FPpkVJIhEqgGDpIo=;
        b=FDma6FSH9LVf6Tx0LTXBlp+fTXB+WsjAO5X2hE3fxAwi0EqpBVbbEzdl7jKBLJPiSp
         S3httpAytp70wJxB9hInu3xbXytyCE3KKZGuAy6QXqoVZTLvzr/5WJqZzCtuHXS1ETyt
         lEl8cuYbT8XaERbHySMN/UhA89OsxtjWzAaq8oju4RjBtWMaFhSq0ZYnOvS5S1EO0DY8
         JBej4E6yHHVrHKUK1DHtXfsaRCZfHY5EkwYgUGYBgw3Jm/3qSt7SeBVekiQS4VNX/0ax
         MlSdRnVGENCcL38Wbdzh0FS3l5X5GyDNkX0oQeBuqBXGsl7VZYbzsbaw4hQgjtJWeIL0
         Q3qQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=TL8MKdaHHltkSLJJhEgpOYC4/+7FPpkVJIhEqgGDpIo=;
        b=GuSdyMKO2d8Vk6wFKYtb0raSAc3xzPufb82a9uEx2rl+7ojb+oX2jUBLLNWMJsdNhN
         brAuoFftqOMXXEY3oXSxkAD0/EZAFf+im8KhNeJhMjlT8gaNyu6y1L+oqJByJNKd4Bny
         rDjC9VI6sIViWKyauRYKBvwYf2B/7YeNf3QoXIy3XDWgIIDdivOgtZj493ErnuVTWndL
         xF+csXrhGk7qc+bmP8fZkMU4yqWynQq/CdoKK75Zc8UfE5AglDVyCJ1xcqLI+zwHBAG3
         Y4Tg3kpSiSKqKhgXabziDLHIyhuwNpw34JMFrKbYbgRv8kuUXeuADVvu2iJMVRoggSdh
         Vt/A==
X-Gm-Message-State: AOAM530dqyiZw3dhlkEZK+ZdvdWuCYFVlXeClhGviuoyvV3vCvKdTQtp
        ozokbM51FZaXRiZ4Nf14Dj5He7m0U94=
X-Google-Smtp-Source: ABdhPJxrqx37vnGZwzi86d06c52M+BYYUENbKxHgRLWQxR9hkllJAe8xAQQIWtHKgmVDPT85Y6dz0Q==
X-Received: by 2002:a63:3e84:: with SMTP id l126mr18260763pga.55.1634548683006;
        Mon, 18 Oct 2021 02:18:03 -0700 (PDT)
Received: from localhost.localdomain ([193.203.214.57])
        by smtp.gmail.com with ESMTPSA id s30sm11644608pgn.38.2021.10.18.02.18.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Oct 2021 02:18:02 -0700 (PDT)
From:   luo penghao <cgel.zte@gmail.com>
X-Google-Original-From: luo penghao <luo.penghao@zte.com.cn>
To:     Steffen Klassert <steffen.klassert@secunet.com>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, penghao luo <luo.penghao@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>
Subject: [PATCH linux-next] xfrm: Remove redundant fields
Date:   Mon, 18 Oct 2021 09:17:58 +0000
Message-Id: <20211018091758.858899-1-luo.penghao@zte.com.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: penghao luo <luo.penghao@zte.com.cn>

the variable err is not necessary in such places. It should be revmoved
for the simplicity of the code.

The clang_analyzer complains as follows:

net/xfrm/xfrm_input.c:530: warning:

Although the value stored to 'err' is used in the enclosing expression,
the value is never actually read from 'err'.

Reported-by: Zeal Robot <zealci@zte.com.cn>
Signed-off-by: penghao luo <luo.penghao@zte.com.cn>
---
 net/xfrm/xfrm_input.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/xfrm/xfrm_input.c b/net/xfrm/xfrm_input.c
index 3df0861..ff34667 100644
--- a/net/xfrm/xfrm_input.c
+++ b/net/xfrm/xfrm_input.c
@@ -530,7 +530,7 @@ int xfrm_input(struct sk_buff *skb, int nexthdr, __be32 spi, int encap_type)
 				goto drop;
 			}
 
-			if ((err = xfrm_parse_spi(skb, nexthdr, &spi, &seq)) != 0) {
+			if ((xfrm_parse_spi(skb, nexthdr, &spi, &seq)) != 0) {
 				XFRM_INC_STATS(net, LINUX_MIB_XFRMINHDRERROR);
 				goto drop;
 			}
@@ -560,7 +560,7 @@ int xfrm_input(struct sk_buff *skb, int nexthdr, __be32 spi, int encap_type)
 	}
 
 	seq = 0;
-	if (!spi && (err = xfrm_parse_spi(skb, nexthdr, &spi, &seq)) != 0) {
+	if (!spi && (xfrm_parse_spi(skb, nexthdr, &spi, &seq)) != 0) {
 		secpath_reset(skb);
 		XFRM_INC_STATS(net, LINUX_MIB_XFRMINHDRERROR);
 		goto drop;
-- 
2.15.2


