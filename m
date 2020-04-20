Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68A171B146E
	for <lists+netdev@lfdr.de>; Mon, 20 Apr 2020 20:25:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726905AbgDTSZT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Apr 2020 14:25:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726021AbgDTSZT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Apr 2020 14:25:19 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30BE2C061A0C
        for <netdev@vger.kernel.org>; Mon, 20 Apr 2020 11:25:19 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id a32so224237pje.5
        for <netdev@vger.kernel.org>; Mon, 20 Apr 2020 11:25:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=0ByFAymEmjbb2sAEloaG2LX/Jp4mza/WuuwAmbbqqrk=;
        b=dPVYhqdc+eJ+l29aElrNxgMjUB3ctP2AuqddUU8HqBzdhGjlSgxDseRmhmIpQswNli
         hERpBAJW0klF0OFfmHd+sN6f6FG+9ExoxvSm9lvt6Bp7Ae3JPD5zvxIdUK93zGJ/nhi2
         uW2zbUdv75sXBbpx+ZfP+iHm6wUVWFBImzbjA66tMG3ieSxXNVSJj95ZVDEhVkTtAYKH
         90pPDi+MoQ+89NP63FyLuskULPdUrEkvbXIr0wd+bqBbiNjo4eYoULn0e4Z7xM0zUk6x
         UTzA1YKR6/k731+jO7vOIbo7OG2a4TTPz85Xs/EqvYFdVvwVtiFm31MliScwecqT9XGT
         soLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=0ByFAymEmjbb2sAEloaG2LX/Jp4mza/WuuwAmbbqqrk=;
        b=dI1VGraeDExy9dfGb/vl4iZfY2hCGYR/4ikt5xew57Fa93d8DHwsgwHp5PR8Wj/sJf
         1f19hPxWOvFWNR/PbjDs/FsZDLP2qiginCvNPfZTw67ZbmoWcZNraOXy15Bhflq+FN4e
         IwEW/8ohk45OoF79xk9KC4qRB0hRe0qFeFw91ePrP77y95Rouj3QyEdz0B1CKfqwYO+7
         m9WJRWP2ZCFvuWjtMSJ3FZRX6yrj3a0abWA/kmM6IXfoD3x1zeWsLCFwkN4uVyWQeGLB
         qaB0X9n+7Eq3cdH6fARavSAauSJPpP+sTcIk4krM8TdwofSfq/+ebx6vHBZIFl7rUik/
         w8GQ==
X-Gm-Message-State: AGi0PuaLAE8eyvLWUV3HEGrIJgD3JZUJQxWSucGfot/44IVyt60EAgvG
        TZz+pkvHXlrFiYXl2q/rgao=
X-Google-Smtp-Source: APiQypKZZS88vPRrijpuUky5uiwm7Gzq7OObx/DYlhO3NtIRdliasoyAxIfCILVaaftZUwok6j4VOg==
X-Received: by 2002:a17:90a:630b:: with SMTP id e11mr761055pjj.167.1587407118645;
        Mon, 20 Apr 2020 11:25:18 -0700 (PDT)
Received: from athina.mtv.corp.google.com ([2620:15c:211:0:c786:d9fd:ab91:6283])
        by smtp.gmail.com with ESMTPSA id c1sm169974pfc.94.2020.04.20.11.25.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Apr 2020 11:25:17 -0700 (PDT)
From:   =?UTF-8?q?Maciej=20=C5=BBenczykowski?= <zenczykowski@gmail.com>
To:     =?UTF-8?q?Maciej=20=C5=BBenczykowski?= <maze@google.com>,
        "David S . Miller" <davem@davemloft.net>
Cc:     Linux Network Development Mailing List <netdev@vger.kernel.org>,
        Erik Kline <ek@google.com>, Jen Linkova <furry@google.com>,
        Lorenzo Colitti <lorenzo@google.com>,
        Michael Haro <mharo@google.com>
Subject: [PATCH] ipv6: ndisc: RFC-ietf-6man-ra-pref64-09 is now published as RFC8781
Date:   Mon, 20 Apr 2020 11:25:07 -0700
Message-Id: <20200420182507.110436-1-zenczykowski@gmail.com>
X-Mailer: git-send-email 2.26.1.301.g55bc3eb7cb9-goog
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maciej Żenczykowski <maze@google.com>

See:
  https://www.rfc-editor.org/authors/rfc8781.txt

Cc: Erik Kline <ek@google.com>
Cc: Jen Linkova <furry@google.com>
Cc: Lorenzo Colitti <lorenzo@google.com>
Cc: Michael Haro <mharo@google.com>
Signed-off-by: Maciej Żenczykowski <maze@google.com>
Fixes: c24a77edc9a7 ("ipv6: ndisc: add support for 'PREF64' dns64 prefix identifier")
---
 include/net/ndisc.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/net/ndisc.h b/include/net/ndisc.h
index 7d107113f988..9205a76d967a 100644
--- a/include/net/ndisc.h
+++ b/include/net/ndisc.h
@@ -41,7 +41,7 @@ enum {
 	ND_OPT_DNSSL = 31,		/* RFC6106 */
 	ND_OPT_6CO = 34,		/* RFC6775 */
 	ND_OPT_CAPTIVE_PORTAL = 37,	/* RFC7710 */
-	ND_OPT_PREF64 = 38,		/* RFC-ietf-6man-ra-pref64-09 */
+	ND_OPT_PREF64 = 38,		/* RFC8781 */
 	__ND_OPT_MAX
 };
 
-- 
2.26.1.301.g55bc3eb7cb9-goog

