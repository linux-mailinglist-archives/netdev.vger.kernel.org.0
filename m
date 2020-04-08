Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5F4811A2BC0
	for <lists+netdev@lfdr.de>; Thu,  9 Apr 2020 00:10:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726492AbgDHWKa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Apr 2020 18:10:30 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:39875 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726467AbgDHWKa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Apr 2020 18:10:30 -0400
Received: by mail-wm1-f67.google.com with SMTP id y24so1684092wma.4
        for <netdev@vger.kernel.org>; Wed, 08 Apr 2020 15:10:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=oE7Hj9Syoi/cKdQThdKFHNgx6mBLmKlQozrjLnYoP+8=;
        b=ezqMMHUSpFvEEXo0YBUv2IcKzZDxta4M+pwGGuJV+ORMWyIUwts7ArO8syv/yI0y6h
         Hv9WzN5anLyG0QwzNvm1l2zbkuW8lfvoHYgf9d/b5ANTCiM1wsB6XddThBMEZzjnzX01
         fs6JLPI5oqM4y1FVpA+IahpvR9xZle/NRaP2Si2Oypbs9xYae3UC2Fia9jC/JOUsCmcJ
         icY+BGZO/Fwh+T6USqeEplzNPS1r3lcTii9DwR6rlCJ4wIzLl2dxRgxsghFo+pTqN5+T
         yq9QFbgsrZONTRL8fcLfNGxrdRnf47qzzhEy1aq087F0zPDNmc2tqa/45C567GBeVI1c
         KSug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=oE7Hj9Syoi/cKdQThdKFHNgx6mBLmKlQozrjLnYoP+8=;
        b=PbEtUkNtol2lTghWoogTvOaPQMK+lQ/3AQNao/s1R6BgLmZB/91kcpB+Y0wFLCi+6D
         PK2HuNweV68IXgNkl17Xtw6QhuTc+Hs0n59lRjMDqbg05kBN8PBYI8iLj6bHQHoc6P7u
         xJOdvyd6g6CZXoMh/4JRwsQAXVNLCzQ08pyg03OSkgzhI1qhNEO8C2Ud3GvjnSmoDxBP
         X7Kdfln1zHNphucrFv9FHHCFleEAXntjMw/KH0C1kPAU53RiReR9EiDxNv1nN6hBAVzW
         f+7HVkEwGdVOkRo2lRd7CVAmkOXShCD0EdC5qlFJI4uD6Usue7G/Hx/Z4MarnVsxNx3G
         M/+w==
X-Gm-Message-State: AGi0PuY6z+uYekQ/m53EB0d4bITKSkhCV+0h7V+Tl+5PQc61C/rzd8Q6
        walIJjSbMWwvgYUkpMyOhHg=
X-Google-Smtp-Source: APiQypLllDnKC9Q7Q5VvaFO9nxjgiJlhM+/ZjscMuqvH4kLTUadkIX/W7osI0DFmts+TGIYplE100Q==
X-Received: by 2002:a7b:cd89:: with SMTP id y9mr7012756wmj.102.1586383828503;
        Wed, 08 Apr 2020 15:10:28 -0700 (PDT)
Received: from de0709bef958.v.cablecom.net ([45.87.212.59])
        by smtp.gmail.com with ESMTPSA id k84sm1164271wmk.2.2020.04.08.15.10.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Apr 2020 15:10:28 -0700 (PDT)
From:   Lothar Rubusch <l.rubusch@gmail.com>
To:     jiri@mellanox.com, davem@davemloft.net, kuba@kernel.org,
        corbet@lwn.net
Cc:     netdev@vger.kernel.org, Lothar Rubusch <l.rubusch@gmail.com>
Subject: [PATCH] Documentation: devlink: fix broken link warning
Date:   Wed,  8 Apr 2020 22:09:31 +0000
Message-Id: <20200408220931.27532-1-l.rubusch@gmail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

At 'make htmldocs' the following warning is thrown:

Documentation/networking/devlink/devlink-trap.rst:302:
WARNING: undefined label: generic-packet-trap-groups

Fixes the warning by setting the label to the specified header,
within the same document.

Signed-off-by: Lothar Rubusch <l.rubusch@gmail.com>
---
 Documentation/networking/devlink/devlink-trap.rst | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/Documentation/networking/devlink/devlink-trap.rst b/Documentation/networking/devlink/devlink-trap.rst
index a09971c2115c..fe089acb7783 100644
--- a/Documentation/networking/devlink/devlink-trap.rst
+++ b/Documentation/networking/devlink/devlink-trap.rst
@@ -257,6 +257,8 @@ drivers:
   * :doc:`netdevsim`
   * :doc:`mlxsw`
 
+.. _Generic-Packet-Trap-Groups:
+
 Generic Packet Trap Groups
 ==========================
 
-- 
2.20.1

