Return-Path: <netdev+bounces-11275-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BE954732594
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 05:03:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 76B702815E1
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 03:03:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 96EF064E;
	Fri, 16 Jun 2023 03:03:42 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1364D64D
	for <netdev@vger.kernel.org>; Fri, 16 Jun 2023 03:03:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46FCDC433C0;
	Fri, 16 Jun 2023 03:03:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686884620;
	bh=ulGOfep6nczNWBUTlh7lvZxYn6VUeFanuknAD7MDRBg=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=N+EZajEL1kBLBisheBB9uP74nvZJd2IfOIAL1KW93SjUwXD5TtVQ0vapxP9wN4Gf1
	 e+x7FqKdrjjmFFA0jFvi8xOXty0tGv1SUKcuCdxP7kqPxW7pc2yxOBJOD7B30GIwvl
	 g+E8mnAc+G6e+vxuI86b2g8MH9IzhoLVY62sXRecsPZbS52iPWn8vGc+p33EeIKkHL
	 eHC8v4wjCStl4iQ2kQqIj9FsFgbf3i+kz5T0CP5OuBghBjgazl0aqhdvqmv44VtjTY
	 vbjtriMLs9HqPevpmcr4WH5aUyBxC6ldV0NVgRqsU/FKPWLkEfwlE0oUgxM5SvuBCp
	 d8egzJSYWfLeA==
Date: Thu, 15 Jun 2023 20:03:39 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Donald Hunter <donald.hunter@gmail.com>
Cc: netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>, Eric
 Dumazet <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>,
 donald.hunter@redhat.com
Subject: Re: [PATCH net-next v1] netlink: specs: fixup openvswitch specs for
 code generation
Message-ID: <20230615200339.3601385d@kernel.org>
In-Reply-To: <20230615151405.77649-1-donald.hunter@gmail.com>
References: <20230615151405.77649-1-donald.hunter@gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 15 Jun 2023 16:14:05 +0100 Donald Hunter wrote:
> Refine the ovs_* specs to align exactly with the ovs netlink UAPI
> definitions to enable code generation.

Hah, the C code gen really tells you if you got the spec right ;)

Changes LGTM!

