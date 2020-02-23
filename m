Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 04B85169A67
	for <lists+netdev@lfdr.de>; Sun, 23 Feb 2020 23:08:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727180AbgBWWIj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Feb 2020 17:08:39 -0500
Received: from mail-pl1-f194.google.com ([209.85.214.194]:39655 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726302AbgBWWIj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Feb 2020 17:08:39 -0500
Received: by mail-pl1-f194.google.com with SMTP id g6so3213520plp.6;
        Sun, 23 Feb 2020 14:08:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=XVT/YiAQAM+tR2353qmEjurEX/hNonF51dX4WWwf8g0=;
        b=M8icaUOjj6WKkl3lO0YEn6n/6EFNlzQtFCC1eFpfB0A/m+Ex3zZ0wgszkR/VJkfPfY
         vkhN/78yQlMZK6/fc9T3IPSoXy49baEQSfWx2y3JQr0mhinh0oa2x6NB9RxioM/4Ldi4
         spbiARX9wvnniO6CsAIo5vEnxjdcDvP8AWrukLg3eyPu6zdvPM2goDQBZbjupndIK+wS
         qKCHAVQHVY8L0oVJxCO6xS02Vj1eRzdExi0jg23VKL0QcHM9/kb+QlRbXHIS3gEt3Us+
         EgZ/z2QDare/fFMjLb5UiIF0UNCTmWaijATJjPLxc7uwMLOlWQoOMahJVUe6r/P0jJo4
         UUCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=XVT/YiAQAM+tR2353qmEjurEX/hNonF51dX4WWwf8g0=;
        b=V9i0Z8uUYzWiwPvJifes07YpyszzRZTWTlp7pL6GSJLtCCPmDJb1TuA8eDgu9YYp0v
         JXjTZZ/htuQbBxa6yDm90mmFjxdL0Q1RuCxVL7gPMKZiX5aQA3zDwh0FnO7G1lqGUHdQ
         uFVq3YwQLu9WmUvhufG+j8Ij+IxE0+waE8Ma5xRbYa3XkvHfdc4sK01lIrdW+MXCqhDG
         YIpbmG4cyT8WiCLTzMBgt/qMvMMbSnfExLbD6dZCZOU8IHE5rCNXZb7IODNU/krCee5Y
         pGoWQRrRIp2JlAEz0umCeIrcA1fyMjQy8jysFCCk6xZ69VsXqplhrKnubm/VMWY/ejU/
         s3+Q==
X-Gm-Message-State: APjAAAVxmhkbr7qITZ3WUtdUPBkUZlqePtSepBUp7GZjKT5WF6FZTobS
        cATdulJaVjoOJlRjPA5sASzw1Qzs
X-Google-Smtp-Source: APXvYqw7avgJ0mrUniGFD86P47DGUntXTbl/vC8rO4/qWXHTyo+kuYAaxDPE5aTYyMY/O+FutHGfxQ==
X-Received: by 2002:a17:90a:5289:: with SMTP id w9mr16774328pjh.95.1582495718321;
        Sun, 23 Feb 2020 14:08:38 -0800 (PST)
Received: from ast-mbp ([2620:10d:c090:400::5:7207])
        by smtp.gmail.com with ESMTPSA id v8sm9840160pfn.172.2020.02.23.14.08.36
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 23 Feb 2020 14:08:37 -0800 (PST)
Date:   Sun, 23 Feb 2020 14:08:34 -0800
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Kees Cook <keescook@chromium.org>
Cc:     Casey Schaufler <casey@schaufler-ca.com>,
        KP Singh <kpsingh@chromium.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux Security Module list 
        <linux-security-module@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        James Morris <jmorris@namei.org>, bpf@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH bpf-next v4 3/8] bpf: lsm: provide attachment points for
 BPF LSM programs
Message-ID: <20200223220833.wdhonzvven7payaw@ast-mbp>
References: <20200220175250.10795-1-kpsingh@chromium.org>
 <20200220175250.10795-4-kpsingh@chromium.org>
 <0ef26943-9619-3736-4452-fec536a8d169@schaufler-ca.com>
 <202002211946.A23A987@keescook>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202002211946.A23A987@keescook>
User-Agent: NeoMutt/20180223
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 21, 2020 at 08:22:59PM -0800, Kees Cook wrote:
> 
> If I'm understanding this correctly, there are two issues:
> 
> 1- BPF needs to be run last due to fexit trampolines (?)

no.
The placement of nop call can be anywhere.
BPF trampoline is automagically converting nop call into a sequence
of directly invoked BPF programs.
No link list traversals and no indirect calls in run-time.

> 2- BPF hooks don't know what may be attached at any given time, so
>    ALL LSM hooks need to be universally hooked. THIS turns out to create
>    a measurable performance problem in that the cost of the indirect call
>    on the (mostly/usually) empty BPF policy is too high.

also no.

> So, trying to avoid the indirect calls is, as you say, an optimization,
> but it might be a needed one due to the other limitations.

I'm convinced that avoiding the cost of retpoline in critical path is a
requirement for any new infrastructure in the kernel.
Not only for security, but for any new infra.
Networking stack converted all such places to conditional calls.
In BPF land we converted indirect calls to direct jumps and direct calls.
It took two years to do so. Adding new indirect calls is not an option.
I'm eagerly waiting for Peter's static_call patches to land to convert
a lot more indirect calls. May be existing LSMs will take advantage
of static_call patches too, but static_call is not an option for BPF.
That's why we introduced BPF trampoline in the last kernel release.

> b) Would there actually be a global benefit to using the static keys
>    optimization for other LSMs?

Yes. Just compiling with CONFIG_SECURITY adds "if (hlist_empty)" check
for every hook. Some of those hooks are in critical path. This load+cmp
can be avoided with static_key optimization. I think it's worth doing.

> If static keys are justified for KRSI

I really like that KRSI costs absolutely zero when it's not enabled.
Attaching BPF prog to one hook preserves zero cost for all other hooks.
And when one hook is BPF powered it's using direct call instead of
super expensive retpoline.

Overall this patch set looks good to me. There was a minor issue with prog
accounting. I expect only that bit to be fixed in v5.
