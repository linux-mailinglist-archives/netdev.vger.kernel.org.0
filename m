Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A20CC396100
	for <lists+netdev@lfdr.de>; Mon, 31 May 2021 16:33:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232260AbhEaOeA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 May 2021 10:34:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233570AbhEaObh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 May 2021 10:31:37 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B9D3C08EA47
        for <netdev@vger.kernel.org>; Mon, 31 May 2021 06:49:23 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id ot16so6641199pjb.3
        for <netdev@vger.kernel.org>; Mon, 31 May 2021 06:49:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=YRpNxFEhPJ2P90LNnNpLditOXew4ld29b752FXayL+k=;
        b=jr19jdrP4LgMLIjqKn5ChCXpqAl8bYUgYIfLCd6jNYIw0tIv1GB15tE7DLia/Ux4Mm
         xYBsEf11UccKRhf5bqVwSGPU8Nug6imaArEEN437x1X7XTOcwE/vWO+T+21VP5mBvH0G
         iXUNhAywf5ijvgGrdWb8CnLGuFzAG7TBF0LlKld1+lsRcwXoTs0sFhYe3HVC1nG6lGK4
         EBaHeCr9stnxRl6SCbomdP/5dCJxIiMuggidbe6D9b1onbuPqlqkCju0Ez/+gpeUlkRl
         V4rxv6JBWp8FTTTeqHG+sUWuMsJEWPwRV/C2lqakKzAe+cGIHvdeazrTI+f/83xwkT11
         4rag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=YRpNxFEhPJ2P90LNnNpLditOXew4ld29b752FXayL+k=;
        b=KWq8qV4mmYxsQR7ba/hAy0Z5OzGR32c0G66qGojndoQ7fjtudvhaQGH6DM8fD+zK0/
         nFW4ozfMevuf9eGyMzDtB0vVR8GjVqSSe2vQurTrB+Tm2FnzL4vSiNMOZ4Y9Zg7chfBs
         GnOaHvMimJv6Ra3Jg00uNgmXiSEFnLkN/7rPQW0GDmiyNHUvbQ9jR+ahgYlu1OZ23P2g
         C7zYWBSLLBJy3U2r1CKh+kxIEx/l//KdGfk4bvZH7NoFpOLmAzwWkkioTKAgsExycg5d
         8RJ3yYaidJMWmqadjqFfZxVnQpbymyR/Sg1qL4DZ+Entd0JcZ/OBOGvuEwVaJiYs5Sbh
         znrg==
X-Gm-Message-State: AOAM530xtoeYyiqBrMjHwUaNwR9PILK3nym4fvsxuRjyJGDa8ZnxdgVQ
        zwE5ijcLAqpgfhD3kgpt9HM=
X-Google-Smtp-Source: ABdhPJwFw9+UpZCrnYiG5Fk8MEB/9kr/aOUPEANPxCtZdw/Nzanm5yeGfBJ2XwdJ3fucNbcVDeoVPg==
X-Received: by 2002:a17:90a:288:: with SMTP id w8mr19555942pja.111.1622468962705;
        Mon, 31 May 2021 06:49:22 -0700 (PDT)
Received: from hoboy.vegasvil.org ([2601:645:c000:35:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id c1sm10825925pfo.181.2021.05.31.06.49.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 May 2021 06:49:22 -0700 (PDT)
Date:   Mon, 31 May 2021 06:49:19 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     "Y.b. Lu" <yangbo.lu@nxp.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [net-next, v2, 7/7] enetc: support PTP domain timestamp
 conversion
Message-ID: <20210531134919.GA7888@hoboy.vegasvil.org>
References: <20210521043619.44694-1-yangbo.lu@nxp.com>
 <20210521043619.44694-8-yangbo.lu@nxp.com>
 <20210525123711.GB27498@hoboy.vegasvil.org>
 <20210525124848.GC27498@hoboy.vegasvil.org>
 <DB7PR04MB5017E8CEA0DA148A4EB1EAF9F83F9@DB7PR04MB5017.eurprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DB7PR04MB5017E8CEA0DA148A4EB1EAF9F83F9@DB7PR04MB5017.eurprd04.prod.outlook.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 31, 2021 at 11:26:18AM +0000, Y.b. Lu wrote:
> So, the timestamp conversion could be in skbuff.c.
> That's good to do this. But there are quite a lot of drivers using timestamping.
> Should we convert all drivers to use the helper, or let others do this when they need?

I think we should convert them all.  Yes, it is work, but I will help.
I really like the vclock idea, especially because it will work with
every clock.  Also, adding the helper will be a nice refactoring all
by itself.

Thanks,
Richard
