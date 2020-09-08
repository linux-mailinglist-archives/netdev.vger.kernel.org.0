Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D1F62621DD
	for <lists+netdev@lfdr.de>; Tue,  8 Sep 2020 23:22:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729298AbgIHVWi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Sep 2020 17:22:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728164AbgIHVWh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Sep 2020 17:22:37 -0400
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 383E0C061573
        for <netdev@vger.kernel.org>; Tue,  8 Sep 2020 14:22:35 -0700 (PDT)
Received: by mail-ej1-x641.google.com with SMTP id z23so416273ejr.13
        for <netdev@vger.kernel.org>; Tue, 08 Sep 2020 14:22:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=oqOh6m3rLnlC8ajqd5NeDF4oaHEgZ3CJ+Z2OjKrzUuc=;
        b=J4AozqdwEKhDUAF8qiC996g76KjEa+7fEqijzj1IFbCJEoXLhNG+Nrp0d50v6SzQzQ
         0uMGM41XDzGUpPiQtyQbPJ0eME8YRxb1Cnjz2IE6qrdgGZYl1ejj6n2uUX6pmNj+8rqH
         z0x+ZG76FWV/i42HQSlOGyd4mIfoB3DMKskJQMoYkyIA4qDxccFXw3QsJxJa7JJNdaJg
         mRjXd9Dgsr1QqCoTmoxMC8l3Xd/GAJnafq2Gxr6w5P42JzdZY8kHj6qyZJ+pXhdWhIVE
         jOXyBnV+6IKcft3XKG87pIdf6nyFg5pkYc2zr76bhSk6vtD7FJETscD3DmITNWD4nkPF
         rbPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=oqOh6m3rLnlC8ajqd5NeDF4oaHEgZ3CJ+Z2OjKrzUuc=;
        b=razja60g+8jT1S2/vl6WKbThhW088CfFURfLEJp+XZgT5kpEqIK1iYAb3z9IYTkuc6
         JWjBZsYoTKMXajzdWMxU1ejYZlpHYXvMOQtOwmwOzBwEo7iPBnj5ogMOsHQYvjWM7xMp
         ytMc78mm3EDk3b2z97OAFXjCIPYqQZFSqWdQnzwnPvAEey3cnCZZaA7llV2A+Kt718Uo
         TqIZej8ktYC7hoKRt93sjhiT/Zaf4bWSwLumIAntOtc+XXHCZDE3qH4OfIgRcxXxOlTw
         P+O4wu0NfJeaRqIiXVoAAyPFinv0kd9yadwKxoCldCscykLP2S8uuWCBqBnU8m5jzACz
         3SZA==
X-Gm-Message-State: AOAM5333TQaULx0VQDoaoQQI7TP41MEnIrQBLjpGeqRA/LLR06Ye8n91
        zGJ1Obg+uRnJhWJgi0Zf6Fm7Rcif4oZjYYqm8cFX
X-Google-Smtp-Source: ABdhPJyKvVm5mCUhxRz1wocuTCtuocuPD14pIldrj3Y3TUjT2RAvb0w0smMDFxSMcrS2qzG/vcpJ24LMokTS4CQ84OI=
X-Received: by 2002:a17:906:a415:: with SMTP id l21mr375281ejz.431.1599600153969;
 Tue, 08 Sep 2020 14:22:33 -0700 (PDT)
MIME-Version: 1.0
References: <20200908135915.22039-1-wanghai38@huawei.com>
In-Reply-To: <20200908135915.22039-1-wanghai38@huawei.com>
From:   Paul Moore <paul@paul-moore.com>
Date:   Tue, 8 Sep 2020 17:22:22 -0400
Message-ID: <CAHC9VhTMmChHskO2K8GchSxX06C-XdAVVQu9Gfih1BH-=eb+uw@mail.gmail.com>
Subject: Re: [PATCH net-next] cipso: fix 'audit_secid' kernel-doc warning in cipso_ipv4.c
To:     Wang Hai <wanghai38@huawei.com>
Cc:     davem@davemloft.net, kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 8, 2020 at 10:02 AM Wang Hai <wanghai38@huawei.com> wrote:
>
> Fixes the following W=1 kernel build warning(s):
>
> net/ipv4/cipso_ipv4.c:510: warning: Excess function parameter 'audit_secid' description in 'cipso_v4_doi_remove'
>
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Wang Hai <wanghai38@huawei.com>
> ---
>  net/ipv4/cipso_ipv4.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Thanks for catching this and submitting the fix.

Acked-by: Paul Moore <paul@paul-moore.com>

> diff --git a/net/ipv4/cipso_ipv4.c b/net/ipv4/cipso_ipv4.c
> index 2eb71579f4d2..471d33a0d095 100644
> --- a/net/ipv4/cipso_ipv4.c
> +++ b/net/ipv4/cipso_ipv4.c
> @@ -498,7 +498,7 @@ static void cipso_v4_doi_free_rcu(struct rcu_head *entry)
>  /**
>   * cipso_v4_doi_remove - Remove an existing DOI from the CIPSO protocol engine
>   * @doi: the DOI value
> - * @audit_secid: the LSM secid to use in the audit message
> + * @audit_info: NetLabel audit information
>   *
>   * Description:
>   * Removes a DOI definition from the CIPSO engine.  The NetLabel routines will
> --
> 2.17.1
>


-- 
paul moore
www.paul-moore.com
