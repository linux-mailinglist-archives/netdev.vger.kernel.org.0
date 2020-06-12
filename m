Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B698A1F7E1D
	for <lists+netdev@lfdr.de>; Fri, 12 Jun 2020 22:37:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726372AbgFLUhu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Jun 2020 16:37:50 -0400
Received: from mta-p7.oit.umn.edu ([134.84.196.207]:54582 "EHLO
        mta-p7.oit.umn.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726290AbgFLUhu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Jun 2020 16:37:50 -0400
Received: from localhost (unknown [127.0.0.1])
        by mta-p7.oit.umn.edu (Postfix) with ESMTP id 49kCGN63K6z9vj1d
        for <netdev@vger.kernel.org>; Fri, 12 Jun 2020 20:37:48 +0000 (UTC)
X-Virus-Scanned: amavisd-new at umn.edu
Received: from mta-p7.oit.umn.edu ([127.0.0.1])
        by localhost (mta-p7.oit.umn.edu [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id iDIPBtJ9Ewoz for <netdev@vger.kernel.org>;
        Fri, 12 Jun 2020 15:37:48 -0500 (CDT)
Received: from mail-io1-f71.google.com (mail-io1-f71.google.com [209.85.166.71])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mta-p7.oit.umn.edu (Postfix) with ESMTPS id 49kCGN4Rcdz9vj1Y
        for <netdev@vger.kernel.org>; Fri, 12 Jun 2020 15:37:48 -0500 (CDT)
DMARC-Filter: OpenDMARC Filter v1.3.2 mta-p7.oit.umn.edu 49kCGN4Rcdz9vj1Y
DKIM-Filter: OpenDKIM Filter v2.11.0 mta-p7.oit.umn.edu 49kCGN4Rcdz9vj1Y
Received: by mail-io1-f71.google.com with SMTP id c5so6917952ioh.2
        for <netdev@vger.kernel.org>; Fri, 12 Jun 2020 13:37:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=umn.edu; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=HPsaJy4sS+SIJullYTRWGhbvNfs6G9NRDFRhe6rMAX0=;
        b=REE5JD5caIZyAehxckQoCJgoY8DyFVRxlHvHCan3LTjFl942hafzaBCxL7hMxdYmYR
         sEjn5tQF9eWEqDWKuQvB+KOi9LUqjiXC0wLcc3HnJXIlqfFebt1Ahw0F7oPBL/9lWmrx
         J0WWW2ic1TBuihGUq1xdI6gcN8nu3kuOXR+EYC21WWsHqFmma+pNfgiuhDWW6bmokV2l
         7U7KfBa/GuBzU62oe0RmSiB1ES1J6UlaZRMeY2ZPHcvOrTGPSnBaMwzk/RzZ1eWn++14
         ZsiRh7g9h8S370iaHojJgVFRANz5zaOZfpw9Phz8IgXELDhE1qMt/nvzb+/GfTjXu7R0
         i1oA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=HPsaJy4sS+SIJullYTRWGhbvNfs6G9NRDFRhe6rMAX0=;
        b=YhYn3orNeXge9jx41Vfuj/4LTQoMc4c3jtEKKbNd3wOfcMDoFRyZkJEbbVG8w7uaTg
         jjhgU9N99XNHDUmzBYFJzQbsQRHWRtu978GiNzfhpSrSiP+bYs6gbp8nMP5HpKWnyM6P
         pFXUHnpXytK+EZwloMCk/2/j8e+O8eU3KpMI+aPKflh9c6pGyEdvFo/2E0YXR/fNxVsV
         2uF8YbfojD1l4yl5X/LY8O1daqOfmmveIe2wVnxDNItZVJy969DgftC82tW1GSjeUy+v
         /8TfdsDIj5nepV8bV+x4ZJGA5mrfaMxls9p82s+kZrbWw14N7GQfvg/uVz5JWwLCcesr
         pu9A==
X-Gm-Message-State: AOAM533JN902JjQAHRcquLJeICYxroIFziumFGxDvVZpJhhqcUkmJfTT
        xLdE4RUz5it2lee0PA/RhX5FVVfxyVQXXu7TTUZwnNTKh10TOxy+bV+8SkmnCYvGxZ0dqUUvFmw
        NB1CLArHcKDIeBG3nhsqr
X-Received: by 2002:a6b:249:: with SMTP id 70mr15355898ioc.146.1591994268296;
        Fri, 12 Jun 2020 13:37:48 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwroUcG/TxV7JnmiwS9VTx/087OQr95ZZFoBKpa6o3cAZKupx6gXa4pzHY8gQlciL0Nf2osjA==
X-Received: by 2002:a6b:249:: with SMTP id 70mr15355886ioc.146.1591994268159;
        Fri, 12 Jun 2020 13:37:48 -0700 (PDT)
Received: from piston-t1.hsd1.mn.comcast.net ([2601:445:4380:5b90:79cf:2597:a8f1:4c97])
        by smtp.googlemail.com with ESMTPSA id 199sm3774485ilb.11.2020.06.12.13.37.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Jun 2020 13:37:47 -0700 (PDT)
From:   Aditya Pakki <pakki001@umn.edu>
To:     pakki001@umn.edu
Cc:     kjlu@umn.edu, wu000273@umn.edu,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] net: Fix a potential incorrect error handling in rawsock_connect
Date:   Fri, 12 Jun 2020 15:37:43 -0500
Message-Id: <20200612203745.58304-1-pakki001@umn.edu>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In rawsock_connect, the device is allocated by calling nfc_get_device.
In case of incorrect bounds index, the device should be freed by
calling nfc_put_device. The patch fixes this issue.

Signed-off-by: Aditya Pakki <pakki001@umn.edu>
---
 net/nfc/rawsock.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/nfc/rawsock.c b/net/nfc/rawsock.c
index ba5ffd3badd3..4f0f0ea4c009 100644
--- a/net/nfc/rawsock.c
+++ b/net/nfc/rawsock.c
@@ -105,7 +105,7 @@ static int rawsock_connect(struct socket *sock, struct sockaddr *_addr,
 	if (addr->target_idx > dev->target_next_idx - 1 ||
 	    addr->target_idx < dev->target_next_idx - dev->n_targets) {
 		rc = -EINVAL;
-		goto error;
+		goto put_dev;
 	}
 
 	rc = nfc_activate_target(dev, addr->target_idx, addr->nfc_protocol);
-- 
2.25.1

