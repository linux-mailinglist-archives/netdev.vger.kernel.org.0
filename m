Return-Path: <netdev+bounces-6691-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AFAF071770B
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 08:44:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 57167281367
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 06:44:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1E05F749B;
	Wed, 31 May 2023 06:44:28 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DAB14C67
	for <netdev@vger.kernel.org>; Wed, 31 May 2023 06:44:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5A2FC433EF;
	Wed, 31 May 2023 06:44:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685515466;
	bh=8FFAnP2AKirMnKiN7vrfsjvnFnx5Y2aiaL8iPmbUD3s=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=fzEnF7s8XO9BItu42PKxSBdTVJLsA9PrbVpKM/UWCD3wlXtGS7lX/FBIhKeikjYUz
	 ow0WAYsDo3TFwlXmpS0d0zPorr/V7TRc227KNV79RAphmY9Ob0R0PGd/MnJUyx0KuO
	 XE3nAsbLl2JrzbHkQGgxDvNhyGgFvlBJHK9e2w5+f0ryUK76VpOjQIPFvewDQZ7fhF
	 te3F12GH6Sh6BSW2MaZW1UbdgJhqSXDVDdUwhJnpHAiLhTwZLciEwZ90Qz9QdIZFDe
	 RAZVcsHDujVjUTXlQOsUSI0mZBAPd/RTItKU6UfvHyugsMaTi+qqgBc+TAbyklF7Mr
	 pPC8CMm8miigQ==
Date: Tue, 30 May 2023 23:44:24 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Paolo Abeni <pabeni@redhat.com>
Cc: Eric Dumazet <edumazet@google.com>, Kuniyuki Iwashima
 <kuniyu@amazon.com>, davem@davemloft.net, dsahern@kernel.org,
 kuni1840@gmail.com, netdev@vger.kernel.org, willemdebruijn.kernel@gmail.com
Subject: Re: [PATCH v1 net-next 00/14] udp: Farewell to UDP-Lite.
Message-ID: <20230530234424.42f7dd06@kernel.org>
In-Reply-To: <f5d311452eba0a4d49d18682e9f143e6c69277dd.camel@redhat.com>
References: <20230530151401.621a8498@kernel.org>
	<20230531010130.43390-1-kuniyu@amazon.com>
	<CANn89iKK4Si92z91ACV_mgh4vqbecxQCHmB-SYEbq6Bsqei_Qg@mail.gmail.com>
	<20230530221043.5ae05030@kernel.org>
	<f5d311452eba0a4d49d18682e9f143e6c69277dd.camel@redhat.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 31 May 2023 08:24:02 +0200 Paolo Abeni wrote:
> > oohm, fair point user-reachable WARN() is a liability.  
> 
> What about a plain pr_warn_once() banner, verbose enough to be
> noticeable? Alike:
> 
> https://lwn.net/ml/linux-fsdevel/20220225125445.29942-1-jack@suse.cz/

SGTM, I think the config option will do the heavy lifting, but doesn't
hurt to throw in a print as well.

