Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1CDBD5F4A95
	for <lists+netdev@lfdr.de>; Tue,  4 Oct 2022 23:02:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229549AbiJDVCJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Oct 2022 17:02:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbiJDVCI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Oct 2022 17:02:08 -0400
Received: from nautica.notk.org (nautica.notk.org [91.121.71.147])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9927C65248;
        Tue,  4 Oct 2022 14:02:05 -0700 (PDT)
Received: by nautica.notk.org (Postfix, from userid 108)
        id DE340C009; Tue,  4 Oct 2022 23:02:02 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1664917322; bh=TQuv4dworN6gXfiGfaMjBzpIG00Hu+fteykKUo3XV7c=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=muqfAJqP1CSYM8nz/7o6fHngTJk36Rxpvo52YMt5mktINDgp+idnOfJycrVO+SfzL
         TQkDJXtajzhmMQOXuha1sDos+uLaeIhEWR9RuuXJ6VptTYKBpoaeMORMI2w3o+6FcQ
         UtzopbZ/Xh074KbVScbDW/CgxA9jzNHZYAbDGxlEGrqPCEAESPDxI/3XcIRP0mz+3b
         bS+eB1G9EJ0GAUaMjG4Ocuuae45ENSm2Js2EAHbW1TlecIxjBu6GRw/Pk+z6hgmgww
         ieYNMYuBqLtVIWZLq61pZBeA8sWgQiLlG0J9EuUMsjPspbJBJAVOCrqB8BWJHxiYo9
         550HnpakYe63g==
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
Received: from odin.codewreck.org (localhost [127.0.0.1])
        by nautica.notk.org (Postfix) with ESMTPS id ED5FAC009;
        Tue,  4 Oct 2022 23:01:57 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1664917321; bh=TQuv4dworN6gXfiGfaMjBzpIG00Hu+fteykKUo3XV7c=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=jVig2ysiF+cVU62HzWH6DcQPrNE1RT4nhRLIVRtZvfehbec04BB4p6dh2cwxuxIe4
         WpAvr6M7Z6D+8Ug1AEfiyBmGw/eMMk7mIsLVRVBUV5sXPmH8YULHNW83zo/h3Yo0Ks
         MsbQ0Igqvgc+sYAa4OXRWVPjak8vBs8eVxWVjUKPdELnnU4iOuknKcsHhWS7gLzVWi
         HW1Rd7mj7bX0M+4sAw3+/Q15P5l8mwmRWkWSDXkFLual9nZfKyJfTutAtAJ80bdljD
         fdDqar9gEAaeGHF452yeFahD12nWo6aWioYCLpwIanWW9idEMAip0OGaq1VU3n050A
         Ne1Nl5zPG2MjA==
Received: from localhost (odin.codewreck.org [local])
        by odin.codewreck.org (OpenSMTPD) with ESMTPA id b1a35815;
        Tue, 4 Oct 2022 21:01:54 +0000 (UTC)
Date:   Wed, 5 Oct 2022 06:01:39 +0900
From:   Dominique Martinet <asmadeus@codewreck.org>
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     Leon Romanovsky <leon@kernel.org>,
        v9fs-developer@lists.sourceforge.net, linux_oss@crudebyte.com,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        syzbot+67d13108d855f451cafc@syzkaller.appspotmail.com,
        davem@davemloft.net, edumazet@google.com, ericvh@gmail.com,
        kuba@kernel.org, lucho@ionkov.net, netdev@vger.kernel.org
Subject: Re: [PATCH 1/2] Revert "9p: p9_client_create: use p9_client_destroy
 on failure"
Message-ID: <YzyfM1rJrmT1Qe4N@codewreck.org>
References: <cover.1664442592.git.leonro@nvidia.com>
 <024537aa138893c838d9cacc2e24f311c1e83d25.1664442592.git.leonro@nvidia.com>
 <Yzww1LRLIE+It6J8@kadam>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Yzww1LRLIE+It6J8@kadam>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dan Carpenter wrote on Tue, Oct 04, 2022 at 04:10:44PM +0300:
> On Thu, Sep 29, 2022 at 12:37:55PM +0300, Leon Romanovsky wrote:
> > Rely on proper unwind order.
> > 
> > This reverts commit 3ff51294a05529d0baf6d4b2517e561d12efb9f9.
> > 
> > Reported-by: syzbot+67d13108d855f451cafc@syzkaller.appspotmail.com
> > Signed-off-by: Leon Romanovsky <leon@kernel.org>
> 
> The commit message doesn't really say what the problem is to the user.
> Is this just to make the next patch easier?

Yes (and perhaps a bit of spite from the previous discussion), and the
next patch was not useable so I am not applying this as is.

The next patch was meant as an alternative implementation to this fix:
https://lore.kernel.org/all/20220928221923.1751130-1-asmadeus@codewreck.org/T/#u

At this point I have the original fix in my -next branch but it hasn't
had any positive review (and well, I myself agree it's ugly), so unless
Leon sends a v2 I'll need to think of a better way of tracking if
clnt->trans_mod->create has been successfully called.
I'm starting to think that since we don't have so many clnt I can
probably just fit a bool/bitfield in one of the holes of the struct
and just keep track of it; that'll be less error-prone than relying on
clnt->trans (which -is- initialized in create() most of the time, but
not in a way we can rely on) or reworking create() to return it as I
originally wanted to do (rdma still needs to populate clnt->trans behind
the scenees before create() returns, so the abstraction is also quite
ugly)

The current breakage is actually quite bad so I'll try to send that
today or tomorrow for merging next week unless Leon resends something we
can work with... Conceptually won't be different than the patch
currently in next so hopefully can pretend it's had a couple of weeks of
testing...
-- 
Dominique
