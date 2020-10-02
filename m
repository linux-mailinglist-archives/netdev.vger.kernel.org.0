Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC47B281C98
	for <lists+netdev@lfdr.de>; Fri,  2 Oct 2020 22:08:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725832AbgJBUIB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Oct 2020 16:08:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725616AbgJBUIA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Oct 2020 16:08:00 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C447EC0613D0
        for <netdev@vger.kernel.org>; Fri,  2 Oct 2020 13:08:00 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 2A78411E3E4C0;
        Fri,  2 Oct 2020 12:51:10 -0700 (PDT)
Date:   Fri, 02 Oct 2020 13:07:53 -0700 (PDT)
Message-Id: <20201002.130753.3572832287386183.davem@davemloft.net>
To:     kuba@kernel.org
Cc:     johannes@sipsolutions.net, netdev@vger.kernel.org, andrew@lunn.ch,
        jiri@resnulli.us, mkubecek@suse.cz, dsahern@kernel.org,
        pablo@netfilter.org
Subject: Re: [PATCH net-next v2 00/10] genetlink: support per-command
 policy dump
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20201002082517.31e644ab@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20201002080944.2f63ccf5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <db56057454ee3338a7fe13c8d5cc450b22b18c3b.camel@sipsolutions.net>
        <20201002082517.31e644ab@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Fri, 02 Oct 2020 12:51:10 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jakub Kicinski <kuba@kernel.org>
Date: Fri, 2 Oct 2020 08:25:17 -0700

> Dave, are you planning a PR to Linus soon by any chance? The conflict
> between this series and Johannes's fix would be logically simple to
> resolve but not trivial :(

Let me apply Johannes's fix to both net and net-next, and then you can
respin a v3 of this series on top of that.
