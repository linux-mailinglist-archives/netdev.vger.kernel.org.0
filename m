Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 613835769E8
	for <lists+netdev@lfdr.de>; Sat, 16 Jul 2022 00:31:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230446AbiGOWbL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jul 2022 18:31:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230218AbiGOWbK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jul 2022 18:31:10 -0400
Received: from nautica.notk.org (nautica.notk.org [91.121.71.147])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 050A157E01;
        Fri, 15 Jul 2022 15:31:07 -0700 (PDT)
Received: by nautica.notk.org (Postfix, from userid 108)
        id AB30DC01E; Sat, 16 Jul 2022 00:31:05 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1657924265; bh=XVWBfw25/xbELFTjDfF1NZ0Lppo6CvFhF/8lmkwM8Tc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=y0l4aIPQuM9ZuawOHbdnwDk2TF9dPuWBEvzrKzLGpgTjDHRIR5EPAJ1nCZxP/YrNs
         +P/2ivp8/TZfFF2FCnBQNbCdY3YDNCuYARBr9mHvUFcfAHCHbDAXqb8dXNDCEZN2mI
         wrDPZFLmS+8ve8bObhvJ1FKnEFkR7hWTJjs47IsmOfmXSr4DGddEqjhbiGci/o08hC
         aREWswUGHyxqC5kFlObTLWEcsuXor8e96Uq2HWr3U9alT6+oq0zrUSr4r1yGAYkSqK
         AF9MGHg9cCGbUdpdFhbhHDgoCTkmk0EUvywYo5fORRxPo+IjhcXbiDEOTQwumHDCR8
         CVGYduC+Luzvw==
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
Received: from odin.codewreck.org (localhost [127.0.0.1])
        by nautica.notk.org (Postfix) with ESMTPS id E2533C009;
        Sat, 16 Jul 2022 00:31:02 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1657924265; bh=XVWBfw25/xbELFTjDfF1NZ0Lppo6CvFhF/8lmkwM8Tc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=y0l4aIPQuM9ZuawOHbdnwDk2TF9dPuWBEvzrKzLGpgTjDHRIR5EPAJ1nCZxP/YrNs
         +P/2ivp8/TZfFF2FCnBQNbCdY3YDNCuYARBr9mHvUFcfAHCHbDAXqb8dXNDCEZN2mI
         wrDPZFLmS+8ve8bObhvJ1FKnEFkR7hWTJjs47IsmOfmXSr4DGddEqjhbiGci/o08hC
         aREWswUGHyxqC5kFlObTLWEcsuXor8e96Uq2HWr3U9alT6+oq0zrUSr4r1yGAYkSqK
         AF9MGHg9cCGbUdpdFhbhHDgoCTkmk0EUvywYo5fORRxPo+IjhcXbiDEOTQwumHDCR8
         CVGYduC+Luzvw==
Received: from localhost (odin.codewreck.org [local])
        by odin.codewreck.org (OpenSMTPD) with ESMTPA id 83975ade;
        Fri, 15 Jul 2022 22:31:00 +0000 (UTC)
Date:   Sat, 16 Jul 2022 07:30:45 +0900
From:   Dominique Martinet <asmadeus@codewreck.org>
To:     Christian Schoenebeck <linux_oss@crudebyte.com>
Cc:     v9fs-developer@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Eric Van Hensbergen <ericvh@gmail.com>,
        Latchesar Ionkov <lucho@ionkov.net>,
        Nikolay Kichukov <nikolay@oldum.net>
Subject: Re: [PATCH v6 00/11] remove msize limit in virtio transport
Message-ID: <YtHqlVx9/joj+AXH@codewreck.org>
References: <cover.1657920926.git.linux_oss@crudebyte.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <cover.1657920926.git.linux_oss@crudebyte.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Christian Schoenebeck wrote on Fri, Jul 15, 2022 at 11:35:26PM +0200:
> * Patches 7..11 tremendously reduce unnecessarily huge 9p message sizes and
>   therefore provide performance gain as well. So far, almost all 9p messages
>   simply allocated message buffers exactly msize large, even for messages
>   that actually just needed few bytes. So these patches make sense by
>   themselves, independent of this overall series, however for this series
>   even more, because the larger msize, the more this issue would have hurt
>   otherwise.

Unless they got stuck somewhere the mails are missing patches 10 and 11,
one too many 0s to git send-email ?

I'll do a quick review from github commit meanwhile
-- 
Dominique
