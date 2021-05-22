Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56E8C38D738
	for <lists+netdev@lfdr.de>; Sat, 22 May 2021 21:22:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231340AbhEVTXg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 May 2021 15:23:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231310AbhEVTXf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 May 2021 15:23:35 -0400
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59E9CC061574
        for <netdev@vger.kernel.org>; Sat, 22 May 2021 12:22:09 -0700 (PDT)
Received: by mail-pg1-x52e.google.com with SMTP id j12so16968534pgh.7
        for <netdev@vger.kernel.org>; Sat, 22 May 2021 12:22:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0x0b3e/hYrjG4GYlQ6UIJigYryi47UR+O/jVDOYmAKE=;
        b=E8i2bY3vlQDcmc1TRb5pUDQ+YGWbZQFwaA0UTPCfJT/+Y6COE3xGPRNC8vETQPmNFj
         +zWRHnnNDvsHx4ZaIMTyq0Rp24kEklXGS86TkD/0pz+e/1WEsXs0aqmSPIsyRuCokvRc
         w50+mUe48RHizEQUfUT/x2ZEm/vKFP7jMbHn6PE51XM2JPJhUeJAHSFW9sQMvEPyRFXK
         MvJ2cXjcu5vNobWLQkoQp5K1pIloAM5Bc3O6Ur40ZQCyBy+upAuUyLbQQPgwWu53iVoO
         8sL6GOjO40LOTLbERQA+a6bASz5x+v6iOILuQt8huASoNxNMNtVxJrj6FsUv7ByDnptM
         e+LA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0x0b3e/hYrjG4GYlQ6UIJigYryi47UR+O/jVDOYmAKE=;
        b=RKnpomuiErGrSWOXUG/lBq6vA4vrAZAULnzsHS0zm1KugIhVg4RqR+BTyVYwwE8vZk
         XMskkCQwTaYlUeHd+9uTR+4v83gUNxRO8Vquw/AgQBrb64346xIAwfP2A9t+BNaDjn9D
         MbcijaJa6kZyOeonZSSVMKoms1ICsuPGZmrGeQVbEEElvgtwQNTfYQXZaCeFCKOz0uKO
         V5xNPd5gDiyOj+BjXv4HURDaMjDBQfdhiCkVrPOhTq7bC38I6Detfe1/zO7SSEr4OZhG
         34wtfufWFRUTwgHDQsweR5wC0ZtbX/bUy0s43Z8f/7ihqzKd3s+5zJyJ3vNGQTGYU+yn
         02AA==
X-Gm-Message-State: AOAM530EYFGkcR0FzTAe7Q9N5Ya6myscMQwwUsOhQoKgYkmpT3tK7aEc
        ZvrRdC0S9mIvUrQhsLLa1jxWwBJ5oNqtJhvVQdk=
X-Google-Smtp-Source: ABdhPJwUXnvN0SFw0L+xxkHCL7zcguTxjNh6l8HuXxGbEF7UUWbf+jNaYwYy6ko6YIqHiGSI/AMQ7UGrZNOidIaMQrg=
X-Received: by 2002:a63:e709:: with SMTP id b9mr5523854pgi.18.1621711328655;
 Sat, 22 May 2021 12:22:08 -0700 (PDT)
MIME-Version: 1.0
References: <20210522004654.2058118-1-vinicius.gomes@intel.com>
In-Reply-To: <20210522004654.2058118-1-vinicius.gomes@intel.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Sat, 22 May 2021 12:21:57 -0700
Message-ID: <CAM_iQpU+VCtQJCQgEpKtfgQTr-rRf07dLj5f86jkZimsQH6e5g@mail.gmail.com>
Subject: Re: [PATCH net-next v2] MAINTAINERS: Add entries for CBS, ETF and
 taprio qdiscs
To:     Vinicius Costa Gomes <vinicius.gomes@intel.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>, Jakub Kicinski <kuba@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 21, 2021 at 5:47 PM Vinicius Costa Gomes
<vinicius.gomes@intel.com> wrote:
>
> Add Vinicius Costa Gomes as maintainer for these qdiscs.
>
> These qdiscs are all TSN (Time Sensitive Networking) related.
>
> Signed-off-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>

Acked-by: Cong Wang <cong.wang@bytedance.com>

Thanks.
