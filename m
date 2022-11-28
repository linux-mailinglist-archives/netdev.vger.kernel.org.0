Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 64F3E63B19F
	for <lists+netdev@lfdr.de>; Mon, 28 Nov 2022 19:50:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232492AbiK1St7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Nov 2022 13:49:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232839AbiK1Stb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Nov 2022 13:49:31 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9B7A275D0;
        Mon, 28 Nov 2022 10:48:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2B5AB61372;
        Mon, 28 Nov 2022 18:48:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 649C9C433C1;
        Mon, 28 Nov 2022 18:48:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669661334;
        bh=4cuGQwsXEndrZXujF7esGANaIWPXrt52pTIPN8b5YN4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=oMYeVnlIA4GXklUml2HCLJeRTsHzbh6KC7BNwB9TXwWeIsd8K0yQnZFkhm28T6bNp
         4jHr0VfSzuwacwYpyx/CsNcg1Y22LxlD7KN/QgcAjeZVbAAAH/A7QfT2U5XgC4bRH/
         S1H9bmSaPeja2POqVbKyh4JkcvUsb90FylDfBbwFzD83AeQKZm0s2Bti7sqmWYnMwm
         Wl1J23xaya4mrykRI4Tm9akva5eXdZHTACKx+2PbsWA1zaRbzQbnb3uxzFigHr2wi+
         7bhyDujU8U58RsLTBykwcLLx6cuMchQ0FwiufEVa2rJcGpIiSQxg/YTal3PO83z+i9
         6IXCkBG+L8qwg==
Date:   Mon, 28 Nov 2022 10:48:53 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     David Howells <dhowells@redhat.com>
Cc:     netdev@vger.kernel.org, linux-afs@lists.infradead.org,
        Marc Dionne <marc.dionne@auristor.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 00/13] rxrpc: Increasing SACK size and moving
 away from softirq, part 2
Message-ID: <20221128104853.25665813@kernel.org>
In-Reply-To: <1869061.1669273688@warthog.procyon.org.uk>
References: <20221123192335.119335ac@kernel.org>
        <166919798040.1256245.11495568684139066955.stgit@warthog.procyon.org.uk>
        <1869061.1669273688@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 24 Nov 2022 07:08:08 +0000 David Howells wrote:
> What's the best way to base on a fix commit that's in net for patches in
> net-next?  Here I tried basing on a merge between them.  Should I include the
> fix patch on my net-next branch instead? Or will net be merged into net-next
> at some point and I should wait for that?

We merge net -> net-next each Thursday afternoon (LT / Linus Time)
so if the wait is for something in net then we generally ask for folks
to just hold off posting until the merge. If the dependency is the
other way then just post based on what's in tree and provide the
conflict resolution in the cover letter.
