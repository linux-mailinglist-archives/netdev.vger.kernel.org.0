Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 088895B021
	for <lists+netdev@lfdr.de>; Sun, 30 Jun 2019 16:30:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726557AbfF3O35 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 Jun 2019 10:29:57 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:46722 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726500AbfF3O35 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 30 Jun 2019 10:29:57 -0400
Received: by mail-pg1-f196.google.com with SMTP id i8so1536846pgm.13;
        Sun, 30 Jun 2019 07:29:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:subject:message-id:mime-version:content-disposition
         :user-agent;
        bh=A7XL+qSvCLvsjTbzTI2K8VFDVm1pv1sO4YoeogNZP4U=;
        b=WocshXmMMY6BwgYpCy4zHm/Ouj9z7d7H/lj+vQDCYBdpdAy8OUaopHsgnr6Y+B97Fs
         Yo8D5vpgW/gh1ZWd06NpV00WlHlxcGZREd2lHacooXqMV0qV5Dlk9auViSk7sdp26KIw
         1yjz9ZLxDkJo3nx1NHI2I/d14RslPvZsWWOLh5Q4G8zaaXLmU3+/E1Fd4cib1YDZEXJE
         1rL2THNoIjoXaICsqz1rre+zLSWJxtoU9XuW2bdBTe0JzVWZLi7PDz0dZXvr+0LPFvlh
         /cpNCJQVjE5PKrneKsWW7v700qI0IpquHQw5+IDA2sJPkqQYBOPqv05BB2iAYvpCBDGm
         kgYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=A7XL+qSvCLvsjTbzTI2K8VFDVm1pv1sO4YoeogNZP4U=;
        b=GF0qkCZ//xcI/d/Za84MdNVEfsZ6BzG4SXfQfdVkrZZ9/HkGhMa2d6XbKn2W/+kq02
         90QqKvr4oQCnJbtybrfH9tcMOHTNuh2D6Q/Xrc3EqiBq/kIa76CgdPW48AwS86z5xu9E
         P/FQ07x3PmSJUZflea3CzC+dqx2uZePrI90lFqc5bJm5fc3ssu+VaglzhwfiC03MI8vX
         v7pc7pVoJpdAGbOLDhiQYhfKYwAYyAiExHD61XxGlwKqQxhpeXWjHP2dG4pQ83U54EHY
         3irZq0Htp2mW3loGhXkYEKuRQDJAjng5jdD0/Q508t/03qlaGudxCAJvUkZUEIrmmbrj
         q4CQ==
X-Gm-Message-State: APjAAAUChYvQXlzUvYitkJIp/gtAbgTUwqb89OxrOyY+k9QwaI2tQAu3
        U+r0xT3586hc1jRrLLRYvoU=
X-Google-Smtp-Source: APXvYqyUF3CwPFMn20FOljcrALPcEPpdki7WvtU6sHNL98Jy13f9+56fQo1hMMyrcAo/c/1QtOELnA==
X-Received: by 2002:a63:1a5e:: with SMTP id a30mr18908127pgm.433.1561904996250;
        Sun, 30 Jun 2019 07:29:56 -0700 (PDT)
Received: from hari-Inspiron-1545 ([183.83.164.161])
        by smtp.gmail.com with ESMTPSA id t8sm7930660pfq.31.2019.06.30.07.29.52
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 30 Jun 2019 07:29:55 -0700 (PDT)
Date:   Sun, 30 Jun 2019 19:59:49 +0530
From:   Hariprasad Kelam <hariprasad.kelam@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        bcm-kernel-feedback-list@broadcom.com,
        Andrew Lunn <andrew@lunn.ch>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Hariprasad Kelam <hariprasad.kelam@gmail.com>,
        YueHaibing <yuehaibing@huawei.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Luis Chamberlain <mcgrof@kernel.org>, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH] net: ethernet: broadcom: bcm63xx_enet: Remove unneeded memset
Message-ID: <20190630142949.GA7422@hari-Inspiron-1545>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Remove unneeded memset as alloc_etherdev is using kvzalloc which uses
__GFP_ZERO flag

Signed-off-by: Hariprasad Kelam <hariprasad.kelam@gmail.com>
---
 drivers/net/ethernet/broadcom/bcm63xx_enet.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bcm63xx_enet.c b/drivers/net/ethernet/broadcom/bcm63xx_enet.c
index 85e6102..f2dd74c 100644
--- a/drivers/net/ethernet/broadcom/bcm63xx_enet.c
+++ b/drivers/net/ethernet/broadcom/bcm63xx_enet.c
@@ -2659,8 +2659,7 @@ static int bcm_enetsw_probe(struct platform_device *pdev)
 	if (!dev)
 		return -ENOMEM;
 	priv = netdev_priv(dev);
-	memset(priv, 0, sizeof(*priv));
-
+
 	/* initialize default and fetch platform data */
 	priv->enet_is_sw = true;
 	priv->irq_rx = irq_rx;
-- 
2.7.4

