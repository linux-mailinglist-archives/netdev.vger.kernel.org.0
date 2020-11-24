Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 993412C2D24
	for <lists+netdev@lfdr.de>; Tue, 24 Nov 2020 17:40:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390539AbgKXQjx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Nov 2020 11:39:53 -0500
Received: from mail.buslov.dev ([199.247.26.29]:42769 "EHLO mail.buslov.dev"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726105AbgKXQjx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 24 Nov 2020 11:39:53 -0500
Received: from vlad-x1g6 (unknown [IPv6:2a0b:2bc3:193f:1:a5fe:a7d6:6345:fe8d])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.buslov.dev (Postfix) with ESMTPSA id 2A5D2205AB;
        Tue, 24 Nov 2020 18:39:52 +0200 (EET)
References: <20201121160902.808705-1-vlad@buslov.dev> <20201123132244.55768678@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com> <87v9dv9k8q.fsf@buslov.dev> <20201124082448.56a03de5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
User-agent: mu4e 1.4.13; emacs 26.3
From:   Vlad Buslov <vlad@buslov.dev>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us
Subject: Re: [PATCH net-next] net: sched: alias action flags with TCA_ACT_ prefix
In-reply-to: <20201124082448.56a03de5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Date:   Tue, 24 Nov 2020 18:39:50 +0200
Message-ID: <87sg8yaeuh.fsf@buslov.dev>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue 24 Nov 2020 at 18:24, Jakub Kicinski <kuba@kernel.org> wrote:
> On Tue, 24 Nov 2020 11:28:37 +0200 Vlad Buslov wrote:
>> > TCA_FLAG_TERSE_DUMP exists only in net-next, we could rename it, right?  
>> 
>> You are right. I'll send a fix.
>
> You mean v2, not a follow up, right? :)

Yes. Sending the v2.

