Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 918361E7538
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 07:12:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725865AbgE2FMo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 May 2020 01:12:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725768AbgE2FMn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 May 2020 01:12:43 -0400
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93BE3C08C5C6
        for <netdev@vger.kernel.org>; Thu, 28 May 2020 22:12:43 -0700 (PDT)
Received: by mail-pf1-x434.google.com with SMTP id z64so695489pfb.1
        for <netdev@vger.kernel.org>; Thu, 28 May 2020 22:12:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=BJnC+F/8foXa8X2dJA0/Sqp55pxz1g2RkOhtIqMl4pg=;
        b=TNR4I00m892wtMnnOg1p4CPWE4Uo5MzgG0ueOFSwsF8c5cL1fD6hINeFdpmEYPT5VF
         Kiu1Cvu0lBEZJnQRrjUzIV5Ec7f9XLUAMawdaQMgUWbZNQ26hbYKGTaOfG0BIwKDxzO5
         5y4LR8nlV8s0hYaOpntkYGOz3RtMRU4rE/DsU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=BJnC+F/8foXa8X2dJA0/Sqp55pxz1g2RkOhtIqMl4pg=;
        b=E0kCZjAzx/8oVFhvIsgi6S6YzxS4YKwuSxHI85AM+MHobBPx5ojyW/QNV5oCJm/H0Y
         IN2/SX1jU71up3uibts92UQ2ieIhaFrdWBZuOdn7fxgbandrcfe1yG5JvQ+OEQ5f3rhe
         hYDo7KOVlOdlTOBUF8kz+N3BhpZlDL0i3jjKFv4NrDeh5JIl9I2PV3iprGi+QuSsUZH4
         1azJTp5T3r9337CfvU3+Gl4CC1pwPCEiQ11cikvLx3M1TxVZjJ4qpA0Rmcyj8vsqKpYA
         aQkrLUcPsvZ1g0cd8a9PojF2NL8dhns0qMN3bLc1Gz7CF4Lr3bKbO+FDwSr6Id0FkmtZ
         EFgA==
X-Gm-Message-State: AOAM533+C0ZrtXLwYxl+WvZrXyZ37CswYqrtdwq7+FHZl8nasoX/RJvK
        jai9yV5j9ck28+bx2EhDQRtkcQ==
X-Google-Smtp-Source: ABdhPJxzKKUHFvmr8YnNjAsVa2dNSMlQj+m08RnVDCE9nml8Eee3H+VZXtunWUIJXXadF6ADDG3jkw==
X-Received: by 2002:a63:689:: with SMTP id 131mr5970700pgg.401.1590729162036;
        Thu, 28 May 2020 22:12:42 -0700 (PDT)
Received: from monster-08.mvlab.cumulusnetworks.com. (fw.cumulusnetworks.com. [216.129.126.126])
        by smtp.googlemail.com with ESMTPSA id z20sm6935634pjn.53.2020.05.28.22.12.40
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 28 May 2020 22:12:41 -0700 (PDT)
From:   Roopa Prabhu <roopa@cumulusnetworks.com>
X-Google-Original-From: Roopa Prabhu
To:     davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, dsahern@gmail.com,
        nikolay@cumulusnetworks.com, jiri@mellanox.com,
        idosch@mellanox.com, petrm@mellanox.com
Subject: [PATCH net-next 0/2] vxlan fdb nexthop misc fixes
Date:   Thu, 28 May 2020 22:12:34 -0700
Message-Id: <1590729156-35543-1-git-send-email-roopa@cumulusnetworks.com>
X-Mailer: git-send-email 2.1.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Roopa Prabhu <roopa@cumulusnetworks.com>

Roopa Prabhu (2):
  vxlan: add check to prevent use of remote ip attributes with NDA_NH_ID
  vxlan: few locking fixes in nexthop event handler

 drivers/net/vxlan.c | 36 +++++++++++++++++++++++++++++-------
 1 file changed, 29 insertions(+), 7 deletions(-)

-- 
2.1.4

