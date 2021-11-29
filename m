Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8268F460ED5
	for <lists+netdev@lfdr.de>; Mon, 29 Nov 2021 07:41:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350788AbhK2Gon (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Nov 2021 01:44:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238716AbhK2Gmm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Nov 2021 01:42:42 -0500
Received: from mail-yb1-xb2a.google.com (mail-yb1-xb2a.google.com [IPv6:2607:f8b0:4864:20::b2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E755C061574;
        Sun, 28 Nov 2021 22:39:25 -0800 (PST)
Received: by mail-yb1-xb2a.google.com with SMTP id f186so39269041ybg.2;
        Sun, 28 Nov 2021 22:39:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=B6yKYPwr/LM20VGnd+7UYABkSSnQvOILrOCDqr/PwxE=;
        b=oUwGo+yHYn0UvXAR8F7SfTAYTI/JPc9AqrRqfdaFltqBnRTb5qmksF85JBE1ARa9pb
         K5ZeQrW8YwuE6oj7G61M7NPI6UM1fAo4Mh95eCPMvib/NF8Y36AHrlSrsUNahiEl3LKg
         89nv5PoPD/qtepMHUkQJDDj9wRnOZ4hPdYL8EnnUV06MZQaCQ0MIdYdil548DKkb7lo6
         z3Dt/WDiT+UoVqjAvZShK8Tb7+KG+ab0oJL26lRAV1345bLgKWjHk3XslfvLJzkVaSOb
         HZhqsaZtbMgYVzqfkT34a4iPTqxpX7QyKQLxLhDBmlQATiPt+N/BNM2MGfs+sHsT72hj
         ZbnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=B6yKYPwr/LM20VGnd+7UYABkSSnQvOILrOCDqr/PwxE=;
        b=QygGp5LLIaaPul61QpYputusH4KLWhNGwm5tVIyPHlebtLgf9P7ejO0LmuTbBAHJCU
         YHiQFkHpQLIEedrgVZsYr6Nh7gd6RJXOARev8z40UAx38nVScUYH7h50nce/QVAfwknz
         ujrnA+zh8CNKEclfxtP5lNLJE+0ToMb2D0BsKv0DrJNGDfnnDqFcQtUxorgqe5h1j6TB
         otvgmOnL2DQoLq7N/tkbiPhLHbkD4AJm+WFP1LW878eUNJCtmy1cPZ46FwlaMQr/9xT5
         Q/hkARRoIb2AVYd/7d8jVJoKumiK0YLAHK0tY4JZOiUz9uQ6/NRhO+RDIrlSMCviaRIU
         SNSQ==
X-Gm-Message-State: AOAM531PLB1De79tmBo9qBbgnSYBEutleJJ1M3YO84ukG/fjgbOCq+R3
        FFadl5H6kc7tGMmB+3rFGy629lQk7T0RXILraadBk5GP7JA=
X-Google-Smtp-Source: ABdhPJwsvmBAKHvBiarhsddSdnsJ5UOWtbfKkp/pdkROcfBQM000fltN4XDXGW3xJqQe2QajZ4/HKiaTq7ccGHL5RLI=
X-Received: by 2002:a25:4253:: with SMTP id p80mr32449552yba.312.1638167964657;
 Sun, 28 Nov 2021 22:39:24 -0800 (PST)
MIME-Version: 1.0
From:   Lukas Bulwahn <lukas.bulwahn@gmail.com>
Date:   Mon, 29 Nov 2021 07:39:13 +0100
Message-ID: <CAKXUXMyEqSsA1Xez+6nbdQTqbKJZFUVGtzG6Xb2aDDcTHCe8sg@mail.gmail.com>
Subject: Reference to non-existing symbol WAR_R10000 in arch/mips/net/bpf_jit_comp.h
To:     Johan Almbladh <johan.almbladh@anyfinetworks.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Paul Burton <paulburton@kernel.org>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Netdev <netdev@vger.kernel.org>, bpf@vger.kernel.org,
        "open list:BROADCOM NVRAM DRIVER" <linux-mips@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dear Johan,

In arch/mips/net/bpf_jit_comp.h and introduced with commit commit
72570224bb8f ("mips, bpf: Add JIT workarounds for CPU errata"), there
is an ifdef that refers to a non-existing symbol WAR_R10000. Did you
intend to refer to WAR_R10000_LLSC instead?

This issue was identified with the script ./scripts/checkkconfigsymbols.py.

Best regards,

Lukas
