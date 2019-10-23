Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 62A95E2059
	for <lists+netdev@lfdr.de>; Wed, 23 Oct 2019 18:16:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407105AbfJWQQo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Oct 2019 12:16:44 -0400
Received: from mail-pg1-f177.google.com ([209.85.215.177]:46874 "EHLO
        mail-pg1-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404332AbfJWQQo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Oct 2019 12:16:44 -0400
Received: by mail-pg1-f177.google.com with SMTP id e15so12405638pgu.13
        for <netdev@vger.kernel.org>; Wed, 23 Oct 2019 09:16:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=hb5ZKAVZKxZj2yid72BQgn/j2ODYCf6YBMuQPrggChA=;
        b=mIfYlogshZQtjG6VUVVM+NsCXB63REfqEfwm5fwECLl0Pb6PvpI/MDU037o/FD22sE
         JkGqotdAnce73zp1nPQAAJgPFcfI5cIacW5F54hXRNT642sNBhNNG3DM9GPweCScggDF
         KI2qh0WJw/OJqxTYmbHTTO1z+iTHN7pRjfqPMkfo/KYzpgQc7PYSNm+u409KaHVzNom8
         CLtBeHh8dENElHPziqUdmw+TU4NifK+hPGXGXmvMFiwzLX7jkE3pj2iOeXSnNSQGXX3Z
         tFkCuNRagi+gYVPHX9DvJ2cPtFS3xo400J09epn7y/j022wBfDCr0NAOi9ewyL49V/bh
         ktUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=hb5ZKAVZKxZj2yid72BQgn/j2ODYCf6YBMuQPrggChA=;
        b=P31JRw2RbchaVHP0e5/S34AYxIsXDJSHoQxJ+L9ncck6mfJIClv6PGtnnzrbEzK/1+
         0uXetjauIF6A2DRhE7ajy614KkUMkEe6uzXHGErJ8kMpa0JNS/C5vhm5xz9q73yZ3MZ1
         Ah9AExyy84XAlpm5jFO56ea+JCVQdd4XTWse5nnrQS7v8RmqZ5Iz/y+mkTvIPU0kQPgW
         Bwd/4mS6k2WG8h3iOWVP9Wua72n3kjVv8ZTRtXTRPhYvsgFDV+f0Nyz9FNV1Nekfs3d1
         TmC4oiq3ti5HyrvDLEMiMD2CjxqPl8EPZzUT1AGI6+smlj3GX7uiYpl1z+WfbvB6mniB
         VZCg==
X-Gm-Message-State: APjAAAWXkCooN33gXRl7S4uq4+P/Sit001Du1ma0sdHvgW181GKfwXQz
        dRVjOVRu8SRqlgRcaSj3RvlLZ74UWi+0Cg==
X-Google-Smtp-Source: APXvYqzljVpqTg+dgZjFoWrMEVk23bklDlhRpnvUy5nP3VpvKiuY1nIWsssrRZ68t+sQf4FOGyWn1g==
X-Received: by 2002:a62:fc84:: with SMTP id e126mr5887172pfh.97.1571847400918;
        Wed, 23 Oct 2019 09:16:40 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id m12sm12012724pjk.13.2019.10.23.09.16.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Oct 2019 09:16:39 -0700 (PDT)
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     netdev@vger.kernel.org
Cc:     Stephen Hemminger <stephen@networkplumber.org>
Subject: [PATCH iproute2 0/3] remove old examples
Date:   Wed, 23 Oct 2019 09:16:29 -0700
Message-Id: <20191023161632.541-1-stephen@networkplumber.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Take the old stuff away.

Stephen Hemminger (3):
  examples: remove out of date cbq stuff
  examples: remove gaiconf
  examples: remove diffserv

 examples/README.cbq                  | 122 -----------------
 examples/SYN-DoS.rate.limit          |  49 -------
 examples/cbqinit.eth1                |  76 ----------
 examples/diffserv/Edge1              |  68 ---------
 examples/diffserv/Edge2              |  87 ------------
 examples/diffserv/Edge31-ca-u32      | 170 -----------------------
 examples/diffserv/Edge31-cb-chains   | 132 ------------------
 examples/diffserv/Edge32-ca-u32      | 198 ---------------------------
 examples/diffserv/Edge32-cb-chains   | 144 -------------------
 examples/diffserv/Edge32-cb-u32      | 145 --------------------
 examples/diffserv/README             |  98 -------------
 examples/diffserv/afcbq              | 105 --------------
 examples/diffserv/ef-prio            |  25 ----
 examples/diffserv/efcbq              |  31 -----
 examples/diffserv/regression-testing | 125 -----------------
 examples/gaiconf                     | 134 ------------------
 16 files changed, 1709 deletions(-)
 delete mode 100644 examples/README.cbq
 delete mode 100644 examples/SYN-DoS.rate.limit
 delete mode 100644 examples/cbqinit.eth1
 delete mode 100644 examples/diffserv/Edge1
 delete mode 100644 examples/diffserv/Edge2
 delete mode 100644 examples/diffserv/Edge31-ca-u32
 delete mode 100644 examples/diffserv/Edge31-cb-chains
 delete mode 100644 examples/diffserv/Edge32-ca-u32
 delete mode 100644 examples/diffserv/Edge32-cb-chains
 delete mode 100644 examples/diffserv/Edge32-cb-u32
 delete mode 100644 examples/diffserv/README
 delete mode 100644 examples/diffserv/afcbq
 delete mode 100644 examples/diffserv/ef-prio
 delete mode 100644 examples/diffserv/efcbq
 delete mode 100644 examples/diffserv/regression-testing
 delete mode 100644 examples/gaiconf

-- 
2.20.1

