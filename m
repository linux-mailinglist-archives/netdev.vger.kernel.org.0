Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C4F825DF87
	for <lists+netdev@lfdr.de>; Fri,  4 Sep 2020 18:15:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726937AbgIDQPG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Sep 2020 12:15:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726185AbgIDQPD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Sep 2020 12:15:03 -0400
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35CEBC061246
        for <netdev@vger.kernel.org>; Fri,  4 Sep 2020 09:15:03 -0700 (PDT)
Received: by mail-wm1-x32a.google.com with SMTP id o21so6618234wmc.0
        for <netdev@vger.kernel.org>; Fri, 04 Sep 2020 09:15:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isovalent-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=d3xRWn3b8mYhu8abwt/w5QeihTHMhGtZlZ6eOGG8jao=;
        b=soLpylM+G5lceY4YjLGYt0Wlob2CwAzKkn2LWznJLmnEXQlRMyN+2QrjK9Demg2FcN
         5vbKbWmNfpTs81yNioLoWtaE/0cLZR5guKiVAOrfHypyCQGQMeria0dg0GVJKIRXq3iF
         hE8S5FVVXFiSkHTCyb3sF/EUFt5HKLERCbhZeITvIBlePIpdYtWgEoGXcioPnsZvGxpA
         4en8/39BipwIpHGeFk55nsm2g/a0vz9i6CAH6CkQ972Pas7TdILu5Ibzqx1jzQE8d2OG
         zt2TJUaRffzXBJHYW1TJyIOIGyxbXoWspox+EROi1A6Aknm7eq7iE8PPu2jO9SWpmJwd
         7DzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=d3xRWn3b8mYhu8abwt/w5QeihTHMhGtZlZ6eOGG8jao=;
        b=GptU3C5WQvvdZvKDwZx+6LGJMhlX80HHR+90M1WHUUer1mNw6D/FgWlIK5p93xD/Fp
         10exgMccroJXBwCTIGsr17z3hBVlEiDXhwREs8xBSniQ+azlHPtWxtf+d0IGQ4ESm9mj
         +2vArBaa5mpymDXFtAsX8GlqFav0PkqjpQIqrQ7ZrCpuolxrYeJTKtT2MUeYGV6ajgUG
         Px7RVHwClWN8MilhJXAkRQe2dmLPv7VNAwY0WcwgjCvROdfj6c1Fam7iz6vD63FwuJGb
         Hos3t+B534aTGaEI5B7SrtLT9grOPxwlO9DVnXUEe337GvCTzimOB+t4SzRyYC6xms5l
         LWog==
X-Gm-Message-State: AOAM531dw/ZVlDAZPNiyUIW2q2ZrWw9nczlkF2eFM3z6hCXmFJ4wphoX
        /WcE29dPP7RjXR0O0qPp5HKACA==
X-Google-Smtp-Source: ABdhPJyQHeolU2KSmDmNpwz9DpvdYKhn1IgLswRepB9dgrvh8nE7melSUojbQiqwhax/SqkrJf9E1A==
X-Received: by 2002:a1c:e0d4:: with SMTP id x203mr8990199wmg.91.1599236101923;
        Fri, 04 Sep 2020 09:15:01 -0700 (PDT)
Received: from localhost.localdomain ([194.35.117.187])
        by smtp.gmail.com with ESMTPSA id p1sm28859352wma.0.2020.09.04.09.15.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Sep 2020 09:15:01 -0700 (PDT)
From:   Quentin Monnet <quentin@isovalent.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        Quentin Monnet <quentin@isovalent.com>
Subject: [PATCH bpf-next 1/3] tools: bpftool: fix formatting in bpftool-link documentation
Date:   Fri,  4 Sep 2020 17:14:52 +0100
Message-Id: <20200904161454.31135-2-quentin@isovalent.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200904161454.31135-1-quentin@isovalent.com>
References: <20200904161454.31135-1-quentin@isovalent.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix a formatting error in the documentation for bpftool-link, so that
the man page can build correctly.

Signed-off-by: Quentin Monnet <quentin@isovalent.com>
---
 tools/bpf/bpftool/Documentation/bpftool-link.rst | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/bpf/bpftool/Documentation/bpftool-link.rst b/tools/bpf/bpftool/Documentation/bpftool-link.rst
index 4a52e7a93339..dc7693b5e606 100644
--- a/tools/bpf/bpftool/Documentation/bpftool-link.rst
+++ b/tools/bpf/bpftool/Documentation/bpftool-link.rst
@@ -21,7 +21,7 @@ LINK COMMANDS
 
 |	**bpftool** **link { show | list }** [*LINK*]
 |	**bpftool** **link pin** *LINK* *FILE*
-|	**bpftool** **link detach *LINK*
+|	**bpftool** **link detach** *LINK*
 |	**bpftool** **link help**
 |
 |	*LINK* := { **id** *LINK_ID* | **pinned** *FILE* }
-- 
2.20.1

