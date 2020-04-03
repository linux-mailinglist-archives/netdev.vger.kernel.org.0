Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 631F319CE16
	for <lists+netdev@lfdr.de>; Fri,  3 Apr 2020 03:14:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390218AbgDCBOR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Apr 2020 21:14:17 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:44194 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731783AbgDCBOR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Apr 2020 21:14:17 -0400
Received: by mail-qt1-f194.google.com with SMTP id x16so5186214qts.11
        for <netdev@vger.kernel.org>; Thu, 02 Apr 2020 18:14:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=pq7EIx0kFSLCCakGNAi4q6PNlriz9F5nBUZQ4jByOoM=;
        b=YTXQzkvoLIje9d1ITDrz0rrpkRkH0qWFOp+gne1pOdJnX5edXwSNFREynsDBLSswTX
         D6yWHsMDz55KAm7KwBZeq3d4SpxjnEne5y9pD2qjpvRlauEKVf1jiCN2OUfSSQ7YuYSi
         KWPfqw7jm9FIupi8DzdampXyIrN6YTTL+P4TvQ0WKh/OH8883PUTtfeO9nUXe9pxgJ0b
         k/k/fRVTlrFePiVp+2yAHrJ6JOrAAVkyLOZdymVsDZmzmEODLQ6uNLEX0nX43NY9peM+
         NvzucMwM/E6eg00SGeFcAQXSuIt6YODcCB5pa7S5d4hCOGQ2CbwtK4xs3sex8BmWIXMJ
         tKRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=pq7EIx0kFSLCCakGNAi4q6PNlriz9F5nBUZQ4jByOoM=;
        b=ZmFEPjOLyyugZNCad+CabJ3UuGVzsiV6/jDiSYl59Im1DeUcrfOYxdzDjhw0LjxThC
         he9rWo0NghHg1D16MROSlP8595RWcrzhFdjnW4q1ht/NJrHKU/XGDM9N5Grj87t4hyP0
         f3eU/Fy457TxjFWK2yWOyI90VQ0ZxVVltFTkySssQZZ/HUYgWgvsaT4P3PnECVKwnRp5
         sO+j7EiRYI8g0fJS8zmUYWHbGUZo2MBloCQxwXIjkclEf87rrvGUL87t+ivOqD23GJjV
         qubaUOKnlj1jvtnamLhePMceZPpBSpvomdfTLfeJU6e1NGwQwjBvjB09lXciA/e4MoJo
         m51g==
X-Gm-Message-State: AGi0PubHw4zub99DRaRC+79ESZAx5rux3A0jRBdV4VGThjp/kkrhLVoY
        4+icacQl4btUwt7bvGE7zQ8=
X-Google-Smtp-Source: APiQypJ7ZPbHMA67WPAF3bAen8i1kyusQIGISOr1ClUtNZ1bxBM8OhAJOa5Y+leQtvNiy2PxHMULkA==
X-Received: by 2002:ac8:24e4:: with SMTP id t33mr5987566qtt.107.1585876456036;
        Thu, 02 Apr 2020 18:14:16 -0700 (PDT)
Received: from localhost.localdomain ([2001:1284:f016:e706:e019:95fc:6441:c82])
        by smtp.gmail.com with ESMTPSA id 60sm4935057qtb.95.2020.04.02.18.14.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Apr 2020 18:14:15 -0700 (PDT)
Received: by localhost.localdomain (Postfix, from userid 1000)
        id F1DCAC0EBA; Thu,  2 Apr 2020 22:14:12 -0300 (-03)
Date:   Thu, 2 Apr 2020 22:14:12 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        jiri@resnulli.us
Subject: Re: [PATCH net] net: sched: reduce amount of log messages in
 act_mirred
Message-ID: <20200403011412.GA3629@localhost.localdomain>
References: <a59f92670c72db738d91b639ecc72ef8daf69300.1585866258.git.marcelo.leitner@gmail.com>
 <20200402.180417.804204103829966415.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200402.180417.804204103829966415.davem@davemloft.net>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 02, 2020 at 06:04:17PM -0700, David Miller wrote:
> From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
> Date: Thu,  2 Apr 2020 19:26:12 -0300
> 
> > @@ -245,8 +245,8 @@ static int tcf_mirred_act(struct sk_buff *skb, const struct tc_action *a,
> >  	}
> >  
> >  	if (unlikely(!(dev->flags & IFF_UP))) {
> > -		net_notice_ratelimited("tc mirred to Houston: device %s is down\n",
> > -				       dev->name);
> > +		pr_notice_once("tc mirred: device %s is down\n",
> > +			       dev->name);
> 
> This reduction is too extreme.
> 
> If someone causes this problem, reconfigures everything thinking that the
> problem will be fixed, they won't see this message the second time and
> mistakenly think it's working.

Fair point. Then what about removing it entirely? printk's are not the
best way to debug packet drops anyway and the action already registers
the drops in its stats.

Or perhaps a marker in the message, stating that it is logged only
once per boot. I'm leaning to the one above, to just remove it.
