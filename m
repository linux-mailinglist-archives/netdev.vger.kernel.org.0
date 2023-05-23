Return-Path: <netdev+bounces-4577-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id DD1D770D470
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 08:59:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A6D6E1C20CCF
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 06:59:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 393461C754;
	Tue, 23 May 2023 06:59:33 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D5A21641D;
	Tue, 23 May 2023 06:59:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23271C433D2;
	Tue, 23 May 2023 06:59:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1684825171;
	bh=8bCyd/iyRVecAb/iC58YqCmI1gFlhQUVWms6GTv8yuU=;
	h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To:From;
	b=ODbLFCMWK19Cvwzcmi4OfzXBWpT33XKeSb8OVFEKYmrXDyxzB+3sRqq1FJC57OOLY
	 b6c3/cab8+Ps2E+WntAoBMOl6uV3gBHNC4lu+5UQ8/ndytTzQRF8zWy1z7uKoRJUoh
	 j9vdOStNIh7635iVk6ZZO5wRazE0wwNwah/LLUgPIfhTKjKWUMpp3BKHfktDlnkvDf
	 JpcaCHvV9IO7HKoWYc3U5QaR9un379nIRXyP91omWgZWPofxPyWgLGOoTw8eSPmrBn
	 BdytxxWX3akeKVonuEihGcqcYsvKO4Irj8OVa3NE4QYodgdP1/DWdkYWeWioHBLH5d
	 QT6h81EEXeBuQ==
Received: by paulmck-ThinkPad-P17-Gen-1.home (Postfix, from userid 1000)
	id D4E7ECE1C03; Mon, 22 May 2023 23:59:28 -0700 (PDT)
Date: Mon, 22 May 2023 23:59:28 -0700
From: "Paul E. McKenney" <paulmck@kernel.org>
To: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Ze Gao <zegao2021@gmail.com>, Jiri Olsa <olsajiri@gmail.com>,
	Yonghong Song <yhs@meta.com>, Alexei Starovoitov <ast@kernel.org>,
	Andrii Nakryiko <andrii@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>, Hao Luo <haoluo@google.com>,
	John Fastabend <john.fastabend@gmail.com>,
	KP Singh <kpsingh@kernel.org>,
	Martin KaFai Lau <martin.lau@linux.dev>, Song Liu <song@kernel.org>,
	Stanislav Fomichev <sdf@google.com>,
	Steven Rostedt <rostedt@goodmis.org>, Yonghong Song <yhs@fb.com>,
	bpf@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org, kafai@fb.com,
	kpsingh@chromium.org, netdev@vger.kernel.org, songliubraving@fb.com,
	Ze Gao <zegao@tencent.com>
Subject: Re: 
Message-ID: <9dc981d5-e385-4468-9b51-64a10476c86d@paulmck-laptop>
Reply-To: paulmck@kernel.org
References: <20220515203653.4039075-1-jolsa@kernel.org>
 <20230520094722.5393-1-zegao@tencent.com>
 <b4f66729-90ab-080a-51ec-bf435ad6199d@meta.com>
 <CAD8CoPAXse1GKAb15O5tZJwBqMt1N_btH+qRe7c_a-ryUMjx7A@mail.gmail.com>
 <ZGp+fW855gmWuh9W@krava>
 <CAD8CoPDASe7hpkFbK+UzJats7j4sbgsCh_P4zaQYVuKD7jWu2w@mail.gmail.com>
 <20230523133019.ce19932f89585eb10d092896@kernel.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230523133019.ce19932f89585eb10d092896@kernel.org>

On Tue, May 23, 2023 at 01:30:19PM +0800, Masami Hiramatsu wrote:
> On Mon, 22 May 2023 10:07:42 +0800
> Ze Gao <zegao2021@gmail.com> wrote:
> 
> > Oops, I missed that. Thanks for pointing that out, which I thought is
> > conditional use of rcu_is_watching before.
> > 
> > One last point, I think we should double check on this
> >      "fentry does not filter with !rcu_is_watching"
> > as quoted from Yonghong and argue whether it needs
> > the same check for fentry as well.
> 
> rcu_is_watching() comment says;
> 
>  * if the current CPU is not in its idle loop or is in an interrupt or
>  * NMI handler, return true.
> 
> Thus it returns *fault* if the current CPU is in the idle loop and not
> any interrupt(including NMI) context. This means if any tracable function
> is called from idle loop, it can be !rcu_is_watching(). I meant, this is
> 'context' based check, thus fentry can not filter out that some commonly
> used functions is called from that context but it can be detected.

It really does return false (rather than faulting?) if the current CPU
is deep within the idle loop.

In addition, the recent x86/entry rework (thank you Peter and
Thomas!) mean that the "idle loop" is quite restricted, as can be
seen by the invocations of ct_cpuidle_enter() and ct_cpuidle_exit().
For example, in default_idle_call(), these are immediately before and
after the call to arch_cpu_idle().

Would the following help?  Or am I missing your point?

							Thanx, Paul

------------------------------------------------------------------------

diff --git a/kernel/rcu/tree.c b/kernel/rcu/tree.c
index 1449cb69a0e0..fae9b4e29c93 100644
--- a/kernel/rcu/tree.c
+++ b/kernel/rcu/tree.c
@@ -679,10 +679,14 @@ static void rcu_disable_urgency_upon_qs(struct rcu_data *rdp)
 /**
  * rcu_is_watching - see if RCU thinks that the current CPU is not idle
  *
- * Return true if RCU is watching the running CPU, which means that this
- * CPU can safely enter RCU read-side critical sections.  In other words,
- * if the current CPU is not in its idle loop or is in an interrupt or
- * NMI handler, return true.
+ * Return @true if RCU is watching the running CPU and @false otherwise.
+ * An @true return means that this CPU can safely enter RCU read-side
+ * critical sections.
+ *
+ * More specifically, if the current CPU is not deep within its idle
+ * loop, return @true.  Note that rcu_is_watching() will return @true if
+ * invoked from an interrupt or NMI handler, even if that interrupt or
+ * NMI interrupted the CPU while it was deep within its idle loop.
  *
  * Make notrace because it can be called by the internal functions of
  * ftrace, and making this notrace removes unnecessary recursion calls.

