Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0846633D2E5
	for <lists+netdev@lfdr.de>; Tue, 16 Mar 2021 12:25:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234168AbhCPLYn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 07:24:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232781AbhCPLYd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Mar 2021 07:24:33 -0400
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AA2FC06175F
        for <netdev@vger.kernel.org>; Tue, 16 Mar 2021 04:24:33 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id b16so8273822eds.7
        for <netdev@vger.kernel.org>; Tue, 16 Mar 2021 04:24:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=GA9KgPbXCjkkZMOpk0TLpFUUrFcKnH4dAm++pMGhu5w=;
        b=g0yjYL3Z0UTZJBCmjrPhILlc4jjnhvXRh485ONS9xWcizzVn83RB75LImgbLAOpju8
         qwIJIWJnAcszuJ1OJa3lnrl8MQZ0FvA++hijJP1UEseWJpVitS3RuFo5yw1RxGvKQg1j
         PKM9b+pJ6OZkMWL0+HDIbVi8e4F/XRWCOkHO+RCWUW5nyyqbLUMl8qPU4b/zohTGi8CJ
         diipajsiS80LyVU3rLqYWCFQOpk1a1CUiK07GU9EGIQ+x0WrSZfk3w7c7oos+uWcm6SO
         E0JzgYWm00TO1nVaEIl05hmVB5/qJF/tuoH1ktua5sywxYsT44x2KmNJNGsJw76GiNlq
         i9MA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=GA9KgPbXCjkkZMOpk0TLpFUUrFcKnH4dAm++pMGhu5w=;
        b=m0TTD1/l7lSAqGXpYPFp1a/vxLD+Q34NRqga1e8ogKE5LCJWOuII7P0+jd+1x55JLl
         U8tAxqpihubX19YgGQlvLZDkxS8NynSMwJ6BkbeWS2qbB+58XbFz3934ROpp6MDAu0Az
         9ZzElcK3Ho/EqIMXbtxZgRwTPP1zkRnVlpzCM2q36o6LFObWAwdeb8J7VEko/4v6FETK
         Xeij45TV5YgKSMACS27QQOZz/HUq7rfRBpFE7Bz30xbGq9CtuyMyOWGgRh0+kjdgENo8
         zXGyFjEtCbDwXN5uQK4vjeHuSd2/X+KcNEcH5gC+iFAYnWOFYzWrKKnVuXLut53HToBA
         tyEw==
X-Gm-Message-State: AOAM530phoCamtG8ZQblTdCmZBa6eyyQs13prlWPCShkQujPNLw98fVL
        vLo78GFSUDLBjAmwAz7iT+GC6sEvHdc=
X-Google-Smtp-Source: ABdhPJzncDxSEzulEBaROIldXV2k5velXNnyV7gsA+nULEvWYf72gdqnhLowPn0cI4Hz+XtvR9oxdQ==
X-Received: by 2002:aa7:cd54:: with SMTP id v20mr35756970edw.80.1615893871931;
        Tue, 16 Mar 2021 04:24:31 -0700 (PDT)
Received: from localhost.localdomain (5-12-16-165.residential.rdsnet.ro. [5.12.16.165])
        by smtp.gmail.com with ESMTPSA id y12sm9294825ejb.104.2021.03.16.04.24.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Mar 2021 04:24:31 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ido Schimmel <idosch@idosch.org>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH v2 net-next 05/12] Documentation: networking: dsa: remove TODO about porting more vendor drivers
Date:   Tue, 16 Mar 2021 13:24:12 +0200
Message-Id: <20210316112419.1304230-6-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210316112419.1304230-1-olteanv@gmail.com>
References: <20210316112419.1304230-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

On one hand, the link is dead and therefore useless.

On the other hand, there are always more drivers to port, but at this
stage, DSA does not need to affirm itself as the driver model to use for
Ethernet-connected switches (since we already have 15 tagging protocols
supported and probably more switch families from various vendors), so
there is nothing actionable to do.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
---
 Documentation/networking/dsa/dsa.rst | 2 --
 1 file changed, 2 deletions(-)

diff --git a/Documentation/networking/dsa/dsa.rst b/Documentation/networking/dsa/dsa.rst
index ced2eb6d647a..b90a852e5329 100644
--- a/Documentation/networking/dsa/dsa.rst
+++ b/Documentation/networking/dsa/dsa.rst
@@ -699,5 +699,3 @@ Other hanging fruits
 
 - allowing more than one CPU/management interface:
   http://comments.gmane.org/gmane.linux.network/365657
-- porting more drivers from other vendors:
-  http://comments.gmane.org/gmane.linux.network/365510
-- 
2.25.1

