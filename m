Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7646A1C1793
	for <lists+netdev@lfdr.de>; Fri,  1 May 2020 16:20:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729315AbgEAOUP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 May 2020 10:20:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728839AbgEAOUM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 May 2020 10:20:12 -0400
Received: from mail-qk1-x743.google.com (mail-qk1-x743.google.com [IPv6:2607:f8b0:4864:20::743])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85F3EC061A0E;
        Fri,  1 May 2020 07:20:12 -0700 (PDT)
Received: by mail-qk1-x743.google.com with SMTP id t3so9349324qkg.1;
        Fri, 01 May 2020 07:20:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=TPLVyj8f5mQqYUKs8lkjtGqXIkcmActCd7PGHTqZdko=;
        b=gSzv1gWmtw/Vtswzi/0ONsfdq5Ue86EQMBsZd/OlsaGbzoMHCMihz7vc+VPvJyZig5
         RnOLRrqOXgzfWvSrNAvCx8h0sV/g0gNX5dEITgD0/iaiY5pQY5oS3nbh95g1aA8Nxpb7
         ifBR4SLhnPENX6/vAB6Nydb0x6SJ9BwQAcGqipVPmUWCCQVBLxFZSIJQBnwC0RgmuXoO
         F/4THmHXa87WxBH3tcTgwK65RKt3AMiNm3z9Fyzs67UlVy0nuqrD/IZYRcl9pUhRvuhC
         ssb/TGkpBhEBv0qB31F3z+6rW8PtY+WIUM5dBWIhS9PB/DcBGmxGBzTNtoNBNGsbVQF4
         nOFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=TPLVyj8f5mQqYUKs8lkjtGqXIkcmActCd7PGHTqZdko=;
        b=ZsHDRuT4IHEU/Mbgs4WUsJOo9L8dpotc+ojhrURnaCVUj4/z1dAV/DLJQ45iZpL63A
         emZnwBtJRxBgL+Ahpa3cEmjzi+duaQTS5KH9bdhkJHjRV2x/8M0VUrGLkmTcibG0Ogu9
         jF9jRlOLF2brdP4/0PDWyiN30JiayAB6DhY0sJ2fL2PYD62vhqPr05+lIkP1iMQ4ZcyE
         Gz2h42An1k9ST+qKUQm+31hejKyaKRGTKLMQMA6QfFb+KjfXwuT5RCgvveZw12j6b23G
         gtt2q6JqbFdiijqLe7LCumAxZUpk8lrtJPIQJQFbIi4MAD3HESgjOnHqjpCpzcmN57+k
         ++XA==
X-Gm-Message-State: AGi0Pub0rRc1G2HHWNYn94xFeU3m2SR9kpnRDZuzcDGjYdusoaSuphvo
        3Yl03+yl+OP3N9ORQq6jaEU=
X-Google-Smtp-Source: APiQypIaPrqMPQmYjszwqajb3DHEnU9r1JnszMnITeRVif9i1H5Wb4g6PbVRI1y2fP8NqNhytueEEA==
X-Received: by 2002:ae9:edd8:: with SMTP id c207mr3518603qkg.347.1588342811696;
        Fri, 01 May 2020 07:20:11 -0700 (PDT)
Received: from localhost.localdomain ([2001:1284:f022:1531:d4ee:a562:95b8:a0e1])
        by smtp.gmail.com with ESMTPSA id c124sm2812254qke.13.2020.05.01.07.20.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 May 2020 07:20:10 -0700 (PDT)
Received: by localhost.localdomain (Postfix, from userid 1000)
        id 6B253C1B88; Fri,  1 May 2020 11:20:08 -0300 (-03)
Date:   Fri, 1 May 2020 11:20:08 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     Harald Welte <laforge@gnumonks.org>
Cc:     Xin Long <lucien.xin@gmail.com>,
        network dev <netdev@vger.kernel.org>,
        linux-sctp@vger.kernel.org
Subject: Re: ABI breakage in sctp_event_subscribe (was [PATCH net-next 0/4]
 sctp: add some missing events from rfc5061)
Message-ID: <20200501142008.GC2470@localhost.localdomain>
References: <cover.1570534014.git.lucien.xin@gmail.com>
 <20200419102536.GA4127396@nataraja>
 <20200501131607.GU1294372@nataraja>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200501131607.GU1294372@nataraja>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 01, 2020 at 03:16:07PM +0200, Harald Welte wrote:
> Dear Linux SCTP developers,
> 
> On Sun, Apr 19, 2020 at 12:25:36PM +0200, Harald Welte wrote:
> > this patchset (merged back in Q4/2019) has broken ABI compatibility, more
> > or less exactly as it was discussed/predicted in Message-Id
> > <20190206201430.18830-1-julien@arista.com>
> > "[PATCH net] sctp: make sctp_setsockopt_events() less strict about the option length"
> > on this very list in February 2019.
> 
> does the lack of any follow-up so far seems to indicate nobody considers
> this a problem?  Even without any feedback from the Linux kernel
> developers, I would be curious to hear What do other SCTP users say.

No. Speaking for myself only, I just didn't have the time to check
your report yet. I'm a developer but it's not on my main priorities.

> 
> So far I have a somewhat difficult time understanding that I would be
> the only one worried about ABI breakage?  If that's the case, I guess
> it would be best to get the word out that people using Linux SCTP should
> better make sure to not use binary packages but always build on the
> system they run it on, to ensure kernel headers are identical.
> 
> I don't mean this in any cynical way.  The point is either the ABI is
> stable and people can move binaries between different OS/kernel
> versions, or they cannot.  So far the general assumption on Linux is you
> can, but with SCTP you can not, so this needs to be clarified.

That's what we want as well. Some breakage happened, yes, by mistake,
and fixing that properly now, without breaking anything else, may be
just impossible, unfortunatelly. But you can be sure that we are
engaged on not doing it again.

Thanks,
Marcelo
