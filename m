Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7493A270B1
	for <lists+netdev@lfdr.de>; Wed, 22 May 2019 22:16:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729969AbfEVUQ3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 May 2019 16:16:29 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:39638 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729632AbfEVUQ3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 May 2019 16:16:29 -0400
Received: by mail-pl1-f196.google.com with SMTP id g9so1595673plm.6;
        Wed, 22 May 2019 13:16:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=LFtb1aLHAoniHgO1XVMl+H7og93sXsDQP7kXz4xastQ=;
        b=pwyuDal8T9u/cMqXs0chOoAJnigbdDXf4erfNfREXXtF8b+s/I+NI1yQrJ5h2YE2x3
         J13plfkrlSBxLPtAP73cIifjo2DjFZlHFafe9g0E9WWP4fjLgyRuHTbNzrr4mWKQpXEr
         O6NtOiEswNSbAzDyXKMO70at36tfMUOW/NUs0CNQIOf3hpolRdnl5VsCx0pZY8TCq7yd
         J9sHu7nb7mMwIgJYSQYczgarQ85hRQstISHy2Rt+Oe4Fx3U1j74ULR8G0QYiCWemP8+o
         AO2d3JYkhGVQ3jO27y0Lerk/ptCZ3AafxTBUOhjrfOJzKFs9V/vfrjOnUgHpfZU5Elts
         X1VQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=LFtb1aLHAoniHgO1XVMl+H7og93sXsDQP7kXz4xastQ=;
        b=o8/+fhG15A95IoOCRkaqW+lFGiGwVx7+Gc3g9hb+SV1nq2HQ6bGL758ri/C4aOcrpP
         NgKtdCiVtJsHy9uoK0KrgNDxaI+I11x1YdEr3ThMqIio+r1Ar2uNgPXitzsW1JLArJt/
         GQWuoFPtjkvE1UTng/nmb6wpMF/xMBYSiGESTH9zJGey2fv5N5/kATw5OvF+DlTeyDIb
         PpYBhnxOT520MEb/Tnsr+HyBhaJc+7OE7DmrczKDvd5a+p8XwxUe/6xGd4PgQpbYwJBg
         uWVFnCa86a3kK4LxHx8t2aNkZZdQf4Le76Hjz+hePmIeh/hok+arL6onJ/Pn6eUdvFi5
         9sig==
X-Gm-Message-State: APjAAAUl0jwR4T5t1i7qYXG21cLOLcSGrMbA+XpxnA6GRi/MVeshxy55
        ccqYK9RAOIdACoM7EgdHEF8=
X-Google-Smtp-Source: APXvYqx1cWhmgVEyuS/Eh6JMeDaGtMkspvblFEsUjIrH+1a4OPaEA/RAGpenifl2QKB8sclxRyN+DA==
X-Received: by 2002:a17:902:ac90:: with SMTP id h16mr29233951plr.162.1558556188297;
        Wed, 22 May 2019 13:16:28 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:180::6565])
        by smtp.gmail.com with ESMTPSA id q5sm30530958pfb.51.2019.05.22.13.16.26
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 22 May 2019 13:16:27 -0700 (PDT)
Date:   Wed, 22 May 2019 13:16:25 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Kris Van Hees <kris.van.hees@oracle.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        dtrace-devel@oss.oracle.com, linux-kernel@vger.kernel.org,
        rostedt@goodmis.org, mhiramat@kernel.org, acme@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, peterz@infradead.org
Subject: Re: [RFC PATCH 00/11] bpf, trace, dtrace: DTrace BPF program type
 implementation and sample use
Message-ID: <20190522201624.eza3pe2v55sn2t2w@ast-mbp.dhcp.thefacebook.com>
References: <201905202347.x4KNl0cs030532@aserv0121.oracle.com>
 <20190521175617.ipry6ue7o24a2e6n@ast-mbp.dhcp.thefacebook.com>
 <20190521184137.GH2422@oracle.com>
 <20190521205533.evfszcjvdouby7vp@ast-mbp.dhcp.thefacebook.com>
 <20190521213648.GK2422@oracle.com>
 <20190521232618.xyo6w3e6nkwu3h5v@ast-mbp.dhcp.thefacebook.com>
 <20190522041253.GM2422@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190522041253.GM2422@oracle.com>
User-Agent: NeoMutt/20180223
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 22, 2019 at 12:12:53AM -0400, Kris Van Hees wrote:
> 
> Could you elaborate on why you believe my patches are not adding generic
> features?  I can certainly agree that the DTrace-specific portions are less
> generic (although they are certainly available for anyone to use), but I
> don't quite understand why the new features are deemed non-generic and why
> you believe no one else can use this?

And once again your statement above contradicts your own patches.
The patch 2 adds new prog type BPF_PROG_TYPE_DTRACE and the rest of the patches
are tying everything to it.
This approach contradicts bpf philosophy of being generic execution engine
and not favoriting one program type vs another.

I have nothing against dtrace language and dtrace scripts.
Go ahead and compile them into bpf.
All patches to improve bpf infrastructure are very welcomed.

In particular you brought up a good point that there is a use case
for sharing a piece of bpf program between kprobe and tracepoint events.
The better way to do that is via bpf2bpf call.
Example:
void bpf_subprog(arbitrary args)
{
}

SEC("kprobe/__set_task_comm")
int bpf_prog_kprobe(struct pt_regs *ctx)
{
  bpf_subprog(...);
}

SEC("tracepoint/sched/sched_switch")
int bpf_prog_tracepoint(struct sched_switch_args *ctx)
{
  bpf_subprog(...);
}

Such configuration is not supported by the verifier yet.
We've been discussing it for some time, but no work has started,
since there was no concrete use case.
If you can work on adding support for it everyone will benefit.

Could you please consider doing that as a step forward?

