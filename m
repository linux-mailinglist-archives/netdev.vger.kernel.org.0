Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4EDAE5FA00A
	for <lists+netdev@lfdr.de>; Mon, 10 Oct 2022 16:17:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229778AbiJJORC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Oct 2022 10:17:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229596AbiJJORB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Oct 2022 10:17:01 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B663371735;
        Mon, 10 Oct 2022 07:16:59 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id b2so10488683plc.7;
        Mon, 10 Oct 2022 07:16:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cP3630Ux0R29NjXAE8Q+cQQu2TnyroFaNlYUsA7faec=;
        b=KLKEFQ4RJhqsz0sH4fEBvcRr+wJoBwL2Zuy//el4serLyxXBel/VziaA5M6qzDCDLu
         sLYYJNqWxrjrJn1fIdNxd9aI6eaS2ZhzLZueXP71rLVx3kBsurg5VqtEQydgHOL9mSMU
         vStXHAm/F2oZuiuNqjt7CcsrZg8rqoY9t/8TClEWMfHAXqWxDrWchX/MA0+t0PTXoB+O
         eA/TQgaapaonVRI0BJWq3zEoi3t3k9dpDj47S6F4U/hCK6EBpW0aRU1UvAun3WQTNvGN
         6JU7NLg882p/O1Pa29Xek6hgisRXjsfUTfDAmmH2282KTbEf0ABr+ipNWQA3u82WKUzn
         p5Ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=cP3630Ux0R29NjXAE8Q+cQQu2TnyroFaNlYUsA7faec=;
        b=pgRQ80RaC7Vv4yuyr9FY7cwcdMYk6tp+CLevFfcihkoMZdiQZhHK1iLFwl3zJJ1XJj
         8A94+Gp9aui4p01tRN7aRXZx/MbV/vhbA/hml3W9YrnWmecFoj8VernJ99I/AFDuw+nK
         cEDJEg2k1LWHFzjFbJGEo5769tMGw/Jm/CTCzW/XErwxYK6DS4t7g2/F3CvCq9DKuMWS
         b7c+Xepp9W3Uc5zNvLP0UVv9620kqbgcCmTXHlK6uhm6OicbqM4McyzzC3Ppn9RUiHdo
         g64vcfEYoCbqd6T2T6chWB80aD0zykXv5Czh2VB2jChVTFdNof2MklE1f8gydgGDrQ0B
         FqGg==
X-Gm-Message-State: ACrzQf0A5zxybsFXhxp9Q6IpIK99B9v2wGJzEi/NXRfncy/0f5BUp0of
        lJ4bEjzF0AisDEjZdQHD1bDP5XJms5E=
X-Google-Smtp-Source: AMsMyM5g3wM/b8P2U1MA2ih0rRJS2HjVTeN+YLhx5vJ0byAPTBVlclCcKrewjnJ9b6pkd6ZlmS/73g==
X-Received: by 2002:a17:902:d50b:b0:178:3ea4:2945 with SMTP id b11-20020a170902d50b00b001783ea42945mr18873223plg.67.1665411418839;
        Mon, 10 Oct 2022 07:16:58 -0700 (PDT)
Received: from localhost.localdomain (124x33x176x97.ap124.ftth.ucom.ne.jp. [124.33.176.97])
        by smtp.gmail.com with ESMTPSA id y198-20020a62cecf000000b005627868e27esm6896930pfg.127.2022.10.10.07.16.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Oct 2022 07:16:58 -0700 (PDT)
Sender: Vincent Mailhol <vincent.mailhol@gmail.com>
From:   Vincent Mailhol <mailhol.vincent@wanadoo.fr>
To:     linux-can@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        netdev@vger.kernel.org
Cc:     Marc Kleine-Budde <mkl@pengutronix.de>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Subject: [PATCH iproute2 v3] iplink_can: add missing `]' of the bitrate, dbitrate and termination arrays
Date:   Mon, 10 Oct 2022 23:16:38 +0900
Message-Id: <20221010141638.72390-1-mailhol.vincent@wanadoo.fr>
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
PRINT_ANY to fix the problem. The second argument was already set
correctly.

Fixes: 67f3c7a5cc0d ("iplink_can: use PRINT_ANY to factorize code and fix signedness")
Reported-by: Marc Kleine-Budde <mkl@pengutronix.de>
Acked-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
---

I just realized that I forgot to adjust the subject prefix to point to
iproute2. So here is the v3. Sorry for the noise.

** Changelog **

v2 -> v3

  * no change in code.
  * Set the subject prefix to [PATCH iproute2] instead of [PATCH].

v1 -> v2

  * no change in code.
  * Remove garbage text due to copy/paste mistake in the Reported-by
    tag of the commit message.
  * add Acked-by: Marc Kleine-Budde <mkl@pengutronix.de>.
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

