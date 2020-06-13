Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F1681F855B
	for <lists+netdev@lfdr.de>; Sat, 13 Jun 2020 22:59:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726606AbgFMU7f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 13 Jun 2020 16:59:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726304AbgFMU7e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 13 Jun 2020 16:59:34 -0400
Received: from mail-lj1-x244.google.com (mail-lj1-x244.google.com [IPv6:2a00:1450:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 229D5C08C5C2
        for <netdev@vger.kernel.org>; Sat, 13 Jun 2020 13:59:33 -0700 (PDT)
Received: by mail-lj1-x244.google.com with SMTP id c17so14839861lji.11
        for <netdev@vger.kernel.org>; Sat, 13 Jun 2020 13:59:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cogentembedded-com.20150623.gappssmtp.com; s=20150623;
        h=to:cc:from:subject:organization:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=dKIG2VaXiv/7jVcKi9hIdNksBKJXSgeuBVh/YmceXNA=;
        b=k78RQW9huPhsd1GAU3CHUNUpV+ycs9X1b+iTcFv6o6T2SJVJgj5d+sCSMj19DzuLUG
         MTaTo2hJYwqmxcx3kL0lCMx8jDeHF6tcVKGDv2qe4DQnu+aeorDKie3Om+IXns5IhGcw
         WokIWiTDmwiTT8ZZF2/QMlmLTWUmqn/n+5N16fc/LvSwYbSR21KqOrfjB5zRvA/31N0s
         31vJDqONixDlI7XgGeESYQDTMmrElVexmXWe9n018K0h3aG3cS2PWeVY3K+vRondb8mN
         jGdPZi/klZHNGx06lHf774EbpKe+wHsEEM63NKh//OmdlWuDX56lk/kYmVpIGgxkjY5n
         fv6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:organization:message-id:date
         :user-agent:mime-version:content-language:content-transfer-encoding;
        bh=dKIG2VaXiv/7jVcKi9hIdNksBKJXSgeuBVh/YmceXNA=;
        b=l6RdBpGbXWJAkDEwkc/kKJ1X4qKDJ//ICAYXY1ha9YkmYyrdy/hLvV7LYCAGTg5A44
         aOQmNOWboxX6BvcEWGg/hE+HI9gBFFUJaDPVinVWTB9oHABrXtz9K5Qf4YIZzkRBJzbM
         KT1G7BG01G1Q/zwMjGQgd6iVPhe6+H94ihYPWzgMQeKCI4IDU3PT5EirnLEMdbR3pX9P
         yRiGlCf0uIKxDmF6HUnh1xO5QRNPAIFHPICdfKZylxDqfcSzmllpgQlmhhosj30hLKdO
         GHg4bdk7HYGF7m604soiPe2W9Uzcdj7WeOENYzv+3TIg+/aQGOst9slTkTMRZ5aTKP6r
         4tAg==
X-Gm-Message-State: AOAM5328y6PPoeVelH0YQRYweVdJEC8Z7BfjhTBsy1tyXPNxD4J6vePF
        5G+YGdM4/MgWZl1hHCxprkGA4A==
X-Google-Smtp-Source: ABdhPJyyVKvA7Kqh+U5hiWTD75AjPolOtfQ6N5BFWQYj81elocgEl1d9n1iIO75PwAqLY8x+JnDJhw==
X-Received: by 2002:a2e:a0ca:: with SMTP id f10mr9962551ljm.96.1592081971989;
        Sat, 13 Jun 2020 13:59:31 -0700 (PDT)
Received: from wasted.cogentembedded.com ([2a00:1fa0:2e2:84d1:c335:1451:e577:e115])
        by smtp.gmail.com with ESMTPSA id g12sm2848270ljl.33.2020.06.13.13.59.30
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 13 Jun 2020 13:59:31 -0700 (PDT)
To:     netdev@vger.kernel.org, David Miller <davem@davemloft.net>
Cc:     linux-renesas-soc@vger.kernel.org
From:   Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Subject: [PATCH] MAINTAINERS: switch to my private email for Renesas Ethernet
 drivers
Organization: Cogent Embedded
Message-ID: <b95930e8-0e6b-f37d-da51-afd682a4f1f6@cogentembedded.com>
Date:   Sat, 13 Jun 2020 23:59:30 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-MW
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Subject: MAINTAINERS: switch to my private email for Renesas Ethernet drivers

I no longer work for Cogent Embedded (but my old email still works :-)),
and still would like to continue looking after the Renesas Ethernet drivers
and bindings.  Let's switch to my private email.

Signed-off-by: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>

---
The patch is against the DaveM's 'net.git' repo.

 MAINTAINERS |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: net/MAINTAINERS
===================================================================
--- net.orig/MAINTAINERS
+++ net/MAINTAINERS
@@ -14494,7 +14494,7 @@ F:	Documentation/devicetree/bindings/i2c
 F:	drivers/i2c/busses/i2c-emev2.c
 
 RENESAS ETHERNET DRIVERS
-R:	Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
+R:	Sergei Shtylyov <sergei.shtylyov@gmail.com>
 L:	netdev@vger.kernel.org
 L:	linux-renesas-soc@vger.kernel.org
 F:	Documentation/devicetree/bindings/net/renesas,*.txt
