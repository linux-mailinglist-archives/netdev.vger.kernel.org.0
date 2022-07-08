Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC57E56AFE5
	for <lists+netdev@lfdr.de>; Fri,  8 Jul 2022 03:52:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236366AbiGHBQT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jul 2022 21:16:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229468AbiGHBQS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jul 2022 21:16:18 -0400
Received: from nautica.notk.org (ipv6.notk.org [IPv6:2001:41d0:1:7a93::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3022071BFA
        for <netdev@vger.kernel.org>; Thu,  7 Jul 2022 18:16:17 -0700 (PDT)
Received: by nautica.notk.org (Postfix, from userid 108)
        id C66D3C01A; Fri,  8 Jul 2022 03:16:13 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1657242973; bh=UJjmT92o0tq2NPms9eaGL1i8GJsh7AZ6Ngz2TnmkHGQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=EsmNrWVVRQwEuLZkQMSdORCgOcO8PcxaOOcjQR5D16RqVacJ2fWjmQ63DjgNrE2tl
         n1TBFwO8fSzKDjCka49FHaTS++ttlO+lz6HhU7iZvMfjJEdP9pn8K6khXoyvi0jNof
         FI7uvqThCZChKuqDKdl+I0HQSZCFJVR2ayVRW2jOBDAkkie1U5pb4/2UtY4/1bOeFj
         RrcpL+976oA5rrCF2hqp9GdJOND5r7lpIbwGN0QJO2VsHvxXeJOsoGx6tCzd91QsJk
         /fAjWqN0fIireyeocnn/BFky5m/Zy/Lbd5FiFAHJuu1tv2EE7YLiMuo61WOuTSSsPm
         CBoEphSDiFXeg==
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
Received: from odin.codewreck.org (localhost [127.0.0.1])
        by nautica.notk.org (Postfix) with ESMTPS id E6676C009;
        Fri,  8 Jul 2022 03:16:01 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1657242964; bh=UJjmT92o0tq2NPms9eaGL1i8GJsh7AZ6Ngz2TnmkHGQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ZXcWYi8D3wHR7VxnPPOWByGClt2Wl4ayPoQA627leJWQR5dQEcSueSEV0YLPjNkd2
         Wh0adMyXKF/l9pJHBi+1o6HXaxKDN+ogZEXJKKlsu7kEipbi/ZCU+zCkUdwLB22I0u
         4yyP8BWvMngsViPOvqYTtFuzkLmV1C8RTxFyWbhJaKh/7yHGv5v7eBORIZBALeqzbK
         8amMzLVZggrY1Xpt5Scp0mDvXH63DwBcITC7UrCswcJ4gBLtgIiQlaaabNAEugix8m
         HnNaurfKE4uzi44xlVDS8muBup61WCrIFq4vJFIuG4CDzomkYKl+lVGzsY2pJrW3gd
         vPB1dbrzkQeYQ==
Received: from localhost (odin.codewreck.org [local])
        by odin.codewreck.org (OpenSMTPD) with ESMTPA id 51780399;
        Fri, 8 Jul 2022 01:15:57 +0000 (UTC)
Date:   Fri, 8 Jul 2022 10:15:42 +0900
From:   Dominique Martinet <asmadeus@codewreck.org>
To:     Eric Van Hensbergen <ericvh@gmail.com>
Cc:     Christian Schoenebeck <linux_oss@crudebyte.com>,
        Greg Kurz <groug@kaod.org>,
        Latchesar Ionkov <lucho@ionkov.net>,
        Nikolay Kichukov <nikolay@oldum.net>, netdev@vger.kernel.org,
        v9fs-developer@lists.sourceforge.net
Subject: Re: [PATCH v4 00/12] remove msize limit in virtio transport
Message-ID: <YseFPgFoLpjOGq40@codewreck.org>
References: <cover.1640870037.git.linux_oss@crudebyte.com>
 <7534209.h2h7kyIpJd@silver>
 <CAFkjPT=GAoViYd0E7CZQDq3ZjhmYT0DsBytfZXnE10JL0P8O-Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAFkjPT=GAoViYd0E7CZQDq3ZjhmYT0DsBytfZXnE10JL0P8O-Q@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Eric Van Hensbergen wrote on Fri, Jul 08, 2022 at 10:44:45AM +1000:
> there are other 9p virtio servers - several emulation platforms support it
> sans qemu.

Would you happen to have any concrete example?
I'd be curious if there are some that'd be easy to setup for test for
example; my current validation setup lacks a bit of diversity...

I found https://github.com/moby/hyperkit for OSX but that doesn't really
help me, and can't see much else relevant in a quick search

--
Dominique
