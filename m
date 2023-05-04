Return-Path: <netdev+bounces-480-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 7AB506F79CA
	for <lists+netdev@lfdr.de>; Fri,  5 May 2023 01:40:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B49241C215B7
	for <lists+netdev@lfdr.de>; Thu,  4 May 2023 23:40:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 84D48C13F;
	Thu,  4 May 2023 23:40:08 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05223BA51
	for <netdev@vger.kernel.org>; Thu,  4 May 2023 23:40:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43A49C433EF;
	Thu,  4 May 2023 23:40:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1683243606;
	bh=jngE53SXifGORvh7RbT0vdiJx0s2AZ4cT9LXEwK5tdM=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=fCKVkKF3q1PJ3JEkMXJB8JlrwWkf8aZGkIxAcdGNg2ihyNNdaTwnW3VlYVy8Ssymg
	 mwqhA0xTp4Xai209Q1n9PHCkXWUuh4caamk/R3kBSb/KXq9f6BavkkD7GX4IyXmnxw
	 ju4bls+mz9KM5pSegJWXDLiFOQLqLFDA6gESJ6lh4zUizkct3ORgrEulXCqrS6R+/M
	 VIoovs50oJNwAJU4Hi0xofaKsLPEUvj+8/3FmFloWCulzQRawKh9bNmgtDp4wtQM5V
	 wkcTEFen7mOK3eMcO4ftj4mylR1ndCj/TNUgIBajlO9PaklL7/BI8+wJDEjjK9cFeG
	 3L3GRWHoEiGqQ==
Date: Thu, 4 May 2023 16:40:05 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Brett Creeley <brett.creeley@amd.com>, kvm@vger.kernel.org,
 netdev@vger.kernel.org, alex.williamson@redhat.com, yishaih@nvidia.com,
 shameerali.kolothum.thodi@huawei.com, kevin.tian@intel.com,
 shannon.nelson@amd.com, drivers@pensando.io
Subject: Re: [PATCH v9 vfio 2/7] vfio/pds: Initial support for pds_vfio VFIO
 driver
Message-ID: <20230504164005.16fb3deb@kernel.org>
In-Reply-To: <ZFQ0sqSmJuzLXLbu@nvidia.com>
References: <20230422010642.60720-1-brett.creeley@amd.com>
	<20230422010642.60720-3-brett.creeley@amd.com>
	<ZFPq0xdDWKYFDcTz@nvidia.com>
	<20230504132001.32b72926@kernel.org>
	<ZFQ0sqSmJuzLXLbu@nvidia.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 4 May 2023 19:41:54 -0300 Jason Gunthorpe wrote:
> On Thu, May 04, 2023 at 01:20:01PM -0700, Jakub Kicinski wrote:
> > On Thu, 4 May 2023 14:26:43 -0300 Jason Gunthorpe wrote:  
> > > This GNU style of left aligning the function name should not be
> > > in the kernel.  
> > 
> > FTR that's not a kernel-wide rule. Please scope your coding style
> > suggestions to your subsystem, you may confuse people.  
> 
> It is what Documentation/process/coding-style.rst expects.

A reference to the section? You mean the vague mentions of the GNU
coding style? That's just a tiny part of the GNU style, the separation
of arg types is probably the most offensive.

If the function declaration does not fit in 80 chars breaking the type
off as a separate line is often a very reasonable choice.

Anyway, I shouldn't complain, networking still has its odd rules.
Probably why people making up rules for no strong reason is on my mind.

> It is good advice for new submitters to follow the common style guide
> consistently. The places that want different can ask for their
> differences during the first review, we don't need to confuse people
> with the reality that everything is an exception to someone somewhere.

Yeah.

