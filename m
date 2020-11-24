Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BE6E2C215E
	for <lists+netdev@lfdr.de>; Tue, 24 Nov 2020 10:29:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731293AbgKXJ2p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Nov 2020 04:28:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731004AbgKXJ2p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Nov 2020 04:28:45 -0500
Received: from mail.buslov.dev (mail.buslov.dev [IPv6:2001:19f0:5001:2e3f:5400:1ff:feed:a259])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DFB8C0613D6
        for <netdev@vger.kernel.org>; Tue, 24 Nov 2020 01:28:45 -0800 (PST)
Received: from vlad-x1g6 (unknown [IPv6:2a0b:2bc3:193f:1:a5fe:a7d6:6345:fe8d])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.buslov.dev (Postfix) with ESMTPSA id 9934D1FA90;
        Tue, 24 Nov 2020 11:28:39 +0200 (EET)
References: <20201121160902.808705-1-vlad@buslov.dev> <20201123132244.55768678@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
User-agent: mu4e 1.4.13; emacs 26.3
From:   Vlad Buslov <vlad@buslov.dev>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us
Subject: Re: [PATCH net-next] net: sched: alias action flags with TCA_ACT_ prefix
In-reply-to: <20201123132244.55768678@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Date:   Tue, 24 Nov 2020 11:28:37 +0200
Message-ID: <87v9dv9k8q.fsf@buslov.dev>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon 23 Nov 2020 at 23:22, Jakub Kicinski <kuba@kernel.org> wrote:
> On Sat, 21 Nov 2020 18:09:02 +0200 Vlad Buslov wrote:
>> Currently both filter and action flags use same "TCA_" prefix which makes
>> them hard to distinguish to code and confusing for users. Create aliases
>> for existing action flags constants with "TCA_ACT_" prefix.
>> 
>> Signed-off-by: Vlad Buslov <vlad@buslov.dev>
>
> Are we expecting to add both aliases for all new flags?

I don't think it makes sense to have both aliases for any new flags.

>
> TCA_FLAG_TERSE_DUMP exists only in net-next, we could rename it, right?

You are right. I'll send a fix.

