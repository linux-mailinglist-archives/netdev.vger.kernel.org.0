Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3E702C7350
	for <lists+netdev@lfdr.de>; Sat, 28 Nov 2020 23:14:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389640AbgK1VuE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Nov 2020 16:50:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:48130 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387792AbgK1VUK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 28 Nov 2020 16:20:10 -0500
Received: from kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com (c-67-180-217-166.hsd1.ca.comcast.net [67.180.217.166])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 66CEF2222C;
        Sat, 28 Nov 2020 21:19:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606598369;
        bh=MFtoT+8jC1b9iZEYCO6dH8HHdZMbF18LyG0cnHCuVUk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=AkDleRCq4MW5pQh82mf7oHLOWoDZ8cGeewhcWeCd1Xxlp4MtA/dMY8h+KDJRh2LVv
         HhTgMS14MEXUUqO/1x1UFdXK6Wo9/RMFKajllIX5lW9FlV1Mtf+YGoQDhjOyafv7vM
         h8r7cPgn0yPltr77Qs2H6mBWp0wHM8ih/jy8divk=
Date:   Sat, 28 Nov 2020 13:19:28 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Davide Caratti <dcaratti@redhat.com>
Cc:     netdev@vger.kernel.org, Roman Mashak <mrv@mojatatu.com>,
        Briana Oursler <briana.oursler@gmail.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Vlad Buslov <vladbu@nvidia.com>,
        Marcelo Leitner <mleitner@redhat.com>
Subject: Re: [PATCH net-next] selftests: tc-testing: enable
 CONFIG_NET_SCH_RED as a module
Message-ID: <20201128131928.05ea8e94@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
In-Reply-To: <cfa23f2d4f672401e6cebca3a321dd1901a9ff07.1606416464.git.dcaratti@redhat.com>
References: <cfa23f2d4f672401e6cebca3a321dd1901a9ff07.1606416464.git.dcaratti@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 26 Nov 2020 19:47:47 +0100 Davide Caratti wrote:
> a proper kernel configuration for running kselftest can be obtained with:
> 
>  $ yes | make kselftest-merge
> 
> enable compile support for the 'red' qdisc: otherwise, tdc kselftest fail
> when trying to run tdc test items contained in red.json.
> 
> Signed-off-by: Davide Caratti <dcaratti@redhat.com>

Looks rather low risk, applied to net, thanks!
