Return-Path: <netdev+bounces-5480-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 16CD771193F
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 23:39:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8A06C1C20F54
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 21:39:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DBA1624EA7;
	Thu, 25 May 2023 21:39:04 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C1751EA8B
	for <netdev@vger.kernel.org>; Thu, 25 May 2023 21:39:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 531AFC433D2;
	Thu, 25 May 2023 21:39:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1685050742;
	bh=ifHbzh3pec3yqvmX9F0OZzDTjTGDEDgj+fBkFuIO95o=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=H3GfJpFlWacAa2fLs8q7IprbF1I4AZZ+vHFTE4tD8maHrgfo3uCNazQeVTWIBFttr
	 F1vnouhg7gTSmd394ccL17BBQsp2FlUa5Fdd/jTyZY6nhxkxHc0Jaj3FPFQzO9vPMz
	 r83a6ub6iEZ4Z72z+lj4t3McREDmEFAVF1jTkOEE=
Date: Thu, 25 May 2023 14:39:01 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Anjali Kulkarni <anjali.k.kulkarni@oracle.com>
Cc: davem@davemloft.net, david@fries.net, edumazet@google.com,
 kuba@kernel.org, pabeni@redhat.com, zbr@ioremap.net, brauner@kernel.org,
 johannes@sipsolutions.net, ecree.xilinx@gmail.com, leon@kernel.org,
 keescook@chromium.org, socketcan@hartkopp.net, petrm@nvidia.com,
 linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH v5 0/6] Process connector bug fixes & enhancements
Message-Id: <20230525143901.dc8c3d8cced48e52d3b136c1@linux-foundation.org>
In-Reply-To: <20230420202709.3207243-1-anjali.k.kulkarni@oracle.com>
References: <20230420202709.3207243-1-anjali.k.kulkarni@oracle.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 20 Apr 2023 13:27:03 -0700 Anjali Kulkarni <anjali.k.kulkarni@oracle.com> wrote:

> Oracle DB is trying to solve a performance overhead problem it has been
> facing for the past 10 years and using this patch series, we can fix this 
> issue.  

An update to Documentation/driver-api/connector.rst would be
appropriate.

If you're feeling generous, please review the existing material in
there, check that it is complete and accurate.  Thanks.


