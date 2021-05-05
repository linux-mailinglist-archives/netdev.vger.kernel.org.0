Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31FDA373693
	for <lists+netdev@lfdr.de>; Wed,  5 May 2021 10:45:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232222AbhEEIqD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 May 2021 04:46:03 -0400
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:35709 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231764AbhEEIqB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 May 2021 04:46:01 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id 00E955C0100;
        Wed,  5 May 2021 04:45:05 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Wed, 05 May 2021 04:45:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=6ua8GK
        Rb0BSjRg2GcfmDKrYt5noqzyDDcwo5eKfGJsM=; b=Bi/FtOapANp2LaUl17PIAh
        BEjRgqwMl9N9QYzsnwX6KnVUFr7O05eYu/cY1Aw0SDgXzjxJIm4qqWk75b072VNn
        BCaVnBM/O2GvX7XlmOeAEvojvqEKGLhbrgD1rBgTUmurN6mN+2pwh2VbgrwKG155
        ufPDfQxqfE8pKIbVOc025f4vISf78bP4fJoEr+BOZw5uzLtG3ABYd5OE8hWpM+zj
        y/UYNsQCvgXHlbmNsLH8Hhb93hLsDWqlaVc0Vy1lnMX/3qKhf9d0D5JxjGmkUfkH
        sP+gX1DtZkNCYjUh9mtw5gMr/LfbG6CFbf2zsm1riuOQBS1UbfS5hEWToES1/A4Q
        ==
X-ME-Sender: <xms:EFuSYMH3Rtsnjpa3XFcKqFLANEjYXANtyn96TIbPeo7WKyjdQVJ75Q>
    <xme:EFuSYFX_sCuWRwW5expivbJF3NK7MM60QTcnnBMd6frRusKHySWHDF3PjZpUPAcwi
    VKQrL7FyYoT-Ic>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdefkedgtdefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefkughoucfu
    tghhihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucggtffrrghtth
    gvrhhnpedtffekkeefudffveegueejffejhfetgfeuuefgvedtieehudeuueekhfduheel
    teenucfkphepkeegrddvvdelrdduheefrddukeejnecuvehluhhsthgvrhfuihiivgeptd
    enucfrrghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:EFuSYGJtf69Ifh7kZb7R0oU_XrxHW1niPpEX3Ix8tTUU3q0tPDxeKg>
    <xmx:EFuSYOEKw0xyVuytNww9nsqpneVIJKxfZ5RhpHn1bxJt7WH9xmTxCA>
    <xmx:EFuSYCWMgUz7coi2aXJLZvZSxjLjFl0JvQB-cyxTIYx1GSxq_haoQA>
    <xmx:EFuSYELP1YmiuquJLpFRFO3YFGrmT5sR018S_xq4Cnj8GsJxuXRcSA>
Received: from localhost (igld-84-229-153-187.inter.net.il [84.229.153.187])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Wed,  5 May 2021 04:45:04 -0400 (EDT)
Date:   Wed, 5 May 2021 11:45:00 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     David Ahern <dsahern@gmail.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        petrm@nvidia.com, roopa@nvidia.com, nikolay@nvidia.com,
        ssuryaextr@gmail.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: Re: [RFC PATCH net-next 03/10] ipv4: Add custom multipath hash policy
Message-ID: <YJJbDNLH+UK88X+U@shredder.lan>
References: <20210502162257.3472453-1-idosch@idosch.org>
 <20210502162257.3472453-4-idosch@idosch.org>
 <7cfadc51-2d4a-f7ed-f762-eb001b0c2b32@gmail.com>
 <beb58830-de0e-cb47-0a5c-6109be737fb5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <beb58830-de0e-cb47-0a5c-6109be737fb5@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 03, 2021 at 08:40:18PM -0600, David Ahern wrote:
> On 5/3/21 8:38 PM, David Ahern wrote:
> > On 5/2/21 10:22 AM, Ido Schimmel wrote:
> >> diff --git a/Documentation/networking/ip-sysctl.rst b/Documentation/networking/ip-sysctl.rst
> >> index 8ab61f4edf02..549601494694 100644
> >> --- a/Documentation/networking/ip-sysctl.rst
> >> +++ b/Documentation/networking/ip-sysctl.rst
> >> @@ -99,6 +99,8 @@ fib_multipath_hash_policy - INTEGER
> >>  	- 0 - Layer 3
> >>  	- 1 - Layer 4
> >>  	- 2 - Layer 3 or inner Layer 3 if present
> >> +	- 3 - Custom multipath hash. Fields used for multipath hash calculation
> >> +	  are determined by fib_multipath_hash_fields sysctl
> >>  
> > 
> > If you default the fields to L3, then seems like the custom option is a
> > more generic case of '0'.
> > 
> 
> Actually this is the more generic case of all of them, so all of them
> could be implemented using this custom field selection.

Yes and no. The default policy (0) special cases ICMP packets whereas
the rest of the policies do not. Therefore, entirely ignoring the chosen
policy and only looking at the hash fields is not possible here.

Policy 1 can be implemented based on the hash fields alone, as it only
considers outer fields.

Policy 2 is a bit quirky. It will consider inner layer 3 fields and
fallback to outer fields if no encapsulation was encountered. It is not
possible to implement it as-is based on hash fields alone. A good
approximation would be to hash based on both outer and inner layer 3
fields, as the outer fields should remain constant throughout the
lifetime of a given encapsulated flow.

However, while some code can be reused between the different policies, I
do not think it is the primary consideration here. With the new policy,
I tried to minimize the amount of checks as much as I could, but at the
worst case it still adds a per-field check. Avoiding this penalty for
existing use cases was my primary motivation. Especially when the
multipath code can be called from XDP via bpf_fib_lookup() helper.
