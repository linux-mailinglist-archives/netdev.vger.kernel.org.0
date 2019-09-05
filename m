Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D07D3A98E7
	for <lists+netdev@lfdr.de>; Thu,  5 Sep 2019 05:37:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729907AbfIEDhW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Sep 2019 23:37:22 -0400
Received: from mail-pf1-f178.google.com ([209.85.210.178]:36735 "EHLO
        mail-pf1-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726240AbfIEDhW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Sep 2019 23:37:22 -0400
Received: by mail-pf1-f178.google.com with SMTP id y22so802099pfr.3
        for <netdev@vger.kernel.org>; Wed, 04 Sep 2019 20:37:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=UMP/S2fCberFyG7WUfO4nV2dQ7qbF+SuAvDENBNoKNI=;
        b=EGs34kWpT03Zsuc4XSokotaRGPtwpQibk43T9mJVeLNDoSiKnrifVp+Th9bRssLLcv
         LMXY+AGA16JIVk5NxUSQFjge/KKqrtuJuTFZr5nvdzVsY1m/gwzEEe12e3fWyOwTUZd4
         pL2qQwxV+5XB85XPEXDTaXSm0waN4HqPXfhEN8rayhDeMccIlTsqKVbofRPmY+2AZqcd
         7UdBXF+Tv1+rgbWNG82XyujfoxSLm5tKQGCuPuna3AjTGHU+x5b3T+sk+sDsPXNYJU4s
         oVUQKqlVg8ZHD5pqAG1J+rbj2el0TldPW5B0N9Khe9aniREDrwOseUVYecgSbGM1GkWB
         p2lw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=UMP/S2fCberFyG7WUfO4nV2dQ7qbF+SuAvDENBNoKNI=;
        b=rgEvh3gG4E8fKTe0ZbSuqfo2lDoNpDVuA0rcxZ+5LM1i8l2+C0BDSNZg1mes/jl5sz
         UM4+Hl2/ncEx9zi5XHUz6vNxQ+2pqwtwhJv5yat4T3Q4ToHoTFvWYVrzMs8MiecmN84e
         Ao08Cn4gv2ZUWbQLVwNyG3/G/hcl9boUtD2o1ayA3FGtSgPEQtewln1gpp38Bu66QBh4
         JrmjJyER8ujOby5cdVmBi0oAtuxN1+ZN/GZXbkYEYHxSRn0TgkfhoifivQUN/vq6iSv3
         tiGH9/bbK3HaukgXdXNencXRTanRl2EwXm2lrRqBaKU0uhn9Q5DaC0U06AXe7zRWJODy
         hvKA==
X-Gm-Message-State: APjAAAWZNR6Nx9Q4Sf1wJKTWnA1VbsG6Nvn7xtQ4VaOlaTHXR6A2GZy8
        b66GFA2NORHlHpMKG+2SVoQ=
X-Google-Smtp-Source: APXvYqzQQvKSugyR6iYrE9m2J/8M6ZtRzOaY1qpDYGj/qXt7uS17XOAKXKjIqhOd0kOs3w8B1Zj0ng==
X-Received: by 2002:aa7:91d7:: with SMTP id z23mr1185755pfa.262.1567654641519;
        Wed, 04 Sep 2019 20:37:21 -0700 (PDT)
Received: from dhcp-12-139.nay.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id k36sm494708pgl.42.2019.09.04.20.37.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Sep 2019 20:37:20 -0700 (PDT)
Date:   Thu, 5 Sep 2019 11:37:10 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     netdev@vger.kernel.org, Phil Karn <karn@ka9q.net>,
        Sukumar Gopalakrishnan <sukumarg1973@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
Subject: Re: [PATCHv2 net-next] ipmr: remove cache_resolve_queue_len
Message-ID: <20190905033710.GI18865@dhcp-12-139.nay.redhat.com>
References: <20190903084359.13310-1-liuhangbin@gmail.com>
 <20190904033408.13988-1-liuhangbin@gmail.com>
 <aa759647-953e-23b5-32e2-b0b7373e07e4@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aa759647-953e-23b5-32e2-b0b7373e07e4@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 04, 2019 at 09:50:15AM +0200, Eric Dumazet wrote:
> > +static int queue_count(struct mr_table *mrt)
> > +{
> > +	struct list_head *pos;
> > +	int count = 0;
> > +
> > +	spin_lock_bh(&mfc_unres_lock);
> > +	list_for_each(pos, &mrt->mfc_unres_queue)
> > +		count++;
> > +	spin_unlock_bh(&mfc_unres_lock);
> > +
> > +	return count;
> > +}
> 
> I guess that even if we remove a limit on the number of items, we probably should
> keep the atomic counter (no code churn, patch much easier to review...)
> 
> Your patch could be a one liner really [1]
> 
> Eventually replacing this linear list with an RB-tree, so that we can be on the safe side.
> 
> [1]
> diff --git a/net/ipv4/ipmr.c b/net/ipv4/ipmr.c
> index c07bc82cbbe96d53d05c1665b2f03faa055f1084..313470f6bb148326b4afbc00d265b6a1e40d93bd 100644
> --- a/net/ipv4/ipmr.c
> +++ b/net/ipv4/ipmr.c
> @@ -1134,8 +1134,8 @@ static int ipmr_cache_unresolved(struct mr_table *mrt, vifi_t vifi,
>  
>         if (!found) {
>                 /* Create a new entry if allowable */
> -               if (atomic_read(&mrt->cache_resolve_queue_len) >= 10 ||
> -                   (c = ipmr_cache_alloc_unres()) == NULL) {
> +               c = ipmr_cache_alloc_unres();
> +               if (!c) {
>                         spin_unlock_bh(&mfc_unres_lock);
>  
>                         kfree_skb(skb);

hmm, that looks more clear and easy to review..

Hi David, Alexey,

What do you think? If you also agree, I could post a new version patch.

Thanks
Hangbin
