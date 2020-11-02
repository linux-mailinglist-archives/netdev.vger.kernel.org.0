Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6F5D2A29D1
	for <lists+netdev@lfdr.de>; Mon,  2 Nov 2020 12:48:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728762AbgKBLrf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Nov 2020 06:47:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728687AbgKBLqA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Nov 2020 06:46:00 -0500
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37248C0401C2
        for <netdev@vger.kernel.org>; Mon,  2 Nov 2020 03:45:55 -0800 (PST)
Received: by mail-wr1-x444.google.com with SMTP id a9so14188830wrg.12
        for <netdev@vger.kernel.org>; Mon, 02 Nov 2020 03:45:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=qRyyhT2AWsAOiMgoL3f0fJFF+pEVB6J7sHbwygfJRQ4=;
        b=yby+34tgJw4ulZID9MO+AkwPdoB+lgG/KF699C6ysVMZmY5ZMs/K8eK2UdR7TmvODj
         2LCdDXqy1BkH5rIqnQsyf7N2ABBGx59blLnBn23X+JGtDd0ho4v0S1Rd9P5nYlTQz1rP
         imeHg28VCHg5O9Wee87TWnjZMAVjXh2auTZO+NTQxexs7ljsTQSfpiFz+LSDgUp9W7GY
         WeEJuSm6W551rPQ689dmWWUw/8lt6KDJUK+FQMdr5gFjFstMp8jJjE70ZjOL9Kaa0vFt
         QKEx6Etp9Ub0zGvuxJh1Gpx9ytWMn/V5uW73qeENSK6KFASRXGHb0GmO88N0LagO00jE
         Rgww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=qRyyhT2AWsAOiMgoL3f0fJFF+pEVB6J7sHbwygfJRQ4=;
        b=m6ByTcQh6srkLccx6HZ0KNnpukhGxXkVs+eztss35tJkWil2XliknfGCm2gVQSHgxD
         xso3Fs8MuKJo4pRWSKxCYJggE7ism2k5XRUBm4gKxWClrRVBSLv/04ANgrGcRF1fxUEk
         h60V//rM4yFpeOMhzPckVW8fmLfg6b8lED8GwP+4fn2g0OPm6wJQNQDsuj5AUchJFaAm
         xv6RJmXDNF8WfpOwbZEtYUGSRO5FID6Bvn6DOXj3kJECXSKeTwsEWT5AbRYeLtWn5Hks
         9wwZTCnzuM8z44T7Ok5EqimOnuzrC17HgbSr6UGjSjja91SzSnOVTE7t6Pl1EGYX/M5F
         yULA==
X-Gm-Message-State: AOAM530WTXmO6xsnWK6NoNH4ztDb3C8NUb0aRu/7/4cVzSjIEPX/+7L2
        wT3gbm9b8OWqnpDC9RLjOCMwvFF63oHOgA==
X-Google-Smtp-Source: ABdhPJyAos5nl+3PwujH9XAhxApX2rSFmyk/MyXjAFeSwdTg9e4wkEmYoPTeUCplhSzBTAURRcOhYg==
X-Received: by 2002:adf:cf10:: with SMTP id o16mr19697049wrj.264.1604317554017;
        Mon, 02 Nov 2020 03:45:54 -0800 (PST)
Received: from dell.default ([91.110.221.242])
        by smtp.gmail.com with ESMTPSA id g66sm15545352wmg.37.2020.11.02.03.45.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Nov 2020 03:45:53 -0800 (PST)
From:   Lee Jones <lee.jones@linaro.org>
To:     davem@davemloft.net
Cc:     Lee Jones <lee.jones@linaro.org>, Jakub Kicinski <kuba@kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Matt Mackall <mpm@selenic.com>,
        netdev@vger.kernel.org
Subject: [PATCH 28/30] net: netconsole: Add description for 'netconsole_target's extended attribute
Date:   Mon,  2 Nov 2020 11:45:10 +0000
Message-Id: <20201102114512.1062724-29-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201102114512.1062724-1-lee.jones@linaro.org>
References: <20201102114512.1062724-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fixes the following W=1 kernel build warning(s):

 drivers/net/netconsole.c:104: warning: Function parameter or member 'extended' not described in 'netconsole_target'

Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Matt Mackall <mpm@selenic.com>
Cc: netdev@vger.kernel.org
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/net/netconsole.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/netconsole.c b/drivers/net/netconsole.c
index 92001f7af380c..ccecba908ded6 100644
--- a/drivers/net/netconsole.c
+++ b/drivers/net/netconsole.c
@@ -83,6 +83,7 @@ static struct console netconsole_ext;
  *		whether the corresponding netpoll is active or inactive.
  *		Also, other parameters of a target may be modified at
  *		runtime only when it is disabled (enabled == 0).
+ * @extended:	Denotes whether console is extended or not.
  * @np:		The netpoll structure for this target.
  *		Contains the other userspace visible parameters:
  *		dev_name	(read-write)
-- 
2.25.1

