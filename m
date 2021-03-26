Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C30F34B2B1
	for <lists+netdev@lfdr.de>; Sat, 27 Mar 2021 00:18:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231522AbhCZXRi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Mar 2021 19:17:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231420AbhCZXRR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Mar 2021 19:17:17 -0400
Received: from mail-qk1-x733.google.com (mail-qk1-x733.google.com [IPv6:2607:f8b0:4864:20::733])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFDD8C0613AA;
        Fri, 26 Mar 2021 16:17:14 -0700 (PDT)
Received: by mail-qk1-x733.google.com with SMTP id q3so6937818qkq.12;
        Fri, 26 Mar 2021 16:17:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=BXMr6QKv1x/w9vef6A424NJEEK5cW+MFw53/3UbGokU=;
        b=IDwfm5M7H14p/NvE3G79wtza7IrNeMxF7LSqitB7V/nDccGlM+3PE+bimxV1qE4wXV
         TdyUVWzDhHa8G06m1Qo+yW9OeSrpIY6WY6azm2alvZmG+WcTyn4pro3g4V48CykKTJAf
         33k2VBShDrVFwnOWvL1kpO9Vi4N6XXvJ2so9QKYw4N2VIlXWFu4hxlw3Ib21edSheggM
         qQch0faaxvA13T0BQeVrCud3+LrxiZ5+m3JzbKjLobW+emqWvYUsLXSe6Uo9V8SrVSyf
         4GKE8rpVAW1rSvfRtSuzpD0DsacAhB9ENuOTpuxAiWbUlBx49oPynAOvTRK+Zas1fWCX
         u80A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=BXMr6QKv1x/w9vef6A424NJEEK5cW+MFw53/3UbGokU=;
        b=g5q9swKBlCyUplBsBuCaAXhHM5kZ9McY0DdOLl/Apa/RBIjFxn5wY3DyZmpSkQtzQD
         sENuVFqMIn5WcrUdAMD2FpCEXIe+8AEteGQxAU+UvL3BwHAvBiUkVZ8QICrrwRHJKmox
         X/1vwAe/MuCtcTiA9rs7Gxw4QiA8zu9Otxpqoa2lDOzRTeahGZrdRr1MgReu8VuFOxG8
         YZ8Ow9M6+3y99c/dmVdkZPRnXp2Yyce9e1tvyyWBR3JyCHXs/7gihxKLdT9vQXrAARma
         LIuxJh0tzLSWe6BfAQaQvPIAAgoAW1zOEbq0AGFlmH/kV7sGQ/6ZOuS4mmflFmQvAxBL
         UcBQ==
X-Gm-Message-State: AOAM531y95APvATA13RIGsXnl97wUZtfZcEur7NJVKIY211nBXSc+XOQ
        5Gj4v6LwO9CWxx5j8Z471h0=
X-Google-Smtp-Source: ABdhPJxZR52VQtsceAP9awiKo9mT6VODi5xw9/bccEudTXZuwvvEzRj19KRWW10RGfXAwqO/GAXqUQ==
X-Received: by 2002:a37:6888:: with SMTP id d130mr15155990qkc.368.1616800634046;
        Fri, 26 Mar 2021 16:17:14 -0700 (PDT)
Received: from localhost.localdomain ([156.146.58.30])
        by smtp.gmail.com with ESMTPSA id w78sm7960414qkb.11.2021.03.26.16.17.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Mar 2021 16:17:13 -0700 (PDT)
From:   Bhaskar Chowdhury <unixbhaskar@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Bhaskar Chowdhury <unixbhaskar@gmail.com>, rdunlap@infradead.org
Subject: [PATCH] sm_statefuns.c: Mundane spello fixes
Date:   Sat, 27 Mar 2021 04:42:52 +0530
Message-Id: <20210326231608.24407-17-unixbhaskar@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <cover.1616797633.git.unixbhaskar@gmail.com>
References: <cover.1616797633.git.unixbhaskar@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


s/simulataneous/simultaneous/    ....in three dirrent places.
s/tempory/temporary/
s/interpeter/interpreter/

Signed-off-by: Bhaskar Chowdhury <unixbhaskar@gmail.com>
---
 net/sctp/sm_statefuns.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/net/sctp/sm_statefuns.c b/net/sctp/sm_statefuns.c
index af2b7041fa4e..7632714c1e5b 100644
--- a/net/sctp/sm_statefuns.c
+++ b/net/sctp/sm_statefuns.c
@@ -1452,7 +1452,7 @@ static char sctp_tietags_compare(struct sctp_association *new_asoc,
 	return 'E';
 }

-/* Common helper routine for both duplicate and simulataneous INIT
+/* Common helper routine for both duplicate and simultaneous INIT
  * chunk handling.
  */
 static enum sctp_disposition sctp_sf_do_unexpected_init(
@@ -1685,7 +1685,7 @@ enum sctp_disposition sctp_sf_do_5_2_1_siminit(
 					void *arg,
 					struct sctp_cmd_seq *commands)
 {
-	/* Call helper to do the real work for both simulataneous and
+	/* Call helper to do the real work for both simultaneous and
 	 * duplicate INIT chunk handling.
 	 */
 	return sctp_sf_do_unexpected_init(net, ep, asoc, type, arg, commands);
@@ -1740,7 +1740,7 @@ enum sctp_disposition sctp_sf_do_5_2_2_dupinit(
 					void *arg,
 					struct sctp_cmd_seq *commands)
 {
-	/* Call helper to do the real work for both simulataneous and
+	/* Call helper to do the real work for both simultaneous and
 	 * duplicate INIT chunk handling.
 	 */
 	return sctp_sf_do_unexpected_init(net, ep, asoc, type, arg, commands);
@@ -2221,11 +2221,11 @@ enum sctp_disposition sctp_sf_do_5_2_4_dupcook(
 		break;
 	}

-	/* Delete the tempory new association. */
+	/* Delete the temporary new association. */
 	sctp_add_cmd_sf(commands, SCTP_CMD_SET_ASOC, SCTP_ASOC(new_asoc));
 	sctp_add_cmd_sf(commands, SCTP_CMD_DELETE_TCB, SCTP_NULL());

-	/* Restore association pointer to provide SCTP command interpeter
+	/* Restore association pointer to provide SCTP command interpreter
 	 * with a valid context in case it needs to manipulate
 	 * the queues */
 	sctp_add_cmd_sf(commands, SCTP_CMD_SET_ASOC,
--
2.26.2

