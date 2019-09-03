Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 47A23A69A3
	for <lists+netdev@lfdr.de>; Tue,  3 Sep 2019 15:22:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729090AbfICNWi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Sep 2019 09:22:38 -0400
Received: from mx2.suse.de ([195.135.220.15]:60424 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728538AbfICNWi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Sep 2019 09:22:38 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 49677B11B;
        Tue,  3 Sep 2019 13:22:37 +0000 (UTC)
Date:   Tue, 3 Sep 2019 15:22:31 +0200
From:   Michal Hocko <mhocko@kernel.org>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     Qian Cai <cai@lca.pw>, davem@davemloft.net, netdev@vger.kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net/skbuff: silence warnings under memory pressure
Message-ID: <20190903132231.GC18939@dhcp22.suse.cz>
References: <1567177025-11016-1-git-send-email-cai@lca.pw>
 <6109dab4-4061-8fee-96ac-320adf94e130@gmail.com>
 <1567178728.5576.32.camel@lca.pw>
 <229ebc3b-1c7e-474f-36f9-0fa603b889fb@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <229ebc3b-1c7e-474f-36f9-0fa603b889fb@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri 30-08-19 18:15:22, Eric Dumazet wrote:
> If there is a risk of flooding the syslog, we should fix this generically
> in mm layer, not adding hundred of __GFP_NOWARN all over the places.

We do already ratelimit in warn_alloc. If it isn't sufficient then we
can think of a different parameters. Or maybe it is the ratelimiting
which doesn't work here. Hard to tell and something to explore.

-- 
Michal Hocko
SUSE Labs
