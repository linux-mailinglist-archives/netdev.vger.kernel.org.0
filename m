Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D88F8524186
	for <lists+netdev@lfdr.de>; Thu, 12 May 2022 02:29:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349667AbiELA3G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 May 2022 20:29:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349666AbiELA3D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 May 2022 20:29:03 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99B781C15CA;
        Wed, 11 May 2022 17:29:02 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id p8so3346491pfh.8;
        Wed, 11 May 2022 17:29:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=blac2gkekiCR/N+3veVySx5+NNNuZs8L9MfqZlFBgdc=;
        b=ErtLfWYHEru3ngKWye3L/NmbpYu9MrH4FVyanHO3x+jzZXRObQI0c190tQzgr+tYqR
         /xIP6GjQKvA/6uVA1DThFv7+i7fWBZBWI757UTZx5ysP0DNBluXwals5Uj8qBbTyJZCa
         FiCC90sUEq9GHqOKotW2R4YqiPt0n81JSGE61fCrmXgDH1Fu8RMlzUWg2j1/FAlOlm7R
         V/GiDxea1Msj1PGqu5d08cD/T9CM7CSlbwHbA7dZvAtJUJgqMixVd21g5rJC1PLn8KBR
         XnF1h85jYwwPjc2bHWGMNz7NHDdoHVofhRzt3V+EGVIiCDiIc9vUgMqKR+d4rReF8c19
         fCmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=blac2gkekiCR/N+3veVySx5+NNNuZs8L9MfqZlFBgdc=;
        b=dbqXfAvk0lXQMRG6iT7PxPenZW+L/jglM55HreiOAJ0fxmBzFC/g6GimhDxnoZepRi
         ofGQCcXF1vGTRZyILLl+nXoq56tV8+ZrZlynAN9ZySzUGjJZutflIfWYJRqpOOqKT21e
         mqtTTpt3hbV2dw6yFV8YJzeCfjeXOUbkZQG1tSGm042PCQ0WuBotu4B7WMmnbpVE//Pb
         EbcWgHu10IbiLDdlry/S0uS7t22RjRzAgYt4H6V4Ylf6jQxIpRxNS12DurGaGuGJRyiQ
         lzpKMWBvyrCYY1ORTb5WcYfv6U1eq+PL6hItzPTBCDMJ6LvggTxGyfIxm44lJSMf9gKS
         h05A==
X-Gm-Message-State: AOAM530eSRqTsfn8HVzEY/1vmsyChfZjzL3uMlKmcsZIB/q1NgVis+TU
        eJuAgZ1DlN+kksblXGn6y40=
X-Google-Smtp-Source: ABdhPJxjw5DL0azT6MqkGH4IytZ++zQmhTi9ippotGj6tp4J2OrVQkw080E24I9W40xx5VKwMVH6Yg==
X-Received: by 2002:a63:5:0:b0:3c6:dcb2:428 with SMTP id 5-20020a630005000000b003c6dcb20428mr11021960pga.73.1652315342027;
        Wed, 11 May 2022 17:29:02 -0700 (PDT)
Received: from lvondent-mobl4.. (c-71-56-157-77.hsd1.or.comcast.net. [71.56.157.77])
        by smtp.gmail.com with ESMTPSA id c19-20020aa78c13000000b0050dc762812csm2371951pfd.6.2022.05.11.17.29.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 May 2022 17:29:01 -0700 (PDT)
From:   Luiz Augusto von Dentz <luiz.dentz@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org
Subject: pull request: bluetooth 2022-05-11
Date:   Wed, 11 May 2022 17:29:01 -0700
Message-Id: <20220512002901.823647-1-luiz.dentz@gmail.com>
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

The following changes since commit 3f95a7472d14abef284d8968734fe2ae7ff4845f:

  i40e: i40e_main: fix a missing check on list iterator (2022-05-11 15:19:28 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth.git tags/for-net-2022-05-11

for you to fetch changes up to 103a2f3255a95991252f8f13375c3a96a75011cd:

  Bluetooth: Fix the creation of hdev->name (2022-05-11 17:18:42 -0700)

----------------------------------------------------------------
bluetooth pull request for net:

 - Fix the creation of hdev->name when index is greater than 9999

----------------------------------------------------------------
Itay Iellin (1):
      Bluetooth: Fix the creation of hdev->name

 include/net/bluetooth/hci_core.h | 3 +++
 net/bluetooth/hci_core.c         | 6 +++---
 2 files changed, 6 insertions(+), 3 deletions(-)
