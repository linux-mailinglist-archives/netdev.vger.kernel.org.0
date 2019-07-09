Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BA1CE638C9
	for <lists+netdev@lfdr.de>; Tue,  9 Jul 2019 17:40:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726232AbfGIPkZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Jul 2019 11:40:25 -0400
Received: from mail-io1-f66.google.com ([209.85.166.66]:38512 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726055AbfGIPkZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Jul 2019 11:40:25 -0400
Received: by mail-io1-f66.google.com with SMTP id j6so44126484ioa.5;
        Tue, 09 Jul 2019 08:40:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=lBGHvOhuEXhBOTWSFCxq6KmZhMlzdxSO+iRbbFomrS8=;
        b=Tdqn0m9aB9JaMlVevOX+vJfjMEmQ9j6EISYMkEIR7n8OmgOSNE0QbpbgEEgpZU6Pjl
         RvAZq6rP39Ku9mvbiwUZ7126GAxBXLT/uhIflgfQCuL/lVEIEn0waJBRaJpppd0lxfwP
         p4gI/8Nyw7NiwvQRw+ib8SSk6ZHwzmVF4PGqchd10+kURHbjyVpjmJKvpp16fitvKz28
         qDExyg/6pWog2gYjlrKJjovWdznIVaEwgjRRm6a9Yv+xIdgFEFDchzGZ6XA9NGoGdkUr
         cLRWGzdVFyTKiNWXgKJm08zNGTSmJebCSoyj7RNPyLOI5UqkhvBA/YNsouhODI5D9iEF
         X4Jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=lBGHvOhuEXhBOTWSFCxq6KmZhMlzdxSO+iRbbFomrS8=;
        b=n0HoNf/iWX+WsP8l15kU3S1ZTJvMtUBT0Llf3euxWccOo+IfeDfc+46m2ACmxrFjOM
         HIoJ5TFaj2wqmn80SRYToScnO5vOXCW5ZupH7RjMU+XUWuaVMeCAVjUmxsDPygIreIQE
         fRmtJfBOtR+WMSqmD76ExglN6LgPU/NutRXHuZepJKxgbARykgfO9Meq3Xo1gkRvPaYG
         h5PirTIG4mv4MtO4BusmT9BJ6OsbcSXH/RtoRrjMBbuJijZFi9O8ltFy2BhNKX9cqPBZ
         rQmOja5YkzQvLb9PGFatQhII2ufTzAc8eIrbeAgSLXlLA5lJQx1Gh0vqcExFaskdBL6z
         sukg==
X-Gm-Message-State: APjAAAX8iICWt4pKyONhYlJeIFOZjVqDQy/1ZHCoLwgiAIIAfQRIWqAF
        VBAsxsszXeDvviWROL3FTlk=
X-Google-Smtp-Source: APXvYqxV55F7G567Fl3WDffkOaXOB5+felKggg5k/fMdZgmDx2IOvxWZmK2eug243DFdxuhx+52SMw==
X-Received: by 2002:a05:6602:1d2:: with SMTP id w18mr4793051iot.157.1562686824847;
        Tue, 09 Jul 2019 08:40:24 -0700 (PDT)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id n21sm15753542ioh.30.2019.07.09.08.40.21
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 09 Jul 2019 08:40:23 -0700 (PDT)
Date:   Tue, 09 Jul 2019 08:40:14 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>,
        John Fastabend <john.fastabend@gmail.com>
Cc:     ast@kernel.org, daniel@iogearbox.net, netdev@vger.kernel.org,
        edumazet@google.com, bpf@vger.kernel.org
Message-ID: <5d24b55e8b868_3b162ae67af425b43e@john-XPS-13-9370.notmuch>
In-Reply-To: <20190708231318.1a721ce8@cakuba.netronome.com>
References: <156261310104.31108.4569969631798277807.stgit@ubuntu3-kvm1>
 <20190708231318.1a721ce8@cakuba.netronome.com>
Subject: Re: [bpf PATCH v2 0/6] bpf: sockmap/tls fixes
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub Kicinski wrote:
> On Mon, 08 Jul 2019 19:13:29 +0000, John Fastabend wrote:
> > Resolve a series of splats discovered by syzbot and an unhash
> > TLS issue noted by Eric Dumazet.
> > 
> > The main issues revolved around interaction between TLS and
> > sockmap tear down. TLS and sockmap could both reset sk->prot
> > ops creating a condition where a close or unhash op could be
> > called forever. A rare race condition resulting from a missing
> > rcu sync operation was causing a use after free. Then on the
> > TLS side dropping the sock lock and re-acquiring it during the
> > close op could hang. Finally, sockmap must be deployed before
> > tls for current stack assumptions to be met. This is enforced
> > now. A feature series can enable it.
> > 
> > To fix this first refactor TLS code so the lock is held for the
> > entire teardown operation. Then add an unhash callback to ensure
> > TLS can not transition from ESTABLISHED to LISTEN state. This
> > transition is a similar bug to the one found and fixed previously
> > in sockmap. Then apply three fixes to sockmap to fix up races
> > on tear down around map free and close. Finally, if sockmap
> > is destroyed before TLS we add a new ULP op update to inform
> > the TLS stack it should not call sockmap ops. This last one
> > appears to be the most commonly found issue from syzbot.
> 
> Looks like strparser is not done'd for offload?

Right so if rx_conf != TLS_SW then the hardware needs to do
the strparser functionality.

> 
> About patch 6 - I was recently wondering about the "impossible" syzbot
> report where context is not freed and my conclusion was that there
> can be someone sitting at lock_sock() in tcp_close() already by the
> time we start installing the ULP, so TLS's close will never get called.
> The entire replacing of callbacks business is really shaky :(

Well replacing callbacks is the ULP model. The race we are fixing in
patch 6 is sockmap being free'd which removes psock and resets proto ops
with tcp_close() path.

I don't think there is another race like you describe because tcp_set_ulp
is called from do_tcp_setsockopt which holds the lock and tcp state is
checked to ensure its ESTABLISHED. A closing sock wont be in ESTABLISHED
state so any setup will be aborted. Before patch 1 though I definately
saw this race because we dropped the lock mid-close.

With this series I've been running those syzbot programs over night
without issue on 4 cores. Also selftests pass in ./net/tls and ./bpf/
so I think its stable and resolves many of the issues syzbot has been
stomping around.

> 
> Perhaps I'm rumbling, I will take a close look after I get some sleep :)

Yes please do ;)
