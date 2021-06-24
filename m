Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1652A3B31D0
	for <lists+netdev@lfdr.de>; Thu, 24 Jun 2021 16:55:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232220AbhFXO6F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Jun 2021 10:58:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230008AbhFXO6E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Jun 2021 10:58:04 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DB22C061574;
        Thu, 24 Jun 2021 07:55:44 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id c7so8948081edn.6;
        Thu, 24 Jun 2021 07:55:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=jyh0qZZOSEyMXCaNjFKISCMuG9u1EE4acEpsTgDD8a8=;
        b=lBWA31DutdjoiIpw88ijtJ/SlUiPk5I850kb/xBDKJcHL3ofPv6PIjYAEXCSmSDr9X
         S2Q/Q/FW7Yn3srUrwgdMtRyBTHQZrp6irytVVNykmV92AJZV7jqKZmR2qXrCeLJwh1+s
         QCXl6VczyFMSbk5h08HJ3zMYUGojIScpi5R6GuKo7lVFpBQuPc7mpI3kxXhgMEClHHnh
         OUPCompArzwjJN+EHt99CrMDTZc+YiPsI1zGrfLSYSytZK9/0YNXcIDvNxw/nUO0Sxhq
         qfkcjUma1h5cK2IFxqaGikZG/KnLhQHAikN86+VObWzzdbAbK/319NII1OxLRGFkKcDe
         FaTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=jyh0qZZOSEyMXCaNjFKISCMuG9u1EE4acEpsTgDD8a8=;
        b=s/vQ0RqB7T1yis09OXxnCM8A+eThDNsztd9UfpXxeNvhDG5aPluCuhnsUK5ujZR/Wz
         1/Yz4oreogMG6I/uBaYlMp8bDNWnYzQKnQiXcaLKnkHBX7J+XUzBkzyYspDMGjNn7oA8
         OasEruRV28cCyE354enQQ2ZgfzBLScEpL+sD+VVr5ZY9cnjYrNaFaG5I6ZcyGTW4kAdl
         4bdOd4OO2T6fgvIj7U3QT6Vn+OvePTu3nL9n9p1Wd++3Lip1dT79QYBLngAShV+AE3pV
         gz6EIk10j6dZjSBJsE9HV+SrqSCT/1aFZuW/mzgWC0WP3IQCnECrPibwB4Xg6gr47Wja
         Picw==
X-Gm-Message-State: AOAM533ZE5pkbTyswtkijN6QYDjkygfZWh2EHrw6gZ8ekIjYMCFAEOTD
        3zFU1BUPgnF00hk/lfx10ZCmsB+X0cc=
X-Google-Smtp-Source: ABdhPJxsz4raQz+bkHxP1L5cFIC4IKnCdvXgcwUeQua+0iaujWi1JeBKaW/1SQY5bbHp9ZqNisZRug==
X-Received: by 2002:a05:6402:31b4:: with SMTP id dj20mr7923993edb.186.1624546542690;
        Thu, 24 Jun 2021 07:55:42 -0700 (PDT)
Received: from localhost.localdomain ([188.26.224.68])
        by smtp.gmail.com with ESMTPSA id n2sm2034061edi.32.2021.06.24.07.55.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Jun 2021 07:55:42 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH net-next 0/2] Document the NXP SJA1110 switch as supported
Date:   Thu, 24 Jun 2021 17:55:22 +0300
Message-Id: <20210624145524.944878-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

Now that most of the basic work for SJA1110 support has been done in the
sja1105 DSA driver, let's add the missing documentation bits to make it
clear that the driver can be used.

Vladimir Oltean (2):
  Documentation: net: dsa: add details about SJA1110
  net: dsa: sja1105: document the SJA1110 in the Kconfig

 Documentation/networking/dsa/sja1105.rst | 61 ++++++++++++++++++++++--
 drivers/net/dsa/sja1105/Kconfig          |  8 +++-
 2 files changed, 63 insertions(+), 6 deletions(-)

-- 
2.25.1

