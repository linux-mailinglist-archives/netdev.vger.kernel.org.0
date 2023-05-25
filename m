Return-Path: <netdev+bounces-5377-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A4C1C710F89
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 17:27:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 49AED1C20E10
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 15:27:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A2A3D18C2B;
	Thu, 25 May 2023 15:27:06 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8408D171D6
	for <netdev@vger.kernel.org>; Thu, 25 May 2023 15:27:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7301AC433EF;
	Thu, 25 May 2023 15:27:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685028425;
	bh=aFdNsYlQ+SeXOzak6xT5A2/VMZ0jqKm47vjavk9WCJg=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=JRCIvRw5wQ/RlI0eepRPP8lKUbxOET4mEbod8N31GXZuxK4J/1VkvlGLuoszYnw7y
	 oYtVkouIVEtFnc+5mSXzwUC2k/JpctdSRcbXUCqvtEUtkpM5oQ9EEMCM+dgUSvDOKS
	 Bif9yfbKUiDifh3YCCn+6SMMT9gAbYoucxPg8KIGUmqj3rwbiGkVx/8Sr2Swa1vCOt
	 de6NaFq0grB+CfaiSrh9nRZ71WdEKkT5xXQDfgUVa5WxkinTucmASU5t1wMl3vfHRG
	 co1fUOz8NHx3RIBS+MU/YZU2yKjbGbFm18/DOkqjIFBNmjgMlqCP+CHxOJXh4pU3Kn
	 PXgODA81IzDCw==
Date: Thu, 25 May 2023 08:27:03 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Jiri Pirko <jiri@resnulli.us>
Cc: netdev@vger.kernel.org, pabeni@redhat.com, davem@davemloft.net,
 edumazet@google.com, leon@kernel.org, saeedm@nvidia.com, moshe@nvidia.com,
 jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com, tariqt@nvidia.com,
 idosch@nvidia.com, petrm@nvidia.com, simon.horman@corigine.com,
 ecree.xilinx@gmail.com, habetsm.xilinx@gmail.com,
 michal.wilczynski@intel.com, jacob.e.keller@intel.com
Subject: Re: [patch net-next 05/15] devlink: move port_split/unsplit() ops
 into devlink_port_ops
Message-ID: <20230525082703.0922dab0@kernel.org>
In-Reply-To: <ZG76ohK00xF2LHeK@nanopsycho>
References: <20230524121836.2070879-1-jiri@resnulli.us>
	<20230524121836.2070879-6-jiri@resnulli.us>
	<20230524215301.02ae701e@kernel.org>
	<ZG76ohK00xF2LHeK@nanopsycho>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 25 May 2023 08:05:22 +0200 Jiri Pirko wrote:
> >I think it's because every time I look at struct net_device_ops 
> >a little part of me gives up.  
> 
> Does this work? I checked the existing layout of devlink_ops and the
> internal comments are ignored by kdoc. Actually the whole devlink_ops
> struct is omitted in kdoc. See:
> $ scripts/kernel-doc include/net/devlink.h

Hm, it should work, it's documented as a legal way to kdoc:

https://www.kernel.org/doc/html/next/doc-guide/kernel-doc.html#in-line-member-documentation-comments

We should ask Jon if you're sure it's broken.

