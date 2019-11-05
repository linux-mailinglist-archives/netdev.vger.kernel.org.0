Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 779FAEF692
	for <lists+netdev@lfdr.de>; Tue,  5 Nov 2019 08:46:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387804AbfKEHqy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Nov 2019 02:46:54 -0500
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:58747 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2387482AbfKEHqy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Nov 2019 02:46:54 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 44F9221F3C;
        Tue,  5 Nov 2019 02:46:53 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Tue, 05 Nov 2019 02:46:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=zI52HG
        wmHmVQDk2QPsF/mE4A8BuLMVUXTDQb7bAD0Cw=; b=KiMNbqtiyUy0c2cA2YzlNA
        iJc9QYrfADhA7tV6mjzKA7qxQA/dqwbT59MVDm35coqUr1+lNtwpkXO6Y6x8dxty
        7E1E+30/u5tw+mjvfXVfVmHg0S6zIcww6bOilQL0oLEKf24IkOfdq5vIXjnQxSjL
        Zi7DoECpcz4s9aqOh3ptgofL8YyBz9EpZROhEPWLdohUuQARrtrtY9p/+JBDp7dd
        /bXGze6C3Yjx1R+lyffwvvQvrJ7N0Y0UOBkxN9PIun/EIUFhh4fP4z2YTqkMkv3N
        oEQo29MuoNqDBWp6RR2pSRjBKXYx+xrb118dt5qlpXtIJsGeqjbhCf2uAXZqmpsQ
        ==
X-ME-Sender: <xms:7CjBXchSFhkLiUiSGQbFnKHF3JuBSQzqKerWctBg-Qg3BBH3BB3Hxw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedruddugedguddufecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvuffkfhggtggujggfsehttdertddtredvnecuhfhrohhmpefkugho
    ucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucfkphepud
    elfedrgeejrdduieehrddvhedunecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgt
    hhesihguohhstghhrdhorhhgnecuvehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:7CjBXev8knPxkjPuYt3owdJTE4iql7H3mw3tLI9GDGOsQO2uJ8kUhQ>
    <xmx:7CjBXbCx7fKEJBAzugg2-Ev9ntnpytx5rUdOGH1Wf8uC94nzltjZNQ>
    <xmx:7CjBXRXlUA_nDzYEYljfEnptqg5eGyytLwPT7YubuEl30mrQ054AlA>
    <xmx:7SjBXUBfoucLrcVFJgcobGB70d79kg_zw4VLnJ9L7-cAaledF23puw>
Received: from localhost (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 46F838005A;
        Tue,  5 Nov 2019 02:46:52 -0500 (EST)
Date:   Tue, 5 Nov 2019 09:46:50 +0200
From:   Ido Schimmel <idosch@idosch.org>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, jiri@mellanox.com,
        shalomt@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: Re: [PATCH net-next 0/6] mlxsw: Add extended ACK for EMADs
Message-ID: <20191105074650.GA14631@splinter>
References: <20191103083554.6317-1-idosch@idosch.org>
 <20191104123954.538d4574@cakuba.netronome.com>
 <20191104210450.GA10713@splinter>
 <20191104144419.46e304a9@cakuba.netronome.com>
 <20191104232036.GA12725@splinter>
 <20191104153342.36891db7@cakuba.netronome.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191104153342.36891db7@cakuba.netronome.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 04, 2019 at 03:33:42PM -0800, Jakub Kicinski wrote:
> On Tue, 5 Nov 2019 01:20:36 +0200, Ido Schimmel wrote:
> > On Mon, Nov 04, 2019 at 02:44:19PM -0800, Jakub Kicinski wrote:
> > > On Mon, 4 Nov 2019 23:04:50 +0200, Ido Schimmel wrote:  
> > > > I don't understand the problem. If we get an error from firmware today,
> > > > we have no clue what the actual problem is. With this we can actually
> > > > understand what went wrong. How is it different from kernel passing a
> > > > string ("unstructured data") to user space in response to an erroneous
> > > > netlink request? Obviously it's much better than an "-EINVAL".  
> > > 
> > > The difference is obviously that I can look at the code in the kernel
> > > and understand it. FW code is a black box. Kernel should abstract its
> > > black boxiness away.  
> > 
> > But FW code is still code and it needs to be able to report errors in a
> > way that will aid us in debugging when problems occur. I want meaningful
> > errors from applications regardless if I can read their code or not.
> 
> And the usual way accessing FW logs is through ethtool dumps.

I assume you're referring to set_dump() / get_dump_flag() /
get_dump_data() callbacks?

In our case it's not really a dump. These are errors that are reported
inline to the driver for a specific erroneous operation. We currently
can't retrieve them from firmware later on. Using ethtool means that we
need to store these errors in the driver and then push them to user
space upon get operation. Seems like a stretch to me. Especially when
we're already reporting the error code today and this set merely
augments it with more data to make the error more specific.
