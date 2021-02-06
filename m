Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C95C3311B44
	for <lists+netdev@lfdr.de>; Sat,  6 Feb 2021 06:02:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229931AbhBFFBl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 6 Feb 2021 00:01:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:58410 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230244AbhBFFAw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 6 Feb 2021 00:00:52 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4F21764F70;
        Sat,  6 Feb 2021 05:00:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612587606;
        bh=gjjUdNER3lDFYGoOuFJgeMZuHKyVgcnqaf0bbxETDAo=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=KQzaL96AsYsJsgKwrkTSITKar1r4BvCZvJ3rCC5JJLc2gHXxeY0feNB8b0u6BIpPE
         mMqDstoRqfa7Xodxq6x6cJCi9DbT2myVHnv0CyZzr7r32vl7EHj2j77jcsMcTVtEHi
         v9UcqXuqyVDwnRgRs54f6ZN/kyi/+8BaQfHVIp25jmmhlQdTp8o2yL5XsnS0m01US0
         8jX8vwj9ORsUHCVTrX61LjHYow9ecriAhzM+gMugzo3JS/yJCGoJlr06WL8+5Ss7xy
         PM8qDlCeTXMMrfwxn6AUiK5M4KWumh7Wjys/YSe2M/Co0hpsY14T4k00QLtuetiD+Q
         qXO3hKCaBedwA==
Message-ID: <be9308477f9f25e44ca0c33017f7bb8478d4bb9c.camel@kernel.org>
Subject: Re: [pull request][net-next 00/17] mlx5 updates 2021-02-04
From:   Saeed Mahameed <saeed@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>
Date:   Fri, 05 Feb 2021 21:00:05 -0800
In-Reply-To: <20210205124109.38fc6677@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20210205064051.89592-1-saeed@kernel.org>
         <20210205124109.38fc6677@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.3 (3.38.3-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2021-02-05 at 12:41 -0800, Jakub Kicinski wrote:
> On Thu,  4 Feb 2021 22:40:34 -0800 Saeed Mahameed wrote:
> > This series adds support for VF tunneling from Vlad,
> > For more information please see tag log below.
> > 
> > Please pull and let me know if there is any problem.
> 
> Patch 2 and on do not build, could you investigate?

I sent the wrong version (facepalm), Sorry, i had to rebase this series
at the last minute and collect all the dependencies manually and
eventually sent an older broken version.

sending V2.


