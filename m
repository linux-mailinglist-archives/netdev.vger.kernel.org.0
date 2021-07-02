Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A76053BA25E
	for <lists+netdev@lfdr.de>; Fri,  2 Jul 2021 16:50:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232665AbhGBOxQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Jul 2021 10:53:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231474AbhGBOxP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Jul 2021 10:53:15 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39F4FC061762
        for <netdev@vger.kernel.org>; Fri,  2 Jul 2021 07:50:43 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1lzKV1-0004qt-8J; Fri, 02 Jul 2021 16:50:35 +0200
Date:   Fri, 2 Jul 2021 16:50:35 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        John Sperbeck <jsperbeck@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Florian Westphal <fw@strlen.de>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: Re: [PATCH net] sock: fix error in sock_setsockopt()
Message-ID: <20210702145035.GF18022@breakpoint.cc>
References: <20210702144101.3815601-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210702144101.3815601-1-eric.dumazet@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Eric Dumazet <eric.dumazet@gmail.com> wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> Some tests are failing, John bisected the issue to a recent commit.
> 
> sock_set_timestamp() parameters should be :
> 
> 1) sk
> 2) optname
> 3) valbool

Oh, right!

Thanks for fixing this.

Reviewed-by: Florian Westphal <fw@strlen.de>
