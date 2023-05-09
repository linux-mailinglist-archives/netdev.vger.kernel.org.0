Return-Path: <netdev+bounces-1209-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id ECE5D6FCA51
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 17:34:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 23B661C20C1F
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 15:34:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1ED8C18002;
	Tue,  9 May 2023 15:34:36 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8241D8BE2
	for <netdev@vger.kernel.org>; Tue,  9 May 2023 15:34:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC099C433D2;
	Tue,  9 May 2023 15:34:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1683646474;
	bh=tcsG/9yvVS7yUA7c8w07U/zowguK+rl0WQ5JKrgKA1c=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=dg5asSl54sAUzZyP7SAE/OHZjKAjvHCORCTCtt4w9qsz/vr3n5kPBDdcGnson4Knq
	 M+tmNPKQp/k7C9sRCUp5kHwsyBHYs9aBk/QFQ2VlRNcdSgu5Yz0PnDnvNuTYaUH1Ye
	 KkF3c5/BgZw1kig1MB1TKO23hQc8IvQleGAk6I+VgrdD67tJ6Z2Diu8Lie28y+fBwU
	 OqRdlXmEG6iSpY/xpzqfxCcLEzwBJito7VgyHAtMys632isFB+KAZYRdcK13w6mf6e
	 Z4ODiBDpEor14DAHgqw14xMsC4iOug6vb+fr4Yz3xKhwzJwCyLWhHp01KLOVtqh6I0
	 W4Z2o/OpFmKuA==
Date: Tue, 9 May 2023 09:34:31 -0600
From: David Ahern <dsahern@kernel.org>
To: Guillaume Nault <gnault@redhat.com>
Cc: David Miller <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>, Eric Dumazet <edumazet@google.com>,
	netdev@vger.kernel.org
Subject: Re: [PATCH net-next 1/4] selftests: Add SO_DONTROUTE option to
 nettest.
Message-ID: <20230509153431.GB26485@u2004-local>
References: <cover.1683626501.git.gnault@redhat.com>
 <1b3d54c39af185c514a16cbd779b52a9cf9ef2de.1683626501.git.gnault@redhat.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1b3d54c39af185c514a16cbd779b52a9cf9ef2de.1683626501.git.gnault@redhat.com>

On Tue, May 09, 2023 at 02:02:36PM +0200, Guillaume Nault wrote:
> Add -G option to nettest. It allows to set the SO_DONTROUTE option to
> the created sockets. This will be used by the following patches to test
> the SO_DONTROUTE behaviour with TCP and UDP.
> 
> Signed-off-by: Guillaume Nault <gnault@redhat.com>
> ---
>  tools/testing/selftests/net/nettest.c | 32 +++++++++++++++++++++++++--
>  1 file changed, 30 insertions(+), 2 deletions(-)
> 

Reviewed-by: David Ahern <dsahern@kernel.org>

