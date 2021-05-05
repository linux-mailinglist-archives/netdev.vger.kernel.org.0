Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05D523735D2
	for <lists+netdev@lfdr.de>; Wed,  5 May 2021 09:48:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231494AbhEEHtg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 May 2021 03:49:36 -0400
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:48045 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229741AbhEEHtf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 May 2021 03:49:35 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 92C195C0060;
        Wed,  5 May 2021 03:48:38 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Wed, 05 May 2021 03:48:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=zgsZ4A
        3r4kNcbuxwkWZ1xKUX08B1TYZFKdCXUD8zP+c=; b=XBtZT5dG+vqLqfO7QyGRVt
        hSb0EHAW2EXVQoVtgHHtWewvpWH5KoKQFWnUkPCQLpRt9BfZBsIGNJQU28AjdMop
        sX718zc/l913iB0Py1DoYmyZwjAaJ2kYmkB284vBB3i/SQqSmVmymwQXc4SUxtC/
        yn2xo1JnN6akD8Re2cds2JFXo/GskJc+ZPPRrGNjQUBUCzHtdeI6PwJLWiRqMmxC
        PGq1KJnFZygLRaKH6YTkgGV5SoFcPiyW2Z/N6m6FRBPCnvggQDNUcp7kKtcC5NL4
        0SQ6U9DOrDdjyft8n+Fac6SqC3ziluf9WMj4btoeeSiVn3iaiQZpbmpORy2tqeuw
        ==
X-ME-Sender: <xms:1k2SYJeHh16eS23c3_hbVqIU4GI9bC1YAgPNqxZfQrRdprvGULo4Ag>
    <xme:1k2SYHOBsDy-5mSFbdZlfrQkvc2ln4KzvSaiOh6-QOjKxXnz2L9j3vcd5uHFMHdl6
    eomCPUvUtGx6Y0>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdefjedguddukecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepkfguohcu
    ufgthhhimhhmvghluceoihguohhstghhsehiughoshgthhdrohhrgheqnecuggftrfgrth
    htvghrnheptdffkeekfeduffevgeeujeffjefhtefgueeugfevtdeiheduueeukefhudeh
    leetnecukfhppeekgedrvddvledrudehfedrudekjeenucevlhhushhtvghrufhiiigvpe
    dtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:1k2SYCjI2HLOEY75Uj3b2SsTDWje4HVpfFJP_vqBArxNcMXs5l_Xmw>
    <xmx:1k2SYC-V5CNkqhG3FZlfVkKvRsBwmSdjMjg25Eb8KcaEMPJp_DVItQ>
    <xmx:1k2SYFuD8ytOK2FEE4Pz5itmB-3UfGAhVR2yJw6F-2ygD1Ia-ZswOw>
    <xmx:1k2SYJgAUsuEsdj5A-y9v0nC1DJ_hW9VQMcQ6-MFF9ZQ9t1AnteLYQ>
Received: from localhost (igld-84-229-153-187.inter.net.il [84.229.153.187])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Wed,  5 May 2021 03:48:37 -0400 (EDT)
Date:   Wed, 5 May 2021 10:48:34 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     David Ahern <dsahern@gmail.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        petrm@nvidia.com, roopa@nvidia.com, nikolay@nvidia.com,
        ssuryaextr@gmail.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: Re: [RFC PATCH net-next 02/10] ipv4: Add a sysctl to control
 multipath hash fields
Message-ID: <YJJN0igwJEC6HoC2@shredder.lan>
References: <20210502162257.3472453-1-idosch@idosch.org>
 <20210502162257.3472453-3-idosch@idosch.org>
 <3664a338-40ad-9379-0a4c-ec2bd99681dd@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3664a338-40ad-9379-0a4c-ec2bd99681dd@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 03, 2021 at 08:33:40PM -0600, David Ahern wrote:
> On 5/2/21 10:22 AM, Ido Schimmel wrote:
> > From: Ido Schimmel <idosch@nvidia.com>
> > 
> > A subsequent patch will add a new multipath hash policy where the packet
> > fields used for multipath hash calculation are determined by user space.
> > This patch adds a sysctl that allows user space to set these fields.
> > 
> > The packet fields are represented using a bitmap and are common between
> > IPv4 and IPv6 to allow user space to use the same numbering across both
> > protocols. For example, to hash based on standard 5-tuple:
> > 
> >  # sysctl -w net.ipv4.fib_multipath_hash_fields=0-2,4-5
> >  net.ipv4.fib_multipath_hash_fields = 0-2,4-5
> > 
> > More fields can be added in the future, if needed.
> > 
> > The 'need_outer' and 'need_inner' variables are set in the control path
> > to indicate whether dissection of the outer or inner flow is needed.
> > They will be used by a subsequent patch to allow the data path to avoid
> > dissection of the outer or inner flow when not needed.
> > 
> > Signed-off-by: Ido Schimmel <idosch@nvidia.com>
> > ---
> >  Documentation/networking/ip-sysctl.rst | 29 ++++++++++++++++
> >  include/net/ip_fib.h                   | 46 ++++++++++++++++++++++++++
> >  include/net/netns/ipv4.h               |  4 +++
> >  net/ipv4/fib_frontend.c                | 24 ++++++++++++++
> >  net/ipv4/sysctl_net_ipv4.c             | 32 ++++++++++++++++++
> >  5 files changed, 135 insertions(+)
> > 
> > diff --git a/Documentation/networking/ip-sysctl.rst b/Documentation/networking/ip-sysctl.rst
> > index c2ecc9894fd0..8ab61f4edf02 100644
> > --- a/Documentation/networking/ip-sysctl.rst
> > +++ b/Documentation/networking/ip-sysctl.rst
> > @@ -100,6 +100,35 @@ fib_multipath_hash_policy - INTEGER
> >  	- 1 - Layer 4
> >  	- 2 - Layer 3 or inner Layer 3 if present
> >  
> > +fib_multipath_hash_fields - list of comma separated ranges
> > +	When fib_multipath_hash_policy is set to 3 (custom multipath hash), the
> > +	fields used for multipath hash calculation are determined by this
> > +	sysctl.
> > +
> > +	The format used for both input and output is a comma separated list of
> > +	ranges (e.g., "0-2" for source IP, destination IP and IP protocol).
> > +	Writing to the file will clear all previous ranges and update the
> > +	current list with the input.
> > +
> > +	Possible fields are:
> > +
> > +	== ============================
> > +	 0 Source IP address
> > +	 1 Destination IP address
> > +	 2 IP protocol
> > +	 3 Unused
> > +	 4 Source port
> > +	 5 Destination port
> > +	 6 Inner source IP address
> > +	 7 Inner destination IP address
> > +	 8 Inner IP protocol
> > +	 9 Inner Flow Label
> > +	10 Inner source port
> > +	11 Inner destination port
> > +	== ============================
> > +
> > +	Default: 0-2 (source IP, destination IP and IP protocol)
> 
> since you are already requiring a name to id conversion, why not just
> use a bitmask here as the input? if the value is a 32-bit bitmask do you
> need bitmap_zalloc and its overhead?

A bitmask was what I originally planned to use, but a bitmap seemed to
provide a better user interface. In practice, it is probably not a big
deal given that most people will just put the relevant value in
/etc/sysctl.d/ and forget about it. Will try the bitmask option.

> Also, you could implement the current default using this scheme since
> you have the default fields as the current L3 policy.

Will reply in patch #3.
