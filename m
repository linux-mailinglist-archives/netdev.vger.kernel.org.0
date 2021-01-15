Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 258DA2F84A5
	for <lists+netdev@lfdr.de>; Fri, 15 Jan 2021 19:43:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729507AbhAOSm4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jan 2021 13:42:56 -0500
Received: from mail-wm1-f54.google.com ([209.85.128.54]:37816 "EHLO
        mail-wm1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726347AbhAOSmz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jan 2021 13:42:55 -0500
Received: by mail-wm1-f54.google.com with SMTP id g10so8461518wmh.2;
        Fri, 15 Jan 2021 10:42:39 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Rgp6HmZdsqwCwGp3tkj9iKIu0RyVYf4eF8x8ZYdMR0I=;
        b=uElEs5HiNOP1itipL2k9WxRM50jMS+00b0UwMnTdTE6yspUpk8NA2bC5niHjtIrZMB
         fnGn3Abf0aYGMSsLddW6wj/qCLzdcGibcFVpLiUqCx14s9sznTBLPgjw426p9KjWqDc8
         awQEk61xUbggBgLSc9twKcnwkf4D45SqSvNyEdEMwiL1EZoXCEkM5NubnEODq7Ooykgy
         c6iGYYtLvXKKG2yfYVDiUmvP4TTSos4Cb0p37IJ3lh3xpwhb6E/x0NAAuyH0Yo9lXDJ3
         CexuzrV/wS4N2XsvOS2RpzNo2LKj14Gbhii+mv2YtluwmQqzH4YjWymwS9qWr+cVZGGG
         MFPw==
X-Gm-Message-State: AOAM533dBPfrjWRJ4lWI9x6cEv3hg3xAR41wpgoF/5mTVLuofP8Jg59s
        ZtheS4F3bJ1yuOhvnAOdkuVKpgyplEg3Yw==
X-Google-Smtp-Source: ABdhPJwaJ72EeFeh+UfpQUjB+WUAtm73FVCvaWLCwRTcAoAYJgoPaut80AKTWWGM/tmsTVuay9i2EQ==
X-Received: by 2002:a05:600c:3510:: with SMTP id h16mr9854424wmq.156.1610736133611;
        Fri, 15 Jan 2021 10:42:13 -0800 (PST)
Received: from msft-t490s.fritz.box (host-80-116-27-12.pool80116.interbusiness.it. [80.116.27.12])
        by smtp.gmail.com with ESMTPSA id z6sm12881529wmi.15.2021.01.15.10.42.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Jan 2021 10:42:12 -0800 (PST)
From:   Matteo Croce <mcroce@linux.microsoft.com>
To:     netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net 0/2] ipv6: fixes for the multicast routes
Date:   Fri, 15 Jan 2021 19:42:07 +0100
Message-Id: <20210115184209.78611-1-mcroce@linux.microsoft.com>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Matteo Croce <mcroce@microsoft.com>

Fix two wrong flags in the IPv6 multicast routes created
by the autoconf code.

Matteo Croce (2):
  ipv6: create multicast route with RTPROT_KERNEL
  ipv6: set multicast flag on the multicast route

 net/ipv6/addrconf.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

-- 
2.29.2

