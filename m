Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66B6F463C46
	for <lists+netdev@lfdr.de>; Tue, 30 Nov 2021 17:51:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244500AbhK3QyW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Nov 2021 11:54:22 -0500
Received: from mta-p6.oit.umn.edu ([134.84.196.206]:55938 "EHLO
        mta-p6.oit.umn.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244588AbhK3QyM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Nov 2021 11:54:12 -0500
Received: from localhost (unknown [127.0.0.1])
        by mta-p6.oit.umn.edu (Postfix) with ESMTP id 4J3Ss43ynyz9vqlK
        for <netdev@vger.kernel.org>; Tue, 30 Nov 2021 16:50:48 +0000 (UTC)
X-Virus-Scanned: amavisd-new at umn.edu
Received: from mta-p6.oit.umn.edu ([127.0.0.1])
        by localhost (mta-p6.oit.umn.edu [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 9y8VP0iEd8mI for <netdev@vger.kernel.org>;
        Tue, 30 Nov 2021 10:50:48 -0600 (CST)
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com [209.85.216.72])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mta-p6.oit.umn.edu (Postfix) with ESMTPS id 4J3Ss41vr9z9vqlJ
        for <netdev@vger.kernel.org>; Tue, 30 Nov 2021 10:50:48 -0600 (CST)
DMARC-Filter: OpenDMARC Filter v1.3.2 mta-p6.oit.umn.edu 4J3Ss41vr9z9vqlJ
DKIM-Filter: OpenDKIM Filter v2.11.0 mta-p6.oit.umn.edu 4J3Ss41vr9z9vqlJ
Received: by mail-pj1-f72.google.com with SMTP id x1-20020a17090a294100b001a6e7ba6b4eso10134620pjf.9
        for <netdev@vger.kernel.org>; Tue, 30 Nov 2021 08:50:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=umn.edu; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=W4lvCUBRSibHXkkFm5Ye1P7mrNgQ0tt0c7dI8z7Afww=;
        b=Dlmdt+ElX1hlkn6am6/1pELOrapSy/t1WY9DyPuGdNODNSWoBFeg6Wg4xITA/iEoa+
         j4UCUIK35xCdxg9kcWVBrMZ3+D4yib/Xz7aoYtZMWLfhcRurW28K6O3Dc1uEawwx2xWb
         UnRdDxZH0zR+RiLuPciO9KahoCMNO39X6DAX2bYzqXBGqfzCQrInM9FySrJV/5bIGuhy
         IP/zUAahOdVn7DuG4f+p5FQdh2XxsfHaNFMhPV5eeV7gilXCqx7yGBAnRoRVH5Jm8GTm
         OrCgXUSdH8kmb9uySd9GtUchctxqAVqYacwvcBpMg490GB/Pd2dtNfnunRAibwGRPe+w
         70uQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=W4lvCUBRSibHXkkFm5Ye1P7mrNgQ0tt0c7dI8z7Afww=;
        b=AjGyFLtdJaf4T6ICmuVTLzl/dTLEwMZ1UXQntxXWHtu7PVm3/q1yjX6qf7nVyAF01j
         m13J9U1vU4Em9mZsGOFaRGL64SdDzmt0R2LtBOD7xemFBX3vFq5QCCi/EoAQyQZ/56Yd
         sJ8oBnXE7lm/anXxYql4RflW9ypYC/7lUP0W3797H1wrLFrEBJjOJPZxgJf91JfqlfUu
         NNjZcU7uYWuPcrfz0apZlEp499vhBygKIn1SndDjsK/dLKAbsi+urviZg7TtbJAgog39
         ORy4+Y/uN4UnAYElVx5LkjuPG1mfWSeT1FSNZaIpHMVSAMbOI8JXC2y7evfMGXIB9ZeB
         ZMbA==
X-Gm-Message-State: AOAM532VlGBvXFUlIoo5GebNGbcM2moo3mjVNUaqIydn6kVf/xneewOi
        B7NzUIubglWOXL7GU7O5xBoEI6HeNoz9kL8R0Kq93chv+49aw3zDCQCSw7lZDmXHWgUBl2oPKCH
        YXhMudC25kq4yJZ2qR2H7
X-Received: by 2002:a63:d848:: with SMTP id k8mr219758pgj.467.1638291047499;
        Tue, 30 Nov 2021 08:50:47 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzUoLI32LU8MqKKgo7LZRAezZSN58Vg9+5tPg/RV3rRdVJexTB/R0GhOJHYcIY2IKHynr7WlQ==
X-Received: by 2002:a63:d848:: with SMTP id k8mr219736pgj.467.1638291047279;
        Tue, 30 Nov 2021 08:50:47 -0800 (PST)
Received: from zqy787-GE5S.lan ([36.7.42.137])
        by smtp.gmail.com with ESMTPSA id y4sm22832295pfi.178.2021.11.30.08.50.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Nov 2021 08:50:47 -0800 (PST)
From:   Zhou Qingyang <zhou1615@umn.edu>
To:     zhou1615@umn.edu
Cc:     kjlu@umn.edu, Sunil Goutham <sgoutham@marvell.com>,
        Linu Cherian <lcherian@marvell.com>,
        Geetha sowjanya <gakula@marvell.com>,
        Jerin Jacob <jerinj@marvell.com>,
        hariprasad <hkelam@marvell.com>,
        Subbaraya Sundeep <sbhatta@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] octeontx2-af: Fix a memleak bug in rvu_mbox_init()
Date:   Wed,  1 Dec 2021 00:50:39 +0800
Message-Id: <20211130165039.192426-1-zhou1615@umn.edu>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In rvu_mbox_init(), mbox_regions is not freed or passed out
under the switch-default region, which could lead to a memory leak.

Fix this bug by changing 'return err' to 'goto free_regions'.

This bug was found by a static analyzer. The analysis employs
differential checking to identify inconsistent security operations
(e.g., checks or kfrees) between two code paths and confirms that the
inconsistent operations are not recovered in the current function or
the callers, so they constitute bugs.

Note that, as a bug found by static analysis, it can be a false
positive or hard to trigger. Multiple researchers have cross-reviewed
the bug.

Builds with CONFIG_OCTEONTX2_AF=y show no new warnings,
and our static analyzer no longer warns about this code.

Fixes: 98c561116360 (“octeontx2-af: cn10k: Add mbox support for CN10K platform”)
Signed-off-by: Zhou Qingyang <zhou1615@umn.edu>
---
 drivers/net/ethernet/marvell/octeontx2/af/rvu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
index cb56e171ddd4..3ca6b942ebe2 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
@@ -2341,7 +2341,7 @@ static int rvu_mbox_init(struct rvu *rvu, struct mbox_wq_info *mw,
 			goto free_regions;
 		break;
 	default:
-		return err;
+		goto free_regions;
 	}
 
 	mw->mbox_wq = alloc_workqueue(name,
-- 
2.25.1

