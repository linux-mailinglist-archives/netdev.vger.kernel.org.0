Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 61869EE78A
	for <lists+netdev@lfdr.de>; Mon,  4 Nov 2019 19:42:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729619AbfKDSmX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Nov 2019 13:42:23 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:53879 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728322AbfKDSmW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Nov 2019 13:42:22 -0500
Received: by mail-wm1-f65.google.com with SMTP id x4so6714735wmi.3
        for <netdev@vger.kernel.org>; Mon, 04 Nov 2019 10:42:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=ZQeDMNLtAE2aTlNwur2MGyCnS7Gedgp0o+XTo1rLWg8=;
        b=Kr9xCb2jShlEgTn8pdxb6p0zgvQcRmR80T+BHrVJUIaXzl9O2gAUsPq3Kawre6u35O
         bQc5vKaDctMk9Zsla05oKEEQM8CCsCtbDie1DC53sgK+AgPzQjO4TCx7YALPW1MPZuR6
         Udbd/YN8j6vUfuoKNja13RsjlqcW48kxrvZivx1R4ECwGqoW/4YvDdW0wBibwOMNP7ze
         kU4KFOBW9vzObj+jkba8wQLPiJTqzJTIXoXiEi8yt5ONZW4NvXSfFBP4RjIIefG+v4J6
         8aHFfmsis6wZGwwy12DuQ1TdIcUSok7PKU+NL7aHR2yylAbQQpKDSvIr1rba9kST4jMq
         N1/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=ZQeDMNLtAE2aTlNwur2MGyCnS7Gedgp0o+XTo1rLWg8=;
        b=UGEBhVSs5+fzaH4ezEnoN5zhG3OsVh2tdctNUlUQ1KgZTUcVOhlk7toTmHpn/JCf3b
         cojQOgVGHUEhn/rSzpiwJdj33orcsFYoWAXq6jGC2DgkQKXeL3u9mzDPULuURBrdfiKz
         lHoktWq9/IMi2z/Tc7jJYroM9hcunoRl6wq++Bu7yOR3h1bnziexoTXTZnWKPLhQAWDD
         ZBE2r587fEpqHO1EtRYtcVdw39eUli7Y0l8RMXBQb6eS1tL43Ok/JRkkUzl2QF0tdXn5
         m5VQzFXjxo5DMNgBtUC6FmwK0MA3ixwqZPYVycEvF1uJ9crnwCKRY/kkiaDbGknyjMPe
         Ttsw==
X-Gm-Message-State: APjAAAV3uD2K0ZTCyOGvOuAUgOcz3knvzhUN0TgQs7M/9U1C6bkp3FH0
        7E4aPff/Cz0flw012QiZXymL7vBa
X-Google-Smtp-Source: APXvYqwIx0oLF5GV1WSmNYmf6tjsbxdS6fH9PkfGYN+ZosJZhynWZtHxGKLGw/Y5aopzveDbzNDaXg==
X-Received: by 2002:a05:600c:2919:: with SMTP id i25mr459274wmd.158.1572892940415;
        Mon, 04 Nov 2019 10:42:20 -0800 (PST)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id l2sm16586993wrt.15.2019.11.04.10.42.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Nov 2019 10:42:19 -0800 (PST)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>, andrew@lunn.ch,
        vivien.didelot@gmail.com, davem@davemloft.net,
        Jakub Kicinski <jakub.kicinski@netronome.com>
Subject: [PATCH net-next 1/2] dt-bindings: net: Describe BCM7445 switch reset property
Date:   Mon,  4 Nov 2019 10:42:02 -0800
Message-Id: <20191104184203.2106-2-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191104184203.2106-1-f.fainelli@gmail.com>
References: <20191104184203.2106-1-f.fainelli@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The BCM7445/BCM7278 built-in Ethernet switch have an optional reset line
to the SoC's reset controller, describe the 'resets' and 'reset-names'
properties as optional.

Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 .../devicetree/bindings/net/brcm,bcm7445-switch-v4.0.txt    | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/brcm,bcm7445-switch-v4.0.txt b/Documentation/devicetree/bindings/net/brcm,bcm7445-switch-v4.0.txt
index b7336b9d6a3c..48a7f916c5e4 100644
--- a/Documentation/devicetree/bindings/net/brcm,bcm7445-switch-v4.0.txt
+++ b/Documentation/devicetree/bindings/net/brcm,bcm7445-switch-v4.0.txt
@@ -44,6 +44,12 @@ Optional properties:
   Admission Control Block supports reporting the number of packets in-flight in a
   switch queue
 
+- resets: a single phandle and reset identifier pair. See
+  Documentation/devicetree/binding/reset/reset.txt for details.
+
+- reset-names: If the "reset" property is specified, this property should have
+  the value "switch" to denote the switch reset line.
+
 Port subnodes:
 
 Optional properties:
-- 
2.17.1

