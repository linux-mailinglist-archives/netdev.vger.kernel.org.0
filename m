Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BF502ADA81
	for <lists+netdev@lfdr.de>; Tue, 10 Nov 2020 16:36:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731255AbgKJPgu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Nov 2020 10:36:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730139AbgKJPgu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Nov 2020 10:36:50 -0500
Received: from mail-lj1-x244.google.com (mail-lj1-x244.google.com [IPv6:2a00:1450:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E9E6C0613CF;
        Tue, 10 Nov 2020 07:36:50 -0800 (PST)
Received: by mail-lj1-x244.google.com with SMTP id y16so15179694ljk.1;
        Tue, 10 Nov 2020 07:36:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=yCkfPOQLt6gc9t/YVztMhlgr4Q0m8ZRXrNAsWzJdQfY=;
        b=KaMyqlkTsiPf3suhjyjMamyRy8K4B1u/3SRxjjEwZ97h5crMUSVRfFhlJl6KUXcwhT
         1n2y2lPMK3Q8k2id7wHAnzTuAJ45PV3xjtFz6DR7FGTO6teld0ujevZqdKa25Edo25sG
         DfipG5Cca4lhBFCQ8TMary0klLHMfmUZrRiKBzhUfQHAVAW7qo6c3a6RiE1SPWW0hZ6s
         Vyrb0BLOE0tfJteCnWGj+f8VqYQ+bqyEuaMvqCOf8th7I4kBy7zMFKVT9PapKkPdT8z5
         b0pEKfzXW5iHiI5KGKiRsf5+nWPcEoNFldHfloFY3M2nUZCODbCUy5YFZV1lHWO5vWtC
         Picw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=yCkfPOQLt6gc9t/YVztMhlgr4Q0m8ZRXrNAsWzJdQfY=;
        b=EnnkCbVFEVgT9ahoGLlHQfo4n+BfRKvx4S60aKz3wpRSVh8YI8fSdni+q+0LT5Ov4j
         XkPrksPNPCqaT8KJakrisHQm1A2tNxXhNI2uFvfD92fWON/ZI640cD1Bnq3KNb3wLRZV
         ymtxQF6EOkyHhrJFxO1Q3svzKhtLi0g+5/ZBuLKcbmhyMyxxv15LFGIuzBi5Dss0WGB5
         idF68HO8oFvq0Veu+KJJs+BGVIOqRd8AzVbfxZy7EYURw9GPSAbNZB4V6BdbA05aVVYX
         7dMOFgPITOGBoR3urQcAWL/6UP/09No8EaqkCbms/Isd0DKQksPC1Xa8e3kbYMph1HP8
         pbpA==
X-Gm-Message-State: AOAM532d1DNMGqrrXljnPbJ0bp6NOabDPkjr2Srv/QY32y4dEyHQ1Kv0
        S0eRcUiaqy78p31DdU3zurfG5hrRRAaK0g/3zn8=
X-Google-Smtp-Source: ABdhPJw3sLVI0y9BKV7BKGuHRya4tYsmojgjE0CKJCKR0tZle6ao0nA4GKyusXzZT4wWrrr8YuLu8kRDvLl1zimiQWs=
X-Received: by 2002:a05:651c:2041:: with SMTP id t1mr6810110ljo.202.1605022608722;
 Tue, 10 Nov 2020 07:36:48 -0800 (PST)
MIME-Version: 1.0
References: <5fa8e9d4.1c69fb81.5d889.5c64@mx.google.com> <5fa9b34f132a5_8c0e208ca@john-XPS-13-9370.notmuch>
In-Reply-To: <5fa9b34f132a5_8c0e208ca@john-XPS-13-9370.notmuch>
From:   Menglong Dong <menglong8.dong@gmail.com>
Date:   Tue, 10 Nov 2020 23:36:37 +0800
Message-ID: <CADxym3b3nt5GP6H3HKDnk27zfjCX3CUg2B=mzFugk-d3-TPDMQ@mail.gmail.com>
Subject: Re: [PATCH] net: sched: fix misspellings using misspell-fixer tool
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        xiyou.wangcong@gmail.com,
        =?UTF-8?B?SmnFmcOtIFDDrXJrbw==?= <jiri@resnulli.us>,
        David Miller <davem@davemloft.net>, ast@kernel.org,
        daniel@iogearbox.net, kafai@fb.com, songliubraving@fb.com,
        yhs@fb.com, andrii@kernel.org, kpsingh@chromium.org,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, bpf@vger.kernel.org,
        Menglong Dong <dong.menglong@zte.com.cn>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi, John.

On Tue, Nov 10, 2020 at 5:23 AM John Fastabend <john.fastabend@gmail.com> wrote:
>
> Hi, you will want to add net-next to the [PATCH *] line next time
> to make it clear this is for net-next. The contents make it
> obvious in this case though.
>
> Also I'm not sure why the bpf@ include but OK.

Thanks for your suggestion, and I will pay attention to the [PATCH *] next time.

As for the bpf@, I guess that 'get_maintainer.pl' listed it to me
because of 'act_bpf.c'.

Cheers,
Menglong Dong
