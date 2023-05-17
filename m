Return-Path: <netdev+bounces-3385-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id CAD12706CA7
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 17:26:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7EF642813D5
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 15:26:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D9F1CAD48;
	Wed, 17 May 2023 15:26:33 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 914BA2F5B
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 15:26:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F173AC433D2;
	Wed, 17 May 2023 15:26:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1684337192;
	bh=WyX3P6M5M5c3jfzTnvw9bOQVg8E6BzjWY2PAmKDSgbM=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=MgZ7wzV1WCzPwV3HeO0Dxz5S74wMWf6E7XH4ANO9fvJWBhL5MGLV2rOPaG0BDFhMm
	 dJwXtGYkaGxCvSAKnwQdhFdl8oauaiDM4//TEAeCGRWZulB3BMaDnV+xUgrU6UUEPe
	 K5Fl1wzbaDnL+LeJE1GKIu7uhB1wMI3D26kqZLy+l/xg2Z023yABHjp3ls5rlgfgO3
	 HjCa8lQwyi9T0MmhREUPq1zUvSE9MHKx5ES2g2rsVB5Axm9Rb7swZ+sL6kKO0d/QWQ
	 D/Ybrg9Vs78MQXC/9o0vgQUHkbEE66+sZAso/ogFN63OOCZXoAjoD/dDO6YChhQHlA
	 Zqajksh9sfdUQ==
Date: Wed, 17 May 2023 08:26:30 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Kui-Feng Lee <thinker.li@gmail.com>
Cc: netdev@vger.kernel.org, ast@kernel.org, martin.lau@linux.dev,
 kernel-team@meta.com, Kui-Feng Lee <kuifeng@meta.com>
Subject: Re: [RFC PATCH net-next 1/2] net: Remove expired routes with
 separated timers.
Message-ID: <20230517082630.3e75f320@kernel.org>
In-Reply-To: <20230517042757.161832-2-kuifeng@meta.com>
References: <20230517042757.161832-1-kuifeng@meta.com>
	<20230517042757.161832-2-kuifeng@meta.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 16 May 2023 21:27:56 -0700 Kui-Feng Lee wrote:
> To: netdev@vger.kernel.org,  ast@kernel.org,  martin.lau@linux.dev,  kernel-team@meta.com
> Cc: Kui-Feng Lee <kuifeng@meta.com>

How do you expect the IPv6 maintainer to find this series? :(
Please use get_maintainer.pl to CC the correct maintainers.

