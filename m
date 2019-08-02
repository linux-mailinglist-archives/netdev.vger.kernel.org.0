Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CA971801B3
	for <lists+netdev@lfdr.de>; Fri,  2 Aug 2019 22:23:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436962AbfHBUXg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Aug 2019 16:23:36 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:39010 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2436954AbfHBUXg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Aug 2019 16:23:36 -0400
Received: by mail-qt1-f193.google.com with SMTP id l9so75181389qtu.6;
        Fri, 02 Aug 2019 13:23:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=7b+QpyZJy6WVG+CsDdFzQqS3UP4BUviIhmtTS57SLxI=;
        b=Efl24pIIAWTWx/nSPf8qxs1ZdBAjZceq8NkYlGnae0RIl+ZKMw339lWIdlkxxn4PD8
         LLQuPj9yp5pqYUC5/1w7dIDh7FbAFJEqm1vWWNN1my3zWreokDhXB8eTJ6WWbz6sdT5a
         7EjatRff4kM50cooNbVjk13Ru0PTpDhOOmj5vN1s1TUR41Yv4NSwps4icALMfgXhx6ci
         dp7aczZfvp+7Rhiwjsiz7sfvjSHexhT5mfldf1gVYbIpwqzlWIHCFojSR3y+OoVjudW/
         uRgR8KlY0316lBONQG0moGnOy/hglJXHhhgYHwl5PvDId86NwAfEuJ4ZEwc1WEroiXQx
         CKWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=7b+QpyZJy6WVG+CsDdFzQqS3UP4BUviIhmtTS57SLxI=;
        b=VwLM0+i/MVu5CfAdrhZAxE6bPuegXkarvSm4ELps5n1PKIpyjd5prhewxpHDIeNe9p
         EC6aTiqEkZ1wc5pgPXrvMh5SdC6KCPTRWw6dWtm+PRcGrZoh1fOt60Tu8BZ566SPCRLG
         YfidWNCIJyEA8JL6bWv9pgeRO3E6lvhZ+ttR2QfXvbT4VhOnFs1x+w1RugljrUdisJuL
         tp+coupFe+5jB2RBbFj8aVIqlTfGeez2St7Aqe21ojfmPP2bymOIAbEOHExBJLCxbrMR
         WGJbxriaL89bkVzermFjdBN1ot9t4vCKnbyzdJwJJwsF8aeqVH4wHEldKjKJHI4KyHYD
         HVyQ==
X-Gm-Message-State: APjAAAVvAJ5AYTOCRdSYF77980yfKnYso8mzwDNPGfiN+KAkreGWvfWT
        kczWBbKE1NAAPeHpSkx0kByhICV4MQu7Bg==
X-Google-Smtp-Source: APXvYqxng4ujPdMSOl8LXJMqkhOtwXaWv/1GkHPTS6Mif0yJO/ekUiIXcAXJ4oiId/EKiwuZviAUGw==
X-Received: by 2002:aed:3f29:: with SMTP id p38mr95861962qtf.126.1564777415353;
        Fri, 02 Aug 2019 13:23:35 -0700 (PDT)
Received: from 541fc7a84f4a.ime.usp.br ([143.107.45.1])
        by smtp.gmail.com with ESMTPSA id y9sm32294338qki.116.2019.08.02.13.23.33
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 02 Aug 2019 13:23:34 -0700 (PDT)
From:   Thiago Bonotto <thbonotto@gmail.com>
To:     Karsten Keil <isdn@linux-pingi.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        netdev@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, lkcamp@lists.libreplanetbr.org
Subject: [PATCH] staging: isdn: remove unnecessary parentheses
Date:   Fri,  2 Aug 2019 20:23:23 +0000
Message-Id: <20190802202323.27117-1-thbonotto@gmail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix the following checkpatch error:

ERROR: return is not a function, parentheses are not required
FILE: drivers/staging/isdn/hysdn/hysdn_net.c:289:
+        return (0);                /* and return success */

Signed-off-by: Thiago Bonotto <thbonotto@gmail.com>
---
Hello, this is my first contribution :)
Thanks for reviewing 

 drivers/staging/isdn/hysdn/hysdn_net.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/isdn/hysdn/hysdn_net.c b/drivers/staging/isdn/hysdn/hysdn_net.c
index bea37ae30..dcb9ef7a2 100644
--- a/drivers/staging/isdn/hysdn/hysdn_net.c
+++ b/drivers/staging/isdn/hysdn/hysdn_net.c
@@ -286,7 +286,7 @@ hysdn_net_create(hysdn_card *card)
 
 	if (card->debug_flags & LOG_NET_INIT)
 		hysdn_addlog(card, "network device created");
-	return (0);		/* and return success */
+	return 0;		/* and return success */
 }				/* hysdn_net_create */
 
 /***************************************************************************/
-- 
2.20.1

