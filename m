Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DF8D44397E
	for <lists+netdev@lfdr.de>; Wed,  3 Nov 2021 00:18:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231755AbhKBXUx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Nov 2021 19:20:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230331AbhKBXUv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Nov 2021 19:20:51 -0400
Received: from nautica.notk.org (ipv6.notk.org [IPv6:2001:41d0:1:7a93::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C11DC061714;
        Tue,  2 Nov 2021 16:18:16 -0700 (PDT)
Received: by nautica.notk.org (Postfix, from userid 108)
        id 0B831C01E; Wed,  3 Nov 2021 00:18:13 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1635895093; bh=1pTmdyOEPgOjYARloB4mWE8fy1Eol4wLWmFLu9HJ9HY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=PB3sJX7ee1PdTCz/uu2NiiQ5Ep6Om8viNgcQyRp5Bw1NHkVQC3QvADAN87adnHVv/
         L5UDX4ChOrPPPgUVqe8+0WbVA4ub7X2PF3jtObKevy/RklsI62y7Gum4eNoiuIWsee
         Bc3iOp2djV75QpLPu2Rn+tA8xJPcR282XBfc1GS7dRfaHO1FTWE7K6+L3uYuv+9sJA
         AF/kFO6rsSHV05EmVUVAXiFG0+dPsVXBvu8cKfxaSnS9GZBuTOOLAYEs5l6SvyqZYH
         5Marh2R2lDncDhLaiBY0UtGF4wMjrVS3I01Ut6Dr+VNH5Pyngku84CHJztxvokLYw8
         ldVPSI3ULNQGg==
X-Spam-Checker-Version: SpamAssassin 3.3.2 (2011-06-06) on nautica.notk.org
X-Spam-Level: 
X-Spam-Status: No, score=0.0 required=5.0 tests=UNPARSEABLE_RELAY
        autolearn=unavailable version=3.3.2
Received: from odin.codewreck.org (localhost [127.0.0.1])
        by nautica.notk.org (Postfix) with ESMTPS id 17F70C009;
        Wed,  3 Nov 2021 00:18:09 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1635895092; bh=1pTmdyOEPgOjYARloB4mWE8fy1Eol4wLWmFLu9HJ9HY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=GfFvZOVHKaTCacEuOTpM+PDYMG1MHeEe72nG3gegKvRY75jnQ54IW59FrxLe2Ov0B
         rsb0Wd9/9Lowe8bULCnn/s8zQZH3aprHJXIZKcIEeOLV2dVVCkuuQlujwhu74Ok/Ib
         fA1Pj8iqPimUgFcTLlzFddFPN+tn3MXdgYSC7Dh6qfKsl5g8HKlzrs8RdF2yOCwjZ0
         744cjEWMXff+9KW72Hrt2Ak+ON6JCsil4LFudzQjUzTwDXaSPsqdw3ONbyy1+Cr0lP
         QYumJNUDypC/+OmHRbNTK/PxZQampBJEDUMUQ97vo5D0IkYpaBZOJnQuXAQ03aMBJt
         k7otCdrpvKy2w==
Received: from localhost (odin.codewreck.org [local])
        by odin.codewreck.org (OpenSMTPD) with ESMTPA id 42328f3f;
        Tue, 2 Nov 2021 23:18:06 +0000 (UTC)
Date:   Wed, 3 Nov 2021 08:17:51 +0900
From:   Dominique Martinet <asmadeus@codewreck.org>
To:     Thomas =?utf-8?Q?Wei=C3=9Fschuh?= <linux@weissschuh.net>
Cc:     Eric Van Hensbergen <ericvh@gmail.com>,
        Latchesar Ionkov <lucho@ionkov.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        v9fs-developer@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net/9p: autoload transport modules
Message-ID: <YYHHHy0qJGlpGEaQ@codewreck.org>
References: <20211017134611.4330-1-linux@weissschuh.net>
 <YYEYMt543Hg+Hxzy@codewreck.org>
 <922a4843-c7b0-4cdc-b2a6-33bf089766e4@t-8ch.de>
 <YYEmOcEf5fjDyM67@codewreck.org>
 <ddf6b6c9-1d9b-4378-b2ee-b7ac4a622010@t-8ch.de>
 <YYFSBKXNPyIIFo7J@codewreck.org>
 <3e8fcaff-6a2e-4546-87c9-a58146e02e88@t-8ch.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <3e8fcaff-6a2e-4546-87c9-a58146e02e88@t-8ch.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thomas Weißschuh wrote on Tue, Nov 02, 2021 at 04:32:21PM +0100:
> > with 9p/9pnet loaded,
> > running "mount -t 9p -o trans=virtio tmp /mnt"
> > request_module("9p-%s", "virtio") returns -2 (ENOENT)
> 
> Can you retry without 9p/9pnet loaded and see if they are loaded by the mount
> process?
> The same autoloading functionality exists for filesystems using
> request_module("fs-%s") in fs/filesystems.c
> If that also doesn't work it would indicate an issue with the kernel setup in general.

Right, that also didn't work, which matches modprobe not being called
correctly


> > Looking at the code it should be running "modprobe -q -- 9p-virtio"
> > which finds the module just fine, hence my supposition usermodhelper is
> > not setup correctly
> > 
> > Do you happen to know what I need to do for it?
> 
> What is the value of CONFIG_MODPROBE_PATH?
> And the contents of /proc/sys/kernel/modprobe?

aha, these two were indeed different from where my modprobe is so it is
a setup problem -- I might have been a little rash with this initrd
setup and modprobe ended up in /bin with path here in /sbin...

Thanks for the pointer, I saw the code setup an environment with a
full-blown PATH so didn't think of checking if this kind of setting
existed!
All looks in order then :)

-- 
Dominique
