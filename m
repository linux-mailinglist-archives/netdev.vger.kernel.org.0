Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CEC8269BAA6
	for <lists+netdev@lfdr.de>; Sat, 18 Feb 2023 16:30:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229681AbjBRPaT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Feb 2023 10:30:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229475AbjBRPaS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Feb 2023 10:30:18 -0500
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F16516AC6;
        Sat, 18 Feb 2023 07:30:17 -0800 (PST)
Received: by mail-ed1-x534.google.com with SMTP id z7so1207736edb.12;
        Sat, 18 Feb 2023 07:30:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=nKSAfgWxxsdHCNUz+kYQSuMrwvt86KKNaeBhNElRNF8=;
        b=Hp5U4N74V4hkOtyX5nO9XO2T0PwAaMZ0VU5SRl8h5Bj12/AbSf8Y0/MDOa6Cmxgm+I
         4lU7hSB/4O4cuNw+yb4WlExPAoWyj6Dn0JSG5w3niDrkN7sCPVWu5rm58J7dl0UjbO0i
         grBKCGnv18JeEHiWmm2OSqu0vcIDk73wAUGb3+m7TPmU1Dk41+WjEqJL+KTW2tHgXANk
         EciE8fa0niBOC424IOK8BayRcNg3kgZTRF+9JqI4wA8RiiR9vPnEQ3y2ay12eA6MKKYF
         X7BNmFHCwj34w/vQAtLRiVVSgRNAujTb3W9w6bKIfdoueneL5VRyXJzP+RQKkBHiBUaw
         icXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=nKSAfgWxxsdHCNUz+kYQSuMrwvt86KKNaeBhNElRNF8=;
        b=my7lGVJcNR6ayqdpupaXNTGOsCGuyztB/GB3b2aIJN/buciIgGjEPAvRrQKtuHbj7U
         8TqQ4APbS6D9SuQtyqCSK6VFwQwNmSpSMvXbbSCKRVKqIS8zk8qqxFh+ve+4vAb/uZzb
         gJ0znWTaGJZtK/A53W10x+38uWFIkVZIKcdmHO5Tdh4JgdSqTTeqKAhMrX2tCds/6VLu
         5jvRi0UgjNVEF6LeDySP33vyRnKgcbCb5susjJ4LmrZsOQpf5BaJapZRLZoigQER8Ayz
         SFyKo5Qi7OeDz+YAybKiEjWlB2TP5Ue10ByC4l3UwIzAjHhAdFibBceSvVZir1SttHDh
         irJw==
X-Gm-Message-State: AO0yUKXgtpyGwbtsxC0I856NXm4m9xeOfFmqKk+rAjyK/cwnj9XLha2p
        HQtlwciOTa8kVKVkEifo2ohS30aRA2E=
X-Google-Smtp-Source: AK7set+8mflZfjLUVnSf1BMxAi4s6spTOve01d2ObjGEknMtfNBrA2pFvEG/WxGpIm6yEjHcyYHBrA==
X-Received: by 2002:a05:6402:783:b0:4ad:6d95:5cc2 with SMTP id d3-20020a056402078300b004ad6d955cc2mr7474148edy.35.1676734215292;
        Sat, 18 Feb 2023 07:30:15 -0800 (PST)
Received: from localhost.localdomain (dynamic-2a01-0c23-b8cf-1500-0000-0000-0000-0e63.c23.pool.telefonica.de. [2a01:c23:b8cf:1500::e63])
        by smtp.googlemail.com with ESMTPSA id a65-20020a509ec7000000b004acc5077026sm3742554edf.79.2023.02.18.07.30.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 18 Feb 2023 07:30:14 -0800 (PST)
From:   Martin Blumenstingl <martin.blumenstingl@googlemail.com>
To:     linux-wireless@vger.kernel.org
Cc:     tony0620emma@gmail.com, kvalo@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Neo Jou <neojou@gmail.com>,
        Jernej Skrabec <jernej.skrabec@gmail.com>, pkshih@realtek.com,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Subject: [PATCH v2 0/5] rtw88: Add additional SDIO support bits
Date:   Sat, 18 Feb 2023 16:29:39 +0100
Message-Id: <20230218152944.48842-1-martin.blumenstingl@googlemail.com>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

These patches are split from my big RFC series called "rtw88: Add
SDIO support" from [0].
The goal of this smaller series is to make it easier to review the
patches and already upstream support bits which are mostly
independent.

For patches 3-5 I got feedback from Ping-Ke in the RFC version where
he suggested to add __packed to various structs. This resulted in
discussions around that whole topic in [1] and [2]. Since I'm new
to that topic I sent an RFC patch [3] based on the suggestions from
Ping-Ke and David. That patch has not been reviewed yet. My
suggestion is to take the patches from this series first, then
come to a conclusion on the RFC patch which I'll then re-spin as
a normal patch with the required changes that will come up in the
discussion (if any).


Changes since v1 from [4]:
- keep a consistent order for newly added functions, case statements
  and union members in patches 3, 4, 5 as suggested by Ping-Ke
- removed an extraneous newline which was added by accident from
  patch 4


[0] https://lore.kernel.org/lkml/20221227233020.284266-1-martin.blumenstingl@googlemail.com/
[1] https://lore.kernel.org/linux-wireless/20221228133547.633797-2-martin.blumenstingl@googlemail.com/
[2] https://lore.kernel.org/linux-wireless/4c4551c787ee4fc9ac40b34707d7365a@AcuMS.aculab.com/
[3] https://lore.kernel.org/lkml/20230108213114.547135-1-martin.blumenstingl@googlemail.com/
[4] https://lore.kernel.org/lkml/ef11acd2c4054365b76d06966f40cc61@realtek.com/T/


Martin Blumenstingl (5):
  wifi: rtw88: mac: Add support for the SDIO HCI in rtw_pwr_seq_parser()
  wifi: rtw88: mac: Add SDIO HCI support in the TX/page table setup
  wifi: rtw88: rtw8821c: Implement RTL8821CS (SDIO) efuse parsing
  wifi: rtw88: rtw8822b: Implement RTL8822BS (SDIO) efuse parsing
  wifi: rtw88: rtw8822c: Implement RTL8822CS (SDIO) efuse parsing

 drivers/net/wireless/realtek/rtw88/mac.c      | 9 +++++++++
 drivers/net/wireless/realtek/rtw88/rtw8821c.c | 9 +++++++++
 drivers/net/wireless/realtek/rtw88/rtw8821c.h | 6 ++++++
 drivers/net/wireless/realtek/rtw88/rtw8822b.c | 9 +++++++++
 drivers/net/wireless/realtek/rtw88/rtw8822b.h | 8 +++++++-
 drivers/net/wireless/realtek/rtw88/rtw8822c.c | 9 +++++++++
 drivers/net/wireless/realtek/rtw88/rtw8822c.h | 8 +++++++-
 7 files changed, 56 insertions(+), 2 deletions(-)

-- 
2.39.2

