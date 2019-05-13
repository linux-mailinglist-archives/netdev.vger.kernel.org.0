Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 084DB1BD85
	for <lists+netdev@lfdr.de>; Mon, 13 May 2019 20:57:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728897AbfEMS52 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 May 2019 14:57:28 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:33811 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726084AbfEMS52 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 May 2019 14:57:28 -0400
Received: by mail-pl1-f194.google.com with SMTP id w7so6942901plz.1
        for <netdev@vger.kernel.org>; Mon, 13 May 2019 11:57:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fomichev-me.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=BkQqub5XwKygwNJRTEvlmToJlno8Ci7n+XxR7Likzj0=;
        b=VRGfs62xszS383fY9D/RVvy6vFRMDeO4m/6o8xQ0ihWb1H0ksvIGdJJOxMP9NM2Y4X
         roBBxUNKHG/TrxtZSltr83IqdhpwWSFR1WmHF2bfmhOhmqrbZtfK+xuyidB1iPhTNHtm
         vycBQnp7DNXNFRvGlo8ZoxtQDR6TtPgLZT3EeUXrAWmSgof9kagWgX1XsV7v7ISUvlMz
         91FjHyxyJVJVwqjiukDD9R00f2MZdNLM7s+N9hlBx73100WxxLTWVr6w9wsaRPNRsN7z
         FgXOs9qCdENVWVLXk/tGrgBxdozsoiGPYeyA43LBig2tgenuRO2t3Pn8uC5YfzDShK4K
         fkIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=BkQqub5XwKygwNJRTEvlmToJlno8Ci7n+XxR7Likzj0=;
        b=j7XuHTJQWQql9hlFmFcEm8tJ7Djz/AX0Z11QWPLPnPC42HFTUh7+FWiBG2Kr5d5dTM
         R4RD9ANWzmajAUsv76Jx9FLvLcw1YcTYWeFtsaZa9E7BUUzk0rnSqZOT4Jjum0udOghX
         9Ht/m7/wdt1toHHurPZBpYVJ7In2yZvsz++gu4gWWRl7JYQwLT2wMrI851IV8NmKAyr4
         M3r9P6yT8v+bvDXw3D8s0R1HQ/rF2QO1/F5fXEp437BXA1mRUPbvDbSJ2roee3UihsOI
         yw6L655zGqWxFsokmYtoSDgmL0zHkHUC+Vt5D5iA3TDhf0K7qcUC1Gg10cpPqJt+ngiT
         4yjQ==
X-Gm-Message-State: APjAAAWAcJSRR4txtXve7Fey0okR9tlpynyntZQwkkf+C8q7Xk3JzwVK
        jyivyk7MJ8uiTeTNm1nxQ1AMlg==
X-Google-Smtp-Source: APXvYqzqcFrVkEXQdGDGzDvqxFEepgTBsa9yAkT/dWkFIgSh1Sg6k7dxrwiNz5o3OVgrg2IVSdAygA==
X-Received: by 2002:a17:902:284a:: with SMTP id e68mr8362814plb.258.1557773847092;
        Mon, 13 May 2019 11:57:27 -0700 (PDT)
Received: from localhost ([2601:646:8f00:18d9:d0fa:7a4b:764f:de48])
        by smtp.gmail.com with ESMTPSA id 19sm15983387pgz.24.2019.05.13.11.57.25
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 13 May 2019 11:57:25 -0700 (PDT)
Date:   Mon, 13 May 2019 11:57:24 -0700
From:   Stanislav Fomichev <sdf@fomichev.me>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Stanislav Fomichev <sdf@google.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, davem@davemloft.net, ast@kernel.org,
        daniel@iogearbox.net
Subject: Re: [PATCH bpf 0/4] bpf: remove __rcu annotations from bpf_prog_array
Message-ID: <20190513185724.GB24057@mini-arch>
References: <20190508171845.201303-1-sdf@google.com>
 <20190508175644.e4k5o6o3cgn6k5lx@ast-mbp>
 <20190508181223.GH1247@mini-arch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190508181223.GH1247@mini-arch>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 05/08, Stanislav Fomichev wrote:
> On 05/08, Alexei Starovoitov wrote:
> > On Wed, May 08, 2019 at 10:18:41AM -0700, Stanislav Fomichev wrote:
> > > Right now we are not using rcu api correctly: we pass __rcu pointers
> > > to bpf_prog_array_xyz routines but don't use rcu_dereference on them
> > > (see bpf_prog_array_delete_safe and bpf_prog_array_copy in particular).
> > > Instead of sprinkling rcu_dereferences, let's just get rid of those
> > > __rcu annotations and move rcu handling to a higher level.
> > > 
> > > It looks like all those routines are called from the rcu update
> > > side and we can use simple rcu_dereference_protected to get a
> > > reference that is valid as long as we hold a mutex (i.e. no other
> > > updater can change the pointer, no need for rcu read section and
> > > there should not be a use-after-free problem).
> > > 
> > > To be fair, there is currently no issue with the existing approach
> > > since the calls are mutex-protected, pointer values don't change,
> > > __rcu annotations are ignored. But it's still nice to use proper api.
> > > 
> > > The series fixes the following sparse warnings:
> > 
> > Absolutely not.
> > please fix it properly.
> > Removing annotations is not a fix.
> I'm fixing it properly by removing the annotations and moving lifetime
> management to the upper layer. See commits 2-4 where I fix the users, the
> first patch is just the "preparation".
> 
> The users are supposed to do:
> 
> mutex_lock(&x);
> p = rcu_dereference_protected(prog_array, lockdep_is_held(&x))
> // ...
> // call bpf_prog_array helpers while mutex guarantees that
> // the object referenced by p is valid (i.e. no need for bpf_prog_array
> // helpers to care about rcu lifetime)
> // ...
> mutex_unlock(&x);
> 
> What am I missing here?

Just to give you my perspective on why current api with __rcu annotations
is working, but not optimal (even if used from the rcu read section).

Sample code:

	struct bpf_prog_array __rcu *progs = <comes from somewhere>;
	int n;

	rcu_read_lock();
	n = bpf_prog_array_length(progs);
	if (n > 0) {
	  // do something with __rcu progs
	  do_something(progs);
	}
	rcu_read_unlock();

Since progs is __rcu annotated, do_something() would need to do
rcu_dereference again and it might get a different value compared to
whatever bpf_prog_array_free got while doing its dereference.

A better way is not to deal with rcu inside those helpers and let
higher layers do that:

	struct bpf_prog_array __rcu *progs = <comes from somewhere>;
	struct bpf_prog_array *p;
	int n;

	rcu_read_lock();
	p = rcu_dereference(p);
	n = bpf_prog_array_length(p);
	if (n > 0) {
	  do_something(p); // do_something sees the same p as bpf_prog_array_length
	}
	rcu_read_unlock();

What do you think?

If it sounds reasonable, I can follow up with a v2 because I think I can
replace xchg with rcu_swap_protected as well. Or I can resend for bpf-next to
have another round of discussion. Thoughts?
