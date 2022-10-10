Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 109625F9D38
	for <lists+netdev@lfdr.de>; Mon, 10 Oct 2022 13:01:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231218AbiJJLBg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Oct 2022 07:01:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231223AbiJJLBf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Oct 2022 07:01:35 -0400
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 299622C6;
        Mon, 10 Oct 2022 04:01:33 -0700 (PDT)
Received: by mail-pg1-x529.google.com with SMTP id 78so9973442pgb.13;
        Mon, 10 Oct 2022 04:01:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hkoWneOY7U3jvpgDYhqtOSOufEj1ZI44Rj90YLp9Meg=;
        b=G5DYGTYTP5HYtu+ZDcpaVP97CugNyoU/vH1l0S56RClmBtcGO2nN2oSAylhpzhY/Nb
         KcJsniVd3fcQVulNWjA63h/T0fcPv7W+Kxpl+ObZx0SIBWAfmoNLSmoJOP6a3DL28KcP
         oXdV/e04popGykVrsIz3QSC/0tnG6PlIL3NJ2m3vlu6mcAs6am3yB9Aeq/13ZoGY+uF/
         xOH6GJkATP48Tp8HiPcJu/e+ChBwOBZRj989+B6heifVy/exiHg8zrBJSrGhl7hqjzUt
         nENF3Tcn6zhcA70wpITjamZavDDTXkRGzkkDeNp7WmA/rd2HchNDIgJ5LE75OAxSnfVD
         LCIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=hkoWneOY7U3jvpgDYhqtOSOufEj1ZI44Rj90YLp9Meg=;
        b=BnIlsZLybqvq1kvNf0L4C94JRQnKcdjQkCJnDdBKIg9XOfxs/NN/ONShhCm9/RL/OT
         czqOZvDwaU3gRHETjMR62rryjKqedSLLiirt+nbDgC9tjxPY1XFg9vqdkpKfgEs3aA0d
         yNu6YYi+7+jk1/D8m1kHrtmlVuSW/H7GEtuLYVIvZjxa22pNd7ZOPabhDHa+5bfdclcS
         qy5q8czDSd5iJ27f0PoNPS5P/WxJwyqLUCCLaLaA+Vsvh+ettPmD6Dxnv9OvT6nsUHYR
         TOmgZ43IopFCXkbqokO+QYztf5nnuHqYWiegLdTUkJWjj5GKxTH1rZnxzeqcSnd/pptT
         A+LA==
X-Gm-Message-State: ACrzQf0gucdVFDvypFufTM2UzvmZYHov6YgR0gHBSJLhA2hqBClgrshF
        yCMsvuOzFZp/bkH8uWgx33WNwfZCUUc=
X-Google-Smtp-Source: AMsMyM7vhboKCvSndwJCMoHPW/feORhz5j1KGkBMRDSGZIPpdA7pxA3XsR9DndVJSk/3vH8JftvGvA==
X-Received: by 2002:a05:6a00:22cf:b0:563:744a:8951 with SMTP id f15-20020a056a0022cf00b00563744a8951mr2862840pfj.3.1665399692453;
        Mon, 10 Oct 2022 04:01:32 -0700 (PDT)
Received: from localhost.localdomain (124x33x176x97.ap124.ftth.ucom.ne.jp. [124.33.176.97])
        by smtp.gmail.com with ESMTPSA id z18-20020a170903019200b00176c6738d13sm2778905plg.169.2022.10.10.04.01.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Oct 2022 04:01:31 -0700 (PDT)
Sender: Vincent Mailhol <vincent.mailhol@gmail.com>
From:   Vincent Mailhol <mailhol.vincent@wanadoo.fr>
To:     linux-can@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        netdev@vger.kernel.org
Cc:     Marc Kleine-Budde <mkl@pengutronix.de>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Subject: [PATCH v2] iplink_can: add missing `]' of the bitrate, dbitrate and termination arrays
Date:   Mon, 10 Oct 2022 20:01:18 +0900
Message-Id: <20221010110118.66116-1-mailhol.vincent@wanadoo.fr>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221010105041.65736-1-mailhol.vincent@wanadoo.fr>
References: <20221010105041.65736-1-mailhol.vincent@wanadoo.fr>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The command "ip --details link show canX" misses the closing bracket
`]' of the bitrate, the dbitrate and the termination arrays. The --json
output is not impacted.

Change the first argument of close_json_array() from PRINT_JSON to
PRINT_ANY to fix the problem. The second argument is already set
correctly.

Fixes: 67f3c7a5cc0d ("iplink_can: use PRINT_ANY to factorize code and fix signedness")
Reported-by: Marc Kleine-Budde <mkl@pengutronix.de>
Acked-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
---
 ip/iplink_can.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/ip/iplink_can.c b/ip/iplink_can.c
index 0e670a6c..9bbe3d95 100644
--- a/ip/iplink_can.c
+++ b/ip/iplink_can.c
@@ -519,7 +519,7 @@ static void can_print_opt(struct link_util *lu, FILE *f, struct rtattr *tb[])
 				   i < bitrate_cnt - 1 ? "%8u, " : "%8u",
 				   bitrate_const[i]);
 		}
-		close_json_array(PRINT_JSON, " ]");
+		close_json_array(PRINT_ANY, " ]");
 	}
 
 	/* data bittiming is irrelevant if fixed bitrate is defined */
@@ -606,7 +606,7 @@ static void can_print_opt(struct link_util *lu, FILE *f, struct rtattr *tb[])
 				   i < dbitrate_cnt - 1 ? "%8u, " : "%8u",
 				   dbitrate_const[i]);
 		}
-		close_json_array(PRINT_JSON, " ]");
+		close_json_array(PRINT_ANY, " ]");
 	}
 
 	if (tb[IFLA_CAN_TERMINATION_CONST] && tb[IFLA_CAN_TERMINATION]) {
@@ -623,7 +623,7 @@ static void can_print_opt(struct link_util *lu, FILE *f, struct rtattr *tb[])
 			print_hu(PRINT_ANY, NULL,
 				 i < trm_cnt - 1 ? "%hu, " : "%hu",
 				 trm_const[i]);
-		close_json_array(PRINT_JSON, " ]");
+		close_json_array(PRINT_ANY, " ]");
 	}
 
 	if (tb[IFLA_CAN_CLOCK]) {
-- 
2.35.1

