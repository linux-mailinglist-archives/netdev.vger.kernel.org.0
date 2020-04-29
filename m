Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB9281BEC43
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 00:58:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727831AbgD2W6V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Apr 2020 18:58:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726164AbgD2W6S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Apr 2020 18:58:18 -0400
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93FDBC03C1AE;
        Wed, 29 Apr 2020 15:58:17 -0700 (PDT)
Received: by mail-wm1-x341.google.com with SMTP id e26so3833569wmk.5;
        Wed, 29 Apr 2020 15:58:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=+6NoQf2USPmT+yFI6PS5hYdeh8psj2plU0uHwMJplJ0=;
        b=fFidUgCC73KVNdch60JMuZhxViVXpLNnJAOIU2feWxEMPT14V+N2CPhFq2CldYnFJ7
         c17sXOUwn56vhC1P/BpLJM1hzkdhMMr36N0aSHRhm9Ye2X45iJsCMCxIFbTrsntApZI6
         4vVo+WU5byJNskqvQWMCrjNsDoCOVf20afWjK9XH6ponxdSFRUyz1Ddc3//r92EdMhHY
         8seWzhiaCZbfOug4hIgIrgp1GlazlLcFVIUkCaxQ9bRprld4IrP60aloJ/KDkGZ8DTnT
         cQtUx9D+nXEBqfI2afdpRzCjlStSJXS94Ep4r2skd70jOcNuaRh16Q2UKoPJkRITTckM
         39Lw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+6NoQf2USPmT+yFI6PS5hYdeh8psj2plU0uHwMJplJ0=;
        b=Pi6BXkBfv8HAgxnlaOdaNlUVfds4SfLOo3nQpHRapPhYBKjvHgWYVeu9lMVgxTQNuJ
         jJD2UwRbiUqRNYcfNcGixqkoCsUOxpG3BgtGVvzcPeb08IJkoCHRVkx88JfeVapEpwr6
         tWWYyWcP5WOiV2BZoHb8U6TvOM3YfIBfh+gaTDDrZC277K3agRcWlANuF0Eh8yMsRo6b
         afEKEXXD9lJDal1ECCxjFmPgqh5EuGhSrxqD61QZv0eHvgrH0sX1o2loCP5VUNcf7N0j
         Q3uFiX+laI2jaugk92tfKBOI8iZUdu6ZZZLQnI5POmFZWK40RVdjemKHANNeOjRQ3sy5
         N/xw==
X-Gm-Message-State: AGi0PuY0tImjpMfzRlJ07rPRv/73e9Md9gdcVHP27Zdh+52Ufr2mNT85
        IHcmQjaBo2VyP+ew+N5FRHZkW1hboRBX
X-Google-Smtp-Source: APiQypJ+E68ZHvFA2HcEqegr44lcSdfb9XbNTbnuT4Q4Qx7od9MMtBaOvj/ujJN0U6kPVrl2qIqpFw==
X-Received: by 2002:a7b:c44d:: with SMTP id l13mr170481wmi.72.1588201095735;
        Wed, 29 Apr 2020 15:58:15 -0700 (PDT)
Received: from ninjahost.lan (host-2-102-14-195.as13285.net. [2.102.14.195])
        by smtp.gmail.com with ESMTPSA id 91sm1247675wra.37.2020.04.29.15.58.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Apr 2020 15:58:15 -0700 (PDT)
From:   Jules Irenge <jbi.octave@gmail.com>
To:     linux-kernel@vger.kernel.org
Cc:     linux-arm-kernel@lists.infradead.org, netdev@vger.kernel.org,
        Vishal Kulkarni <vishal@chelsio.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 1/2] cxgb4: Add missing annotation for service_ofldq()
Date:   Wed, 29 Apr 2020 23:57:22 +0100
Message-Id: <20200429225723.31258-2-jbi.octave@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200429225723.31258-1-jbi.octave@gmail.com>
References: <0/2>
 <20200429225723.31258-1-jbi.octave@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sparse reports a warning at service_ofldq()

warning: context imbalance in service_ofldq() - unexpected unlock

The root cause is the missing annotation at service_ofldq()

Add the missing __must_hold(&q->sendq.lock) annotation

Signed-off-by: Jules Irenge <jbi.octave@gmail.com>
---
 drivers/net/ethernet/chelsio/cxgb4/sge.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/chelsio/cxgb4/sge.c b/drivers/net/ethernet/chelsio/cxgb4/sge.c
index 97cda501e7e8..5da8eb6eb9b3 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/sge.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/sge.c
@@ -2702,6 +2702,7 @@ static void ofldtxq_stop(struct sge_uld_txq *q, struct fw_wr_hdr *wr)
  *	is ever running at a time ...
  */
 static void service_ofldq(struct sge_uld_txq *q)
+	__must_hold(&q->sendq.lock)
 {
 	u64 *pos, *before, *end;
 	int credits;
-- 
2.26.2

