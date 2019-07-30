Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 93F8C7B376
	for <lists+netdev@lfdr.de>; Tue, 30 Jul 2019 21:42:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726345AbfG3Tmg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jul 2019 15:42:36 -0400
Received: from mail-qk1-f170.google.com ([209.85.222.170]:42265 "EHLO
        mail-qk1-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725911AbfG3Tmf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jul 2019 15:42:35 -0400
Received: by mail-qk1-f170.google.com with SMTP id 201so47439247qkm.9;
        Tue, 30 Jul 2019 12:42:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=GlRRaTMsJuKfbqzAj8h8sadYDrRCBxht4b8RcEpyhqM=;
        b=EMiQ+/iLjl9ib6+JYa7oXZviwkUH00nOg8QPjN7+X5pr5dUeEmHA6LZk9Q59MYlHC5
         ScVCQ5nL9BhOHo2zIivywYUgob7ejgQxbuoH2j8SjEFR7twl87/pYD6LFmE8rgFAqp1x
         L0qO8OIy2Cr65x9IFduFslzBCq+PvMLrqRhMvGO9fQZ5ArYvgVcp/MhTqX0Dqa4HFv9B
         rYWhT6i6nUQLWayZENFJBYDgHh63fs/DK/D+D1koJnp8/GyDt/JcvC3fbMNY59MRJEy2
         k8XHLBTBctnSwudrOu/tFRDhU2nqFO10e2R0cO+4qvqh91NQesHy6jvav1rnIYbKrDKY
         q1LQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=GlRRaTMsJuKfbqzAj8h8sadYDrRCBxht4b8RcEpyhqM=;
        b=NhOyGV0aLygy4z8Aa0MPvE6//nB8hvSJeRUBIHSjRyGIO4rx7efL7rOKKXiUE2defK
         mTEWJnslLRnNphNYsTUtnhjkMqsHf5mfeLhAbaqlVCbonFUBw00pZwS32HUHqDxkZZ+b
         e1TS8EpnQWLWIRegGuRR+5wxORA0MI0J/L5iGl1DzkAKrfqB+yl+PFzBUTGjCmkv59Dx
         BXEwmGMtQgO6V7ChTgg/iBSy4+FVNXnzc982hcsas6v2g7ggxhvj/2rZDZrBmgRZiQWh
         Dph17Da0JrasUXDgul7b9JAADoj7QZ60z2cQyfhH1QswJlYMcO1l5mIohMbaZJ68DdDx
         sl6g==
X-Gm-Message-State: APjAAAV2Il0mrOovhqBqmPFnSZS8/GVBAsG9qvn58gAVVE/d+tjbrDRi
        xIFLMhnBZtvXHo/n2ctqEqs=
X-Google-Smtp-Source: APXvYqwWCqkHDLE8lTPw0V3nufR9nhHvpiEivqKvjN8KQD6PUj/9wRZR7UYIncDSzfvpOt/RiXxkzQ==
X-Received: by 2002:a37:72c5:: with SMTP id n188mr70115902qkc.181.1564515754677;
        Tue, 30 Jul 2019 12:42:34 -0700 (PDT)
Received: from localhost.localdomain ([177.220.172.104])
        by smtp.gmail.com with ESMTPSA id e125sm26916206qkd.120.2019.07.30.12.42.33
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 30 Jul 2019 12:42:34 -0700 (PDT)
Received: by localhost.localdomain (Postfix, from userid 1000)
        id B052AC18C6; Tue, 30 Jul 2019 16:42:31 -0300 (-03)
Date:   Tue, 30 Jul 2019 16:42:31 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     Xin Long <lucien.xin@gmail.com>
Cc:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org,
        Neil Horman <nhorman@tuxdriver.com>, davem@davemloft.net
Subject: Re: [PATCHv2 net-next 0/5] sctp: clean up __sctp_connect function
Message-ID: <20190730194231.GE4064@localhost.localdomain>
References: <cover.1564490276.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1564490276.git.lucien.xin@gmail.com>
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 30, 2019 at 08:38:18PM +0800, Xin Long wrote:
> This patchset is to factor out some common code for
> sctp_sendmsg_new_asoc() and __sctp_connect() into 2
> new functioins.
> 
> v1->v2:
>   - add the patch 1/5 to avoid a slab-out-of-bounds warning.
>   - add some code comment for the check change in patch 2/5.
>   - remove unused 'addrcnt' as Marcelo noticed in patch 3/5.
> 
> Xin Long (5):
>   sctp: only copy the available addr data in sctp_transport_init
>   sctp: check addr_size with sa_family_t size in
>     __sctp_setsockopt_connectx
>   sctp: clean up __sctp_connect
>   sctp: factor out sctp_connect_new_asoc
>   sctp: factor out sctp_connect_add_peer

Series,
Acked-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
