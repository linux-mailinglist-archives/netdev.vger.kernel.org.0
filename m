Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5213E4EBC58
	for <lists+netdev@lfdr.de>; Wed, 30 Mar 2022 10:07:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244024AbiC3IH0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Mar 2022 04:07:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241258AbiC3IHY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Mar 2022 04:07:24 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FFE72E9CB;
        Wed, 30 Mar 2022 01:05:39 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id c62so23430083edf.5;
        Wed, 30 Mar 2022 01:05:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=1z8TXXlpQVL9z0uA0npERoI26EWiwefnwRh9sArmtDg=;
        b=QTl3olxcdGTfJRZrWGfnvnk+cryD1ju4eE/Cxzef4pPJ1rcc0waLGYenCL3KYstawU
         DHU0HklHprALU5xVCeBO0RT4i4flr2xiU9CJjEKs4Z4Xr6nT1DVvuz++EsREJsqN9wD9
         TtWt2QcwH9GqSozzOqsM7vnlzFd79YGkjGIVgKA6ekDC079Qke+Jh1u5JtAJgHmxuiYt
         Uk+YlhEDfEEIGvytEL1rb68/fKtl/hYxwAQDlsK51Iaw2zSNXC5k3bzoAibTFy7FxDRD
         TS63FnMAPUu1+udXKo6JJF2GJTaWWxSXU6I7Znd4l5X37A/6OhlMKHWkSA3aAidAO8b5
         z/pQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=1z8TXXlpQVL9z0uA0npERoI26EWiwefnwRh9sArmtDg=;
        b=k+KM+Wf852Qk8tzUajMrm6wHr4prDiPtjFmBG1I/buYG0kFbCEMql/8cgmGSdSmtkX
         VlKffV7kjh6k8oa+yBujNgld5eXKk8mkObWy/dfZoe8IE60HH1jR2eMRyKawDmQ2M5t+
         69Aq+f02dcLH8xlfmpkZ4Uxi3mgzgK1xDiFTYSGbIW29IIFRH5JwxSbPYUKZWt8cSV5o
         kpYo/VIt+XJgt5PpS1Jebtr5E+8E/6rwgXt4kVFlyGUF4biSPgxSG6MSalVvNimGlTbx
         OE+sN0MjGqi18wWhWfLYkoHz4wMc9N4R5CcutqkSEcMLbe3oNv+QYVr3suUQ0eIni/Uy
         fd3g==
X-Gm-Message-State: AOAM530yl7MA+SoemM/0KKucKLerOFVtHbusUNXG7ysBVou4mtLKSPmo
        DbFle2eu0AF1SwQhWmyqJC0=
X-Google-Smtp-Source: ABdhPJz/BdmBZOR0CjSQeGjeouiadC8MbKNFeqvsfrfpl7n40Ww37DauJQvbl3KFqiuBZ93syscnBQ==
X-Received: by 2002:a05:6402:3452:b0:418:f963:42a3 with SMTP id l18-20020a056402345200b00418f96342a3mr9374579edc.12.1648627537655;
        Wed, 30 Mar 2022 01:05:37 -0700 (PDT)
Received: from krava ([193.85.244.190])
        by smtp.gmail.com with ESMTPSA id z21-20020a1709063a1500b006da6436819dsm7961129eje.173.2022.03.30.01.05.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Mar 2022 01:05:37 -0700 (PDT)
Date:   Wed, 30 Mar 2022 10:05:34 +0200
From:   Jiri Olsa <olsajiri@gmail.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Peter Zijlstra <peterz@infradead.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Kernel Team <kernel-team@fb.com>
Subject: Re: pull-request: bpf 2022-03-29
Message-ID: <YkQPTlN5VMeRg5zZ@krava>
References: <20220329234924.39053-1-alexei.starovoitov@gmail.com>
 <20220329184123.59cfad63@kernel.org>
 <CAADnVQJNS_U97aqaNxtAhuvZCK6oiDA-tDoAEyDMYnCBbfaZkg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAADnVQJNS_U97aqaNxtAhuvZCK6oiDA-tDoAEyDMYnCBbfaZkg@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 29, 2022 at 06:51:22PM -0700, Alexei Starovoitov wrote:
> On Tue, Mar 29, 2022 at 6:41 PM Jakub Kicinski <kuba@kernel.org> wrote:
> >
> > On Tue, 29 Mar 2022 16:49:24 -0700 Alexei Starovoitov wrote:
> > > Hi David, hi Jakub,
> > >
> > > The following pull-request contains BPF updates for your *net* tree.
> > >
> > > We've added 16 non-merge commits during the last 1 day(s) which contain
> > > a total of 24 files changed, 354 insertions(+), 187 deletions(-).
> > >
> > > The main changes are:
> > >
> > > 1) x86 specific bits of fprobe/rethook, from Masami and Peter.
> > >
> > > 2) ice/xsk fixes, from Maciej and Magnus.
> > >
> > > 3) Various small fixes, from Andrii, Yonghong, Geliang and others.
> >
> > There are some new sparse warnings here that look semi-legit.
> > As in harmless but not erroneous.
> 
> Both are new warnings and not due to these patches, right?
> 
> > kernel/trace/rethook.c:68:9: error: incompatible types in comparison expression (different address spaces):
> > kernel/trace/rethook.c:68:9:    void ( [noderef] __rcu * )( ... )
> > kernel/trace/rethook.c:68:9:    void ( * )( ... )
> >
> > 66 void rethook_free(struct rethook *rh)
> > 67 {
> > 68         rcu_assign_pointer(rh->handler, NULL);
> > 69
> > 70         call_rcu(&rh->rcu, rethook_free_rcu);
> > 71 }
> >
> > Looks like this should be a WRITE_ONCE() ?
> 
> Masami, please take a look.
> 
> > And the __user annotations in bpf_trace.c are still not right,
> > first arg of kprobe_multi_resolve_syms() should __user:
> >
> > kernel/trace/bpf_trace.c:2370:34: warning: incorrect type in argument 2 (different address spaces)
> > kernel/trace/bpf_trace.c:2370:34:    expected void const [noderef] __user *from
> > kernel/trace/bpf_trace.c:2370:34:    got void const *usyms
> > kernel/trace/bpf_trace.c:2376:51: warning: incorrect type in argument 2 (different address spaces)
> > kernel/trace/bpf_trace.c:2376:51:    expected char const [noderef] __user *src
> > kernel/trace/bpf_trace.c:2376:51:    got char const *
> > kernel/trace/bpf_trace.c:2443:49: warning: incorrect type in argument 1 (different address spaces)
> > kernel/trace/bpf_trace.c:2443:49:    expected void const *usyms
> > kernel/trace/bpf_trace.c:2443:49:    got void [noderef] __user *[assigned] usyms
> 
> This one is known. Still waiting for the fix from Jiri.

right, I replied that for some reason I can't see these warnings
with 'make C=2' and latest sparse.. how do you run that?

if patch below fixes it for you, I can send formal patch quickly

jirka


---
diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
index d8553f46caa2..7fa2ebc07f60 100644
--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -2349,11 +2349,11 @@ kprobe_multi_link_handler(struct fprobe *fp, unsigned long entry_ip,
 }
 
 static int
-kprobe_multi_resolve_syms(const void __user *usyms, u32 cnt,
+kprobe_multi_resolve_syms(const void *usyms, u32 cnt,
 			  unsigned long *addrs)
 {
 	unsigned long addr, size;
-	const char __user **syms;
+	const char **syms;
 	int err = -ENOMEM;
 	unsigned int i;
 	char *func;
