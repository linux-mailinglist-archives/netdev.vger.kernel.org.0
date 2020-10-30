Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B70229FF52
	for <lists+netdev@lfdr.de>; Fri, 30 Oct 2020 09:02:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725954AbgJ3ICw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Oct 2020 04:02:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725784AbgJ3ICv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Oct 2020 04:02:51 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D243C0613CF;
        Fri, 30 Oct 2020 01:02:22 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id a200so4561760pfa.10;
        Fri, 30 Oct 2020 01:02:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=4T5wXLF+Eu0yD7VQqlQ0APXG2OXoFP3uK9mTWxFEVvE=;
        b=cneQz9/v/27EalKInF6rN0+KjA6SYHGE/MDIPOGTkA9FT5GlnOp25GTjhWTdoJtweH
         UCO8F8gxGNKIY6wP4HxhisI63sRZXRHM5FTm6pNQItI1DQzpGACCgMpmfc50fhC3AR+F
         leF0KEk7Lj+RhH0UH89cxsNnowcOiq8IyH0PLK+5dhjVNkzbgxzvoJEORTbOIzqZZPyE
         AaMsDZv06cKsy1r9yc0egTvFuCpM1k+uNfKD3QarK2KKnU0MIYmKW8UrsRkK57DrpOb/
         ya1paAfo8JoPxoxnCI5B0igEoelvMNbh/qhk140EKkMao+6Xfl94j0T7N7LeND+l32Q1
         8dUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=4T5wXLF+Eu0yD7VQqlQ0APXG2OXoFP3uK9mTWxFEVvE=;
        b=PVNdtHe7oPDk9QrSmzdiXQWUp9eiaOSWA1Gd0iy1AwPZX++accVd1H3Knhn5G2H153
         Uz+hQaV05z6hODG1VdLdzdtSPVmTnu8Bd5cHfLuddFhtrPWE093WxBCoHuI+MZilB9hW
         APZMfVumfeHSgbWtGcxnRFMm8KhYeFq/StCh8X4rZuU2cdyb5/3+gctJW6HViSLT64qa
         WwWVao4RUGYOSs46gX2T0D9QBM9v802W/7pfL5g1fzxH1ovhvgiIq3TtdHcGNZ5WG9yX
         95iKNOqQPZRkllAqOfqhAG6eNLsYPPwBKMCk1QLy09i9SIUoEoV1Winrdt/d+WNtDhIE
         SugA==
X-Gm-Message-State: AOAM530P03JCRfb2OwtmDQZbasvHbBMFWOsV7hJKRoDifVITTdSubNwF
        /3OnnVEookZswAZgeOLiuV8=
X-Google-Smtp-Source: ABdhPJykhulgAvrZjlfyO7bIK/OQLCRnIWl4dFSLAQVdZGPlQKbQtL+XgJoUTSiw37yK4uH/EgpHbA==
X-Received: by 2002:a62:30c2:0:b029:152:83fd:5615 with SMTP id w185-20020a6230c20000b029015283fd5615mr8391016pfw.22.1604044941355;
        Fri, 30 Oct 2020 01:02:21 -0700 (PDT)
Received: from [192.168.1.59] (i60-35-254-237.s41.a020.ap.plala.or.jp. [60.35.254.237])
        by smtp.gmail.com with ESMTPSA id mm19sm2300199pjb.45.2020.10.30.01.02.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Oct 2020 01:02:20 -0700 (PDT)
Message-ID: <58c24e12a05d32bda1816a44c462721ba0ed5894.camel@gmail.com>
Subject: Re: [PATCH 2/3] mwifiex: add allow_ps_mode module parameter
From:   Tsuchiya Yuto <kitakar@gmail.com>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Brian Norris <briannorris@chromium.org>
Cc:     Amitkumar Karwar <amitkarwar@gmail.com>,
        Ganapathi Bhat <ganapathi.bhat@nxp.com>,
        Xinming Hu <huxinming820@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        "<netdev@vger.kernel.org>" <netdev@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Maximilian Luz <luzmaximilian@gmail.com>,
        Andy Shevchenko <andriy.shevchenko@intel.com>, verdre@v0yd.nl
Date:   Fri, 30 Oct 2020 17:02:16 +0900
In-Reply-To: <CA+FuTSdayk_YwH2F_k4HYsYPCn_u-k_qdowHpMJUHvLXrvdZ7g@mail.gmail.com>
References: <20201028142433.18501-1-kitakar@gmail.com>
         <20201028142433.18501-3-kitakar@gmail.com>
         <CA+ASDXMXoyOr9oHBjtXZ1w9XxDggv+=XS4nwn0qKWCHQ3kybdw@mail.gmail.com>
         <CA+FuTSdayk_YwH2F_k4HYsYPCn_u-k_qdowHpMJUHvLXrvdZ7g@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2020-10-29 at 13:04 -0400, Willem de Bruijn wrote:
> On Wed, Oct 28, 2020 at 9:13 PM Brian Norris <briannorris@chromium.org> wrote:
> > 
> > On Wed, Oct 28, 2020 at 2:56 PM Tsuchiya Yuto <kitakar@gmail.com> wrote:
> > > 
> > > To make the ps_mode (power_save) control easier, this commit adds a new
> > > module parameter allow_ps_mode and set it false (disallowed) by default.
> 
> This sounds like some form of access control, not something that makes
> power control "easier"? What exactly is the use case.

Thanks for the review!

As I replied to Brian, userspace tools sometimes try to enable power_save
anyway regardless of default driver settings (expecting it's not broken,
but in fact it's broken), the module parameter like this is required.

So, the commit message is misleading. What will be "easier" is letting
userspace tools know power_save should be off, not the procedure of
toggling ps_mode state in the driver.

> Also, module params in networking devices are discouraged.

Even though it should be avoided, some upstream drivers provide a module
parameter like this to let users enable it if needed (since they disable
power_save by default because of stability on some devices) likw this
commit 0172b0292649 ("iwlagn: add power_save module parameter").


