Return-Path: <netdev+bounces-10580-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 249BB72F332
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 05:45:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CFA0F280FE9
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 03:45:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CE01D649;
	Wed, 14 Jun 2023 03:45:41 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63F10363
	for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 03:45:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B907C433C0;
	Wed, 14 Jun 2023 03:45:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686714339;
	bh=vybn/0UP/i4FCllwB+QLyE9U1pCAzcrXTRNnoZxtrDo=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=gUf+RUxHrvb43aEu7iFgxT4YPIWR0mDA0sobv9DdyKJsLEunXHtis1iEjVGwc1fnz
	 Vda55/qLETgWm8WcFxOfZc34OThIDeF7wDMrFJmdrPnokua5Cs1CMPCOACsTOMUqRm
	 /N8lsL10BP7cm0XrC/AzhUhRq83CAobSf51oXhLAeGrUUBrTzVVJ5uHQMxjeFDNSCZ
	 m6TI4fhVDsmyoKv9hPIIIrIx19fZOPmsF5THKIgS5MvjqyI9hE/uv6kREVKaIyoNze
	 lJqRPc9bmyL9daoy14cexSt27g/HmPRInPVuqzRWMNM1MuT6B1Dz7WELDScGzcfuXp
	 fOWy0MSt+OXBg==
Date: Tue, 13 Jun 2023 20:45:38 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Paolo Abeni <pabeni@redhat.com>
Cc: Peilin Ye <yepeilin.cs@gmail.com>, Jamal Hadi Salim <jhs@mojatatu.com>,
 Cong Wang <xiyou.wangcong@gmail.com>, Jiri Pirko <jiri@resnulli.us>, "David
 S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Peilin Ye <peilin.ye@bytedance.com>, Vlad Buslov <vladbu@mellanox.com>,
 Pedro Tammela <pctammela@mojatatu.com>, John Fastabend
 <john.fastabend@gmail.com>, Daniel Borkmann <daniel@iogearbox.net>, Hillf
 Danton <hdanton@sina.com>, Zhengchao Shao <shaozhengchao@huawei.com>,
 netdev@vger.kernel.org, linux-kernel@vger.kernel.org, Cong Wang
 <cong.wang@bytedance.com>
Subject: Re: [PATCH net 2/2] net/sched: qdisc_destroy() old ingress and
 clsact Qdiscs before grafting
Message-ID: <20230613204538.726bc0a4@kernel.org>
In-Reply-To: <7f773c114001cbcd0c6ff21da9976eb0ba533421.camel@redhat.com>
References: <cover.1686355297.git.peilin.ye@bytedance.com>
	<c1f67078dc8a3fd7b3c8ed65896c726d1e9b261e.1686355297.git.peilin.ye@bytedance.com>
	<7f773c114001cbcd0c6ff21da9976eb0ba533421.camel@redhat.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 13 Jun 2023 10:39:33 +0200 Paolo Abeni wrote:
> The fixes LGTM, but I guess this could deserve an explicit ack from
> Jakub, as he raised to point for the full retry implementation.

AFAIU the plan is to rework flags in net-next to address the live lock
issue completely? No objections here.

