Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D5EBFB99DE
	for <lists+netdev@lfdr.de>; Sat, 21 Sep 2019 00:56:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406869AbfITW4L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Sep 2019 18:56:11 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:46081 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2406854AbfITW4L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Sep 2019 18:56:11 -0400
Received: by mail-qt1-f194.google.com with SMTP id u22so10469789qtq.13
        for <netdev@vger.kernel.org>; Fri, 20 Sep 2019 15:56:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=qyfmknBmhupZutM3RGkEhqg5ednevAf7aYRMgrbrhFo=;
        b=sOlFngYbY+UZupqloK+KcG2vBKJFRcF3/dkFSaJ1priq4HW7l/jmWkD2crs/sXYMpG
         g+7xDKSxiQEW2nnyobsZtSAVNs/k+YbEBjtEe0lgn9eUpaZ6YDA6kGHdZmWKJbTiZ1Ed
         q2MXPlUVGIAfsXGQ3Xza2RCi2XEFPkE5As7QiZZyVpMhnZYc/TZjk7iRxvUnGTcjYALS
         JNX1tIp0vXPnZgBIEx/lfUyHuufjYAN5WSsYx3C+WD2uN8u5iiKyq3DS5zLQRiFY29rm
         4SavwVj12M3EEhfGxwJNYayKgaCxowWHIEC66V/ObiOGcqJQOJVOdV+9Pg5tdkwQc0Ao
         leMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=qyfmknBmhupZutM3RGkEhqg5ednevAf7aYRMgrbrhFo=;
        b=op4c8UEA3K4So3qSnAWF2W9ozKjbvne7fbQ0+LBr6XIGyZK+JjmcAeeqVO3SMF7wIY
         gaYlz3NTxTaM6ACjUYBT7muIolz4SnFYL8GPTeVk/n0YexIausq4HEzVNTqRMNLFMQMp
         5xhdEod9ZoBDYvqMFEkf0F91XlJsbio8A8OfLoD0mA4sUIZXTPFtFzUM3e7Cpr4xqqE4
         Qv9Ycye5T2Jo7/tMH8uQZgOXBGxsuba5ksGRstOnd1aYwUQWLVw8QcJgD/whs9B65Naq
         G3dcHAzyA9cnmSdIBzLE/M4MZ7OZhBBulqiQR2/SVYI3zMYkdTQibqLB2S5iXqUwtmHw
         mjGg==
X-Gm-Message-State: APjAAAUw9jtDHI3IBmDOSJTbos341E5KuJnNK9TCAc5QRoclOOO5eDsy
        FAYXz9IqrA/NJ2SxQX/WMXKfZg==
X-Google-Smtp-Source: APXvYqyXYpOYRMyBbwfpYF374JR8TL5tO4JB8l86gCKIAYPIGupDxa7jMWbyRuXDLLNR2Pn+GmQYMg==
X-Received: by 2002:ac8:3876:: with SMTP id r51mr6090089qtb.66.1569020170061;
        Fri, 20 Sep 2019 15:56:10 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id h68sm1681840qkd.35.2019.09.20.15.56.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Sep 2019 15:56:09 -0700 (PDT)
Date:   Fri, 20 Sep 2019 15:56:05 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Vlad Buslov <vladbu@mellanox.com>,
        David Miller <davem@davemloft.net>,
        Paul Blakey <paulb@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jiri Pirko <jiri@resnulli.us>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Pravin Shelar <pshelar@ovn.org>,
        Simon Horman <simon.horman@netronome.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Or Gerlitz <gerlitz.or@gmail.com>
Subject: Re: CONFIG_NET_TC_SKB_EXT
Message-ID: <20190920155605.7c81c2af@cakuba.netronome.com>
In-Reply-To: <0e9a1701-356f-5f94-b88e-a39175dee77a@iogearbox.net>
References: <20190919.132147.31804711876075453.davem@davemloft.net>
        <vbfk1a41fr1.fsf@mellanox.com>
        <20190920091647.0129e65f@cakuba.netronome.com>
        <0e9a1701-356f-5f94-b88e-a39175dee77a@iogearbox.net>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 21 Sep 2019 00:15:16 +0200, Daniel Borkmann wrote:
