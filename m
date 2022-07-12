Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B54A557284D
	for <lists+netdev@lfdr.de>; Tue, 12 Jul 2022 23:13:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231437AbiGLVNn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jul 2022 17:13:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231283AbiGLVNk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jul 2022 17:13:40 -0400
Received: from nautica.notk.org (ipv6.notk.org [IPv6:2001:41d0:1:7a93::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A25ACC01;
        Tue, 12 Jul 2022 14:13:38 -0700 (PDT)
Received: by nautica.notk.org (Postfix, from userid 108)
        id 45E4DC01E; Tue, 12 Jul 2022 23:13:37 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1657660417; bh=1uRYgxUvXSWHHlXdts6WD5ZdpUJe0/o4CU9U9uBN3iw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=BSR8pqpFCjH47FB4d/bLlLg5qZmy3JfF2+tEapF248cL/pZ8MYdWELLASRZ16qNCw
         QwqIA0gvfkJQLQSZ7/F1jC3Rcnw7fiABdDdtEglz4lijuFFPqJjWJXVRB0NRzuBDkr
         MZ33jQ01GiqWRBeW5xoUl3AW+C+xtON8uxyI84FhW2k/DBGc3kUZPdA5EaCbZZVM3M
         rxe/Qe8NSbhhslsXyWcTyArFuZzZTkh87QX/tTY9GoSCB+xsiUOzUzOjZj5nsdUUSy
         Du/3dZFR3znvCS0P5ClEZXvkOKC3lG6/5S5G9YrDHZ1fJ82GgyYC+dOkl+d9c+6bwn
         awyzVK0OLXyuw==
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
Received: from odin.codewreck.org (localhost [127.0.0.1])
        by nautica.notk.org (Postfix) with ESMTPS id 8746AC009;
        Tue, 12 Jul 2022 23:13:34 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1657660416; bh=1uRYgxUvXSWHHlXdts6WD5ZdpUJe0/o4CU9U9uBN3iw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=TgPOQN4TnIjIdJ10R4G6YKEkog5Q6leummnpaJJ62jbU7EMlkl08Oyo89VKC8p5Gw
         YewwMI0ebZ/6+1p6lzMg7BH0uiZ1RpXkuEM7FwKU3ObQ8ch/laiVDqb16diL4nMj2O
         sDs7+9bnu5MwI6oaicPQ2dU/eNU+AJWa+d7C6gIwA8w59J0vkkqHPzzj8UI0w5T2nx
         q1atArnTNnVIaiCUX0EP8v6R8fLGV/cgUCVFBGEXQI2tq6WxYEHwYrsdqVJ8xTU5UF
         F0LdghO9UCgzkrIhgQzHYu5416UEaapAra0eGfWJuNScw00f1EvXzUg6KOVW9SNXto
         zFSMkMMdEib/Q==
Received: from localhost (odin.codewreck.org [local])
        by odin.codewreck.org (OpenSMTPD) with ESMTPA id 75c16631;
        Tue, 12 Jul 2022 21:13:31 +0000 (UTC)
Date:   Wed, 13 Jul 2022 06:13:16 +0900
From:   Dominique Martinet <asmadeus@codewreck.org>
To:     Christian Schoenebeck <linux_oss@crudebyte.com>
Cc:     v9fs-developer@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Eric Van Hensbergen <ericvh@gmail.com>,
        Latchesar Ionkov <lucho@ionkov.net>,
        Nikolay Kichukov <nikolay@oldum.net>
Subject: Re: [PATCH v5 00/11] remove msize limit in virtio transport
Message-ID: <Ys3j7KucZGdFkttA@codewreck.org>
References: <cover.1657636554.git.linux_oss@crudebyte.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <cover.1657636554.git.linux_oss@crudebyte.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Alright; anything I didn't reply to looks good to me.

Christian Schoenebeck wrote on Tue, Jul 12, 2022 at 04:35:54PM +0200:
> OVERVIEW OF PATCHES:
> 
> * Patches 1..6 remove the msize limitation from the 'virtio' transport
>   (i.e. the 9p 'virtio' transport itself actually supports >4MB now, tested
>   successfully with an experimental QEMU version and some dirty 9p Linux
>   client hacks up to msize=128MB).

I have no problem with this except for the small nitpicks I gave, but
would be tempted to delay this part for one more cycle as it's really
independant -- what do you think?


> * Patch 7 limits msize for all transports to 4 MB for now as >4MB would need
>   more work on 9p client level (see commit log of patch 7 for details).
> 
> * Patches 8..11 tremendously reduce unnecessarily huge 9p message sizes and
>   therefore provide performance gain as well. So far, almost all 9p messages
>   simply allocated message buffers exactly msize large, even for messages
>   that actually just needed few bytes. So these patches make sense by
>   themselves, independent of this overall series, however for this series
>   even more, because the larger msize, the more this issue would have hurt
>   otherwise.

time-wise we're getting close to the merge window already (probably in 2
weeks), how confident are you in this?
I can take patches 8..11 in -next now and probably find some time to
test over next weekend, are we good?

-- 
Dominique
