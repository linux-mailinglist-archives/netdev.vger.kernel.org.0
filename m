Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 31BDD143DF2
	for <lists+netdev@lfdr.de>; Tue, 21 Jan 2020 14:23:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729207AbgAUNWs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jan 2020 08:22:48 -0500
Received: from mail-pj1-f67.google.com ([209.85.216.67]:50985 "EHLO
        mail-pj1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725890AbgAUNWr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jan 2020 08:22:47 -0500
Received: by mail-pj1-f67.google.com with SMTP id r67so1373028pjb.0
        for <netdev@vger.kernel.org>; Tue, 21 Jan 2020 05:22:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=1BpKrcBMrBJdvjjGHMme/i3fw0kA5b5DyyxFveEYRhQ=;
        b=mcrdwq4rhJPr/vcRu0arhkx91DKk1Wg/wWGiNQYoPj/CKZUdolxZpKi+Pe/FZ1yLhI
         Tx06hmm04CB5xz7fkGTY48pGSG8wkyG163mLN14fEqakz5gigaBcwUiJcwXpKwjAorQd
         +fjYWzI98uiM9uBPtYIp8R1RWGHABUoMfLonVoprq//QxRSdLuNJEz1ekxOAeqgsNW9t
         gJG1hb9ruSeFWrY/hfKCib/1AtwItCKwoM9cyPHcQsFlXha5gzUNKxKlRkd0HrjgVFN9
         IXWOZziYCT+RaiXN5TR4z8O6koRJRYAZuQSooUJIqAeTrQf3394A0c80Ykfa64mPPRaT
         m4cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=1BpKrcBMrBJdvjjGHMme/i3fw0kA5b5DyyxFveEYRhQ=;
        b=QuR+/REqLqPTEFiS62S8lsSgkShmwOt0h4pzrOTjGbqooZqXyJFWnUquAxFyphkUfk
         cI0Xqg4dbuZ4t93Kcor2l8Rpf+XYESofI/ilMFukmKImvw6vIEHXZCrGk7yH3a7Ws/P7
         qU+vNeh9gcyLdcqsZs/RcXUUCwDkCRBuHL629bSCc9WjPY1JLn4fCq92F0GkeNHOYqmI
         Yf4YLqdjvfyxh+ptjQH1Q0BMYopi2/5gygtD7juumkF/7/Yk/kd+fquq7DVXZgoagjFo
         bWFAIbePcxy8huzYI2sZhFMvazeBp26Ul/uCwr4mgqqzayNSFGO0gfb/A+4AoLXk58rp
         S6KQ==
X-Gm-Message-State: APjAAAXwt37SmYjj7BNpIjfdnZQJ271nAOHeyrTsZOlY72kkrOPQsnFR
        h8i7MFnoj5KpVzROj7e6UUnAWgcbCT8=
X-Google-Smtp-Source: APXvYqzS7n39GIvmPULe5SAGb69V6BrButPDhbAGd5/0L4+Je5Q8Arcbb4XP+mMok04blLTDmDkpTA==
X-Received: by 2002:a17:902:9a42:: with SMTP id x2mr5710560plv.194.1579612966684;
        Tue, 21 Jan 2020 05:22:46 -0800 (PST)
Received: from machine421.marvell.com ([115.113.156.2])
        by smtp.googlemail.com with ESMTPSA id y21sm43328076pfm.136.2020.01.21.05.22.44
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Tue, 21 Jan 2020 05:22:46 -0800 (PST)
From:   sunil.kovvuri@gmail.com
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kubakici@wp.pl, mkubecek@suse.cz,
        Sunil Goutham <sgoutham@marvell.com>
Subject: [PATCH v4 17/17] MAINTAINERS: Add entry for Marvell OcteonTX2 Physical Function driver
Date:   Tue, 21 Jan 2020 18:51:51 +0530
Message-Id: <1579612911-24497-18-git-send-email-sunil.kovvuri@gmail.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1579612911-24497-1-git-send-email-sunil.kovvuri@gmail.com>
References: <1579612911-24497-1-git-send-email-sunil.kovvuri@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sunil Goutham <sgoutham@marvell.com>

Added maintainers entry for Marvell OcteonTX2 SOC's physical
function NIC driver.

Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
---
 MAINTAINERS | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index fdbb875..51d7876 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -10002,6 +10002,15 @@ S:	Supported
 F:	drivers/net/ethernet/marvell/octeontx2/af/
 F:	Documentation/networking/device_drivers/marvell/octeontx2.rst
 
+MARVELL OCTEONTX2 PHYSICAL FUNCTION DRIVER
+M:	Sunil Goutham <sgoutham@marvell.com>
+M:	Geetha sowjanya <gakula@marvell.com>
+M:	Subbaraya Sundeep <sbhatta@marvell.com>
+M:	hariprasad <hkelam@marvell.com>
+L:	netdev@vger.kernel.org
+S:	Supported
+F:	drivers/net/ethernet/marvell/octeontx2/nic/
+
 MATROX FRAMEBUFFER DRIVER
 L:	linux-fbdev@vger.kernel.org
 S:	Orphan
-- 
2.7.4

