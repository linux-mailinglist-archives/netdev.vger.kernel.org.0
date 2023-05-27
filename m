Return-Path: <netdev+bounces-5831-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F17AD7130DF
	for <lists+netdev@lfdr.de>; Sat, 27 May 2023 02:30:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A83222819DD
	for <lists+netdev@lfdr.de>; Sat, 27 May 2023 00:30:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 39661392;
	Sat, 27 May 2023 00:30:07 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3E4E38C;
	Sat, 27 May 2023 00:30:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EF3BC4339C;
	Sat, 27 May 2023 00:30:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685147405;
	bh=Zxe0jJQLpQaYRMsIBGxGKIIQL3s7fZNGnrjONx4la2g=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=nDqYYYkl8zCfQnb8npn6e4/R/eazTOgmBd5DxH2uOti7SY6zxln56ng4VWwRsUxEq
	 wtYEZz+S1lDgTIKW7WYtosaLNKl0RNH8yIM+aKpr2KWDN0iUii9GEPFSpIsr3csIFE
	 zJsfUWiu3YK3KVKSstvMiEtff9O7ZrtIbeAUAP2a/af3DvIaU2f+SritOT/DWpT8+7
	 urBOVynBBVgVSzhtkNfNiU7B+k7NrClSyfQm12FSy7J7yNH0UEt4MmAbojoPcbdMzh
	 Q8M8ZWSoiNVst7lOHaaw2dnELzYDiRlZ3AaZYQUzHT8RfJgONH9NLweAOLmroejIv/
	 nScVZWpu4/sVA==
Date: Fri, 26 May 2023 17:30:03 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Daniel Borkmann <daniel@iogearbox.net>
Cc: davem@davemloft.net, pabeni@redhat.com, edumazet@google.com,
 ast@kernel.org, andrii@kernel.org, martin.lau@linux.dev,
 netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: Re: pull-request: bpf-next 2023-05-26
Message-ID: <20230526173003.55cad641@kernel.org>
In-Reply-To: <20230526222747.17775-1-daniel@iogearbox.net>
References: <20230526222747.17775-1-daniel@iogearbox.net>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Sat, 27 May 2023 00:27:47 +0200 Daniel Borkmann wrote:
> 1) Add the capability to destroy sockets in BPF through a new kfunc, from Aditi Ghag.

Is there a reason this wasn't CCed to netdev?

