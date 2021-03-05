Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1B1D32F6B0
	for <lists+netdev@lfdr.de>; Sat,  6 Mar 2021 00:40:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229865AbhCEXii (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Mar 2021 18:38:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:55224 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229637AbhCEXiG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 5 Mar 2021 18:38:06 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 907B9650A0;
        Fri,  5 Mar 2021 23:38:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614987485;
        bh=Y1/XL2oAp80BxQKqdsYH7jDkWbHHD+zI8kViEFbZ2jM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=LflxLg58/wTKQEB71QsI/MNiUzk3aG8jo73zpliqpi/nanh/6OTBXCsOw1trvltj1
         5ssTzhtVfGBxoSJM6+n7gx9NFJVxG4+ExBOvqI2rb8bimS9IYlCNBWj68nXGjucUyD
         QH59PGrmbtVZm4ebcT4rkATK6BkvlpnItE6Iu0dqvIzh2BGCwlt8XhMQFZ+xZFh1/B
         w0jBB6g24Q1LJ3flDNCfj9iJj4E6DITOV7zAXesY4pSTJiztES+WnjuBQ+yygrLf6p
         pjvR56pqJbGn9AIxFSdxp0vDzjZxgoB2SqYpyOnDRSIcCoO6Qe6ST3jfZRSw1CO7Ei
         VhNQV+aiwZNgQ==
Received: by pali.im (Postfix)
        id 237FC105A; Sat,  6 Mar 2021 00:38:03 +0100 (CET)
Date:   Sat, 6 Mar 2021 00:38:02 +0100
From:   Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 5.11 16/67] net: sfp: add mode quirk for GPON
 module Ubiquiti U-Fiber Instant
Message-ID: <20210305233802.x3g6bfmgbpwmv3e2@pali>
References: <20210224125026.481804-16-sashal@kernel.org>
 <20210224125212.482485-12-sashal@kernel.org>
 <20210225190306.65jnl557vvs6d7o3@pali>
 <YEFgHQt6bp7yBjH/@sashalap>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <YEFgHQt6bp7yBjH/@sashalap>
User-Agent: NeoMutt/20180716
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thursday 04 March 2021 17:33:01 Sasha Levin wrote:
> On Thu, Feb 25, 2021 at 08:03:06PM +0100, Pali Rohár wrote:
> > On Wednesday 24 February 2021 07:49:34 Sasha Levin wrote:
> > > From: Pali Rohár <pali@kernel.org>
> > > 
> > > [ Upstream commit f0b4f847673299577c29b71d3f3acd3c313d81b7 ]
> > 
> > Hello! This commit requires also commit~1 from that patch series:
> > https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=426c6cbc409cbda9ab1a9dbf15d3c2ef947eb8c1
> > 
> > Without it kernel cannot read EEPROM from Ubiquiti U-Fiber Instant
> > module and therefore the hook based on EEPROM data which is below would
> > not be applied.
> 
> Looks like that commit is already in, thanks!

Yes! Now I see that commit in 5.11 queue. So 5.11 would be OK.

But I do not see it in 5.10 queue. In 5.10 queue I see only backport of
f0b4f8476732 commit. 426c6cbc409c seems to be still missing.

Could you check it?
