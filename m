Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 61822181DCC
	for <lists+netdev@lfdr.de>; Wed, 11 Mar 2020 17:28:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730157AbgCKQ2b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Mar 2020 12:28:31 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:57335 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729511AbgCKQ2b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Mar 2020 12:28:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583944110;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=+AcFPUKurIpTmOv61uuE6lYoV6IMLnSbJD63dh/c1Wo=;
        b=O/kiFPPwLfAAlqKeLAZW5nCjyjc4H4REavlr7NCPuLTlS6GfHD0eX3ZfIgz3KUPG+7HAeJ
        6oPuENEfyFsMXcYPQ/D556Wc1oy6e1R0MlaRW5nn0LyNozXEN6HrkfE/C1QoMfT3uXkPQs
        BLtapKChQRyyofg7AjlGTVsknwSKUHo=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-365-q8qWk2BRNKqCw3-rwGVrJg-1; Wed, 11 Mar 2020 12:28:24 -0400
X-MC-Unique: q8qWk2BRNKqCw3-rwGVrJg-1
Received: by mail-wr1-f71.google.com with SMTP id h14so487860wrv.12
        for <netdev@vger.kernel.org>; Wed, 11 Mar 2020 09:28:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=+AcFPUKurIpTmOv61uuE6lYoV6IMLnSbJD63dh/c1Wo=;
        b=NzrHTR0QyXrYutX3Ka2IdDkL7G1GHL4k9nW6cbA6uzwA7owOMm7Lpjof3okJbJiKP6
         Ip+jEp9OmZzUnQ6NLx8T7c78eXlzKK4qRfT8y6cNT11zjPKBCzEF8x1czZVq6YMUIyyI
         +B6TLBENtjt54S6xtNjyytlEil5A+G2AyPfUMW5eWn2m+ycb6aPRdTgOdjaNPDGUzfEU
         cfu3R48XPDZ0ZC9Ql3A+XEJ7nbiq4dYk1G4M6zLTkXnRLXu7yp7hW7YfHp/6EYvIQuXn
         6pwaTUueArmVXFCv1rqWzq/hJcB4fGjGOL59Eu/poo9uTWQ38F/n1VH6SZLdKksrGacD
         /ECQ==
X-Gm-Message-State: ANhLgQ1tBLt5op/9moD83BSPimb4BvR2PzO0yJNAO4HLosKKs5IEYlmh
        8+O7zKRi2JJKTNQ5wFSQRd5oF0jix70Wm8x0sFz5THVg7CTs0QHiw9ZaRYclm61RNAp2HcowvtI
        uPIzPqEbwKo7s+ojL
X-Received: by 2002:a5d:6245:: with SMTP id m5mr5337303wrv.154.1583944103770;
        Wed, 11 Mar 2020 09:28:23 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vsNyw4//2jmv5fSmgb97mVc7AZNgYS+Ev98sGUQ6uHKJBfwNYIX9hyAf6V9x/yMUk/dtzoPjQ==
X-Received: by 2002:a5d:6245:: with SMTP id m5mr5337281wrv.154.1583944103497;
        Wed, 11 Mar 2020 09:28:23 -0700 (PDT)
Received: from pc-3.home (2a01cb0585138800b113760e11343d15.ipv6.abo.wanadoo.fr. [2a01:cb05:8513:8800:b113:760e:1134:3d15])
        by smtp.gmail.com with ESMTPSA id h15sm4791241wrw.97.2020.03.11.09.28.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Mar 2020 09:28:22 -0700 (PDT)
Date:   Wed, 11 Mar 2020 17:28:21 +0100
From:   Guillaume Nault <gnault@redhat.com>
To:     Alexander Duyck <alexander.duyck@gmail.com>
Cc:     David Ahern <dsahern@gmail.com>, Xin Long <lucien.xin@gmail.com>,
        network dev <netdev@vger.kernel.org>,
        davem <davem@davemloft.net>, mmhatre@redhat.com,
        "alexander.h.duyck@intel.com" <alexander.h.duyck@intel.com>
Subject: Re: route: an issue caused by local and main table's merge
Message-ID: <20200311162821.GA31531@pc-3.home>
References: <CADvbK_evghCnfNkePFkkLbaamXPaCOu-mSsSDKXuGSt65DSivw@mail.gmail.com>
 <1441d64c-c334-8c54-39e8-7a06a530089d@gmail.com>
 <CAKgT0UcbycqgrfviqUmvS9S7+F6q-gMzrz-KKQuEb77ruZZLRQ@mail.gmail.com>
 <20200310155630.GA7102@pc-3.home>
 <20200310160133.GA7670@pc-3.home>
 <CAKgT0Ucc2gHxR0TZUZN7LmzFg9xfeA+kC_jQcwVOTY8sUnaijA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKgT0Ucc2gHxR0TZUZN7LmzFg9xfeA+kC_jQcwVOTY8sUnaijA@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 10, 2020 at 10:19:24AM -0700, Alexander Duyck wrote:
> On Tue, Mar 10, 2020 at 9:01 AM Guillaume Nault <gnault@redhat.com> wrote:
> >
> > On Tue, Mar 10, 2020 at 04:56:32PM +0100, Guillaume Nault wrote:
> > > On Mon, Mar 09, 2020 at 08:53:53AM -0700, Alexander Duyck wrote:
> > > > Also, is it really a valid configuration to have the same address
> > > > configured as both a broadcast and unicast address? I couldn't find
> > > > anything that said it wasn't, but at the same time I haven't found
> > > > anything saying it is an acceptable practice to configure an IP
> > > > address as both a broadcast and unicast destination. Everything I saw
> > > > seemed to imply that a subnet should be at least a /30 to guarantee a
> > > > pair of IPs and support for broadcast addresses with all 1's and 0 for
> > > > the host identifier. As such 192.168.122.1 would never really be a
> > > > valid broadcast address since it implies a /31 subnet mask.
> > > >
> > > RFC 3031 explicitly allows /31 subnets for point to point links.
> > That RFC 3021, sorry :/
> >
> 
> So from what I can tell the configuration as provided doesn't apply to
> RFC 3021. Specifically RFC 3021 calls out that you are not supposed to
> use the { <network-prefix>, -1 } which is what is being done here. In
> addition the prefix is technically a /24 as configured here since a
> prefix length wasn't specified so it defaults to a class C.
> 
Yes, I was just replying on the use of /31 subnets. I agree that this
case is different.

> Looking over the Linux kernel code it normally doesn't add such a
> broadcast if using a /31 address:
> https://elixir.bootlin.com/linux/v5.6-rc5/source/net/ipv4/fib_frontend.c#L1122
> 
Yes, and that's the right thing to do IMHO.

I think the original problem is that the command is accepted when it's
run after "ip rule add from 2.2.2.2". It should continue to be rejected
instead, as the ip-rule command has no action and is not supposed to
interfere in this case.

