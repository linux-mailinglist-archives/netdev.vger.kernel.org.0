Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2AA2F4AF3E6
	for <lists+netdev@lfdr.de>; Wed,  9 Feb 2022 15:18:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234891AbiBIOSB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Feb 2022 09:18:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234888AbiBIOR7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Feb 2022 09:17:59 -0500
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54AA9C0613CA
        for <netdev@vger.kernel.org>; Wed,  9 Feb 2022 06:18:02 -0800 (PST)
Received: by mail-ej1-x633.google.com with SMTP id m4so7712732ejb.9
        for <netdev@vger.kernel.org>; Wed, 09 Feb 2022 06:18:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vVorlN5u6BqvPRYEfqAdxuwZYf9fKAFIboIAn/w/sX8=;
        b=ICV0YIHifWafYnEdQESs7UWJS6bXMsDBIc+SZaw0okm9lvffPdzkJkPtj8QdpNbxAY
         /reRVALwcrpePQDFbcrE1e6AMSgc66IvTtjTPV7HBmoNaPHcFoeR4k304PM6KbaFqR9B
         n++L2MoxZ4yGYNxZGLN2T3lEiu337b0pXx4D/4c7uXGUUco1bYKHfnN+zAqV1G4CCCb0
         Of7fL/DJZtzxJMduXfkMVILNT10/rbikyXoElLJkBf/kMfj0AT/pyOBgqrdfoea29bSZ
         EL0/LExCQKcfy4/g2gtquzC5aKZ6luZcv3by64L1dHrYWuFtcgqM10ce5VXUo88Mg8iq
         n5Bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vVorlN5u6BqvPRYEfqAdxuwZYf9fKAFIboIAn/w/sX8=;
        b=n3VQw/RmcZSKW7hvHzR0I521r0lIbuBl9h0hDh1czzetFf5YxF8yu8T4bsY+aU4wG+
         kNAHr1StfaRNJPpnPVPT35VVi+HO57p/cXe0seXl08N1A1EnSIimIXeo99OXeYXk9z9M
         Tx9xMOkeRCt6V1iFRm0WmFnSipfLsQO60HKbCqo1VQEznnTVhizVhcEJtQ3uAwwNkNPH
         gC92FOoBpqn+0r2mM7MxtL3QDGFfmPxc6qyFSEqN/nH5cQWnb7UaRP+D7UNxcj25SUtW
         qyqFSsEcs+UxJqDwIbyNvUMkh1K77IzbBguR+UVNxQvEqMQ9PXzlmkU0aYsvr4WyCkD3
         Tagw==
X-Gm-Message-State: AOAM532jfU/oQgJuBT56YY589hLUc5Aw8B9xkyXJKeg1SFgUU5EI6QyW
        QduJeWaGEDhwNpZRuP/lWp7XxnLaZxauFStI3mI=
X-Google-Smtp-Source: ABdhPJwMz5meuE586LH+uVWRNYSG25SI5d5MkKwvR0VSHuSkQ8EI1D2aEE46sHTW/+bC/YgjNESFDDnQF2ySU3xRCBU=
X-Received: by 2002:a17:906:1e14:: with SMTP id g20mr2108979ejj.251.1644416280728;
 Wed, 09 Feb 2022 06:18:00 -0800 (PST)
MIME-Version: 1.0
References: <20220126143206.23023-1-xiangxia.m.yue@gmail.com>
 <20220126143206.23023-3-xiangxia.m.yue@gmail.com> <CAM_iQpU3yK2bft7gvPkf+pEkqDUOPhkBSJH1y+rqM44bw2sNVg@mail.gmail.com>
 <a2ecd27f-f5b5-0de4-19df-9c30671f4a9f@mojatatu.com> <CAMDZJNUHmrYBbnXrXmiSDF2dOMMCviAM+P_pEqsu=puxWeGuvA@mail.gmail.com>
In-Reply-To: <CAMDZJNUHmrYBbnXrXmiSDF2dOMMCviAM+P_pEqsu=puxWeGuvA@mail.gmail.com>
From:   Tonghao Zhang <xiangxia.m.yue@gmail.com>
Date:   Wed, 9 Feb 2022 22:17:24 +0800
Message-ID: <CAMDZJNUbpK_Fn6eFoSHFg7Mei5aMoop01MmgoKuf+XDr_LXaqA@mail.gmail.com>
Subject: Re: [net-next v8 2/2] net: sched: support hash/classid/cpuid
 selecting tx queue
To:     Jamal Hadi Salim <jhs@mojatatu.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Cong Wang <xiyou.wangcong@gmail.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Alexander Lobakin <alobakin@pm.me>,
        Paolo Abeni <pabeni@redhat.com>,
        Talal Ahmad <talalahmad@google.com>,
        Kevin Hao <haokexin@gmail.com>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Kees Cook <keescook@chromium.org>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Antoine Tenart <atenart@kernel.org>,
        Wei Wang <weiwan@google.com>, Arnd Bergmann <arnd@arndb.de>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Feb 5, 2022 at 3:25 PM Tonghao Zhang <xiangxia.m.yue@gmail.com> wrote:
>
> On Mon, Jan 31, 2022 at 9:12 PM Jamal Hadi Salim <jhs@mojatatu.com> wrote:
> >
> > On 2022-01-26 14:52, Cong Wang wrote:
> > > You really should just use eBPF, with eBPF code you don't even need
> > > to send anything to upstream, you can do whatever you want without
> > > arguing with anyone. It is a win-win.
> >
> > Cong,
> >
> > This doesnt work in some environments. Example:
> >
> > 1) Some data centres (telco large and medium sized enteprises that
> > i have personally encountered) dont allow for anything that requires
> > compilation to be introduced (including ebpf).
> > They depend on upstream - if something is already in the kernel and
> > requires a script it becomes an operational issue which is a simpler
> > process.
> > This is unlike large organizations who have staff of developers
> > dedicated to coding stuff. Most of the folks i am talking about
> > have zero developers in house. But even if they did have a few,
> > introducing code into the kernel that has to be vetted by a
> > multitude of internal organizations tends to be a very
> > long process.
> Yes, really agree with that.
Hi Jakub, do you have an opinion?

> > 2) In some cases adding new code voids the distro vendor's
> > support warranty and you have to pay the distro vendor to
> > vet and put your changes via their regression testing.
> > Most of these organizations are tied to one or other distro
> > vendor and they dont want to mess with the warranty or pay
> > extra fees which causes more work for them (a lot of them
> > have their own vetting process after the distro vendors vetting).
> >
> > I am not sure what the OP's situation is - but what i described
> > above is _real_. If there is some extension to existing features like
> > skbedit and there is a good use case IMO we should allow for it.
> >
> > cheers,
> > jamal
>
>
>
> --
> Best regards, Tonghao



--
Best regards, Tonghao
