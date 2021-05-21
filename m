Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC5E638D1E3
	for <lists+netdev@lfdr.de>; Sat, 22 May 2021 01:18:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230104AbhEUXTr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 May 2021 19:19:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229548AbhEUXTq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 May 2021 19:19:46 -0400
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3C05C061574
        for <netdev@vger.kernel.org>; Fri, 21 May 2021 16:18:21 -0700 (PDT)
Received: by mail-pg1-x534.google.com with SMTP id t193so15414311pgb.4
        for <netdev@vger.kernel.org>; Fri, 21 May 2021 16:18:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=YSr1Vf0XyUjfHJV+SgWyqIHRaqGfHQEiW22UDxprzDo=;
        b=dPCdZGLGoFbffdubUlLVpI0r4272f3+lFQ9rilcf83YBx7JVYtZhUHQ/FKJxIKkNNw
         OlGTlFSRSY2LomHB9c8y/jqXaxjjOaaBzWtKkFW+iM+RMTks0IGDOHnLDOxV6v9PTYfY
         tncdaL4n11eSkVrbZMF0iulOsN8VNlE7iVWPU08tqr+5ZLuLK7G5xQ1Bo/djXWSkNHNc
         a+e+P4qBkzf1xYsnRSt5OSZTFRycZMmS2IoeTvXJNwV8unE/7KoWbHA/1jy+kOsAphJO
         HxByS5oVCa7CCBx5dCiUntnA/T4zfoKKBXqICVkODy0ynSYnKoUpLbq0g73kg3vcbOm+
         F5Sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=YSr1Vf0XyUjfHJV+SgWyqIHRaqGfHQEiW22UDxprzDo=;
        b=sPKq8t0LH+xxjyo1Wct4iyP0JVJTxMnkYeWXaDd1+k8XmwOQQGh82ilcEPgRrP99uk
         6sOJEPUJyhgy7+T6xOh9qWaBgjPTEjuMfFxrh63qXkldaIuZI42zytLZWSqirz3eT2iw
         2/dhRgL9J6ae5o5o8aeFYVDvinc3urn7SmuCV5p1p234x9IrcJLglJtA8tEh/KyLYJCy
         ykW9X6ahvXgCmjr69h7hh/yUEkHWQckhVR0kbBCoAT8b8GI4mdOFqhjzAdsH5A3eWnBx
         ZZxFqjgmynzuhHTh5FjGAeBj6U3YDI8O3t+HgpBDagaCZsIOvhPIMwy/krtkto6b6iTT
         QSXw==
X-Gm-Message-State: AOAM532xneM/WN7fK+Pao4SKff85ZcMcb9MuTnyGW23n21Or7b0DO2KB
        R7N/no3jO4jLsTJvrYt9ps0p3a0Tr6J98qNyIGCnDAOUMocMZA==
X-Google-Smtp-Source: ABdhPJyeS0V5tq1OYbJO2Df7AIgB+1H42RHt45xAwjZYgcCuP4+xOXXncuPhGqiqh11OA+9znyA9FS0iyNi01X2RFiI=
X-Received: by 2002:aa7:8f37:0:b029:2db:551f:ed8e with SMTP id
 y23-20020aa78f370000b02902db551fed8emr12285025pfr.43.1621639099932; Fri, 21
 May 2021 16:18:19 -0700 (PDT)
MIME-Version: 1.0
References: <20210521223337.1873836-1-vinicius.gomes@intel.com>
In-Reply-To: <20210521223337.1873836-1-vinicius.gomes@intel.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Fri, 21 May 2021 16:18:08 -0700
Message-ID: <CAM_iQpVf+9DQktJKJxa49z6m8HZAzvRH9Y9Lk6whcgbXL_24KA@mail.gmail.com>
Subject: Re: [PATCH net-next v1] MAINTAINERS: Add entries for CBS, ETF and
 taprio qdiscs
To:     Vinicius Costa Gomes <vinicius.gomes@intel.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>, Jakub Kicinski <kuba@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 21, 2021 at 3:34 PM Vinicius Costa Gomes
<vinicius.gomes@intel.com> wrote:
>
> Add Vinicius Costa Gomes as maintainer for these qdiscs.
>
> These qdiscs are all TSN (Time Sensitive Networking) related.

I do not mind adding a new section for specific qdisc's, but
can you merge all of the 3 into 1 as you maintain all of them?

Something like:

CBS/ETF/TAPRIO QDISC
M: ...
F: ...
F: ...
F: ...
...

Thanks.
