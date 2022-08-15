Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 324FF593215
	for <lists+netdev@lfdr.de>; Mon, 15 Aug 2022 17:38:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229682AbiHOPiT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Aug 2022 11:38:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231895AbiHOPh4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Aug 2022 11:37:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0537167DC;
        Mon, 15 Aug 2022 08:37:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4CF0F610AA;
        Mon, 15 Aug 2022 15:37:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6965DC433C1;
        Mon, 15 Aug 2022 15:37:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660577874;
        bh=0eWiUukTFCZQ2yDCkxyUGU5tuyCXQ85/HX67PS6Cs1w=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=NOxBlplvHmBk0wmqgk/JAe3+UBZUHSUH5s/wl4Dr/KcTqJqD5HjzYrjF2D8RIsg/I
         /QSWRNtNj5BSZjlWXmOsXXGV46+P9KuJ8JKVkeAhRi+IWsx7dml6N6vPJlzLDuXTIe
         2C6C1+rR+hq8HZ/maCOAEJ75WrW3MrIoBXZyl1LnUi1oxDbEwdejTfZqIS69bpBQ5n
         MzLh6c1P/RWYbX7tvpEzj+YT75LMefAuWeFtCcSFuqEkOie5eo1lT3xLXo9G41WBXh
         h0SF7P8Q0nlFAuD7Fm+XMCbwZcP1xI+zAcng/pmDez8RH7CCt1KeOL68ALs4uPEA71
         ACclxWkxC7MRA==
Date:   Mon, 15 Aug 2022 08:37:53 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
Cc:     Pavel Begunkov <asml.silence@gmail.com>,
        stable-commits@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: Patch "skbuff: don't mix ubuf_info from different sources" has
 been added to the 5.19-stable tree
Message-ID: <20220815083753.6b5da2a4@kernel.org>
In-Reply-To: <4c748c4f-e3a6-8325-fa34-ad6f056830b9@gmail.com>
References: <20220813202956.1906854-1-sashal@kernel.org>
        <4c748c4f-e3a6-8325-fa34-ad6f056830b9@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 15 Aug 2022 13:30:26 +0100 Pavel Begunkov wrote:
> On 8/13/22 21:29, Sasha Levin wrote:
> > This is a note to let you know that I've just added the patch titled
> > 
> >      skbuff: don't mix ubuf_info from different sources
> > 
> > to the 5.19-stable tree which can be found at:
> >      http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary
> > 
> > The filename of the patch is:
> >       skbuff-don-t-mix-ubuf_info-from-different-sources.patch
> > and it can be found in the queue-5.19 subdirectory.
> > 
> > If you, or anyone else, feels it should not be added to the stable tree,
> > please let <stable@vger.kernel.org> know about it.  
> 
> It doesn't hurt but we don't need it in 5.19, added only because of
> 5.20 io_uring zerocopy send work.

Concerning, I already said this doesn't need to be backported,
something's not working here, Sasha...

https://lore.kernel.org/r/20220808114451.78686a5b@kernel.org/
