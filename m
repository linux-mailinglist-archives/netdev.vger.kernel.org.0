Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43B5C427E49
	for <lists+netdev@lfdr.de>; Sun, 10 Oct 2021 03:57:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231295AbhJJB6Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Oct 2021 21:58:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230284AbhJJB6O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 Oct 2021 21:58:14 -0400
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C22BC061768;
        Sat,  9 Oct 2021 18:56:16 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id ec8so2253190edb.6;
        Sat, 09 Oct 2021 18:56:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=4esTCtJZXuuOiwPupffGXoBpgDSTRt7QTWWMeZINX1g=;
        b=XaOjCro+2o9mPh6DhyzOr891TD2yLi5LXYEdXlMPGWsdUMYCvEKTV2k6az44WllLV8
         2HatQwvH+NpeRVMzuPA6GjLNMmi69Mz/jlLR/tMhaG2JPme8Jl1Wgqjsi/cQNUayah72
         qD6KsgV7z3kj4g3RMbgctuhBkqzzBa56oH5UMDe3UGM39JAdki0XAyyVEIUxLH04Ytwd
         WbaL0TZG+lUtioDfEmj58u79Dm7oMSAW2C+I0wITKm167J0eDLF86hGk6cBDixQEl6Ic
         oLfOaDWzhbCa4qE6Svxn5wgG14iMJk2UT5gCe2sBNw++QCLWRLHqqP2vX0RaACdacpyi
         Kqtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4esTCtJZXuuOiwPupffGXoBpgDSTRt7QTWWMeZINX1g=;
        b=Y2Tum8T8y3K5aOh5/UVD0BbAnzJJXiP1ucYSmvw/cZkudSFm4XHo3zILIuilN0t9Ws
         RxXHb4i3hZ1OIgAspCTGjqwG347pz2W8RDn2tUgOGYLde67zZAEPtR9bdar1Ru2Z19D/
         ENvgqVkuCxJ0ebB60xYQ5QisTzkGhLI1SiNp0Nemd13NIKqM5a9S1XIGgxGf5lh18yjv
         wcxT7gNZjULgge5GGROWqj3ihwKIwgOLy6zxfAq72hb1Cny5j6qjUhpssKdiNiMeF5tb
         PkDjTqrZM2c52P2wmVM+36x3sfST0Z0NcP5MxVRGZ8DeB3PzKFsghUu/cdPruILQrvjd
         orJQ==
X-Gm-Message-State: AOAM5324sj9PI1fIb3rUlqXt1cMM0RrcqJ2BPDXGYopkmP2CCfEbO6Wm
        LkW30GukLiQGiol4XwRJ4+Y=
X-Google-Smtp-Source: ABdhPJx5EMgoACTwKyIFeXCuH5qFNSgDIAYRIxZ0ELK+In998YAsEzZK0VdZSB12kSX412MURzFi8w==
X-Received: by 2002:a05:6402:34d2:: with SMTP id w18mr21547078edc.172.1633830974943;
        Sat, 09 Oct 2021 18:56:14 -0700 (PDT)
Received: from Ansuel-xps.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.googlemail.com with ESMTPSA id x11sm1877253edj.62.2021.10.09.18.56.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 09 Oct 2021 18:56:14 -0700 (PDT)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Ansuel Smith <ansuelsmth@gmail.com>
Subject: [net-next PATCH v3 05/13] dt-bindings: net: dsa: qca8k: Document support for CPU port 6
Date:   Sun, 10 Oct 2021 03:55:55 +0200
Message-Id: <20211010015603.24483-6-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211010015603.24483-1-ansuelsmth@gmail.com>
References: <20211010015603.24483-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The switch now support CPU port to be set 6 instead of be hardcoded to
0. Document support for it and describe logic selection.

Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
---
 Documentation/devicetree/bindings/net/dsa/qca8k.txt | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/net/dsa/qca8k.txt b/Documentation/devicetree/bindings/net/dsa/qca8k.txt
index cc214e655442..aeb206556f54 100644
--- a/Documentation/devicetree/bindings/net/dsa/qca8k.txt
+++ b/Documentation/devicetree/bindings/net/dsa/qca8k.txt
@@ -29,7 +29,11 @@ the mdio MASTER is used as communication.
 Don't use mixed external and internal mdio-bus configurations, as this is
 not supported by the hardware.
 
-The CPU port of this switch is always port 0.
+This switch support 2 CPU port. Normally and advised configuration is with
+CPU port set to port 0. It is also possible to set the CPU port to port 6
+if the device requires it. The driver will configure the switch to the defined
+port. With both CPU port declared the first CPU port is selected as primary
+and the secondary CPU ignored.
 
 A CPU port node has the following optional node:
 
-- 
2.32.0

