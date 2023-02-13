Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA756693EE9
	for <lists+netdev@lfdr.de>; Mon, 13 Feb 2023 08:25:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229747AbjBMHZm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Feb 2023 02:25:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229532AbjBMHZl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Feb 2023 02:25:41 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F4AC10A80;
        Sun, 12 Feb 2023 23:25:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0E1CDB80C99;
        Mon, 13 Feb 2023 07:25:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AA15C433EF;
        Mon, 13 Feb 2023 07:25:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676273137;
        bh=jwIJ3njli56AjDHSVUClQZiIJljCv+5G23KjPML97EI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=S9aXQDJ39x2n5ScFWsC86/o8nrznQFRu/iVI78Pd3j4MYpLPazDbP747lvi6O9Icw
         NdiTL95hqNSAr7ConwBuVbgPwiSn8AJhKjT9zZz8qfKoZfgkJ30qdVTOAvU4YHlX6G
         lYJhz0zVL9+QVRzUPgwI57RThI33ItM9Z4hYiVRY=
Date:   Mon, 13 Feb 2023 08:25:34 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Willy Tarreau <w@1wt.eu>
Cc:     Winter <winter@winter.cafe>, stable@vger.kernel.org,
        regressions@lists.linux.dev, netdev@vger.kernel.org
Subject: Re: [REGRESSION] 5.15.88 and onwards no longer return EADDRINUSE
 from bind
Message-ID: <Y+nl7nzQ3GPxlztq@kroah.com>
References: <EF8A45D0-768A-4CD5-9A8A-0FA6E610ABF7@winter.cafe>
 <Y+m8F7Q95al39ctV@1wt.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y+m8F7Q95al39ctV@1wt.eu>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 13, 2023 at 05:27:03AM +0100, Willy Tarreau wrote:
> Hi,
> 
> [CCed netdev]
> 
> On Sun, Feb 12, 2023 at 10:38:40PM -0500, Winter wrote:
> > Hi all,
> > 
> > I'm facing the same issue as
> > https://lore.kernel.org/stable/CAFsF8vL4CGFzWMb38_XviiEgxoKX0GYup=JiUFXUOmagdk9CRg@mail.gmail.com/,
> > but on 5.15. I've bisected it across releases to 5.15.88, and can reproduce
> > on 5.15.93.
> > 
> > However, I cannot seem to find the identified problematic commit in the 5.15
> > branch, so I'm unsure if this is a different issue or not.
> > 
> > There's a few ways to reproduce this issue, but the one I've been using is
> > running libuv's (https://github.com/libuv/libuv) tests, specifically tests
> > 271 and 277.
> 
> >From the linked patch:
> 
>   https://lore.kernel.org/stable/20221228144337.512799851@linuxfoundation.org/

But that commit only ended up in 6.0.y, not 5.15, so how is this an
issue in 5.15.y?

confused,

greg k-h
