Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E639E1D9933
	for <lists+netdev@lfdr.de>; Tue, 19 May 2020 16:15:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729084AbgESOP2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 May 2020 10:15:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726880AbgESOP1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 May 2020 10:15:27 -0400
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A69F9C08C5C0
        for <netdev@vger.kernel.org>; Tue, 19 May 2020 07:15:27 -0700 (PDT)
Received: by mail-wr1-x433.google.com with SMTP id l17so16120004wrr.4
        for <netdev@vger.kernel.org>; Tue, 19 May 2020 07:15:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=AJUjJNyXg2WSVRAizuFTiw3xr9Ox/NuHNKoUyhJnTYs=;
        b=L3SuUQbgqS/w5q7usqVQWKs61AeUaGHvKl1vsZ4Z9xrlb9Rwm+AaA4ku9LubEIL8ug
         Ram7QjK3sRwcztR28PjVv+k+UHqEROU0e9NpSTtcwe7lApGC+puOOKlB0a4tbDD3zijP
         nltHbrnDXypNA+G9Gn8ftNNv8vzY0J0X3cVKn1U3HXKHI4sBK9iNwpLqnXZTxlvJA40I
         j5tB7qZR0S17sq4+vxhgo+36QtUmRnW9sKaw7Z4kDJvKQ5odHwEr47t5wtPHooywHoJ2
         lZbA4r/ih7XHAI5T6UQOmihw2DYBQLfOcofZ4f6eT3p/Hh2FP18jtnLz854zb6Nhpa/0
         PXSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=AJUjJNyXg2WSVRAizuFTiw3xr9Ox/NuHNKoUyhJnTYs=;
        b=JLCyV6VGOS84WPhxXH5TtWbMDc76ZyGLY/S/hvvx8ODMAh1hbU0SWbD9CM5OHNS5tM
         ppFo+iX8AsFn4rwPf6twBQo6pSgGISK9n9xDDKgTkZYku2jxtTJjkTnkACMJTOz1TNL3
         gigFhNSRIUcegox9WxfFT4bkxISngeMLqlRPRrObPERbBau3CGtK9R8WiDrWLH2V0ok/
         ytv97FBlP7FJmRm4XiMgloFj5ktKLhk9N8uQAFuxDlSdIrCR/ji9q/R0tmBrG2b4YNmy
         /vQKjNCeaXqTEV4RJ9kvGcy8NMdajtwk6PWylZTPNbP1B8MIoMhpSfOOMC3Jw0FPCFyK
         kCiA==
X-Gm-Message-State: AOAM532lxNEILRB7lZRj1TUwpkC8TJaU9nBgHdFHZnsu+yBXSeYLSnEK
        5VWlbD6VqqUAeLwXXRHm3kdyBnt4IS/nzw==
X-Google-Smtp-Source: ABdhPJxXKWHEm1IT7atevaNozfBYNIKwgADP3Mv/0jY72jsBfqLBBwU6S4Oqn/gm2bk/jqPckKXhpQ==
X-Received: by 2002:adf:9010:: with SMTP id h16mr24146358wrh.412.1589897726368;
        Tue, 19 May 2020 07:15:26 -0700 (PDT)
Received: from madeliefje.horms.nl ([2001:982:7ed1:403:9eeb:e8ff:fe0d:5b6a])
        by smtp.gmail.com with ESMTPSA id c140sm4242222wmd.18.2020.05.19.07.15.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 May 2020 07:15:25 -0700 (PDT)
From:   Simon Horman <simon.horman@netronome.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     netdev@vger.kernel.org, oss-drivers@netronome.com,
        Simon Horman <simon.horman@netronome.com>
Subject: [PATCH net-next v2 0/2] nfp: flower: feature bit updates
Date:   Tue, 19 May 2020 16:15:00 +0200
Message-Id: <20200519141502.18676-1-simon.horman@netronome.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

this short series has two parts.

* The first patch cleans up the treatment of existing feature bits.
  There are two distinct methods used and the code now reflects this
  more clearly.
* The second patch informs firmware of flower features. This allows
  the firmware to disable certain features in the absence of of host support.

Changes since v1
- Add now-first patch to clean up existing implementation
- Address Jakub's feedback


Louis Peens (2):
  nfp: flower: renaming of feature bits
  nfp: flower: inform firmware of flower features

 .../ethernet/netronome/nfp/flower/action.c    |   4 +-
 .../net/ethernet/netronome/nfp/flower/cmsg.c  |   4 +-
 .../net/ethernet/netronome/nfp/flower/main.c  | 116 ++++++++++++------
 .../net/ethernet/netronome/nfp/flower/main.h  |  20 ++-
 4 files changed, 102 insertions(+), 42 deletions(-)

-- 
2.20.1

