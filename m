Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ABC69442D3A
	for <lists+netdev@lfdr.de>; Tue,  2 Nov 2021 12:51:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231200AbhKBLyW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Nov 2021 07:54:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230336AbhKBLyW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Nov 2021 07:54:22 -0400
Received: from nautica.notk.org (ipv6.notk.org [IPv6:2001:41d0:1:7a93::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B8A4C061714;
        Tue,  2 Nov 2021 04:51:47 -0700 (PDT)
Received: by nautica.notk.org (Postfix, from userid 108)
        id B107DC009; Tue,  2 Nov 2021 12:51:45 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1635853905; bh=N68L2alYd3DJ7Qcj5zBlvsPrdZjk1fqAyrthCp2CoXM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Jitk4g+V+Feq9GE2JHDctYvZpD1dn3V9F1S7y9HrKG472uTitHFob4SY0iiLDGnWv
         D0hnE44xCNfgwY4oXuFR7GHjzHikN5/e/yOQ5DpaSj6WMToETlW1l7HsmFwGGWgodu
         6hj8XtOrObHOOiCHN5vFXesIJkc7Xrzsr5/CkczijEHCsadzD4ngsHrGen6J6/ahV1
         NcEwqfEwGuW0jh1PQPEscHnQOCws83nCUu998O+m0Pw1TdVnIgOrRHXdsuZQCtSaJ7
         t+QsvtPWLgXM9/UQI8o8F0A381XP5e8YStjkuFAISwwiLYpg7V3GGTVvOBUX+iiQEW
         tsdCx+RiJPc8Q==
X-Spam-Checker-Version: SpamAssassin 3.3.2 (2011-06-06) on nautica.notk.org
X-Spam-Level: 
X-Spam-Status: No, score=0.0 required=5.0 tests=UNPARSEABLE_RELAY
        autolearn=unavailable version=3.3.2
Received: from odin.codewreck.org (localhost [127.0.0.1])
        by nautica.notk.org (Postfix) with ESMTPS id 95015C009;
        Tue,  2 Nov 2021 12:51:42 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1635853904; bh=N68L2alYd3DJ7Qcj5zBlvsPrdZjk1fqAyrthCp2CoXM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=u+mZG2dwfJ1lV4mkZy85Q0ZQhOPb7LHmEB9zd9TLA56AEL4Hvse9L6wqQXdwpD7qD
         p/i9W2+neSsFFrlA+Twy8lltP4NiVMa2hjhEBEnYGqa4HElxMHjpWbmSAKLrlTP76+
         lAgAufkoXIlqxPl2+ouo1TmY7rfBITj4Icifj3qbtJJEmGldVAHZWAh0otQ0yPVEjd
         +Ruvqg2OYhyG1pG7mMTHL0fR33whu3+MAHsN0btCa0k/zexDVyNo+EiOTMpLDE6fWM
         3F1tSwrLFN8g4a1+DYinR1V8rVNkhFhOWrZmfuMyJJQY58ALW/gyDXXhyVwpK4ukuN
         XakcAp2uAi0nQ==
Received: from localhost (odin.codewreck.org [local])
        by odin.codewreck.org (OpenSMTPD) with ESMTPA id eb2be388;
        Tue, 2 Nov 2021 11:51:36 +0000 (UTC)
Date:   Tue, 2 Nov 2021 20:51:21 +0900
From:   Dominique Martinet <asmadeus@codewreck.org>
To:     Thomas =?utf-8?Q?Wei=C3=9Fschuh?= <linux@weissschuh.net>
Cc:     Eric Van Hensbergen <ericvh@gmail.com>,
        Latchesar Ionkov <lucho@ionkov.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        v9fs-developer@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net/9p: autoload transport modules
Message-ID: <YYEmOcEf5fjDyM67@codewreck.org>
References: <20211017134611.4330-1-linux@weissschuh.net>
 <YYEYMt543Hg+Hxzy@codewreck.org>
 <922a4843-c7b0-4cdc-b2a6-33bf089766e4@t-8ch.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <922a4843-c7b0-4cdc-b2a6-33bf089766e4@t-8ch.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thomas Weißschuh wrote on Tue, Nov 02, 2021 at 11:59:32AM +0100:
> On 2021-11-02 19:51+0900, Dominique Martinet wrote:
> > Sorry for the late reply
> > 
> > Thomas Weißschuh wrote on Sun, Oct 17, 2021 at 03:46:11PM +0200:
> > > Automatically load transport modules based on the trans= parameter
> > > passed to mount.
> > > The removes the requirement for the user to know which module to use.
> > 
> > This looks good to me, I'll test this briefly on differnet config (=y,
> > =m) and submit to Linus this week for the next cycle.
> 
> Thanks. Could you also fix up the typo in the commit message when applying?
> ("The removes" -> "This removes")

Sure, done -- I hadn't even noticed it..

> > Makes me wonder why trans_fd is included in 9pnet and not in a 9pnet-fd
> > or 9pnet-tcp module but that'll be for another time...
> 
> To prepare for the moment when those transport modules are split into their own
> module(s), we could already add MODULE_ALIAS_9P() calls to net/9p/trans_fd.c.

I guess it wouldn't hurt to have 9p-tcp 9p-unix and 9p-fd aliases to the
9pnet module, but iirc these transports were more closely tied to the
rest of 9pnet than the rest so it might take a while to do and I don't
have much time for this right now...
I'd rather not prepare for something I'll likely never get onto, so
let's do this if there is progress.

Of course if you'd like to have a look that'd be more than welcome :-)

-- 
Dominique
