Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 33AEC193020
	for <lists+netdev@lfdr.de>; Wed, 25 Mar 2020 19:12:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727943AbgCYSME (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Mar 2020 14:12:04 -0400
Received: from mail-ed1-f100.google.com ([209.85.208.100]:45287 "EHLO
        mail-ed1-f100.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727705AbgCYSMD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Mar 2020 14:12:03 -0400
Received: by mail-ed1-f100.google.com with SMTP id u59so3687073edc.12
        for <netdev@vger.kernel.org>; Wed, 25 Mar 2020 11:12:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=flowbird.group; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=KKpKhLhaC9HGAwcc/wCEo8PVI3BgJbUGYTvCaeR49Ok=;
        b=rrNk6KcxURyxMqPmDLj2w7bRmiDPMbUI0d/kn5MoPrEUo33YzVn3zrxcuD85NeIErE
         +uGfzC7ut3SYcHQaLhmVWeUTDF73/vZGMa7Ku0Mz/KEWdWqxjWZHRLrkQP0RfXWMGD0m
         g8VbKMTkYncsJmDzeZV4BiiiM5zYJmPUIi2Cs4pHzaY5pWLRtjTfZVHxHP9YFhI9gv2h
         /soDGEdt35MheO4BaZk6KhmtRX4IfSR4z5IKnqcXCOr/49iFIdKQh5jwWJD6BMQDXElL
         to2vidpfeVH7HdXqu2o5MY3gopz3yUWfxHW8arc0tljoE4wT5MR3wxtPfBk3kpMziCWj
         MZ5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=KKpKhLhaC9HGAwcc/wCEo8PVI3BgJbUGYTvCaeR49Ok=;
        b=HUJQ+mgtQV+5dvDsYbYGAy3Ib3jZHmrgFtMUWmDejx+Y64aeYm/D6i1h+KJqZQ4dCo
         Wt6yVG8SEJ0G6lDxIa47cmiRT7BMKYHDRgIg4WLjRLUGrkdww+EuylaremSiGBBQS7F1
         IK6YKJWjXDPuVtouV8w3V4fee/zqkuL7HFGDTcHWUaL480NYPIK7w3aZfxNdCukMCE6l
         FiO0dUmPygUpX9R88SU281ssbRePA6NZeyRLV+rolVzngrdax27neNYKYWW3GtErbUZ3
         Rmwx7aMXe1Oh7FFaO78N2dQM9sPnJSF3FWYfoyArF+m52/YnnYRVv821Sy+ogkq1GHsN
         f8ZA==
X-Gm-Message-State: ANhLgQ3OB8LPGMTGl9CGj+q/jutfVHUyjeV+ohkFLZTUhBB6z4PcIrcJ
        fHPEo4iN0b6c4GbuWj2JrPxIjNL61QRDm3SUvbzYeFwMht98
X-Google-Smtp-Source: ADFU+vuep+cArUuYfyT4aIlU+oz4LwkVg1M9a67K8D0RfGmqdTIIjC4kRTkukTB5EAVMq2zHqSjAPESSkERj
X-Received: by 2002:a17:906:1cc9:: with SMTP id i9mr2034588ejh.0.1585159920479;
        Wed, 25 Mar 2020 11:12:00 -0700 (PDT)
Received: from mail.besancon.parkeon.com ([185.149.63.251])
        by smtp-relay.gmail.com with ESMTPS id x25sm182281edl.7.2020.03.25.11.12.00
        (version=TLS1 cipher=AES128-SHA bits=128/128);
        Wed, 25 Mar 2020 11:12:00 -0700 (PDT)
X-Relaying-Domain: flowbird.group
Received: from [172.16.13.190] (port=39524 helo=PC12445-BES.dynamic.besancon.parkeon.com)
        by mail.besancon.parkeon.com with esmtp (Exim 4.71)
        (envelope-from <martin.fuzzey@flowbird.group>)
        id 1jHAVT-0003Oy-U9; Wed, 25 Mar 2020 19:12:00 +0100
From:   Martin Fuzzey <martin.fuzzey@flowbird.group>
To:     Fugang Duan <fugang.duan@nxp.com>,
        Rob Herring <robh+dt@kernel.org>,
        Shawn Guo <shawnguo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, Fabio Estevam <festevam@gmail.com>,
        linux-kernel@vger.kernel.org,
        Sascha Hauer <s.hauer@pengutronix.de>,
        NXP Linux Team <linux-imx@nxp.com>,
        devicetree@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH v2 3/4] dt-bindings: fec: document the new gpr property.
Date:   Wed, 25 Mar 2020 19:11:58 +0100
Message-Id: <1585159919-11491-4-git-send-email-martin.fuzzey@flowbird.group>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1585159919-11491-1-git-send-email-martin.fuzzey@flowbird.group>
References: <1585159919-11491-1-git-send-email-martin.fuzzey@flowbird.group>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This property allows the gpr register bit to be defined
for wake on lan support.

Signed-off-by: Martin Fuzzey <martin.fuzzey@flowbird.group>
---
 Documentation/devicetree/bindings/net/fsl-fec.txt | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/fsl-fec.txt b/Documentation/devicetree/bindings/net/fsl-fec.txt
index 5b88fae0..ff8b0f2 100644
--- a/Documentation/devicetree/bindings/net/fsl-fec.txt
+++ b/Documentation/devicetree/bindings/net/fsl-fec.txt
@@ -22,6 +22,8 @@ Optional properties:
 - fsl,err006687-workaround-present: If present indicates that the system has
   the hardware workaround for ERR006687 applied and does not need a software
   workaround.
+- gpr: phandle of SoC general purpose register mode. Required for wake on LAN
+  on some SoCs
  -interrupt-names:  names of the interrupts listed in interrupts property in
   the same order. The defaults if not specified are
   __Number of interrupts__   __Default__
-- 
1.9.1

