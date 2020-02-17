Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C6769160862
	for <lists+netdev@lfdr.de>; Mon, 17 Feb 2020 03:59:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726723AbgBQC7P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Feb 2020 21:59:15 -0500
Received: from mail-pf1-f193.google.com ([209.85.210.193]:43207 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726498AbgBQC7P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 16 Feb 2020 21:59:15 -0500
Received: by mail-pf1-f193.google.com with SMTP id s1so8057619pfh.10
        for <netdev@vger.kernel.org>; Sun, 16 Feb 2020 18:59:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=AXoCAsrsYAfS0oCe4OJYOypuJQ5kCPS5iM2CJV0YR68=;
        b=d9MYPzpHIzaLnEC8z4vpoyZBJHokRTKJ6Lxg2nQ2nTEy5uv5PZvEy3bz+OZaHvNGAR
         6ZVW1JJxGH4+lRzkBmQVtn2me2hNhDT9/QsGjwZIYxkB+u38Jv3vRLm5blUbGt25agiM
         OEBQ8Kl/IQn+6tLEBrPajGtgcjOBozykH5+98Cl2MRJffXmUESS2AT3SYbGxcafJMCrZ
         n+zj24BElsq/dOF2PcPePgSMgsD6/6MIx6xQvFCmCgtQFBtdU/M8bbialwVNY4rBS3gu
         2SX3yu2Dg1P1bdL4eBaOI1SjG9UtvRSZ7VWQfh6pzU/Z/vcZzqzS7dLZv9eYLRdEqJJi
         Ieiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=AXoCAsrsYAfS0oCe4OJYOypuJQ5kCPS5iM2CJV0YR68=;
        b=DYVdZwA64vdOYHUywPhYKSJe5hJvtsRRNloI3x+rxWOcQnp5NnidMdWbOpyjf9Wppi
         8OUIR+atP7y8l+xNi8y3YFiZrKyGXBRLuOuftjqR4VTn+oWbJ/9xpyZ7LZyl7ImmziOo
         vlnT79V8ntKGkdGBlhU+pyqI2RJQvIJL055M+9DyehX8nYFWzREPneb/GFoy1V5rE70P
         BOfaSvAMCmnZcP+d9uaaaQiQAL2u3CkDtXRkXNrYQ5gt9UO3Rk0vGeM7yfP9ecqdHaet
         VxC8lBzqpklcRHkS4hkW0xV1YgQ5ttr/mvLT4GI29A6eoizbZP+oMZz1tWvBbylQJAi/
         4sDA==
X-Gm-Message-State: APjAAAXpxK/KU0fDvQHxSnMqK7kfIq+keWa0sRkJS6sXnk3+/K3TPAHB
        0yN6arz+AbyYOy3PCXDsL3mVSITtvew=
X-Google-Smtp-Source: APXvYqyr30xY3ox6NW6cAvLMFOb4XAR9Fee0sJ/7h/gPTp795rJAHiIKz9NGVGXynKy5P8KcSHv1PA==
X-Received: by 2002:a63:61d3:: with SMTP id v202mr16260275pgb.184.1581908354934;
        Sun, 16 Feb 2020 18:59:14 -0800 (PST)
Received: from dhcp-12-139.nay.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id l69sm14861638pgd.1.2020.02.16.18.59.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 16 Feb 2020 18:59:14 -0800 (PST)
Date:   Mon, 17 Feb 2020 10:59:04 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     Petr Machata <petrm@mellanox.com>
Cc:     Petr Machata <pmachata@gmail.com>, netdev@vger.kernel.org,
        Ido Schimmel <idosch@mellanox.com>,
        "David S . Miller" <davem@davemloft.net>,
        Peter Dawson <petedaws@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>
Subject: Re: [PATCH net] selftests: forwarding: vxlan_bridge_1d: fix tos value
Message-ID: <20200217025904.GP2159@dhcp-12-139.nay.redhat.com>
References: <20200213094054.27993-1-liuhangbin@gmail.com>
 <87a75msl7i.fsf@mellanox.com>
 <20200214025308.GO2159@dhcp-12-139.nay.redhat.com>
 <875zg9qw1a.fsf@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <875zg9qw1a.fsf@mellanox.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 14, 2020 at 11:54:09AM +0100, Petr Machata wrote:
> >> > After commit 71130f29979c ("vxlan: fix tos value before xmit") we start
> >> > strict vxlan xmit tos value by RT_TOS(), which limits the tos value less
> >> 
> >> I don't understand how it is OK to slice the TOS field like this. It
> >> could contain a DSCP value, which will be mangled.
> >
> > Thanks for this remind. I re-checked the tos definition and found a summary
> > from Peter Dawson[1].
> >
> > IPv4/6 Header:0 |0 1 2 3 |0 1 2 3 |0 1 2 3 |0 1 2 3 |
> > RFC2460(IPv6)   |Version | Traffic Class   |        |
> > RFC2474(IPv6)   |Version | DSCP        |ECN|        |
> > RFC2474(IPv4)   |Version |  IHL   |    DSCP     |ECN|
> > RFC1349(IPv4)   |Version |  IHL   | PREC |  TOS   |X|
> > RFC791 (IPv4)   |Version |  IHL   |      TOS        |
> >
> > According to this I think our current IPTOS_TOS_MASK should be updated to 0xFC
> > based on RFC2474. But I'm not sure if there will have compatibility issue.
> > What do you think?
> 
> Looking at the various uses of RT_TOS, it looks like they tend to be
> used in tunneling and routing code. I think that in both cases it makes
> sense to convert to 0xfc. But I'm not ready to vouch for this :)

Yes, I also could not... Maybe David or Daniel could help give some comments?

> 
> What is the problem that commit 71130f29979c aims to solve? It's not
> clear to me from the commit message. What issues arise if the TOS is
> copied as is?

As the commit said, we should not use config tos directly. We should remove
the precedence field based on RFC1349 or ENC field based on RFC2474.

Thanks
Hangbin
