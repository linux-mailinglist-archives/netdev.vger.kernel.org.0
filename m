Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12F0D21C6DB
	for <lists+netdev@lfdr.de>; Sun, 12 Jul 2020 02:49:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727777AbgGLAs4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Jul 2020 20:48:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726948AbgGLAs4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Jul 2020 20:48:56 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF086C08C5DD
        for <netdev@vger.kernel.org>; Sat, 11 Jul 2020 17:48:55 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id w17so3908192ply.11
        for <netdev@vger.kernel.org>; Sat, 11 Jul 2020 17:48:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=bEyMXhX7K1Q9tWRRAML9qpm1JKkh/GXCO0/4u1LgwZo=;
        b=GXRwiMPzKLbQTxiC0+GctNb+cbGm6S4/1BoBKgg45s7pcmstXInY0wuifdSWTn1Px4
         Iz2tlWChDuNQ/frl0xZKGwm31D62Yyed21gBdKtZL9JHeRpM0LXLADXPsda8khIq8Vqa
         3HLzBWjgMku1iN6xlknNwXF9US3pBaf1bKmSE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=bEyMXhX7K1Q9tWRRAML9qpm1JKkh/GXCO0/4u1LgwZo=;
        b=dhJXv983Ttif69pjNh/tHBJ2h0pqdYCdHqGuw3uOfc9uugR2QlLj5oqglOs7P7WMOg
         o7kMrdqNLbE2rBDUDQZhgGlWf1ehoR3iHfSM/NVPjsyBOn/7PpmudCor4NZcoFoNfkm7
         PPL152lyBZiO/8oKwP4cjUWoB7v/IQqgYpj5uKcidmrY8j3KaVbi2YmI4285Q5ITw1MD
         RCvw3uBZ0qPEcM/4L8xDocSVDlFyZL9D+Ll5Wr+hYP4vYEV7NqyWKzOyYu2NAcrViKvv
         pCkxwAWI5erZzCrWukM3AY8L1ORe86q8GrGk96ubabk3+vrN+Tlnf4JuYEcRcGMNeotQ
         f2UQ==
X-Gm-Message-State: AOAM5306lRUkpi/fdstR81UnEhdc+sqlCZisivM1dU2wxOKQWjpJ0zV7
        yyoaFwR38xTY0O++kyEt7/LY990EZZM=
X-Google-Smtp-Source: ABdhPJzvwsrPiIErmWhwPcVam3TAw8M9bZ1u6qj+cC0YOi8NrJ6KBYzEu29Nbfcia01DUZxw/jjG5g==
X-Received: by 2002:a17:902:7008:: with SMTP id y8mr32148278plk.85.1594514935058;
        Sat, 11 Jul 2020 17:48:55 -0700 (PDT)
Received: from localhost.swdvt.lab.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id q6sm10157589pfg.76.2020.07.11.17.48.52
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 11 Jul 2020 17:48:54 -0700 (PDT)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net 0/3] bnxt_en: 3 bug fixes.
Date:   Sat, 11 Jul 2020 20:48:22 -0400
Message-Id: <1594514905-688-1-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

2 Fixes related to PHY/link settings.  The last one fixes the sizing of
the completion ring.

Please also queue for -stable.  Thanks.

Michael Chan (1):
  bnxt_en: Fix completion ring sizing with TPA enabled.

Vasundhara Volam (2):
  bnxt_en: Fix race when modifying pause settings.
  bnxt_en: Init ethtool link settings after reading updated PHY
    configuration.

 drivers/net/ethernet/broadcom/bnxt/bnxt.c         | 22 +++++++++++++++-------
 drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c |  5 ++++-
 2 files changed, 19 insertions(+), 8 deletions(-)

-- 
1.8.3.1

