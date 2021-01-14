Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C6462F556F
	for <lists+netdev@lfdr.de>; Thu, 14 Jan 2021 01:06:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729757AbhANAFr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jan 2021 19:05:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:56184 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729729AbhANADP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 13 Jan 2021 19:03:15 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B8CAB22460;
        Thu, 14 Jan 2021 00:01:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610582519;
        bh=mBPvV6lfYHEUvJ1sPZTLH/iMOLEUzM9vWBaPlPE4+ds=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=FxwHqZCJxPgHJ+DcZjFeDEfAApe+cbVvOPhR7UWwEv3gJW1n0yatabb4i4sPpu4QI
         uPiX1FVouVoyUqOg6n7fv2kEwYL29eusCqHLxs3QqNXdlyVdRuQPBAyHSDXh6HmT1B
         gFLGSO37KV9Xjeg5330p/1c8eWqUREyNFahke1fEUzp1rhNax2ER4h/QE2SaVMrAl3
         B+YRgAJdRPAOfubYuHB7sr5M1L457+uPPttPnxpy2dU1go3R9nvlUzJiBgiHa5dvzo
         BTpdiGXql7+Y4CPhvzHM4WhInV1Cr1clgVuRUXPFrlGq2fAjfVnRKp5TEysfAmOiq/
         Fzla1mLt9YDXg==
Message-ID: <88a2b0ea7554a4ac44e86314cfa0c2794be50d71.camel@kernel.org>
Subject: Re: [pull request][net-next V2 00/11] mlx5 updates 2021-01-07
From:   Saeed Mahameed <saeed@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Date:   Wed, 13 Jan 2021 16:01:57 -0800
In-Reply-To: <20210113154155.1cfa9f0c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20210112070534.136841-1-saeed@kernel.org>
         <20210113154155.1cfa9f0c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2021-01-13 at 15:41 -0800, Jakub Kicinski wrote:
> On Mon, 11 Jan 2021 23:05:23 -0800 Saeed Mahameed wrote:
> > From: Saeed Mahameed <saeedm@nvidia.com>
> > 
> > Hi Dave, Jakub
> > 
> > This series provides misc updates for mlx5 driver. 
> > v1->v2:
> >   - Drop the +trk+new TC feature for now until we handle the module
> >     dependency issue.
> > 
> > For more information please see tag log below.
> > 
> > Please pull and let me know if there is any problem.
> 
> The PR lacks sign-offs, I can apply from the list but what's the
> story

Sing-off where ? the tag ?

> with the fixes tags on the patches for -next?

the patch got migrated from net to net-next as it wasn't deemed to be a
critical bug fix but it is a bug fix .. 
do you want me to remove it ? 

thanks.

