Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7BAE9C40E4
	for <lists+netdev@lfdr.de>; Tue,  1 Oct 2019 21:21:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726864AbfJATSa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Oct 2019 15:18:30 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:38383 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726411AbfJATS3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Oct 2019 15:18:29 -0400
Received: by mail-wm1-f67.google.com with SMTP id 3so4454381wmi.3
        for <netdev@vger.kernel.org>; Tue, 01 Oct 2019 12:18:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=D7lIoy29V1yplyvmw6IyDtPoaLPek92Jx/misBZ4I3I=;
        b=C6AH/dyQ83PYR/eLNazDwpiFP9jGlYhJYCSLeWXJerHscYM1jEIx84mP4fSgRNSOFd
         /WSlvtbreHCZi+ZS/jFf2+XLCXy0VlpDfZDhLJvxbJm5h41cvYM5QAjY0h+I0V+Im75H
         8ARzqZGiMdYNBH3KhTYwx2XRAgRlNOibtH+PqGWOUvxQjAUkQAL15HSrEPcrXJu28pRA
         RTvGohLAG9Y/YuOpAqHshpfrNEDckshR0v1pXAvH/GnpMrUuNvWbUoya5hJFU1Sv7H6V
         vY+sBCH6gPv8JwAPmcHluPepqiuznV7DtGbvBIT2DfKK7B+sqx1eTdZasMA+4o9Tt7rn
         dBjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=D7lIoy29V1yplyvmw6IyDtPoaLPek92Jx/misBZ4I3I=;
        b=hxJmRSvWjRj67XSrbFQbuoUzttEFqMSDlV7NxaGVfLCOk+gI3A3Y7U2+5fh/Ojo+ol
         zYiUCHNb6ZRmn30WYd5E0h8XgWVTvTmjy5y5SnBFwUHWTZj/CVTPYcmVGbrNk/QRmtRd
         U8aaTknikoSYJHLqrY8S2CcmXBgioiuh9xfRisHEAKIMe6nxlW2F5uaGl7Ok9truRL0a
         6tzSr6+E2zh38QLeVQWVGF0MZnTXTAzSxpxt1c3Amk1xAiP3IQmftcRHDPcILgs5P26T
         fi9guOVdH6vaTBPREjmeG0433xxc7ui1i7tOj4+5D5/xzxLT4l5gNrCdUPx+9u2uJWJD
         WsUQ==
X-Gm-Message-State: APjAAAWXZFUC5QKYGS2uz9+pZMMvEM48NtfSd7j9v21CVxaJzz2r8c7J
        0f5+kdIN6HXQMH00Se4SYOCAmltq
X-Google-Smtp-Source: APXvYqwoyXpLPjAIq6Mrgx7pAIqI+RsLHtBecEunLG2XWyEeykC/A9sZ+ZdcrlrM/Tz94o1q5aUHCA==
X-Received: by 2002:a7b:cbd6:: with SMTP id n22mr5318731wmi.39.1569957505643;
        Tue, 01 Oct 2019 12:18:25 -0700 (PDT)
Received: from localhost.localdomain ([86.124.196.40])
        by smtp.gmail.com with ESMTPSA id e6sm15214299wrp.91.2019.10.01.12.18.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Oct 2019 12:18:24 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        davem@davemloft.net
Cc:     netdev@vger.kernel.org, Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH net-next 0/3] SJA1105 DSA coding style cleanup
Date:   Tue,  1 Oct 2019 22:17:58 +0300
Message-Id: <20191001191801.9130-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series provides some mechanical cleanup patches related to function
names and prototypes.

Vladimir Oltean (3):
  net: dsa: sja1105: Don't use "inline" function declarations in C files
  net: dsa: sja1105: Replace sja1105_spi_send_int with
    sja1105_xfer_{u32,u64}
  net: dsa: sja1105: Rename sja1105_spi_send_packed_buf to
    sja1105_xfer_buf

 drivers/net/dsa/sja1105/sja1105.h             | 16 ++-
 drivers/net/dsa/sja1105/sja1105_clocking.c    | 65 ++++++-------
 .../net/dsa/sja1105/sja1105_dynamic_config.c  | 12 +--
 drivers/net/dsa/sja1105/sja1105_ethtool.c     | 16 +--
 drivers/net/dsa/sja1105/sja1105_main.c        | 18 ++--
 drivers/net/dsa/sja1105/sja1105_ptp.c         | 17 ++--
 drivers/net/dsa/sja1105/sja1105_spi.c         | 97 +++++++++++--------
 7 files changed, 118 insertions(+), 123 deletions(-)

-- 
2.17.1

