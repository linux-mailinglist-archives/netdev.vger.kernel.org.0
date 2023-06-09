Return-Path: <netdev+bounces-9713-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 7193A72A51D
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 23:08:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BD8F31C20A96
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 21:08:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 66B501E533;
	Fri,  9 Jun 2023 21:08:46 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 367AE408E0
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 21:08:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 312F0C433EF;
	Fri,  9 Jun 2023 21:08:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686344924;
	bh=khMjJZ6SbRtiHSzoAiJYcCLwvpHE55DPi59sRUk9SnA=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=EPwq+3SVS8hpxxiCv7rr8f9wFYJwjqxeQoWOBcRM374UN7xGFI1xqLQix1de/69rs
	 mzSKQ2vsWaothpzV/NFEyqhlOanSvTSMOsuJjwPr3fNID8aTiJBypYwjufjDvFM/SO
	 /VDFyzRbixe+F1NWRWKhzGNQUNVq0yLdyVmmHwJ0qoTO1YRqU2wm9DkbMj+3sgEBsI
	 yWoBtYIC1jxiyzAzp8N+onYpJng/asUqh8dxb0fbpTm3J+IM0DuAyBCExuuU3IHD+V
	 RB52HW+NYCIG4Ye+w1p8jQuYEdC/Y8pGUd9yUkj2zYf9hIAlH7PN4PeuQ/JXbSs7Ab
	 3klNk7thwj8Xw==
Date: Fri, 9 Jun 2023 14:08:43 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Magali Lemes do Sacramento <magali.lemes@canonical.com>
Cc: davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
 shuah@kernel.org, vfedorenko@novek.ru, tianjia.zhang@linux.alibaba.com,
 andrei.gherzan@canonical.com, netdev@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net v2 1/3] selftests: net: tls: check if FIPS mode is
 enabled
Message-ID: <20230609140843.4444e444@kernel.org>
In-Reply-To: <CAO9q4O1SctX1323-8JDO0=ovsLfNpv4EjOSdP_PwYDJ76tAQiQ@mail.gmail.com>
References: <20230609164324.497813-1-magali.lemes@canonical.com>
	<20230609164324.497813-2-magali.lemes@canonical.com>
	<20230609105307.492cd1f2@kernel.org>
	<CAO9q4O1SctX1323-8JDO0=ovsLfNpv4EjOSdP_PwYDJ76tAQiQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 9 Jun 2023 17:15:38 -0300 Magali Lemes do Sacramento wrote:
> > Eh, let me help you, this should really be part of the SETUP() function
> > but SETUP() doesn't currently handle SKIP(). So you'll need to add this
> > to your series:  
> 
> May I add your Suggested-by tag to this upcoming patch in this patchset v3?

No strong preference but sure, why not :)

