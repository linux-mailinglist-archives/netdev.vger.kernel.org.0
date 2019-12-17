Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C33631238F1
	for <lists+netdev@lfdr.de>; Tue, 17 Dec 2019 22:57:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726556AbfLQV5g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Dec 2019 16:57:36 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:33420 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725805AbfLQV5f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Dec 2019 16:57:35 -0500
Received: by mail-wm1-f68.google.com with SMTP id d139so3208436wmd.0
        for <netdev@vger.kernel.org>; Tue, 17 Dec 2019 13:57:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id;
        bh=lyYHjXVItuXTUpDjkyMb7o72m6Q48ojwbiIW8XlWkNA=;
        b=zbEXJZYSOjF0+fJAkrhrbj9HMe+rt9DyGmytvnFRynZwerK0+pgiqtRmxbvNEHojem
         14XaoipkrRzr+eNo3RQEsKbJ8vogQdDRMquAVkQImH3y4ezvb0O4bm6+Oig63BLxthg4
         3AoryHM8ZP7pxTZAvDg13K5T70LWdTw0cB7m6pVGTkxxSEcNurCgY8jZSUG2G66++C6I
         bEEz8jxoyDmWRXzW4ZRBJdgGTckapdiOEYCdylOv9Cs5YvRufXjox6A08RnEbTPCzPLl
         N/afLjEYqGkatUJX8e3aYfBHfHUlDQmDWoQHxqsh5dIo0VEW0e6hx5yQ2sUgeTcbDZ/B
         Ftsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=lyYHjXVItuXTUpDjkyMb7o72m6Q48ojwbiIW8XlWkNA=;
        b=mxJDwq3i6cB4KHIE8Kl7tZkJVpe6xvszHiT94g43HYJ8igCMsXpaRx8ORudLMD3r9B
         SkrJCSMkwVGAJHThlvbXkCDS7Lr91HSMnapo44BSxVPrNz1OZUTVy+fKgR8OSd70Yz11
         R5xgJ6SdX04O4RPN+fPC6kzQ/i6iK2Rh5FREGTAaBgclj1VyRJFaWAsPdjXBffn3iBDE
         a3niKvzkhFXok4JdnhMys13tKfbwxRigwsr5sLoRMYWUrX8ac+xYjY4edRABFm0WzhGF
         Rbkw9OE4yT8R0yO2LYJHHoIbb+Z2j83iC7EShOeiMan9HCKRFrEAL1eHXNohFIeeczh7
         fuHg==
X-Gm-Message-State: APjAAAU+d/T1crjZ2R6DEw1f2rJnniOb/LQNKSICnVzI+ztygZkUwX5o
        QbT1WpTMxS8QZViZfsvNKgjsnnL98lL6vRWVQxCVGdpanN5f82zpwMp6t0hxFr7HusI1NB2xLfC
        p7SnCY2jNb5saJzYF5o9KXeaPdzvqz458ctsUOWE8hszDCv+J4BPgvYVENw8cvfJdOyIWn/vY+Q
        ==
X-Google-Smtp-Source: APXvYqzLaCAoxw4n/y8bVpdQdK1KcqGksd9jcyt05MhrXFwAiOCq831G08tCVM3lW7hsS5br/Ucy2A==
X-Received: by 2002:a1c:3c89:: with SMTP id j131mr7139875wma.34.1576619853691;
        Tue, 17 Dec 2019 13:57:33 -0800 (PST)
Received: from jhurley-Precision-Tower-3420.netronome.com ([80.76.204.157])
        by smtp.gmail.com with ESMTPSA id u22sm157109wru.30.2019.12.17.13.57.32
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Tue, 17 Dec 2019 13:57:33 -0800 (PST)
From:   John Hurley <john.hurley@netronome.com>
To:     netdev@vger.kernel.org
Cc:     simon.horman@netronome.com, jakub.kicinski@netronome.com,
        oss-drivers@netronome.com, John Hurley <john.hurley@netronome.com>
Subject: [PATCH net-next v2 0/9] Add ipv6 tunnel support to NFP
Date:   Tue, 17 Dec 2019 21:57:15 +0000
Message-Id: <1576619844-25413-1-git-send-email-john.hurley@netronome.com>
X-Mailer: git-send-email 2.7.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

The following patches add support for IPv6 tunnel offload to the NFP
driver.

Patches 1-2 do some code tidy up and prepare existing code for reuse in
IPv6 tunnels.
Patches 3-4 handle IPv6 tunnel decap (match) rules.
Patches 5-8 handle encap (action) rules.
Patch 9 adds IPv6 support to the merge and pre-tunnel rule functions.

v1->v2:
- fix compiler warning when building without CONFIG_IPV6 set -
  Jakub Kicinski (patch 7)

John Hurley (9):
  nfp: flower: pass flow rule pointer directly to match functions
  nfp: flower: move udp tunnel key match compilation to helper function
  nfp: flower: compile match for IPv6 tunnels
  nfp: flower: offload list of IPv6 tunnel endpoint addresses
  nfp: flower: modify pre-tunnel and set tunnel action for ipv6
  nfp: flower: handle ipv6 tunnel no neigh request
  nfp: flower: handle notifiers for ipv6 route changes
  nfp: flower: support ipv6 tunnel keep-alive messages from fw
  nfp: flower: update flow merge code to support IPv6 tunnels

 drivers/net/ethernet/netronome/nfp/flower/action.c |  65 ++-
 drivers/net/ethernet/netronome/nfp/flower/cmsg.c   |  11 +-
 drivers/net/ethernet/netronome/nfp/flower/cmsg.h   | 106 ++++-
 drivers/net/ethernet/netronome/nfp/flower/main.h   |  38 +-
 drivers/net/ethernet/netronome/nfp/flower/match.c  | 260 +++++++----
 .../net/ethernet/netronome/nfp/flower/offload.c    | 144 ++++--
 .../ethernet/netronome/nfp/flower/tunnel_conf.c    | 498 ++++++++++++++++++---
 7 files changed, 893 insertions(+), 229 deletions(-)

-- 
2.7.4