> On 9/20/19 6:16 PM, Jakub Kicinski wrote:
> > On Thu, 19 Sep 2019 15:13:55 +0000, Vlad Buslov wrote:  
> >> On Thu 19 Sep 2019 at 14:21, David Miller <davem@davemloft.net> wrote:  
> >>> As Linus pointed out, the Kconfig logic for CONFIG_NET_TC_SKB_EXT
> >>> is really not acceptable.
> >>>
> >>> It should not be enabled by default at all.
> >>>
> >>> Instead the actual users should turn it on or depend upon it, which in
> >>> this case seems to be OVS.
> >>>
> >>> Please fix this, thank you.  
> >>
> >> Hi David,
> >>
> >> We are working on it, but Paul is OoO today. Is it okay if we send the
> >> fix early next week?  
> > 
> > Doesn't really seem like we have too many ways forward here, right?
> > 
> > How about this?
> >   
> > ------>8-----------------------------------  
> > 
> > net: hide NET_TC_SKB_EXT as a config option
> > 
> > Linus points out the NET_TC_SKB_EXT config option looks suspicious.
> > Indeed, it should really be selected to ensure correct OvS operation
> > if TC offload is used. Hopefully those who care about TC-only and
> > OvS-only performance disable the other one at compilation time.
> > 
> > Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
> > ---
> >   net/openvswitch/Kconfig |  1 +
> >   net/sched/Kconfig       | 13 +++----------
> >   2 files changed, 4 insertions(+), 10 deletions(-)
> > 
> > diff --git a/net/openvswitch/Kconfig b/net/openvswitch/Kconfig
> > index 22d7d5604b4c..bd407ea7c263 100644
> > --- a/net/openvswitch/Kconfig
> > +++ b/net/openvswitch/Kconfig
> > @@ -15,6 +15,7 @@ config OPENVSWITCH
> >   	select NET_MPLS_GSO
> >   	select DST_CACHE
> >   	select NET_NSH
> > +	select NET_TC_SKB_EXT if NET_CLS_ACT
> >   	---help---
> >   	  Open vSwitch is a multilayer Ethernet switch targeted at virtualized
> >   	  environments.  In addition to supporting a variety of features
> > diff --git a/net/sched/Kconfig b/net/sched/Kconfig
> > index b3faafeafab9..f1062ef55098 100644
> > --- a/net/sched/Kconfig
> > +++ b/net/sched/Kconfig
> > @@ -719,6 +719,7 @@ config NET_EMATCH_IPT
> >   config NET_CLS_ACT
> >   	bool "Actions"
> >   	select NET_CLS
> > +	select NET_TC_SKB_EXT if OPENVSWITCH  
> 
> But how would that make much of a difference :( Distros are still going to
> enable all of this blindlessly. Given discussion in [0], could we just get
> rid of this tasteless hack altogether which is for such a narrow use case
> anyway?

Agreed.  I take it you're opposed to the use of skb extensions here 
in general?  Distros would have enabled NET_TC_SKB_EXT even when it 
was a config option.

> I thought idea of stuffing things into skb extensions are only justified if
> it's not enabled by default for everyone. :(
> 
>    [0] https://lore.kernel.org/netdev/CAHC9VhSz1_KA1tCJtNjwK26BOkGhKGbPT7v1O82mWPduvWwd4A@mail.gmail.com/T/#u

The skb ext allocation is only done with GOTO_CHAIN, which AFAIK only
has practical use for offload.  We could perhaps add another static
branch there or move the OvS static branch out of the OvS module so
there are no linking issues?

I personally have little sympathy for this piece of code, it is perhaps
the purest form of a wobbly narrow-use construct pushed into TC for HW
offload.

Any suggestions on the way forward? :(
