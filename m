Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E7101175E06
	for <lists+netdev@lfdr.de>; Mon,  2 Mar 2020 16:18:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727393AbgCBPSy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Mar 2020 10:18:54 -0500
Received: from mail-pf1-f196.google.com ([209.85.210.196]:42554 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727335AbgCBPSx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Mar 2020 10:18:53 -0500
Received: by mail-pf1-f196.google.com with SMTP id f5so744379pfk.9
        for <netdev@vger.kernel.org>; Mon, 02 Mar 2020 07:18:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Br6c2Y1AI7IGoOUT9S32pmgk6z94hhBAZwhijTHQ5mg=;
        b=hDaRnIxNTbb9Ri4vNFvaaxq3dalQGloWpCS+epxtXpqVQP7nEyyfs6d2f6AmdJTYX+
         wgPNs/UOB65yN4VkSUgz2Si4WLUn0+tk81o3hxMCw6NlbIbSKYA9cD19CWY+Wsdfr6S8
         lojWskuDIVV3IyqGAu9QvT+HOIb1VhnGNEgl43jbPwHmvjC7jCOWdsZS/RDCcv1yTfZ6
         KrDB/4QS+gBndivtS4u2otasdqm8Ur52fzSFnVi3/B/3s3u8C1HmT+pRY09/B+JgjOam
         YJTKeI5FxxW8ZgGhzPjvQbtBY2dlV3eZZ8XnnUcTGIlu1QMfZAC59MLh+wsj7ozTeSNQ
         FcKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=Br6c2Y1AI7IGoOUT9S32pmgk6z94hhBAZwhijTHQ5mg=;
        b=RcN5oD6N70/l4CFPM9bbxVJI9pbKWY5I3JWonkux4ieRmzwtM0Tgv56ExnitHCDQrh
         l1NGVW+Ue1cs/vzeg+cbTszh3EPkAjpEUPb1bVWsgNPja3cOm/Vk1/PwqSwywFJ+QTEb
         eM072OAQN4gL0igAwvpXC4IzuBr1+MvssZm7j1v/qbS2ZhQ0nkR767wfJqo4c6/ytJSZ
         IOT5gSBOUWBS1vlHJSRfwO67pczKOxQlWJVdTU6Z4H2VfKAU2spemJddMfy8MgBmAGtL
         gSGFASKCq0JrnD0fazpo2cDnR3HoKedv1KNdx4IbN1aMlFcCPdt4dJ3gEw3UAAtSdxnl
         V83Q==
X-Gm-Message-State: APjAAAW9i0LiONpbU713ZCrScbpMLvOXh+ae4f0Jpj+5NKNNqvLGsDri
        hHjQOnqfyCcXUB0AqByfizTl0vO+
X-Google-Smtp-Source: APXvYqxF8udT2WsdTax/oksWNV8bS7xpgMlNmg/jbGij0nTFd0NRu46x6NvUU0mAHtYBdLi2+RXk9g==
X-Received: by 2002:a63:1e1d:: with SMTP id e29mr20278770pge.347.1583162331920;
        Mon, 02 Mar 2020 07:18:51 -0800 (PST)
Received: from localhost.localdomain ([103.89.235.106])
        by smtp.gmail.com with ESMTPSA id s206sm21908529pfs.100.2020.03.02.07.18.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Mar 2020 07:18:51 -0800 (PST)
From:   Leslie Monis <lesliemonis@gmail.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, tahiliani@nitk.edu.in, gautamramk@gmail.com
Subject: [PATCH net-next 4/4] pie: realign comment
Date:   Mon,  2 Mar 2020 20:48:31 +0530
Message-Id: <20200302151831.2811-5-lesliemonis@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200302151831.2811-1-lesliemonis@gmail.com>
References: <20200302151831.2811-1-lesliemonis@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Realign a comment after the change introduced by the
previous patch.

Signed-off-by: Leslie Monis <lesliemonis@gmail.com>
---
 include/net/pie.h | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/include/net/pie.h b/include/net/pie.h
index 1c645b76a2ed..3fe2361e03b4 100644
--- a/include/net/pie.h
+++ b/include/net/pie.h
@@ -38,15 +38,15 @@ struct pie_params {
 
 /**
  * struct pie_vars - contains pie variables
- * @qdelay:			current queue delay
- * @qdelay_old:			queue delay in previous qdelay calculation
- * @burst_time:			burst time allowance
- * @dq_tstamp:			timestamp at which dq rate was last calculated
- * @prob:			drop probability
- * @accu_prob:			accumulated drop probability
- * @dq_count:			number of bytes dequeued in a measurement cycle
- * @avg_dq_rate:		calculated average dq rate
- * @backlog_old:		queue backlog during previous qdelay calculation
+ * @qdelay:		current queue delay
+ * @qdelay_old:		queue delay in previous qdelay calculation
+ * @burst_time:		burst time allowance
+ * @dq_tstamp:		timestamp at which dq rate was last calculated
+ * @prob:		drop probability
+ * @accu_prob:		accumulated drop probability
+ * @dq_count:		number of bytes dequeued in a measurement cycle
+ * @avg_dq_rate:	calculated average dq rate
+ * @backlog_old:	queue backlog during previous qdelay calculation
  */
 struct pie_vars {
 	psched_time_t qdelay;
-- 
2.17.1

