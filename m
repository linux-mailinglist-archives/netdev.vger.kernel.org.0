Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (unknown [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DBA8A1A6123
	for <lists+netdev@lfdr.de>; Mon, 13 Apr 2020 01:51:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726703AbgDLXvM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Apr 2020 19:51:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.18]:43014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726185AbgDLXvM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Apr 2020 19:51:12 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B766C0A3BE0
        for <netdev@vger.kernel.org>; Sun, 12 Apr 2020 16:51:11 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id a25so8661953wrd.0
        for <netdev@vger.kernel.org>; Sun, 12 Apr 2020 16:51:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=slVnfUhRk4UtJ3dM4QB6wg5FXPdqctew9ZDiOmN+D2Q=;
        b=ZTlH25IJZASekdyEvXOqY4lWrzw5ogbtm/g7jrk99rzJOEhDB1+Nf7vmXm93EMjcjB
         +N5PRp8hW/ezLl2dxsuGHI77mJD3pq9q99uSPQjf5fDjYKKTvMhgDpIANRRhUmPyzJKX
         Z3Nmzxy2sSr4PF/eDf3Nf2uuphsSQH5wArpoMkIr7NT0YpMEXGweoJyES8vdwo+sHzrQ
         kssGExAYp8TeFzC44Z4HPpYSQrdm8yaUKd6G+oubbgEVqxhLt7xRjD/sF5rBCDaFn8bq
         EqNTblcZQSIMVC03cILxZHCyHGvD/r5F+DYPbTMQu5R96vhgDo+7NY2rus+j++Mo+z+n
         VH/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=slVnfUhRk4UtJ3dM4QB6wg5FXPdqctew9ZDiOmN+D2Q=;
        b=T35LVZ68CUg4ECmO6i+kKwC0T5Exx83Mn02FVH3aQC2nLU/0Z8l6VlSwbcSUtHBhhr
         S2e9uYAsFnfximY4xdc8Ir6oyKZkYagGcoAqPPX9M8yVVypauP3RLfDMgTmWVvWAC86w
         v1DF4dN6TZdwO3xYMFPM2qjk49K209EuV4h493Xll5dRuJwoui05kG1c23jQcFJpso5/
         rV5r15NJgU5AsFhgAVfzFeCHMDe1nx6LbRpwkDumOAz4+NKbSjQx9AUc3w8dy5a+YoPP
         i0AkMIxlPwK1moE9V/ftM3qiEjOGLtzlK/e9ILurIRv4SCR4wfHscLhAKaO6Q5C8jjvl
         zaGQ==
X-Gm-Message-State: AGi0PuaNK6caokhx4dwOGB+J8CnnxKerHU3Apuzj/IP3aGE7WpYXZS8o
        J9KjU51GkBk90Cg5Vu0NPtt77PMI
X-Google-Smtp-Source: APiQypLFDbBco9G65NFIGa7YkEb5KhgXOvBM5rP7pM+0FPPXcQaDvypHvGTGvBSBoegfGbOvAxxjWg==
X-Received: by 2002:adf:97d9:: with SMTP id t25mr5330987wrb.157.1586735469017;
        Sun, 12 Apr 2020 16:51:09 -0700 (PDT)
Received: from localhost ([2a01:e35:2f01:a61:fc49:14b:88c:2a9c])
        by smtp.gmail.com with ESMTPSA id k133sm13130272wma.0.2020.04.12.16.51.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 12 Apr 2020 16:51:07 -0700 (PDT)
From:   roucaries.bastien@gmail.com
X-Google-Original-From: rouca@debian.org
To:     netdev@vger.kernel.org
Cc:     sergei.shtylyov@cogentembedded.com,
        Stephen Hemminger <stephen@networkplumber.org>,
        =?UTF-8?q?Bastien=20Roucari=C3=A8s?= <rouca@debian.org>
Subject: [PATCH 2/6] Improve hairpin mode description
Date:   Mon, 13 Apr 2020 01:50:34 +0200
Message-Id: <20200412235038.377692-3-rouca@debian.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200412235038.377692-1-rouca@debian.org>
References: <20200405134859.57232-1-rouca@debian.org>
 <20200412235038.377692-1-rouca@debian.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Bastien Roucariès <rouca@debian.org>

Mention VEPA and reflective relay.

Signed-off-by: Bastien Roucariès <rouca@debian.org>
---
 man/man8/bridge.8 | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/man/man8/bridge.8 b/man/man8/bridge.8
index ff6f6f37..584324b5 100644
--- a/man/man8/bridge.8
+++ b/man/man8/bridge.8
@@ -332,7 +332,9 @@ cause the port to stop processing STP BPDUs.
 .TP
 .BR "hairpin on " or " hairpin off "
 Controls whether traffic may be send back out of the port on which it was
-received. By default, this flag is turned off and the bridge will not forward
+received. This option is also called reflective relay mode, and is used to support
+basic VEPA (Virtual Ethernet Port Aggregator) capabilities.
+By default, this flag is turned off and the bridge will not forward
 traffic back out of the receiving port.
 
 .TP
-- 
2.25.1

