Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B64C4CC79B
	for <lists+netdev@lfdr.de>; Thu,  3 Mar 2022 22:07:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234395AbiCCVId (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Mar 2022 16:08:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232741AbiCCVIc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Mar 2022 16:08:32 -0500
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71F1D4A3CD;
        Thu,  3 Mar 2022 13:07:45 -0800 (PST)
Received: by mail-pl1-x62b.google.com with SMTP id q11so5867411pln.11;
        Thu, 03 Mar 2022 13:07:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=lcGRiz6rr/TDwlVwBBClv8R+9QvaexT6KVuBbBlpjEA=;
        b=CAG5vCfyC5+8LNntm92xwzyDYPQlhh+BDt8EgB1cRrVEpr6sV+JU5AgFw4HACaOgfX
         y5YzcYXLjRh/D5Shetpp5bkY5QYhOW1w7mUt1pbmbVbDbkgN9wKqUmN4iSb6PVPvD3zG
         GRx1fnkRMdpzef1FPqpUl8kozn7IeIXJTCxAigHzLENBOXfpz62srnXHIX/zveD8d5Op
         CxpFl5fDdKeogQz+U629+2CkrttPShKJw/W1uthuVBUlosCY3H/Y8MLe9Qi3fTjT0LkH
         Qqbk00h9Km8m706w54vy7cQEzisfxQT070Y6/v8F+8KcDGdp0iKUbP1Zs/bkO8jj8/LB
         nv7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=lcGRiz6rr/TDwlVwBBClv8R+9QvaexT6KVuBbBlpjEA=;
        b=oReSRYaJLVrY+6CdKALMFrEmNZuVQ+gqKFSbtc8vzHBaJsEVbQh87PNE/YUEK67kli
         igC50OZnL6HoyIAdlX+QaBTekcVN+tohyzPe17u7khtIGaiLYUd6dFNsjVu7vr3BCtuZ
         IACYV3MtH8SounReSopis6UwKu8FHRPTuQXg/Lsq9SaSzA1MvRLThXlyi7Uh9EXZndWX
         400sXUGWbqojfEixT1Z5DyV4vOdK02rsmkigF5KKRSHe/CtVrtzawBcGdBswPPr3VyUF
         fec0foPesuV2odqXHowixEKygUsbA4Im5A2ztvWzyObc2FmUanTYWEruNJq2xdwUmjKz
         sp3g==
X-Gm-Message-State: AOAM532mDeEufdhWu60XZr5qQhDEY8dNGrQEXXt6w8CN086aeGuYjtre
        AYjQbFgn6p79cCRSj+oLYY9VuzvEeuY=
X-Google-Smtp-Source: ABdhPJygVn2JDXKjQVwukHWAT2xZQWWQQ4hudGJk1EHeG8w0NACdaADjAqr8bqZKqXPA0dwW0znI8Q==
X-Received: by 2002:a17:902:8548:b0:14e:e968:9703 with SMTP id d8-20020a170902854800b0014ee9689703mr37247062plo.148.1646341664853;
        Thu, 03 Mar 2022 13:07:44 -0800 (PST)
Received: from lvondent-mobl4.intel.com (c-71-56-157-77.hsd1.or.comcast.net. [71.56.157.77])
        by smtp.gmail.com with ESMTPSA id q15-20020a63504f000000b0037425262293sm2686580pgl.43.2022.03.03.13.07.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Mar 2022 13:07:44 -0800 (PST)
From:   Luiz Augusto von Dentz <luiz.dentz@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org
Subject: pull request: bluetooth 2022-03-03
Date:   Thu,  3 Mar 2022 13:07:43 -0800
Message-Id: <20220303210743.314679-1-luiz.dentz@gmail.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The following changes since commit f8e9bd34cedd89b93b1167aa32ab8ecd6c2ccf4a:

  Merge branch 'smc-fix' (2022-03-03 10:34:18 +0000)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth.git tags/for-net-2022-03-03

for you to fetch changes up to 008ee9eb8a11bcabf12c91771dd4f470b082bd44:

  Bluetooth: hci_sync: Fix not processing all entries on cmd_sync_work (2022-03-03 13:30:03 +0100)

----------------------------------------------------------------
bluetooth pull request for net:

 - Fix regression with processing of MGMT commands
 - Fix unbalanced unlock in Set Device Flags

----------------------------------------------------------------
Hans de Goede (1):
      Bluetooth: hci_core: Fix unbalanced unlock in set_device_flags()

Luiz Augusto von Dentz (1):
      Bluetooth: hci_sync: Fix not processing all entries on cmd_sync_work

 net/bluetooth/hci_sync.c | 49 +++++++++++++++++++++++-------------------------
 net/bluetooth/mgmt.c     |  2 +-
 2 files changed, 24 insertions(+), 27 deletions(-)
