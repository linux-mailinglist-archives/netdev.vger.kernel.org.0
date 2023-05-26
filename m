Return-Path: <netdev+bounces-5801-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 2DB12712C69
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 20:27:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D88FB1C210F2
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 18:27:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2FF5A2910A;
	Fri, 26 May 2023 18:27:31 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 255B115BD
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 18:27:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52505C433EF;
	Fri, 26 May 2023 18:27:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1685125649;
	bh=B9a2+71TulzKBO9c2ZxBPHtYPJB9s9lgR7ZlY+O6qkU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=yzH6gnNir81Oov6JCgRSOSjBEmZ4NR3JxsObBl2m+Rm4Oc3/T1dpci6YSkL4MohI/
	 lHmxJgwFGQFguSb3LbMIZpV81P/lUP+Ni3f3YUTam9ZFR0JwwTx4Ki6KfVN278UulY
	 KQbZ6akaW78CjenlW0TLGwlTt9hTzrieTn/zIynU=
Date: Fri, 26 May 2023 19:27:26 +0100
From: Greg KH <gregkh@linuxfoundation.org>
To: Dragos-Marian Panait <dragos.panait@windriver.com>
Cc: stable@vger.kernel.org, wenxu <wenxu@ucloud.cn>,
	Jakub Kicinski <kuba@kernel.org>,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Davide Caratti <dcaratti@redhat.com>,
	Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
	Paolo Abeni <pabeni@redhat.com>, William Zhao <wizhao@redhat.com>,
	Xin Long <lucien.xin@gmail.com>,
	"David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Cong Wang <xiyou.wangcong@gmail.com>, Jiri Pirko <jiri@resnulli.us>,
	Shuah Khan <shuah@kernel.org>, linux-kselftest@vger.kernel.org,
	netdev@vger.kernel.org
Subject: Re: [PATCH 5.10 0/3] Fix for CVE-2022-4269
Message-ID: <2023052617-preorder-universal-1b5d@gregkh>
References: <20230516190040.636627-1-dragos.panait@windriver.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230516190040.636627-1-dragos.panait@windriver.com>

On Tue, May 16, 2023 at 10:00:37PM +0300, Dragos-Marian Panait wrote:
> The following commits are needed to fix CVE-2022-4269:
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=fa6d639930ee5cd3f932cc314f3407f07a06582d
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=78dcdffe0418ac8f3f057f26fe71ccf4d8ed851f
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=ca22da2fbd693b54dc8e3b7b54ccc9f7e9ba3640

All now queued up, thanks.

greg k-h

