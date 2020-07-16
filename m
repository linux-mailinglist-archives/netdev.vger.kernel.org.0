Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AAF57221954
	for <lists+netdev@lfdr.de>; Thu, 16 Jul 2020 03:13:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727042AbgGPBNm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jul 2020 21:13:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:42484 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726776AbgGPBNm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Jul 2020 21:13:42 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 660F120787;
        Thu, 16 Jul 2020 01:13:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594862021;
        bh=UMY1x2tg7DgZhUmNwgpnW8vbbMkK3/3A5b+29c+zco8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=sSSyU5u+3uRZpNm2E1ke/McEBUYm4HKyZPMIhSo79SV1qYJF6/n6wVJoQjsH/8INx
         ck0FZm4p5wrpbTUexhzS3CFvIbEiq4zg5Efl26JVmOYSzD47n13mLGwVk5v2Ebyedd
         BirAEVFusPP0vWTNrtc+ROsLPZfKJImGX5xbAhXE=
Date:   Wed, 15 Jul 2020 18:13:40 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, jiri@mellanox.com,
        petrm@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: Re: [PATCH net-next 00/11] mlxsw: Offload tc police action
Message-ID: <20200715181340.5cf42a40@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200715082733.429610-1-idosch@idosch.org>
References: <20200715082733.429610-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 15 Jul 2020 11:27:22 +0300 Ido Schimmel wrote:
> From: Ido Schimmel <idosch@mellanox.com>
> 
> This patch set adds support for tc police action in mlxsw.
> 
> Patches #1-#2 add defines for policer bandwidth limits and resource
> identifiers (e.g., maximum number of policers).
> 
> Patch #3 adds a common policer core in mlxsw. Currently it is only used
> by the policy engine, but future patch sets will use it for trap
> policers and storm control policers. The common core allows us to share
> common logic between all policer types and abstract certain details from
> the various users in mlxsw.
> 
> Patch #4 exposes the maximum number of supported policers and their
> current usage to user space via devlink-resource. This provides better
> visibility and also used for selftests purposes.
> 
> Patches #5-#7 gradually add support for tc police action in the policy
> engine by calling into previously mentioned policer core.
> 
> Patch #8 adds a generic selftest for tc-police that can be used with
> veth pairs or physical loopbacks.
> 
> Patches #9-#11 add mlxsw-specific selftests.

Applied, thanks Ido!
