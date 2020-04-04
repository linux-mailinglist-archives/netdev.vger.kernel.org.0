Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B82DE19E662
	for <lists+netdev@lfdr.de>; Sat,  4 Apr 2020 18:16:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726402AbgDDQQZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Apr 2020 12:16:25 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:51219 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726331AbgDDQQZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Apr 2020 12:16:25 -0400
Received: by mail-wm1-f66.google.com with SMTP id z7so10313428wmk.1
        for <netdev@vger.kernel.org>; Sat, 04 Apr 2020 09:16:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=NrFQyzF3ew5HcheEO69QAsKLAp/rm5pZiC9k/QYANuo=;
        b=RR9WFMUriUatJkBMsC1KPix1OKl8EOyoETE8k8Sx5EKrWxc15RFl1M2GJuNPCqDiFy
         RO1D0DLruBvveycDsJDYp7oVfqz1Msq8G2FsBeccN0oXbit+f6wXOTQr1rG/PZE88/q7
         n4LB9rAFHaDAmtAjUajlEeOcPO/1ul+juuOoFQSzqIyjC6Hx4cHbrSgbDRSoKfXnlHVk
         9w2AA8Xqe/ZNFLE7cGf0T+ouebaA/iYgMXCvr950h+ILP2NFmfTWil4NtvQqbauoZQiL
         4uwoBj2gMzTkgBTiUdpyJKlevqh7f1NIw4KNLbCJNvgyqTmkrtR9ifgQvGye+yCOC9Sa
         fbIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=NrFQyzF3ew5HcheEO69QAsKLAp/rm5pZiC9k/QYANuo=;
        b=aBMHjOUoTUButIHrzsg1jhaDBpVu67cgekKZOaJuc/70AveMFEDyfyi9YiChqfWu36
         eZtexL/xbT6MBK0dYvOAnDnucRBAPYTAw6es6nozxUVIhIPio8NmwUeaFtbXGxECMaQJ
         Z/DddpVxesaJ7Tldg+SBFhd3rw637AICoYYoHnmEkU/U8fYenBOQnUIi+0uk0A+/B2oH
         5LTzEU63D8I0bN8xd/f+jMoeMgqG35zXDTFXCVSK5nDKRHGuwwo5NfxLxKryiUfplBj6
         wNi4MTKyGrGIZ+549tAZB6z9GxfX4rxk8jIwXft9MA82oY9fsRLu/Z8Tfx3o/xPqVCOF
         gLog==
X-Gm-Message-State: AGi0PubJq5JpdRgeuLQeJhz5M5z+0HwAfAIXib3whMqwfQiLt6POjS7k
        OWgVzG7K+jjnOSWe3lgZYFIjFG4fBf4=
X-Google-Smtp-Source: APiQypJrOFVv8z5l/t30IbxipxDdv7uc7+0eIVfsAzVglW61j857arothSQINmHMCGYevfe8PeJKjA==
X-Received: by 2002:a1c:7218:: with SMTP id n24mr5291721wmc.103.1586016983086;
        Sat, 04 Apr 2020 09:16:23 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id f25sm16006815wml.11.2020.04.04.09.16.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 04 Apr 2020 09:16:22 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     dsahern@gmail.com, stephen@networkplumber.org, mlxsw@mellanox.com
Subject: [patch iproute2/net-next 0/8] devlink: spring cleanup
Date:   Sat,  4 Apr 2020 18:16:13 +0200
Message-Id: <20200404161621.3452-1-jiri@resnulli.us>
X-Mailer: git-send-email 2.21.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@mellanox.com>

This patchset contains couple of small fixes, consistency changes,
help and man adjustments.

Jiri Pirko (8):
  devlink: remove custom bool command line options parsing
  devlink: Fix help and man of "devlink health set" command
  devlink: fix encap mode manupulation
  devlink: Add alias "counters_enabled" for "counters" option
  devlink: rename dpipe_counters_enable struct field to
    dpipe_counters_enabled
  devlink: Fix help message for dpipe
  devlink: remove "dev" object sub help messages
  man: add man page for devlink dpipe

 bash-completion/devlink   |   8 +--
 devlink/devlink.c         | 131 +++++++++++++++++---------------------
 man/man8/devlink-dev.8    |   8 +--
 man/man8/devlink-dpipe.8  | 100 +++++++++++++++++++++++++++++
 man/man8/devlink-health.8 |  30 +++++----
 5 files changed, 181 insertions(+), 96 deletions(-)
 create mode 100644 man/man8/devlink-dpipe.8

-- 
2.21.1

