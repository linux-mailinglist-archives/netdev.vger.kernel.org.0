Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D13CF3F55AF
	for <lists+netdev@lfdr.de>; Tue, 24 Aug 2021 04:12:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233646AbhHXCNV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Aug 2021 22:13:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229742AbhHXCNU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Aug 2021 22:13:20 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12D3AC061575;
        Mon, 23 Aug 2021 19:12:37 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id m4so274553pll.0;
        Mon, 23 Aug 2021 19:12:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=9hhYYTbT3GW5pW1R3ZHq9iZjz0TiEaoLKl1yLWy2+Xo=;
        b=nMmeTwoGo3pqgObwhkDwgmjDN1ubvxGMFdAfndxMHvETp9ThIcSEXtLsrP+elAA61F
         j7aGq3mONeZqtmdRTy6qLOZYcmv7MJj7ji+66Vm7JO4xxo9J84cfIoTyTQReZIwBHUH9
         +AehdWx1792OVACEn0p+asO3od6JV36tZD4Mi7JGGib4a/jp66eelnwiqU7sxmcahAnt
         w39WEczHu+A28DkMPk9aF8fUNcBleo/u16a+kUezGvvsZnwF5rFM5pQmCD2tW6CFXh9X
         db2ZzPj6A0l2nxxECdXsjDAh2gdFFWFcATQWgUvqpYAyRqENGTANtRhvEfaL6+zRB2Bm
         N0GQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=9hhYYTbT3GW5pW1R3ZHq9iZjz0TiEaoLKl1yLWy2+Xo=;
        b=M1Oa5D/pyMeEo8+jjmuiHdSvDYfqmKuPbIvzWJpeUaCWn2jNPG/c/rpC9ubpHgKcvr
         IWmpeZRfO9zoXFMgPyqq/0gmf5tVH/EpXt4dNFr+nSrQ8m9oIynVwCwEIVdrDh/+5FlY
         QqkiTLfF3ikdgwbvVCaNaB1fgNkzHqOvo3AcfldaqC4leZa0UE9nH2aX1VzzvsDUnEgf
         XBjOnSj/WNU2rtmkjv1NAO3iqmzmMIfJdL0S9Th8fK+TO0h/0R7NnNGqYp6QmqYSeoZS
         LEyd/ZY2mZM9sLsCKqLVlYbUBv2gUc1XkV0C+vJ2kpL4BBRzFhGDq0Sac9JIEAzMekwJ
         3wPw==
X-Gm-Message-State: AOAM531Da6EKI8ZE4xt9vwU1YrFZFEwFPge6hIlY2hmOJ+8PjysPCNPG
        SwLzlclQt+51Zn8UyJet2QhDv05TKCbpTw==
X-Google-Smtp-Source: ABdhPJyB8X+vGD0I6XUHw7EF94swmrHyvX6Ml45fe88LuLNMuaA/BWGdAaorE2myBndfywPuYFFYpg==
X-Received: by 2002:a17:902:7282:b029:12c:75a0:faa5 with SMTP id d2-20020a1709027282b029012c75a0faa5mr31400496pll.35.1629771156465;
        Mon, 23 Aug 2021 19:12:36 -0700 (PDT)
Received: from fedora ([2405:201:6008:6ce2:9fb0:9db:90a4:39e2])
        by smtp.gmail.com with ESMTPSA id g13sm17255529pfo.53.2021.08.23.19.12.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Aug 2021 19:12:35 -0700 (PDT)
Date:   Tue, 24 Aug 2021 07:42:31 +0530
From:   Shreyansh Chouhan <chouhan.shreyansh630@gmail.com>
To:     Stephen Rothwell <sfr@canb.auug.org.au>
Cc:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: Re: linux-next: Fixes tag needs some work in the net tree
Message-ID: <YSRVj0gwlp91UAiF@fedora>
References: <20210823075432.2069fb0b@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210823075432.2069fb0b@canb.auug.org.au>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Stephen,

Apologies for the wrong fixes tag.

Since the patch is already in the tree, (and since this is the first
time I am facing this,) I wanted to ask if I should resend the patch
with the correct fixes tag to fix this.

Thank you for your review.

Regards,
Shreyansh Chouhan

On Mon, Aug 23, 2021 at 07:54:32AM +1000, Stephen Rothwell wrote:
> Hi all,
> 
> In commit
> 
>   9cf448c200ba ("ip6_gre: add validation for csum_start")
> 
> Fixes tag
> 
>   Fixes: Fixes: b05229f44228 ("gre6: Cleanup GREv6 transmit path, call common
> 
> has these problem(s):
> 
>   - Extra word "Fixes:"
> 
> Also, please do not split Fixes tags over more than one line.
> 
> -- 
> Cheers,
> Stephen Rothwell
