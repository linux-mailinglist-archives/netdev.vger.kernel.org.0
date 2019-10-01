Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 65D3AC3237
	for <lists+netdev@lfdr.de>; Tue,  1 Oct 2019 13:18:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731535AbfJALRH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Oct 2019 07:17:07 -0400
Received: from mail-pf1-f180.google.com ([209.85.210.180]:42843 "EHLO
        mail-pf1-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731290AbfJALRH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Oct 2019 07:17:07 -0400
Received: by mail-pf1-f180.google.com with SMTP id q12so7697721pff.9;
        Tue, 01 Oct 2019 04:17:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:cc:subject:message-id:reply-to:mime-version
         :content-disposition:user-agent;
        bh=PHBPieEoIEiHbvbeeHJjltGH3wFRSgkergj3wcnFLm4=;
        b=sTsqsndb21GR8aB81yIio35zSa+c9ao6uAOjuhyJCrvEg1cm1TE3Rg+TrTF88trpRy
         Jp0GQQh5BOUrorDIhUTIhRlFf6A+/SkIx/3uE2J5qTYLV6vfTXjb/L8WcZC2mXR4HiTG
         piG9rpekDDJe/31t7cRi8KKWopw2EQW6C1VPsJVDuNL2LN7nh3NhLSq5XnWtNysDZAhv
         26IpcWXV/U8fMk97GdpDw8YoFjoB6UHZ97qlflksChFi6MGYYnIoSSY4dm+pnfUBcUG2
         CiLTdv1sSU/V3k4IlxgueZ2pLimV3X13o/s/melWl5ufOHPNsi298HimjpHmIKEdAMdo
         6k8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:cc:subject:message-id:reply-to
         :mime-version:content-disposition:user-agent;
        bh=PHBPieEoIEiHbvbeeHJjltGH3wFRSgkergj3wcnFLm4=;
        b=MjMlBZLisxdjH7v/sPidgqPlx9Yzt9cScA5zRyHn6olyE2AjBHKmp48kYT96RUDEWl
         H/2HXMk4ozaR8r93q1D4wz0qMIaeJhi3Fg+qrN4wfP0rpJJ9M9djBFwzoKZdo/DLs27e
         BEO2fwIeQ6XLaiRelrl3Ri+WfqbGn4ZdlxM+5ibx1Qxksll+t+IsuU3LY2reDtOY+VFo
         onDuaUd5zIlUoeRZ4hBblt8DIfOJmddjg3rBqO5uDWqZKkBbuaHgNoBi1p8pDDk0YGd0
         c8Q1k+9+vuizLqxU0ec70NtnqMiSS/febcpBpmSzH0/868heder8lEqz+4WW5SIhhLSR
         fCOQ==
X-Gm-Message-State: APjAAAV4KAYljfscLZmKefCPqq2Ucbbp+xZARk6X/p193XnhTsBEhsZp
        ChQLplldQob4y8pQlM02Ado=
X-Google-Smtp-Source: APXvYqzzT28dhBVJfRRaYBc/gUpXA0OfOFDvLV5YLDiedbEgCmlLs62xDNsRB959hfxbEBuQLPRSIA==
X-Received: by 2002:a17:90a:617:: with SMTP id j23mr5067390pjj.130.1569928626641;
        Tue, 01 Oct 2019 04:17:06 -0700 (PDT)
Received: from gmail.com (ip-103-85-37-165.syd.xi.com.au. [103.85.37.165])
        by smtp.gmail.com with ESMTPSA id l27sm18022696pgc.53.2019.10.01.04.17.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Oct 2019 04:17:04 -0700 (PDT)
Date:   Tue, 1 Oct 2019 21:16:58 +1000
From:   Adam Zerella <adam.zerella@gmail.com>
Cc:     jakub.kicinski@netronome.com, davem@davemloft.net,
        netdev@vger.kernel.org, linux-doc@vger.kernel.org,
        adam.zerella@gmail.com
Subject: [PATCH v2] docs: networking: Add title caret and missing doc
Message-ID: <20191001111658.GA10429@gmail.com>
Reply-To: <20190930113754.5902855e@cakuba.netronome.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.12.1 (2019-06-15)
To:     unlisted-recipients:; (no To-header on input)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Resolving a couple of Sphinx documentation warnings
that are generated in the networking section.

- WARNING: document isn't included in any toctree
- WARNING: Title underline too short.

Signed-off-by: Adam Zerella <adam.zerella@gmail.com>
---

v2: Moved 'netronome/nfp' into alphabetical order
---
 Documentation/networking/device_drivers/index.rst | 1 +
 Documentation/networking/j1939.rst                | 2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/Documentation/networking/device_drivers/index.rst b/Documentation/networking/device_drivers/index.rst
index f51f92571e39..c1f7f75e5fd9 100644
--- a/Documentation/networking/device_drivers/index.rst
+++ b/Documentation/networking/device_drivers/index.rst
@@ -23,6 +23,7 @@ Contents:
    intel/ice
    google/gve
    mellanox/mlx5
+   netronome/nfp
    pensando/ionic
 
 .. only::  subproject and html
diff --git a/Documentation/networking/j1939.rst b/Documentation/networking/j1939.rst
index ce7e7a044e08..dc60b13fcd09 100644
--- a/Documentation/networking/j1939.rst
+++ b/Documentation/networking/j1939.rst
@@ -272,7 +272,7 @@ supported flags are:
 * MSG_DONTWAIT, i.e. non-blocking operation.
 
 recvmsg(2)
-^^^^^^^^^
+^^^^^^^^^^
 
 In most cases recvmsg(2) is needed if you want to extract more information than
 recvfrom(2) can provide. For example package priority and timestamp. The
-- 
2.21.0

