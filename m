Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E2DC544792
	for <lists+netdev@lfdr.de>; Thu, 13 Jun 2019 19:00:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393229AbfFMRAl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jun 2019 13:00:41 -0400
Received: from mail-qk1-f175.google.com ([209.85.222.175]:45700 "EHLO
        mail-qk1-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729766AbfFLX7R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jun 2019 19:59:17 -0400
Received: by mail-qk1-f175.google.com with SMTP id s22so11567669qkj.12
        for <netdev@vger.kernel.org>; Wed, 12 Jun 2019 16:59:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=JFCIBTn7iNCSMtjYWt8+Qq946k7xcjQ4EApQswxqkZY=;
        b=l+V1MsR/7bnKQwFDTe26mBFavfFtRYwnzIbSdgLtgpv6oFB9oACuJmmVowPlqs+R6p
         4Kv3VLX9VDz7cT81EuEsE6HMipl0yp9FJtOLcyUiVdGm3xOj3b1haz3Crnw5KJVExEhV
         nAHzGRKXZA/VZmvutuzqHLUeN0Hsv961Mnydq9GUhTvqQrqx3K68Q36e4o2CuQR1c3bB
         yCL8/9wjYZ8yxWagjGmGGAyqmKpDk/Jy6KpTBPobJSwBbEVW2+ukLhXDP0SVQs9btDZw
         dGkiLNKtTSMkzlWYWgSZiwhrekbfFVUZUAVuVicRD2rMNeXk7HdNyEI3+j7HzUXaNy72
         Z+bQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=JFCIBTn7iNCSMtjYWt8+Qq946k7xcjQ4EApQswxqkZY=;
        b=RbI9ZLwDMbfqEIQzGiXkfgqsiU0XdaUCfv/IPKedtDLwwtiqt5ME33Z9DxCfaWBux6
         BAysMpvN9IzOTEqQh138jILtikc4fcoSYWc+R0rf+CiqmT16Yjo8c31Q2AtoefV0n3BT
         A66hHrNWWhhcnfRX1ktLRZyR8ugGgwe8pH2CVdvIKaT1ObhxHIZYiipiT10JcOJlC6UJ
         1MlYXLOIQINLs5+02M3DTU8nSL7i0xYxk/8Hy7TRqRFJ+1+vhDXGzBi2f7QemNN6XwAH
         6dmWjKN/h6MpxbsOfKSrJz2K5L5U8lGbbDn69nQ63BKvnioOuVe+Y57LT0VwJ3Upp2Pz
         Cz/A==
X-Gm-Message-State: APjAAAUltmcH+I3FbwLT8970U3E5SoC96YMMCfFJPlQNRpWEcrW9u4Qc
        IfXV5SrD5OIbvQVAfdBqNlubPg==
X-Google-Smtp-Source: APXvYqxKrvikanJDzoN8jlzVW9mBMsiKJknUIWt8YUpX+7tx0BrUSCbR9RcV6Tebm4JMbv2WYlbiVw==
X-Received: by 2002:ae9:ed0a:: with SMTP id c10mr66473951qkg.207.1560383956696;
        Wed, 12 Jun 2019 16:59:16 -0700 (PDT)
Received: from jkicinski-Precision-T1700.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id p4sm490891qkb.84.2019.06.12.16.59.15
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 12 Jun 2019 16:59:16 -0700 (PDT)
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, oss-drivers@netronome.com,
        Jakub Kicinski <jakub.kicinski@netronome.com>
Subject: [PATCH net-next 0/2] nfp: add two user friendly errors
Date:   Wed, 12 Jun 2019 16:59:01 -0700
Message-Id: <20190612235903.8954-1-jakub.kicinski@netronome.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi!

This small series adds two error messages based on recent
bug reports which turned out not to be bugs..

Jakub Kicinski (2):
  nfp: update the old flash error message
  nfp: print a warning when binding VFs to PF driver

 drivers/net/ethernet/netronome/nfp/nfp_main.c        | 4 ++++
 drivers/net/ethernet/netronome/nfp/nfpcore/nfp_nsp.c | 7 ++++++-
 2 files changed, 10 insertions(+), 1 deletion(-)

-- 
2.21.0

