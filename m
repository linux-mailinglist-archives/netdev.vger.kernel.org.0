Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7FAF114A486
	for <lists+netdev@lfdr.de>; Mon, 27 Jan 2020 14:06:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729081AbgA0NGi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jan 2020 08:06:38 -0500
Received: from mail-pg1-f196.google.com ([209.85.215.196]:43554 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729043AbgA0NGi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jan 2020 08:06:38 -0500
Received: by mail-pg1-f196.google.com with SMTP id u131so5120280pgc.10
        for <netdev@vger.kernel.org>; Mon, 27 Jan 2020 05:06:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=7lL7JieZgAU6ERHiFb/bqszQNMitfU+D4xLqzbSi8uY=;
        b=VrPk7TU8VSn07T3SViUVsJK7w0UH3jIYbXBTBpSwjjgacv6SF6yRJQ9fzuMF91WV4l
         rcPv0oqq+1vl3mQdBpxVFb352K7Cg+rsnhR00qEfOURIUPjv+cA9LImYwqwcguMKd0yO
         Ln2X35Ao+EpMZiIU0hINRDe/2qQ7Oz7hX/JzMmww3etcB0utQwqY+GH78bP5e8fXGhLo
         BlE15BANeg6FFawn0ZbUDZ/z/KxUw1VlsteLYh66Db5NgoSyvXc85Xuz0yQkGhVwmmfl
         dMMnmsWnRfkVKaERK3kPpoG9IL7KL/qU/elyasM7VOk529HVBKvTS0ioi5pBHP54VKjq
         fVSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=7lL7JieZgAU6ERHiFb/bqszQNMitfU+D4xLqzbSi8uY=;
        b=otDq12yed+AbnTpBifSAm4MFFdPwDqa3oQpkHwT9/5WaU9F3AeHA2NJWCpbkOLjCe7
         mxXbHhenQKXzW7tuSrS/JBUNXndlQVZ/dyqJEbdAG2bby0Ox9xpTM6jeG7vm45HEWTkE
         9inFlnNAiGMTgkbqqu7841N0DwSi95fw4cafo2PFxGHhgK4VjKA1TR0NV7WtJVWvgyCH
         HaB78BUlYqeATShasQFfeI61615cjsRfsKwzPaZ52Mp/ICISUKMK3PN7X483fd4TYfgp
         iPp0oIBQMfBGux3M1t9ADNnCx3Ouzk20k3fopEUIs0LdyCyLww65M2k4s91Wiv2SDCqY
         ldvA==
X-Gm-Message-State: APjAAAW/xkc19+lyLpNDy6nSqZjDm5YFvr48NzPh6aOsEFzOxBgrfbS+
        1gVgv/hrQZD+MuPy5G8cQqJ6mPQEayE=
X-Google-Smtp-Source: APXvYqxQZpWT6j953fUxSLlZPB4vUFpwN2vrRcEVd6ANAgdQ2rEEJcNBPz+F6aOZvH9NybOdIfCAwg==
X-Received: by 2002:a63:78cf:: with SMTP id t198mr18824339pgc.287.1580130397268;
        Mon, 27 Jan 2020 05:06:37 -0800 (PST)
Received: from machine421.marvell.com ([115.113.156.2])
        by smtp.googlemail.com with ESMTPSA id c15sm17241717pja.30.2020.01.27.05.06.34
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Mon, 27 Jan 2020 05:06:36 -0800 (PST)
From:   sunil.kovvuri@gmail.com
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kubakici@wp.pl, mkubecek@suse.cz,
        maciej.fijalkowski@intel.com, Sunil Goutham <sgoutham@marvell.com>
Subject: [PATCH v6 17/17] MAINTAINERS: Add entry for Marvell OcteonTX2 Physical Function driver
Date:   Mon, 27 Jan 2020 18:35:31 +0530
Message-Id: <1580130331-8964-18-git-send-email-sunil.kovvuri@gmail.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1580130331-8964-1-git-send-email-sunil.kovvuri@gmail.com>
References: <1580130331-8964-1-git-send-email-sunil.kovvuri@gmail.com>
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
index 681ba1d..da8a773 100644
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

