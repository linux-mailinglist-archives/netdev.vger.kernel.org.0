Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 134D12103AC
	for <lists+netdev@lfdr.de>; Wed,  1 Jul 2020 08:13:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726905AbgGAGM6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jul 2020 02:12:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726615AbgGAGM5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jul 2020 02:12:57 -0400
Received: from mail-il1-x144.google.com (mail-il1-x144.google.com [IPv6:2607:f8b0:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98492C061755
        for <netdev@vger.kernel.org>; Tue, 30 Jun 2020 23:12:57 -0700 (PDT)
Received: by mail-il1-x144.google.com with SMTP id s21so4914560ilk.5
        for <netdev@vger.kernel.org>; Tue, 30 Jun 2020 23:12:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=1mD2qcpmXNZpHoX/j6sTFkNOa7u7zBCkUoqgoCbSl8M=;
        b=Tqa6oH9p5GOWwbVRO1h+/CSGnUn3T9mTefsNYOJzI68FOaKOeb4OtNAAdVxYUQUCnl
         9GboNub1Ac1KbGJI7M0jWYaqDoUPe/O5Om1o68rXqatV7eHFIAIKzP3wHWRwIcl3vCCu
         0WofGIPljogNxAzRIOrsXBGCx33DT/6qqxd3zLNd8yzwwRDxCVvVGfBYZJLC821bwsOE
         Gs4xGqh2nKJ/w0qqogm0G2MfZ/Do4ClA8kh+J4DjtSr59Loh2ngTPrOrlmcES+9rl0IN
         JBNoZhP64Ej4a8DjcpoynKA7UWhbpSzNiEEaR/UMcNE3gSa8Aeym18smLMUyxsB7AcHm
         fUtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1mD2qcpmXNZpHoX/j6sTFkNOa7u7zBCkUoqgoCbSl8M=;
        b=KqAaF0cV30hn1RLBuvcrTddSgdc5IN9S2H2+oRdVp3TEiQLRufw/V+IqeAWaBG8EKM
         2pnlLiUICVMAOS6sErJlWp08xjorEQN0XL3mC6AFFtgMHzn/px2qA4kAM6EIwaNm6Umm
         aJRKYPP3pEwqpAjH4YwMaA+fMNjZQ2BWMcFaI8KMCSyIyBVdHyfCTR2Y8H6sheeXJeXm
         mPNdTbfWASqRxpybtJQzB8C0jYYouSQFEVMP7wjd6p9y7KLc59pPCuYNKO9l2awDvZ8/
         cydm6Pj+PsAvmimrKJ9NPsnQeIKtRXoFqtE/EOLPRAjhYobLiU9wtwRLCIewaC8kE5ts
         4OHA==
X-Gm-Message-State: AOAM531djGb9E5n2QmilgFF8piSPox/s8IHqbhygBGdYSsYjfdya5R/3
        DyCS/D2lQVWF+cxPepJM6QedR7/WkIIySPZ8oqk=
X-Google-Smtp-Source: ABdhPJzA5HRgt7K7DNrIEgf0V6eHIqj8kWk698hEqGGVl0kEZ2EnmMttG9rSDZelLmKAGWvPGuzHuKngF+ZWNX2YhKc=
X-Received: by 2002:a92:bb0b:: with SMTP id w11mr6529331ili.238.1593583976888;
 Tue, 30 Jun 2020 23:12:56 -0700 (PDT)
MIME-Version: 1.0
References: <1593485646-14989-1-git-send-email-wenxu@ucloud.cn>
 <CAM_iQpVFN3f8OCy-zWWV+ZmKomdn8Cm3dFtbux0figRCDsU9tw@mail.gmail.com>
 <10af044d-c51b-9b85-04b9-ea97a3c3ebdb@ucloud.cn> <CAM_iQpWmyAd3UOk+6+J8aYw3_P=ZWhCPpoYNUyFdj4FCPuuLoA@mail.gmail.com>
 <8b06ac17-e19b-90f3-6dd2-0274a0ee474b@ucloud.cn>
In-Reply-To: <8b06ac17-e19b-90f3-6dd2-0274a0ee474b@ucloud.cn>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Tue, 30 Jun 2020 23:12:45 -0700
Message-ID: <CAM_iQpWWmCASPidrQYO6wCUNkZLR-S+Y9r9XrdyjyPHE-Q9O5g@mail.gmail.com>
Subject: Re: [PATCH net] net/sched: act_mirred: fix fragment the packet after
 defrag in act_ct
To:     wenxu <wenxu@ucloud.cn>
Cc:     Paul Blakey <paulb@mellanox.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 30, 2020 at 11:03 PM wenxu <wenxu@ucloud.cn> wrote:
>
> Only forward packet case need do fragment again and there is no need do defrag explicit.

Same question: why act_mirred? You have to explain why act_mirred
has the responsibility to do this job.

Thanks.
