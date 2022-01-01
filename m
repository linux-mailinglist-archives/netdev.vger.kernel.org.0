Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7817B48264D
	for <lists+netdev@lfdr.de>; Sat,  1 Jan 2022 03:22:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231933AbiAACRO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Dec 2021 21:17:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231229AbiAACRO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Dec 2021 21:17:14 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8352C061574;
        Fri, 31 Dec 2021 18:17:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 1FF67CE1D92;
        Sat,  1 Jan 2022 02:17:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F7A3C36AEC;
        Sat,  1 Jan 2022 02:17:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641003430;
        bh=zNgktqMSEm4Spnftwe0PgXFUZSas22WRXgFRIC+HVWA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=aIVQiieZHF5LcrBSb9TJq4vxpWGEt3s7FbuoNTTsEcjAJ5nXCsrVYaa10DHGRLu6z
         6jwF1Pg6xLZ4DQTZDQ+ule62sbC96Vtp36h8VDkyHAmZiULy6Uk1lXKLkol79P9d0+
         PnOdyi6pM+Ftps1Mo84MzpQ6AmjQoBGnCyLY5ernB2wqvFFonV4igqxGkrNSy1djTw
         ZTce8iaSULh+WtfZN6ub/j5zbKLpuRAZPuslXj4s7TRpTMtqm/sr84/tXS38GgtggQ
         q02DLY5l8k2ZWILBZ7D9EP0Xqmts7xGxwqu7cmUVdVBjNte3KWxbpLB8Vm8yNwB9nZ
         JoKZGPdMNpPEA==
Date:   Fri, 31 Dec 2021 18:17:09 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Gagan Kumar <gagan1kumar.cs@gmail.com>
Cc:     Jeremy Kerr <jk@codeconstruct.com.au>, matt@codeconstruct.com.au,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mctp: Remove only static neighbour on RTM_DELNEIGH
Message-ID: <20211231181709.7f46dbfc@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <65c90674808fc0a93c7d329067bf3e80736a003a.camel@gmail.com>
References: <20211228130956.8553-1-gagan1kumar.cs@gmail.com>
        <20211230175112.7daeb74e@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
        <e20e47833649b5141fa327aa8113e34d4b1bbe15.camel@codeconstruct.com.au>
        <65c90674808fc0a93c7d329067bf3e80736a003a.camel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 31 Dec 2021 17:44:15 +0530 Gagan Kumar wrote:
> > > Can you clarify the motivation and practical impact of the change 
> > > in the commit message to make it clear? AFAICT this is a no-op / prep
> > > for some later changes, right Jeremy?  
> > 
> > Yes, it'll be a no-op now; I'm not aware of any changes coming that
> > require parameterisation of the neighbour type yet.
> > 
> > Gagan - can you provide any context on this change?  
> 
> I was exploring the repository and wanted to get familiar with the
> patching process. During that, I was looking for some TODOs in /net for
> my first patch and came across mctp.
> 
> I thought `TODO: add a "source" flag so netlink can only delete static
> neighbours?` might be of some use in the future. So, thought of sending
> a patch for the same.
> 
> If I were to think like a critic, "You aren't gonna need it" principle
> can be applied here.
> 
> If you think it's ok to proceed I can update the commit message to
> include the motivation and impact as a no-op.

SGTM
