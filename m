Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF37550FDBA
	for <lists+netdev@lfdr.de>; Tue, 26 Apr 2022 14:53:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350235AbiDZM41 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Apr 2022 08:56:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350232AbiDZM4V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Apr 2022 08:56:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D51BE17CEBD;
        Tue, 26 Apr 2022 05:53:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 710E161939;
        Tue, 26 Apr 2022 12:53:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACE59C385AA;
        Tue, 26 Apr 2022 12:53:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650977592;
        bh=kFT9Cma09SNXoBJOeqOUQlH9X2Muy6XZAjh/1E2YLtU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=mTC2qkJUSHFOYIueOWbwO0GZrOnCjbQh9ylat2e15zp/Qb0pmOaN1+Lqg/v18cVuX
         m9yPt50jygBPC/eBrhTQeyDGpyhPZ/zyU8RO5L8uQeehQjQMSeylYXw6sQ/Im1KXuO
         w8nFnKfTPa3xBBp0dRDGL28CL0SnBWLYzI2BJ5ZyaFc/5rcf+HXwKFbeFcCWBMI2Rz
         +zSYnpJGSOxMcDaZWOE30y8vv7CywA/A3HUXdfrTRJEM4yaHMemfRUgoOjmYOrRLeD
         7r+WGpGwl/K255KKdK9PAdJjgAnlKGXZvC6tN5bj9ZQgv4u3IfTBw2Dy0sigcStu5r
         W/s/XqTx2Zl6w==
Date:   Tue, 26 Apr 2022 05:53:11 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Helge Deller <deller@gmx.de>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        linux-parisc@vger.kernel.org
Subject: Re: [PATCH net-next] net: mark tulip obsolete
Message-ID: <20220426055311.53dd8c31@kernel.org>
In-Reply-To: <a66551f3-192a-70dc-4eb9-62090dbfe5fb@gmx.de>
References: <20220315184342.1064038-1-kuba@kernel.org>
        <29f1daf3-e9f2-bbc5-f5e5-6334c040e3fa@gmx.de>
        <20220315120432.2a72810d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <a66551f3-192a-70dc-4eb9-62090dbfe5fb@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 15 Mar 2022 23:18:38 +0100 Helge Deller wrote:
> On 3/15/22 20:04, Jakub Kicinski wrote:
> > On Tue, 15 Mar 2022 19:44:24 +0100 Helge Deller wrote:  
> >> On 3/15/22 19:43, Jakub Kicinski wrote:  
> >>> It's ancient, an likely completely unused at this point.
> >>> Let's mark it obsolete to prevent refactoring.  
> >>
> >> NAK.
> >>
> >> This driver is needed by nearly all PA-RISC machines.  
> >
> > I was just trying to steer newcomers to code that's more relevant today.  
> 
> That intention is ok, but "obsolete" means it's not used any more,
> and that's not true.

Hi Helge! Which incarnation of tulip do you need for PA-RISC, exactly?
I'd like to try to remove DE4X5, if that's not the one you need
(getting rid of virt_to_bus()-using drivers).
