Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E1BF1F8B5E
	for <lists+netdev@lfdr.de>; Mon, 15 Jun 2020 01:57:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727954AbgFNX5f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 14 Jun 2020 19:57:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727928AbgFNX5f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 14 Jun 2020 19:57:35 -0400
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C78E1C05BD43
        for <netdev@vger.kernel.org>; Sun, 14 Jun 2020 16:57:34 -0700 (PDT)
Received: by mail-ej1-x641.google.com with SMTP id q19so15491019eja.7
        for <netdev@vger.kernel.org>; Sun, 14 Jun 2020 16:57:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=RiuNObIpLs2bTzvlx4fAFRxCG127tk/G9KYxxm+N7uQ=;
        b=aYVTD8B1bXEP+A6Y0dY/5i12JGSCoArH7X1fqoHUdyHLz7fRhSjNKDd9eSOsW5x36L
         bCIikhOWKIxZediFx2TeGvOp64+2gYG81KhrQaySTtXQ7eNjjqpZFUDRnl/QBbqNP7Ti
         2OuxycbsULkfhXFyWvxtzOjNqIrdvF2Qh55i8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=RiuNObIpLs2bTzvlx4fAFRxCG127tk/G9KYxxm+N7uQ=;
        b=HIf0YWtd8jZwP+LWQYvmsgmTMJP5Ybh2LWAgSQ41000Jj2XhUPGfmvapADfSDpxN2w
         ZxF31XQYceFz0ybwn3i0Pu98KKAK6Q3eutAOkfy37A/02GoHiJuc1SAqp0ixDZpNO9xE
         SbLq90EtcRrhwzIEkAB2WhxMdAyIHMTr24BYbaa3nTGWUYu9wkDKiOprCChrF+jVwquN
         G50uHlIi1dcvcR8CTtc1eiV3ns+JGo8WA7RY+pzqVBYR4NToPaik674NBMjzM9k8XxIG
         QGCMXD9uk4Dzyzti4SKE32SdS6B9xa9FULBts1t2YXvzFrnI6MvHC10kVBm1K4AcBSUc
         3JMA==
X-Gm-Message-State: AOAM530xZV1ZaDBn5tDU1QcF31KpX6COcGKkGGnE7wzBdyyJQF4P1mIN
        ROTJGU+3bW7qGi4V5X64c5MIM2byc+4=
X-Google-Smtp-Source: ABdhPJyyxAThWunwbWi5zQtg4VWR4wKQ/zJOP2U1IWuMUQFXEHQTAm8qfax+2dDGPCC7qEqtfQt/rg==
X-Received: by 2002:a17:907:1110:: with SMTP id qu16mr23994373ejb.539.1592179053314;
        Sun, 14 Jun 2020 16:57:33 -0700 (PDT)
Received: from localhost.swdvt.lab.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id gj10sm7891398ejb.61.2020.06.14.16.57.31
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 14 Jun 2020 16:57:32 -0700 (PDT)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net 0/4] bnxt_en: Bug fixes.
Date:   Sun, 14 Jun 2020 19:57:06 -0400
Message-Id: <1592179030-4533-1-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Four fixes related to the bnxt_en driver's resume path, AER reset, and
the timer function.

Michael Chan (3):
  bnxt_en: Simplify bnxt_resume().
  bnxt_en: Re-enable SRIOV during resume.
  bnxt_en: Fix AER reset logic on 57500 chips.

Vasundhara Volam (1):
  bnxt_en: Return from timer if interface is not in open state.

 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 35 +++++++++++++++----------------
 1 file changed, 17 insertions(+), 18 deletions(-)

-- 
1.8.3.1

