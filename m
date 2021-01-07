Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D699A2ED5F0
	for <lists+netdev@lfdr.de>; Thu,  7 Jan 2021 18:46:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729017AbhAGRq0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jan 2021 12:46:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728843AbhAGRqZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jan 2021 12:46:25 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65490C0612F5
        for <netdev@vger.kernel.org>; Thu,  7 Jan 2021 09:45:45 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1kxZLu-00049G-Hx; Thu, 07 Jan 2021 18:45:38 +0100
Date:   Thu, 7 Jan 2021 18:45:38 +0100
From:   Florian Westphal <fw@strlen.de>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     lll <liyonglong@chinatelecom.cn>,
        Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org,
        davem@davemloft.net, fw@strlen.de, soheil@google.com,
        ncardwell@google.com, ycheng@google.com
Subject: Re: [PATCH] tcp: remove obsolete paramter sysctl_tcp_low_latency
Message-ID: <20210107174538.GA19605@breakpoint.cc>
References: <1608271876-120934-1-git-send-email-liyonglong@chinatelecom.cn>
 <20201218164647.1bcc6cb9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <b3cb1c57-d992-72c1-dd24-5d594ff38561@chinatelecom.cn>
 <20210107090635.440b1fc6@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210107090635.440b1fc6@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub Kicinski <kuba@kernel.org> wrote:
> > Got it. But a question: why tcp_tw_recycle can be removed totally?
> > it is also part of uAPI
> 
> Good question, perhaps with tcp_tw_recycle we wanted to make sure users
> who depended on it notice removal, since the feature was broken by
> design? 
> 
> tcp_low_latency is an optimization, not functionality which users may
> depend on.
> 
> But I may be wrong so CCing authors.

I guess it was just a case of 'noone noticed'.
I'm not sure if anyone would notice dropping lowlatency sysctl, was just
a case of 'overly careful'.  Personally I'd rather have them gone so
'sysctl tcp.bla' shows if the feature exists/does something.
