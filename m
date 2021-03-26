Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B60F34B2C3
	for <lists+netdev@lfdr.de>; Sat, 27 Mar 2021 00:19:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231751AbhCZXSw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Mar 2021 19:18:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231419AbhCZXRp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Mar 2021 19:17:45 -0400
Received: from mail-qk1-x72a.google.com (mail-qk1-x72a.google.com [IPv6:2607:f8b0:4864:20::72a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 885B2C0613B8;
        Fri, 26 Mar 2021 16:17:44 -0700 (PDT)
Received: by mail-qk1-x72a.google.com with SMTP id q3so6938734qkq.12;
        Fri, 26 Mar 2021 16:17:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=qBJWcvqdwpbCN5xw6go67HhJCwwcnjitjXqMnhiCrMQ=;
        b=V+3iLj/FDyvrrTxBaKDTOUL88OsnVah9OGn0zizwaQXGD4JnP8P8750ufDmkDyWfQi
         /I1xVkefgGSJ2pyy0NbgKsUsfX2Xm65gDZwBjitRWL/yGk41IsVrjiVXdX9DuzTqRzny
         6hVs7YVliRkQnaW1yJ3kxsbZq99zRlbG3CYnX90/vLe1PrGW/G4q8UZdjqP8PjO9WBx/
         q26matQUrGFPNoXm2yHDQb7Y+ivjhlTTAyxX8+koiPDyw+IYSJFC9+sVIFMCY1yaB/qZ
         eeSvss9iqGvGiF0sjPQgxtyEJ7VIj9xOgrNrO3R6hUQl8uXWTDXyHR/ivBGCeJHX8BSf
         RKuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=qBJWcvqdwpbCN5xw6go67HhJCwwcnjitjXqMnhiCrMQ=;
        b=n++FR+/t7j1tmuMFIegQnoT0i9uqA2nmAXsL6/BE4JV2BwdvR3kUhbFLGRSSq8DppL
         aO2Y6l4RIJyyywFwtPopRrEoc1c9ineR2n8vmWgELG9OGl90x/+uJtopAucR7OqHhiFK
         kPS+0eexWc9PVu2dAJP+0eI1tzGJkLALF5yb696PqWZZqP6BhervXLR5ekWjIVUjha3z
         stvpBRErht4gdapEqV2ZY9kDyShdMyWDzGdNYxPd11/chEOe+h4d66A1gcpy5P5J/dwB
         dU9/bc2NKYR/x/dYeCbZRAnxN1GzmaS/6HDrvhsOKEgARZBpYpbmAPwaZ8V88lLqT+Yx
         cHkw==
X-Gm-Message-State: AOAM531yDi5dCTpKMRgt6QC1D6hU1yXgk5X0qQ5f/lgOk4XjPs/R+qTB
        TuMh9s2ARt5sV0/e7WNrc7M=
X-Google-Smtp-Source: ABdhPJwqIfR1sHOO2sKnAqhyAqDwPT0zBUolkNt3RnE84c4dvWSu3Y/IdAAo/ZqTui+TDeLZSCgNgw==
X-Received: by 2002:a37:9f4e:: with SMTP id i75mr15750577qke.283.1616800663863;
        Fri, 26 Mar 2021 16:17:43 -0700 (PDT)
Received: from localhost.localdomain ([156.146.58.30])
        by smtp.gmail.com with ESMTPSA id w78sm7960414qkb.11.2021.03.26.16.17.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Mar 2021 16:17:43 -0700 (PDT)
From:   Bhaskar Chowdhury <unixbhaskar@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Bhaskar Chowdhury <unixbhaskar@gmail.com>, rdunlap@infradead.org
Subject: [PATCH 07/19] sm_statefuns.c: Mundane spello fixes
Date:   Sat, 27 Mar 2021 04:43:00 +0530
Message-Id: <9939421dbe42b24f23684666b5d7923937704087.1616797633.git.unixbhaskar@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <cover.1616797633.git.unixbhaskar@gmail.com>
References: <cover.1616797633.git.unixbhaskar@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


s/simulataneous/simultaneous/ .....three different places.
s/association/association/
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

