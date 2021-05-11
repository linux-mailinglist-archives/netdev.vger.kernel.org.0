Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C26937AFC7
	for <lists+netdev@lfdr.de>; Tue, 11 May 2021 21:58:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229809AbhEKT7i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 May 2021 15:59:38 -0400
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:46719 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229456AbhEKT7i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 May 2021 15:59:38 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id 73CAE5C0178;
        Tue, 11 May 2021 15:58:30 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Tue, 11 May 2021 15:58:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=w9En54
        sELRkrvjsaCzYH+PrjQAJ9pi+3hV73917lLdg=; b=WTlpekK/dTiqrrmkvqFOvy
        bZnxQ7yjnFvw1uFRweqQNyyletONl1RPSDMRtABxgefLG6X2VppCm1HGV4dLmRWg
        wibf8pallLLQxeDbTsZBieEP2Gk0QysJYEGRyBL35btqIKvgtfDI/8MOXLCJth/R
        4+MVde5KIkcneGXAx1h5jebqJNoK2pz959pOhDMz2sOE54KHMSWfujzDhw34CHmo
        x4twPuV8FDMD1+RSnhpz/UiVgCNLF7aZORkVEWnXioIwMZ7IwrZipTwYZF6XsucV
        PQA8kUjO8EL/qujrVZmqhfBZMvG1z3ajL3hJDrpEYRBa9eMc56Ql/5QK2F/TKfdA
        ==
X-ME-Sender: <xms:5uGaYIe_jYPO-7cMguxCPHIx14GFXmOflqMggISfn8oFmGD7ScHU9g>
    <xme:5uGaYKPy10faArMJFuik1HTmiU0oowAB98ZEiJdNqvNZ7Kpp_YyEQ5Bbtr7tOwLTX
    kMS0KvhAqyVdlQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdehtddgudeggecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepkfguohcu
    ufgthhhimhhmvghluceoihguohhstghhsehiughoshgthhdrohhrgheqnecuggftrfgrth
    htvghrnheptdffkeekfeduffevgeeujeffjefhtefgueeugfevtdeiheduueeukefhudeh
    leetnecukfhppeekgedrvddvledrudehfedrudekjeenucevlhhushhtvghrufhiiigvpe
    dtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:5uGaYJgZlZoSjwW6x1dkq4nytp6eFgxvqCqCsHkoGN4ZbHCzq-Xu6Q>
    <xmx:5uGaYN_hfXP-gPbgP1quY6DkdRiFzpzGwxfGjASUwxRXam7cX7ij4Q>
    <xmx:5uGaYEtKXx0DtON_8ghOU2FBxkI-pK54khOtPN5w3EB2BRMnHu-xEQ>
    <xmx:5uGaYIgUFpeRPESLq5Xe4n0voJfDXimr9a5BE74wLWxQFjQvUWeolQ>
Received: from localhost (igld-84-229-153-187.inter.net.il [84.229.153.187])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Tue, 11 May 2021 15:58:29 -0400 (EDT)
Date:   Tue, 11 May 2021 22:58:26 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     David Ahern <dsahern@gmail.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        petrm@nvidia.com, roopa@nvidia.com, nikolay@nvidia.com,
        ssuryaextr@gmail.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: Re: [RFC PATCH net-next v2 02/10] ipv4: Add a sysctl to control
 multipath hash fields
Message-ID: <YJrh4nUgjnmZsVCh@shredder>
References: <20210509151615.200608-1-idosch@idosch.org>
 <20210509151615.200608-3-idosch@idosch.org>
 <59331028-c1a5-2a7a-1e27-57e62f95030f@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <59331028-c1a5-2a7a-1e27-57e62f95030f@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 11, 2021 at 09:10:46AM -0600, David Ahern wrote:
> On 5/9/21 9:16 AM, Ido Schimmel wrote:
> > diff --git a/Documentation/networking/ip-sysctl.rst b/Documentation/networking/ip-sysctl.rst
> > index c2ecc9894fd0..15982f830abc 100644
> > --- a/Documentation/networking/ip-sysctl.rst
> > +++ b/Documentation/networking/ip-sysctl.rst
> > @@ -100,6 +100,33 @@ fib_multipath_hash_policy - INTEGER
> >  	- 1 - Layer 4
> >  	- 2 - Layer 3 or inner Layer 3 if present
> >  
> > +fib_multipath_hash_fields - UNSIGNED INTEGER
> > +	When fib_multipath_hash_policy is set to 3 (custom multipath hash), the
> > +	fields used for multipath hash calculation are determined by this
> > +	sysctl.
> > +
> > +	This value is a bitmask which enables various fields for multipath hash
> > +	calculation.
> > +
> > +	Possible fields are:
> > +
> > +	====== ============================
> > +	0x0001 Source IP address
> > +	0x0002 Destination IP address
> > +	0x0004 IP protocol
> > +	0x0008 Unused
> 
> Document that this bit is flowlabel for IPv6 and ignored for ipv4.

OK
