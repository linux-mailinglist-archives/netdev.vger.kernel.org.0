Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 181B363B323
	for <lists+netdev@lfdr.de>; Mon, 28 Nov 2022 21:28:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234129AbiK1U2F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Nov 2022 15:28:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234118AbiK1U2E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Nov 2022 15:28:04 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A01D42B1BD;
        Mon, 28 Nov 2022 12:28:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 45DF961425;
        Mon, 28 Nov 2022 20:28:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F4A8C433D7;
        Mon, 28 Nov 2022 20:28:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669667282;
        bh=BDIseZUEtuIDBtR3Cz4L4NwzUeHmT0ocSHtsX/E2+l8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=O4JQfp/dQuAZ1CcClrownH8pkmv4cSu+xlLqeGpw7D8ZdDYXiws0HlE/3UJWacDz4
         b2aLtP0mfYqFZlThABn1AStK+RUOfgZQP5efE2FuERrjYJILVgomMXIKmOAIaCWtZO
         XCkuij/VQgunHtSlacSY014Sh2p3nnj3nGP3C5RGgJP0K5Kre9Lozawm9mFPrz+BeU
         jPLpV7VKSaC/YvuXkYkrSKhxeYcYalhCJvW2nqZ3UvcDvM2IVPGwooRZ/YBJcyTKZn
         UAxFr8MSQzPWOmLkV4BPj5QtkI1OGuITzvk66pbMDLQzZHPb18uBhdUCsv/50UaXOy
         qsAYB+gRrffsw==
Date:   Mon, 28 Nov 2022 12:28:01 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     David Howells <dhowells@redhat.com>
Cc:     netdev@vger.kernel.org, linux-afs@lists.infradead.org,
        Marc Dionne <marc.dionne@auristor.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 00/13] rxrpc: Increasing SACK size and moving
 away from softirq, part 2
Message-ID: <20221128122801.277ff209@kernel.org>
In-Reply-To: <3477287.1669666594@warthog.procyon.org.uk>
References: <20221128104853.25665813@kernel.org>
        <20221123192335.119335ac@kernel.org>
        <166919798040.1256245.11495568684139066955.stgit@warthog.procyon.org.uk>
        <1869061.1669273688@warthog.procyon.org.uk>
        <3477287.1669666594@warthog.procyon.org.uk>
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

On Mon, 28 Nov 2022 20:16:34 +0000 David Howells wrote:
> > We merge net -> net-next each Thursday afternoon (LT / Linus Time)
> > so if the wait is for something in net then we generally ask for folks
> > to just hold off posting until the merge. If the dependency is the
> > other way then just post based on what's in tree and provide the
> > conflict resolution in the cover letter.  
> 
> Ok.  I guess last Thursday was skipped because of Thanksgiving.

Really? Ugh. I wasn't clear enough in communicating to other
maintainers that I'll be out, I guess. 

I'll try to send another PR later today, once I caught up with all 
the traffic, and marge things up properly. Stay tuned.
