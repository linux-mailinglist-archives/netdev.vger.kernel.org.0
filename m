Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B0E934CE77
	for <lists+netdev@lfdr.de>; Mon, 29 Mar 2021 13:06:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231610AbhC2LFj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Mar 2021 07:05:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231509AbhC2LFJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Mar 2021 07:05:09 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50ABAC061574
        for <netdev@vger.kernel.org>; Mon, 29 Mar 2021 04:05:09 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id ay2so4217360plb.3
        for <netdev@vger.kernel.org>; Mon, 29 Mar 2021 04:05:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:sender:from:date:message-id:subject:to;
        bh=5/8kk4ox/5Tuoi5bHBW9bZqDcQioEYzA8lrAMJq3ltE=;
        b=r3RPCSUxVlqJ5rgC6a/tvsVfMLLHwK8vLHOr1X99Vj/hlsll4LwgRg4fYrBZ7nAkAB
         ZB/m0DkAUJAMB/cgkvtwi8w18mx7TRarka2CP5geAnLZUNiCq5ruV++u69mQFnjT2h19
         Uz2F/vh0G16H2bWfbRK9CpFm3z4TdO+p9LR/zWZk/nu7TaxRt4XiZjrzIRMTJM6r+21K
         ePzlrgmm2sipwFOW7zyeyPR6a432RBiCrUhICTTapXanyIudRUJkB1yxqJ++oEb7pu+F
         YamX5ymygQAB2r+4oAaBlBOhM/YnGD+qgZSeGf6Ja+q8XaCtjKya1+AmFv+37adiD+4b
         QDsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:sender:from:date:message-id:subject
         :to;
        bh=5/8kk4ox/5Tuoi5bHBW9bZqDcQioEYzA8lrAMJq3ltE=;
        b=eYAyWHZX4egUJh/XxhPCeyD2aa0st35HLO7jhAEP+PnngDFgkK43LT28NY9FdmR162
         fHrO4lk8o4lz4O/SZT20sEEaIisYdKSlnCJiKxxRsqlOvkBVC6VvJHdQFVvyjFvtuWKS
         LgZYG6I/i6ftLn0auxw9tXad7SdlKBV0QQLVEzYYiFc+IY85zd4tW+gDUa8ABfmVDYsM
         hhjgSGicIb8I7FF/fVUhlsJoD8kXJwEN9tjfNreco6Yrm6H8ykZdkXjkHqQyPuYvmzII
         hIx75jgzZArr8bUSLWt/IPOsd4U8Z5E3kh3TerlaVZpe6wwHi8E0cZuqCa8CBghsaORV
         IW9g==
X-Gm-Message-State: AOAM532hM9Hgbcw0BWomVm/ZCO4cj45itSqZfwyEwTu78tQ95jxBg4kx
        LrPSU9D3lwpR3XheEamtR24e4cmHwy89+B0DLFo=
X-Google-Smtp-Source: ABdhPJxfpGPrVTeIYMwgVI0ifCOpFglpHMvu/hEn5IYrMhrvCbNYtnFHjnJszsMvC8YEUfSewnG6hMGVsG0uGQycrTM=
X-Received: by 2002:a17:90a:f68a:: with SMTP id cl10mr25869927pjb.87.1617015908975;
 Mon, 29 Mar 2021 04:05:08 -0700 (PDT)
MIME-Version: 1.0
Sender: mohamedissaka85@gmail.com
Received: by 2002:a17:90a:fb8d:0:0:0:0 with HTTP; Mon, 29 Mar 2021 04:05:08
 -0700 (PDT)
From:   kayla manthey <katiehiggins030@gmail.com>
Date:   Mon, 29 Mar 2021 11:05:08 +0000
X-Google-Sender-Auth: 0la4i4F4-oIf4KThukY6m2Q8Qmc
Message-ID: <CA+WYczNdsJ-g2aeRx+GBvE1bpAcv49AsoTyWQDnrziWDG8VRZA@mail.gmail.com>
Subject: 
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Vennligst jeg vil vite om du har mine tidligere meldinger.
