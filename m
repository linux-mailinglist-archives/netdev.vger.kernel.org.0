Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06251443AAD
	for <lists+netdev@lfdr.de>; Wed,  3 Nov 2021 02:00:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231216AbhKCBDV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Nov 2021 21:03:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229778AbhKCBDT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Nov 2021 21:03:19 -0400
Received: from nautica.notk.org (ipv6.notk.org [IPv6:2001:41d0:1:7a93::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25F0BC061714;
        Tue,  2 Nov 2021 18:00:36 -0700 (PDT)
Received: by nautica.notk.org (Postfix, from userid 108)
        id 99290C021; Wed,  3 Nov 2021 02:00:34 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1635901234; bh=lWGWUPlNU15YUMqghMH2m2/toiDn+Ja68kA6ffuNuP0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=rJxwFKUhVkvdd5ERg0zv6Bi0rYJhVVr0LmpPssvLTa0v35TVaSmP/3Gr1hnIAUY/7
         yQSl0FQ9Wk7n3AcenYZGmHGdZuyfGwLTgBQk2onlvM9RPDGiAI/kPE7cAl4pgNntuo
         +PgvZkk9ULEgBlIzV8YgOmBUoJ5qlyk8JQaMw5J4t/Je9sGWwAVVhVApk91NVK95/V
         8Dq3LsP5uy87EAImW1zCQ3PIIsNzD0hMxlCAguENVCmpXR+ZNIwLauDo0w90m6OLTx
         rA3lOaBjdM+k+XRfB2pgfA94CgfioHSXEubr17WcJ7KZJbYuU+F6quSyHCsxqCuSf9
         HSS6l1Ml832jA==
X-Spam-Checker-Version: SpamAssassin 3.3.2 (2011-06-06) on nautica.notk.org
X-Spam-Level: 
X-Spam-Status: No, score=0.0 required=5.0 tests=UNPARSEABLE_RELAY
        autolearn=unavailable version=3.3.2
Received: from odin.codewreck.org (localhost [127.0.0.1])
        by nautica.notk.org (Postfix) with ESMTPS id 2BA56C009;
        Wed,  3 Nov 2021 02:00:30 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1635901233; bh=lWGWUPlNU15YUMqghMH2m2/toiDn+Ja68kA6ffuNuP0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=RWM4RZtZ0qH38c8CL6Jw3wuxKQG7SEGSL1RAfQPFk6GjWPwJ8wtIpb03FtJw7EyYL
         aQSQRuFm5w4MnHpceXATLzkw3uDu9KeXD3BqjxxkhPTAnmqx7gpkZo9w1gWOVtydlV
         jSNTXNR5Pko8KTedTIQUn4kXxHLqS85eCNSEYkZoECIriNnPv2GO71++l4A4R/Vq0z
         Kg6lRIZA1anx2oZT3kcqtceCmzA/ktLFQ2plWFFOwylfFqODx4HKFhK4eazPBo0HEX
         U5jCIrR4mDpDX3BRZHxKDZ8q3VPlGbYi6JbS2ofVd0pD1ZtRWMkzu2DB7YxaqeOTbo
         Oqr8sCmruNjfw==
Received: from localhost (odin.codewreck.org [local])
        by odin.codewreck.org (OpenSMTPD) with ESMTPA id 4eba7d17;
        Wed, 3 Nov 2021 01:00:28 +0000 (UTC)
Date:   Wed, 3 Nov 2021 10:00:12 +0900
From:   Dominique Martinet <asmadeus@codewreck.org>
To:     Thomas =?utf-8?Q?Wei=C3=9Fschuh?= <thomas@t-8ch.de>
Cc:     Thomas =?utf-8?Q?Wei=C3=9Fschuh?= <linux@weissschuh.net>,
        Eric Van Hensbergen <ericvh@gmail.com>,
        Latchesar Ionkov <lucho@ionkov.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        v9fs-developer@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net/9p: autoload transport modules
Message-ID: <YYHfHIcVSDOSuJnx@codewreck.org>
References: <20211017134611.4330-1-linux@weissschuh.net>
 <YYEYMt543Hg+Hxzy@codewreck.org>
 <922a4843-c7b0-4cdc-b2a6-33bf089766e4@t-8ch.de>
 <YYEmOcEf5fjDyM67@codewreck.org>
 <ddf6b6c9-1d9b-4378-b2ee-b7ac4a622010@t-8ch.de>
 <YYFSBKXNPyIIFo7J@codewreck.org>
 <3e8fcaff-6a2e-4546-87c9-a58146e02e88@t-8ch.de>
 <YYHHHy0qJGlpGEaQ@codewreck.org>
 <778dfd93-ace5-4cab-9a08-21d279f18c1f@t-8ch.de>
 <YYHXOOwkmJW8bhHW@codewreck.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <YYHXOOwkmJW8bhHW@codewreck.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dominique Martinet wrote on Wed, Nov 03, 2021 at 09:26:32AM +0900:
> Feel free to resend in a proper form though, I could make up a commit
> message but it might as well be your words!

Ah, just a couple more things:

* make with W=1 complains about missing prototypes:

net/9p/trans_fd.c:1155:5: warning: no previous prototype for ‘p9_trans_fd_init’ [-Wmissing-prototypes]
 1155 | int p9_trans_fd_init(void)
      |     ^~~~~~~~~~~~~~~~
net/9p/trans_fd.c:1164:6: warning: no previous prototype for ‘p9_trans_fd_exit’ [-Wmissing-prototypes]
 1164 | void p9_trans_fd_exit(void)
      |      ^~~~~~~~~~~~~~~~


* This actually break the 'no trans=tcp' specified case when no extra
module is loaded, but I'm not sure how impactful that is.
See v9fs_get_default_trans(), they iterate through loaded transports
(through register_trans()), we might want to bake in a list that
additionally tries to load modules if no module is loaded at all
(in my opinion virtio makes sense before tcp, then fd, unix, xen, rdma?)

Well, that can probably come later.

-- 
Dominique
