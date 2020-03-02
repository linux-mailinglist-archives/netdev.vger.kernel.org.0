Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 45A7317521E
	for <lists+netdev@lfdr.de>; Mon,  2 Mar 2020 04:27:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726901AbgCBD06 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Mar 2020 22:26:58 -0500
Received: from mail-pf1-f194.google.com ([209.85.210.194]:44604 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726857AbgCBD05 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 1 Mar 2020 22:26:57 -0500
Received: by mail-pf1-f194.google.com with SMTP id y5so4830970pfb.11
        for <netdev@vger.kernel.org>; Sun, 01 Mar 2020 19:26:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=2IJ6v+vBNAPNbMMvS1O0Ku5Q+LCCSOnxCLcdXHEwvh4=;
        b=RqwOLPE/Bcg/5dpKgcIGb0cBoPI1lDtuMOdwJkQBykhfwHqDhUqvi++NUZKQQfGN2n
         CUOdspMkhrJYrkI4672F7G/e0wEZ40nxUi17EbG4EQur6NgQyOmPM8csIp+SSAF5yMuy
         rJTkL88qe+XYlD5akQ28h4/xvz45WmaU+jwnqlBnElSUp7zLNOaYAgnVefgB9goN+ima
         eJTY6BtxLfyI0nxO+g2OAClpjYJ9clmQSa8rRE1XgWIC4qrW7SRDdBF5zIlJq66CtkOM
         YuOyj1YPcT+vejzqjOyM0/c1p59hAvsoDgsf67p9ySttKgq+myv1dOUPVSYrdB4VXTgQ
         Wfzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=2IJ6v+vBNAPNbMMvS1O0Ku5Q+LCCSOnxCLcdXHEwvh4=;
        b=G+Et8CSuXv+SNrYoEQTAjLm2lqSsVhBaSfk01lPKaDP/qAZPojlLiLB6Jmyup+hN+M
         pUiQ4ulW6w67Q/mt4y1eT+2g2Oo4BCV7C+xWjcZHvbyEDvqOU8rdVJ1v71u9gMq0YUy8
         wuRHAXWeh/G/CBYi1YzhtZHNtxouyRg0T1G5vII5gp+MeEOSUnfWjC175WPEmOUttqqo
         A1nSfCILEccujiQMMWON2Pd6zZnhPyh3Tz7HM7d28VA1qeL+b6SO1kO71gJS7esuj+Yz
         mHNd8PgYLA7AjRmIng+Rdzxhi7Kycr2JESvDplbrtmQuAobJd07JmxGx070XNyqcbXm1
         8ZHA==
X-Gm-Message-State: ANhLgQ3+i5mc4v0ERfB7BIRXdhvYr3f79lZmuiTXjsymEWtQh4YEiIYf
        elgmfyVZguxx0QhrpGqYKxU1xX+tFqg=
X-Google-Smtp-Source: ADFU+vsXk1eNu6nmXqw059tsROHTcg802qKJUw3BfLPuhaRNKqHg8tl6eNtdCUaTd4boNQ0QmypMmA==
X-Received: by 2002:a63:c850:: with SMTP id l16mr4109458pgi.290.1583119614697;
        Sun, 01 Mar 2020 19:26:54 -0800 (PST)
Received: from localhost.localdomain (104-188-17-28.lightspeed.sndgca.sbcglobal.net. [104.188.17.28])
        by smtp.gmail.com with ESMTPSA id b133sm18435739pga.43.2020.03.01.19.26.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 01 Mar 2020 19:26:54 -0800 (PST)
From:   Bjorn Andersson <bjorn.andersson@linaro.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
Subject: [PATCH 2/2] net: qrtr: Fix FIXME related to qrtr_ns_init()
Date:   Sun,  1 Mar 2020 19:25:27 -0800
Message-Id: <20200302032527.552916-3-bjorn.andersson@linaro.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20200302032527.552916-1-bjorn.andersson@linaro.org>
References: <20200302032527.552916-1-bjorn.andersson@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 2 second delay before calling qrtr_ns_init() meant that the remote
processors would register as endpoints in qrtr and the say_hello() call
would therefor broadcast the outgoing HELLO to them. With the HELLO
handshake corrected this delay is no longer needed.

Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
---
 net/qrtr/ns.c   | 2 +-
 net/qrtr/qrtr.c | 6 +-----
 net/qrtr/qrtr.h | 2 +-
 3 files changed, 3 insertions(+), 7 deletions(-)

diff --git a/net/qrtr/ns.c b/net/qrtr/ns.c
index e3f11052b5f6..cfd4bd07a62b 100644
--- a/net/qrtr/ns.c
+++ b/net/qrtr/ns.c
@@ -693,7 +693,7 @@ static void qrtr_ns_data_ready(struct sock *sk)
 	queue_work(qrtr_ns.workqueue, &qrtr_ns.work);
 }
 
-void qrtr_ns_init(struct work_struct *work)
+void qrtr_ns_init(void)
 {
 	struct sockaddr_qrtr sq;
 	int ret;
diff --git a/net/qrtr/qrtr.c b/net/qrtr/qrtr.c
index 423310896285..313d3194018a 100644
--- a/net/qrtr/qrtr.c
+++ b/net/qrtr/qrtr.c
@@ -1263,11 +1263,7 @@ static int __init qrtr_proto_init(void)
 		return rc;
 	}
 
-	/* FIXME: Currently, this 2s delay is required to catch the NEW_SERVER
-	 * messages from routers. But the fix could be somewhere else.
-	 */
-	INIT_DELAYED_WORK(&qrtr_ns_work, qrtr_ns_init);
-	schedule_delayed_work(&qrtr_ns_work, msecs_to_jiffies(2000));
+	qrtr_ns_init();
 
 	return rc;
 }
diff --git a/net/qrtr/qrtr.h b/net/qrtr/qrtr.h
index 53a237a28971..dc2b67f17927 100644
--- a/net/qrtr/qrtr.h
+++ b/net/qrtr/qrtr.h
@@ -29,7 +29,7 @@ void qrtr_endpoint_unregister(struct qrtr_endpoint *ep);
 
 int qrtr_endpoint_post(struct qrtr_endpoint *ep, const void *data, size_t len);
 
-void qrtr_ns_init(struct work_struct *work);
+void qrtr_ns_init(void);
 
 void qrtr_ns_remove(void);
 
-- 
2.24.0

