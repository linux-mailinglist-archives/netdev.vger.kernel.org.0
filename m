Return-Path: <netdev+bounces-4857-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5F3AF70EC60
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 06:09:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0B3C3280E06
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 04:09:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5830E15C9;
	Wed, 24 May 2023 04:09:33 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EF0E15BC
	for <netdev@vger.kernel.org>; Wed, 24 May 2023 04:09:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73996C433EF;
	Wed, 24 May 2023 04:09:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1684901371;
	bh=Ot3FfJ9opt7pyx9JJbYGpuLXQ2n5i9rXYms80u1q/3M=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=T4gXjAjgO2RrcRqowKEnIY2EoPe/1fMvvOAXz0y8WYpyYIbIF7eAMhr3bQJSh/ub3
	 4o8gw28q2w0ZSU0WS5i2yKmm5+lKgHeHarR6IXj9ay4rHDJjda4K9v5bLKFrauqGC8
	 naehMYvjU/Rtv5cqboROuRdW4+a+mAT9SghGHjIyUxZKwG9vBGp1gNdrGt1pJfQdoq
	 J2XfJYHC/BO65B9xoqOAE8DKd49OAF+h6l0/6burFRUSdH8DH44KRZkxWpFgwQH+m7
	 A2dQzKeqFaRygsO9bP8FBtvM2lFLBv+RRKtXc13hkDNdH0lAE2N/bsIcltt4RoAv/t
	 csX7AlL3vIhOQ==
Date: Tue, 23 May 2023 21:09:30 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Donald Hunter <donald.hunter@gmail.com>
Cc: netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>, Eric
 Dumazet <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>,
 donald.hunter@redhat.com
Subject: Re: [PATCH net-next v2 0/2] tools: ynl: Add byte-order support for
 struct members
Message-ID: <20230523210930.7b9c2840@kernel.org>
In-Reply-To: <20230523093748.61518-1-donald.hunter@gmail.com>
References: <20230523093748.61518-1-donald.hunter@gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 23 May 2023 10:37:46 +0100 Donald Hunter wrote:
> From: Donald Hunter <donald.hunter@redhat.com>
> 
> This patchset adds support to ynl for handling byte-order in struct
> members. The first patch is a refactor to use predefined Struct() objects
> instead of generating byte-order specific formats on the fly. The second
> patch adds byte-order handling for struct members.

Reviewed-by: Jakub Kicinski <kuba@kernel.org>

Thanks!

