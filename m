Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D23E91CBB0A
	for <lists+netdev@lfdr.de>; Sat,  9 May 2020 01:00:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728187AbgEHXAt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 May 2020 19:00:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726843AbgEHXAp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 May 2020 19:00:45 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71684C061A0C;
        Fri,  8 May 2020 16:00:45 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id x15so1134252pfa.1;
        Fri, 08 May 2020 16:00:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=pi4iGLk6Iqw2U9dhbisdfCzZo8oBkEm8dn90sYqaEQ8=;
        b=sZdflKUYXgN0b2+NUt7GZuTrsWAWtODPxRonqYIRglDOmrttJQp76y0M1d7gpFOwDI
         Ai4Zle0D9LE3LQKL0hRYS2LJXEeNE6e6snm1zxELbQ/ODeVhGZDazWxGaELjaR8hqLi8
         XNdhqEeD0XFv3saZQBYzj0UX45tYRNfVaVcTfzd/j5EVNUf6Cz4ABt5Cnwy+6QbA4v3x
         4mp9xy4tRLnsCTl0BV5vRefVn26h2HLjivlEcC2VK1vG9zDAOq+tjtaDbJqnZamF1rbS
         HOGUHEPodGXN85Ih2MmTS2VJKM0+Kp4QtG2mPrXPfH3K7KKZVQcaLPIEr0BX+vuhtv59
         8y3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=pi4iGLk6Iqw2U9dhbisdfCzZo8oBkEm8dn90sYqaEQ8=;
        b=M5bxQdYgdib0ICi/8xacVLNdqyIpcHkzxlen29iZvEPHD8uSuPL7MwhyZU5fgniDAe
         7gImrVVAiapHd1W2sSiVobJsa5GvRTUakDzLWKjkcksIXebKmiCa7EImcZk6uIu+1Hs7
         Rdzz91YoKvFoW7oj3/6Pg3Pq4xec3a3VLwJofi+BlY1fwvbnFx66iZYEqs+T68D/gQ6l
         QQNh+P66CZUw/WkFfjYXzXKvyv8uG+gW99zWe2AZMETlzyg1GX6qZB7qXwaf+M/EwTp7
         nr0rlKjH/Dvt99GNDhpx62pL3iRLHERq+akr3IYZvovhbZEm/o4P7XvGBePnUxElhS97
         DGog==
X-Gm-Message-State: AGi0PuYEy3tHb782tNrbW2t5QDZwIAvyvvusMZaFFsJ6Rcwla/iStWmk
        2A1Yo+2ai/uoRqp/l2YEnSk=
X-Google-Smtp-Source: APiQypJDOE5rzSDmg+tXx4CH+Ryq95Crs+V8O5vHJ64bK5E4fs2FUQwrNKXs2S4xJyWzpB1bBdCMDQ==
X-Received: by 2002:aa7:9429:: with SMTP id y9mr5439514pfo.8.1588978844916;
        Fri, 08 May 2020 16:00:44 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:400::5:d7c7])
        by smtp.gmail.com with ESMTPSA id d4sm1684354pgk.2.2020.05.08.16.00.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 May 2020 16:00:43 -0700 (PDT)
Date:   Fri, 8 May 2020 16:00:41 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Casey Schaufler <casey@schaufler-ca.com>
Cc:     davem@davemloft.net, daniel@iogearbox.net, netdev@vger.kernel.org,
        bpf@vger.kernel.org, kernel-team@fb.com,
        linux-security-module@vger.kernel.org, acme@redhat.com,
        jamorris@linux.microsoft.com, jannh@google.com, kpsingh@google.com
Subject: Re: [PATCH v5 bpf-next 0/3] Introduce CAP_BPF
Message-ID: <20200508230041.uwsj7ubk3zvphioe@ast-mbp.dhcp.thefacebook.com>
References: <20200508215340.41921-1-alexei.starovoitov@gmail.com>
 <71f66e31-02d9-a661-af3b-f493140a53e2@schaufler-ca.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <71f66e31-02d9-a661-af3b-f493140a53e2@schaufler-ca.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 08, 2020 at 03:45:36PM -0700, Casey Schaufler wrote:
> On 5/8/2020 2:53 PM, Alexei Starovoitov wrote:
> > From: Alexei Starovoitov <ast@kernel.org>
> >
> > v4->v5:
> >
> > Split BPF operations that are allowed under CAP_SYS_ADMIN into combination of
> > CAP_BPF, CAP_PERFMON, CAP_NET_ADMIN and keep some of them under CAP_SYS_ADMIN.
> >
> > The user process has to have
> > - CAP_BPF and CAP_PERFMON to load tracing programs.
> > - CAP_BPF and CAP_NET_ADMIN to load networking programs.
> > (or CAP_SYS_ADMIN for backward compatibility).
> 
> Is there a case where CAP_BPF is useful in the absence of other capabilities?
> I generally object to new capabilities in cases where existing capabilities
> are already required.

You mean beyond what is written about CAP_BPF in include/uapi/linux/capability.h in patch 1?
There are prog types that are neither tracing nor networking.
Like LIRC2 and cgroup-device are not, but they were put under CAP_SYS_ADMIN + CAP_NET_ADMIN
because there was no CAP_BPF. This patch keeps them under CAP_BPF + CAP_NET_ADMIN for now.
May be that can be relaxed later. For sure future prog types won't have to deal with
such binary decision.
