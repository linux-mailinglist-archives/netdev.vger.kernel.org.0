Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8D674678A1
	for <lists+netdev@lfdr.de>; Fri,  3 Dec 2021 14:41:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381202AbhLCNol (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Dec 2021 08:44:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381200AbhLCNok (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Dec 2021 08:44:40 -0500
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29077C06173E
        for <netdev@vger.kernel.org>; Fri,  3 Dec 2021 05:41:15 -0800 (PST)
Received: by mail-pl1-x632.google.com with SMTP id o14so2133876plg.5
        for <netdev@vger.kernel.org>; Fri, 03 Dec 2021 05:41:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=r0jQ2vqvqVACSZUM62bMvCTz9IltU2IYdpyR5hGXgzs=;
        b=Nh/GGc780YLHvTZw77hscjW+GfnxMIFXLgMiOeDouqxchoNgnwRH38S7p6Urwtjefn
         9mIizU28TNcN8hMuoNa56PCohGHMZbemjUNB0bA3pSrGS2IZq/LKW+nyi7Y4ypkws1b1
         3oXvMOYGMza0QChXjDwk+XeEOgCnq9FuPdnmSwnZK+dAxfhpchEN2Ne5pqj5RYP2qqmV
         KdLZaG4gR1K9EhkbHrYdTmXfq+s9tTW54hTSP7+h+UDaLQO+WjCNT81PctjZvrcozClk
         KwX3iYFO1mg/VCauaIcJfkUEDWqaic7PHR9W8DljC7tL7m2VvIaMpWhwseU7yhrOU7PT
         Tklw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=r0jQ2vqvqVACSZUM62bMvCTz9IltU2IYdpyR5hGXgzs=;
        b=1anEcCYZIbvqDQjip6nhWyWGjwXgnRXEaGxfgsKweuTSHORflfwHRCLlQO9Q2hjMM/
         eULD1QMstTqVM3UQ0DNCMNVhffKVtJsEGHNq8LQZJ3zhZAMy/+PFIgpFT+JQfQOY2QJQ
         fLcweWpaDb2wrhEZ3XGGIelOWdgiHVmKlNsckbDSy9kHywJKLfdiDN3tnGfCRko/+CXN
         aq6vlbcBVmBuXf1Q873jvDWEzzLeEPun/Dqr6ZgdsbQwi3RFMQbcpoc4G0PQHM4d7nSb
         4gQ25bUtWp+KSVH6HMRDYlKl7WPS/mbS9W1511uu/bgWbqSRvtSe9jQ6/WHgmE8vRlvc
         7yYA==
X-Gm-Message-State: AOAM533d+EuBLN6hW5t1l5pzb4TOXPCp5ScNr4DYG9qgGSOp9TFDfv7C
        v3EJ6iCB7tiIC/E19xIsXoQnKzx2/2Y=
X-Google-Smtp-Source: ABdhPJwFJrYkNrWegPLJQP/FO4WoHC+0HETbF9q+9yTgXPnVeRjtS37DFsK1SNPHiTa26KnRe9pkIQ==
X-Received: by 2002:a17:90b:4b86:: with SMTP id lr6mr13991556pjb.98.1638538874701;
        Fri, 03 Dec 2021 05:41:14 -0800 (PST)
Received: from Laptop-X1 ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id qe12sm5607269pjb.29.2021.12.03.05.41.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Dec 2021 05:41:14 -0800 (PST)
Date:   Fri, 3 Dec 2021 21:41:09 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     Peilin Ye <yepeilin.cs@gmail.com>
Cc:     peilin.ye@bytedance.com, xiyou.wangcong@gmail.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH net v3] selftests/fib_tests: Rework fib_rp_filter_test()
Message-ID: <YaoedfKGfQ500Vzs@Laptop-X1>
References: <20211201004720.6357-1-yepeilin.cs@gmail.com>
 <163849740916.2738.7046909132205232442.git-patchwork-notify@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <163849740916.2738.7046909132205232442.git-patchwork-notify@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 03, 2021 at 02:10:09AM +0000, patchwork-bot+netdevbpf@kernel.org wrote:
> Hello:
> 
> This patch was applied to netdev/net.git (master)
> by Jakub Kicinski <kuba@kernel.org>:
> 
> On Tue, 30 Nov 2021 16:47:20 -0800 you wrote:
> > From: Peilin Ye <peilin.ye@bytedance.com>
> > 
> > Currently rp_filter tests in fib_tests.sh:fib_rp_filter_test() are
> > failing.  ping sockets are bound to dummy1 using the "-I" option
> > (SO_BINDTODEVICE), but socket lookup is failing when receiving ping
> > replies, since the routing table thinks they belong to dummy0.
> > 
> > [...]
> 
> Here is the summary with links:
>   - [net,v3] selftests/fib_tests: Rework fib_rp_filter_test()
>     https://git.kernel.org/netdev/net/c/f6071e5e3961
> 
> You are awesome, thank you!

Thanks Peilin for your fixup.

Cheers
Hangbin
