Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 099F5440517
	for <lists+netdev@lfdr.de>; Fri, 29 Oct 2021 23:51:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231315AbhJ2Vxb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Oct 2021 17:53:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231173AbhJ2Vxa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Oct 2021 17:53:30 -0400
Received: from mail-yb1-xb2c.google.com (mail-yb1-xb2c.google.com [IPv6:2607:f8b0:4864:20::b2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C62A6C061570
        for <netdev@vger.kernel.org>; Fri, 29 Oct 2021 14:51:01 -0700 (PDT)
Received: by mail-yb1-xb2c.google.com with SMTP id s186so3459422yba.12
        for <netdev@vger.kernel.org>; Fri, 29 Oct 2021 14:51:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=f45ca7gZsYUq9gSRTvBzdUMqmFEDIrmlxlYEV3iWKMI=;
        b=KZUJSA1CzuqSmitLBKlG6oGOrQKiX8PJhsL9l5+cjYRwL2rsRn2qXGXqhYX4GberDq
         g5fVDpXTHWmv2Dqv429DHY4Lv7iFFFEFDUYmDDNel7VKWT+K2I+HYMHczCWcBAJ6nbmg
         UiDKQq3gFucePW1ZpMQcSDGKhafry2xauRY4c=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=f45ca7gZsYUq9gSRTvBzdUMqmFEDIrmlxlYEV3iWKMI=;
        b=5lXSEB5XlgPFWc86CLJSvJVUA81XX3jKSqbeaKWy03EV5mcoyWmVJ16bsK1QQwWuDE
         lWgO9lM/QpI88L5AaV3Y2ZC7VjSP4O3nPO7o3sK9txf3cEPpbRtH8HyG96w5WPkmhSN9
         TWcVQE1wdtnmrEt+fdybknQHLCgmdVFLuCgkIUXNxE47HqW/oA5P3jYXbWMHdFfdWqbp
         7Y2/qI2eNKpggVCd5hX/ESvyIb5ujEA+0JKjZE/nj+EcJlnWxo+5bSAZFOA3zJDW6MlY
         KPbw70Q6OwMn/yVlS1XtecfCpSy671DxZiZUMWQd8NwXqRdlrbYlCTXBCKOarM0W5k2y
         BvPQ==
X-Gm-Message-State: AOAM530DdD4bYZrJTtpYxbVtdE3q2aFBCew07Ic05qmVuTVPOySJkXET
        QgPaSKt09vaLn7NKpMCF9HbvLHT5dHCE4Vm6EA3qow==
X-Google-Smtp-Source: ABdhPJyw9Z7BARzXvRT+zclB1btIUWYPoyEPcAyeHcSKWNYtIqPHF9UeecN4n/XIYTPNo4W8ptaIzgTdvSx2ATugPTU=
X-Received: by 2002:a25:8882:: with SMTP id d2mr15187283ybl.68.1635544261081;
 Fri, 29 Oct 2021 14:51:01 -0700 (PDT)
MIME-Version: 1.0
From:   Ivan Babrou <ivan@cloudflare.com>
Date:   Fri, 29 Oct 2021 14:50:50 -0700
Message-ID: <CABWYdi1XNPbCHfR7-8NiSnjNG4cCy=KTHPKcHiDYp5E-0F2g0A@mail.gmail.com>
Subject: bpf, cgroups: Fix cgroup v2 fallback on v1/v2 mixed mode [backport]
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     kernel-team <kernel-team@cloudflare.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Stanislav Fomichev <sdf@google.com>, Tejun Heo <tj@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

We have re-discovered the issue fixed by the following commit in v5.15:

* https://github.com/torvalds/linux/commit/8520e224f54

Is it possible to also backport the fix to 5.10 series, where the
issue is also present?

Thanks!
