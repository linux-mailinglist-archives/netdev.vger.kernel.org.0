Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 01C5519D60F
	for <lists+netdev@lfdr.de>; Fri,  3 Apr 2020 13:51:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390787AbgDCLvQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Apr 2020 07:51:16 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:41272 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726087AbgDCLvP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Apr 2020 07:51:15 -0400
Received: by mail-pf1-f195.google.com with SMTP id a24so3366887pfc.8;
        Fri, 03 Apr 2020 04:51:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=8Le05iGqq6bc/g4wGimHz6enik2yvmwi6fzSxUNSxjk=;
        b=usWegjiDDEKz+JmXZefUYVDwOQMddImVLfn/ykTysx36sNEbA/cQzdBN9nJXUH9H7v
         ss1mYkW69YIXiT0CZgm/8bwQo71xgBDUsk10+Cak3Z83tSXgmJH6sqd/ra8mf/vdDsYn
         3vRGBSDY9uUoYgDpfvAXN4UCdpimqRVaSceHUDg2IlHgmHXtoY3sx9AQeGJrLtmPy5QW
         BJc73uY6W2xbBl5sEAvFpWs64rNxp04x2/UFVQrXO0HD+7cphCzWROdMnAyWGnOA74BB
         Ys7g5iXQPmbJgwMTbbA65sJ839/iHLdKSoAHw4Se2/Lqn+X24CZBqqiFlmU2LNZt4Uk4
         avyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=8Le05iGqq6bc/g4wGimHz6enik2yvmwi6fzSxUNSxjk=;
        b=APfah2p50JdGFumUzJ8oOIXdkSwkxUZG3CygPFeoLOhceu4kgX+FZRdgsq531UGLes
         g+eBb//oggeHzVqdDo8wOSRlN0F/OCVjbpgy4xe/EAFt+H6ORaoQilZY7XhxIJqVKpnw
         r/8iemkhqTBpmKnU7wBi813jD5cInWjT884Kp1RElUelIJzNM8t0aSn/HDRn3qE977kY
         xaoSH5MY2zDLHDcIi6UGSThfkyfZ96J5xOfgRs+Rh+4ct+4P+Z15GOEQrLf0Ej2xkHPJ
         5i6sa0PI83x1wGR/s+uCUkf/Gc1YPfY8xSG3H0SpZohnWk3hhWmiu7CQGjLIqRVEzL1u
         FYTA==
X-Gm-Message-State: AGi0PuaIGzOswm9K2MS35fWdNUbeDajNjgDhazxGuc/aqmK2BlXewPB7
        6h5DP9Ih5iSHpBj0yv9/SRU/erIN
X-Google-Smtp-Source: APiQypLtz8ZlhkbSPJQhw6xzzu7Sl0grZTmkoKmq7v1/GzJa20URzGz5zchw1EEDu08OLtEvSFRdww==
X-Received: by 2002:aa7:9a45:: with SMTP id x5mr8280691pfj.248.1585914674075;
        Fri, 03 Apr 2020 04:51:14 -0700 (PDT)
Received: from localhost ([43.224.245.180])
        by smtp.gmail.com with ESMTPSA id u8sm2172821pgl.19.2020.04.03.04.51.13
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 03 Apr 2020 04:51:13 -0700 (PDT)
Date:   Fri, 3 Apr 2020 19:49:01 +0800
From:   Geliang Tang <geliangtang@gmail.com>
To:     Matthieu Baerts <matthieu.baerts@tessares.net>
Cc:     Mat Martineau <mathew.j.martineau@linux.intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        mptcp@lists.01.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mptcp: move pr_fmt defining to protocol.h
Message-ID: <20200403114901.GB10201@OptiPlex>
References: <34c83a5fe561739c7b85a3c4959eb44c3155d075.1585899578.git.geliangtang@gmail.com>
 <9674b6ce-3888-557e-8f32-230671363903@tessares.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9674b6ce-3888-557e-8f32-230671363903@tessares.net>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 03, 2020 at 12:29:27PM +0200, Matthieu Baerts wrote:
> Hi Geliang,
> 
> On 03/04/2020 09:57, Geliang Tang wrote:
> > Some of the mptcp logs didn't print out the format string "MPTCP":
> > 
> > [  129.185774] DSS
> > [  129.185774] data_fin=0 dsn64=1 use_map=1 ack64=1 use_ack=1
> > [  129.185774] data_ack=5481534886531492085
> > [  129.185775] data_seq=15725204003114694615 subflow_seq=1425409 data_len=5216
> > [  129.185776] subflow=0000000093526a92 fully established=1 seq=0:0 remaining=28
> > [  129.185776] MPTCP: msk=00000000d5a704a6 ssk=00000000b5aabc31 data_avail=0 skb=0000000088f05424
> > [  129.185777] MPTCP: seq=15725204003114694615 is64=1 ssn=1425409 data_len=5216 data_fin=0
> > [  129.185777] MPTCP: msk=00000000d5a704a6 ssk=00000000b5aabc31 status=0
> > [  129.185778] MPTCP: msk ack_seq=da3b25b9a233c2c7 subflow ack_seq=da3b25b9a233c2c7
> > [  129.185778] MPTCP: msk=00000000d5a704a6 ssk=00000000b5aabc31 data_avail=1 skb=000000000caed2cc
> > [  129.185779] subflow=0000000093526a92 fully established=1 seq=0:0 remaining=28
> > 
> > So this patch moves the pr_fmt defining from protocol.c to protocol.h, which
> > is included by all the C files. Then we can get the same format string
> > "MPTCP" in all mptcp logs like this:
> > 
> > [  141.854787] MPTCP: DSS
> > [  141.854788] MPTCP: data_fin=0 dsn64=1 use_map=1 ack64=1 use_ack=1
> > [  141.854788] MPTCP: data_ack=18028325517710311871
> > [  141.854788] MPTCP: data_seq=6163976859259356786 subflow_seq=3309569 data_len=8192
> > [  141.854789] MPTCP: msk=000000005847a66a ssk=0000000022469903 data_avail=0 skb=00000000dd95efc3
> > [  141.854789] MPTCP: seq=6163976859259356786 is64=1 ssn=3309569 data_len=8192 data_fin=0
> > [  141.854790] MPTCP: msk=000000005847a66a ssk=0000000022469903 status=0
> > [  141.854790] MPTCP: msk ack_seq=558ad84b9be1d162 subflow ack_seq=558ad84b9be1d162
> > [  141.854791] MPTCP: msk=000000005847a66a ssk=0000000022469903 data_avail=1 skb=000000000b8926f6
> > [  141.854791] MPTCP: subflow=00000000e4e4579c fully established=1 seq=0:0 remaining=28
> > [  141.854792] MPTCP: subflow=00000000e4e4579c fully established=1 seq=0:dcdf2f3b remaining=28
> 
> Good idea to uniform that.
> I think it can be useful for MPTCP devs to add a different prefix in each
> MPTCP .c files but this small improvement can be done later.
> 
> LGTM, thanks Geliang!
> 
> Reviewed-by: Matthieu Baerts <matthieu.baerts@tessares.net>

Hi Matthieu,

Thanks for your reply.

I have already resend this patch to you, patch v2, a better version, add
pr_fmt defines in each .c files.

-Geliang
