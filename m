Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 428D850B80F
	for <lists+netdev@lfdr.de>; Fri, 22 Apr 2022 15:14:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1447791AbiDVNQg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Apr 2022 09:16:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1447787AbiDVNQg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Apr 2022 09:16:36 -0400
Received: from nautica.notk.org (nautica.notk.org [91.121.71.147])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEACC580DD;
        Fri, 22 Apr 2022 06:13:40 -0700 (PDT)
Received: by nautica.notk.org (Postfix, from userid 108)
        id D72BCC021; Fri, 22 Apr 2022 15:13:38 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1650633218; bh=arZcP3kJHlJ8SEpr6WdbTpaE0DnsvTOiOitkCJZmFdY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=nOdC2T5Dhqaut2J004hiQt31EBBwPVxp4oWg4Uo09BZPaGDl5pAvDUOHBeTPD4PaD
         ZiCWYJaQ6I3B6Jv0ZwE6JPtgwdtMZ0S265i0vpasipmMAF2trBzKDSQYmxfwhDGV5d
         /0ZKJvj7jKnjJMTGPAsGdcvS/7GsX0yZ2DuO3EfVDJNTnXqawzTzOOtcLvhYHSgJFC
         so7Z2+Y8TooRFvk/rHEFBlBweOH/Bvszu1Zs5CGl3vfNcfzstMDz82WFWOUSeddUbi
         uueLLONEzLBvrbEXS2Gatke6dbOwF4Y7t879vjSFa2j7mISxG8PU0eW3R7iMoLSaUd
         SlFVGxz/hzOBw==
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
Received: from odin.codewreck.org (localhost [127.0.0.1])
        by nautica.notk.org (Postfix) with ESMTPS id CC236C009;
        Fri, 22 Apr 2022 15:13:34 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1650633218; bh=arZcP3kJHlJ8SEpr6WdbTpaE0DnsvTOiOitkCJZmFdY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=nOdC2T5Dhqaut2J004hiQt31EBBwPVxp4oWg4Uo09BZPaGDl5pAvDUOHBeTPD4PaD
         ZiCWYJaQ6I3B6Jv0ZwE6JPtgwdtMZ0S265i0vpasipmMAF2trBzKDSQYmxfwhDGV5d
         /0ZKJvj7jKnjJMTGPAsGdcvS/7GsX0yZ2DuO3EfVDJNTnXqawzTzOOtcLvhYHSgJFC
         so7Z2+Y8TooRFvk/rHEFBlBweOH/Bvszu1Zs5CGl3vfNcfzstMDz82WFWOUSeddUbi
         uueLLONEzLBvrbEXS2Gatke6dbOwF4Y7t879vjSFa2j7mISxG8PU0eW3R7iMoLSaUd
         SlFVGxz/hzOBw==
Received: from localhost (odin.codewreck.org [local])
        by odin.codewreck.org (OpenSMTPD) with ESMTPA id 9bea8e61;
        Fri, 22 Apr 2022 13:13:30 +0000 (UTC)
Date:   Fri, 22 Apr 2022 22:13:15 +0900
From:   asmadeus@codewreck.org
To:     Christian Schoenebeck <linux_oss@crudebyte.com>
Cc:     David Howells <dhowells@redhat.com>,
        David Kahurani <k.kahurani@gmail.com>, davem@davemloft.net,
        ericvh@gmail.com, kuba@kernel.org, linux-kernel@vger.kernel.org,
        lucho@ionkov.net, netdev@vger.kernel.org,
        v9fs-developer@lists.sourceforge.net, Greg Kurz <groug@kaod.org>
Subject: Re: 9p EBADF with cache enabled (Was: 9p fs-cache tests/benchmark
 (was: 9p fscache Duplicate cookie detected))
Message-ID: <YmKp68xvZEjBFell@codewreck.org>
References: <YlySEa6QGmIHlrdG@codewreck.org>
 <YlyFEuTY7tASl8aY@codewreck.org>
 <1050016.1650537372@warthog.procyon.org.uk>
 <1817268.LulUJvKFVv@silver>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1817268.LulUJvKFVv@silver>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Christian Schoenebeck wrote on Thu, Apr 21, 2022 at 01:36:14PM +0200:
> I hope this does not sound harsh, wouldn't it make sense to revert 
> eb497943fa215897f2f60fd28aa6fe52da27ca6c for now until those issues are sorted 
> out? My concern is that it might take a long time to address them, and these 
> are not minor issues.

I'm not sure that's possible at all, the related old fscache code has
been ripped out since and just reverting won't work.

I'm also curious why that behavior changed though, I don't think the
old code had any special handling of partially written pages either...
Understanding that might give a key to a small quick fix.


It is quite a bad bug though and really wish I could give it the
attention it deserves, early next month has a few holidays here
hopefully I'll be able to look at it closer then :/

-- 
Dominique
