Return-Path: <netdev+bounces-9389-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 8A2D4728B46
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 00:51:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E67491C20E5B
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 22:51:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B7F0723D71;
	Thu,  8 Jun 2023 22:51:49 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D07851953A;
	Thu,  8 Jun 2023 22:51:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98BA2C433D2;
	Thu,  8 Jun 2023 22:51:45 +0000 (UTC)
Date: Thu, 8 Jun 2023 18:51:42 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Jiri Olsa <jolsa@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
 Andrii Nakryiko <andrii.nakryiko@gmail.com>, Daniel Borkmann
 <daniel@iogearbox.net>, Andrii Nakryiko <andrii@kernel.org>,
 netdev@vger.kernel.org, bpf@vger.kernel.org, lkml
 <linux-kernel@vger.kernel.org>, Martin KaFai Lau <kafai@fb.com>, Song Liu
 <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>, John Fastabend
 <john.fastabend@gmail.com>, KP Singh <kpsingh@chromium.org>, "Naveen N .
 Rao" <naveen.n.rao@linux.ibm.com>, Anil S Keshavamurthy
 <anil.s.keshavamurthy@intel.com>, "David S . Miller" <davem@davemloft.net>
Subject: Re: [PATCH v12 bpf-next 02/12] fprobe: Add ftrace based probe APIs
Message-ID: <20230608185142.7372e7b6@gandalf.local.home>
In-Reply-To: <164735283857.1084943.1154436951479395551.stgit@devnote2>
References: <164735281449.1084943.12438881786173547153.stgit@devnote2>
	<164735283857.1084943.1154436951479395551.stgit@devnote2>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 15 Mar 2022 23:00:38 +0900
Masami Hiramatsu <mhiramat@kernel.org> wrote:

> +static void fprobe_init(struct fprobe *fp)
> +{
> +	fp->nmissed = 0;
> +	fp->ops.func = fprobe_handler;
> +	fp->ops.flags |= FTRACE_OPS_FL_SAVE_REGS;
> +}
> +

Masami,

I thought one of the advantages of fprobes over kprobes was that it did not
need to use SAVE_REGS, as that causes more overhead than SAVE_ARGS?

If fprobes uses save regs, what is the advantage of it over kprobes?

-- Steve

