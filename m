Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB911363B1D
	for <lists+netdev@lfdr.de>; Mon, 19 Apr 2021 07:48:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232073AbhDSFsf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Apr 2021 01:48:35 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:33657 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230392AbhDSFsf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Apr 2021 01:48:35 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 94D235C039E;
        Mon, 19 Apr 2021 01:48:05 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Mon, 19 Apr 2021 01:48:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=j/e8a3
        qQql0tN+k4Xa4i1asqnsgycUpoWvwOCFIwSSk=; b=eyAcjb4Yvbz8vAnxl3C21u
        VA/IUTxU8Ntq6olGvHYf9e5hk/pK2gtub1siRav7RzO7NjCsvDpL49wjYX0qQwPQ
        D5EZhoKYRqSZDwTgjHhAN2rdRikptTm+7Ny9Ly1AEvw5C78vwlYVPtbaacFmttx5
        pIpGf8YKaxXSrHPYw7L5dvRMcbf6tZX8A/AIkyFJP1AUBxroQln/CqM4GfbYmp2P
        JtaVqm6ne+yyhti5w2PGpjhCbgaRPtoPq3E3rX8IpkNPMewWRRa14mQWJtCGg8vd
        GK9sIVfzdq6cVuzlk1f34PaMT/tkoZy9wgA5D6x+Wf1P8o5DVw8S9PC2HbnCy2gw
        ==
X-ME-Sender: <xms:lRl9YK6hXIqQFDNdfXxFsyBj09CZbf8ancXMu9ybTtNuhSt7MtEExQ>
    <xme:lRl9YD5HEVtf6WchP80HQuGQMK-OU0yjlGS6IWseJ8r_e8ibQhlVn-zRCoqHmjdOT
    ZyiNgjePI13w4M>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvddtvddgudeffecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepkfguohcu
    ufgthhhimhhmvghluceoihguohhstghhsehiughoshgthhdrohhrgheqnecuggftrfgrth
    htvghrnheptdffkeekfeduffevgeeujeffjefhtefgueeugfevtdeiheduueeukefhudeh
    leetnecukfhppeekgedrvddvledrudehfedrudekjeenucevlhhushhtvghrufhiiigvpe
    dtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:lRl9YJdh5bS-rut3JmzpkctdSdHRZpddXW8VmwpJJgIUyfzSfDarIQ>
    <xmx:lRl9YHKjb0lHWTi3wur23vYQ4X1Z6GLHjpZ01B-5tmD0pqadhbO2Nw>
    <xmx:lRl9YOLHvFaIr9HVLnu3pSqNBTg4-PtxxoEc_j4pzXuskVTuGmL6ZA>
    <xmx:lRl9YK2OJZQABpXgFPYOg0zaobVgHhCr_An1qxGlLdK7PjhAuZK1dw>
Received: from localhost (igld-84-229-153-187.inter.net.il [84.229.153.187])
        by mail.messagingengine.com (Postfix) with ESMTPA id C4C6E108005B;
        Mon, 19 Apr 2021 01:48:04 -0400 (EDT)
Date:   Mon, 19 Apr 2021 08:48:01 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     David Ahern <dsahern@gmail.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        petrm@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: Re: [PATCH net-next 1/2] nexthop: Restart nexthop dump based on last
 dumped nexthop identifier
Message-ID: <YH0ZkeP1OVLeASpY@shredder.lan>
References: <20210416155535.1694714-1-idosch@idosch.org>
 <20210416155535.1694714-2-idosch@idosch.org>
 <91838deb-c82d-444e-6a19-3926aeff87f2@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <91838deb-c82d-444e-6a19-3926aeff87f2@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Apr 18, 2021 at 10:06:41AM -0700, David Ahern wrote:
> On 4/16/21 8:55 AM, Ido Schimmel wrote:
> > From: Ido Schimmel <idosch@nvidia.com>
> > 
> > Currently, a multi-part nexthop dump is restarted based on the number of
> > nexthops that have been dumped so far. This can result in a lot of
> > nexthops not being dumped when nexthops are simultaneously deleted:
> > 
> >  # ip nexthop | wc -l
> >  65536
> >  # ip nexthop flush
> >  Dump was interrupted and may be inconsistent.
> >  Flushed 36040 nexthops
> >  # ip nexthop | wc -l
> >  29496
> > 
> > Instead, restart the dump based on the nexthop identifier (fixed number)
> > of the last successfully dumped nexthop:
> > 
> >  # ip nexthop | wc -l
> >  65536
> >  # ip nexthop flush
> >  Dump was interrupted and may be inconsistent.
> >  Flushed 65536 nexthops
> >  # ip nexthop | wc -l
> >  0
> > 
> > Reported-by: Maksym Yaremchuk <maksymy@nvidia.com>
> > Tested-by: Maksym Yaremchuk <maksymy@nvidia.com>
> > Signed-off-by: Ido Schimmel <idosch@nvidia.com>
> > Reviewed-by: Petr Machata <petrm@nvidia.com>
> > ---
> >  net/ipv4/nexthop.c | 14 ++++++--------
> >  1 file changed, 6 insertions(+), 8 deletions(-)
> > 
> 
> Reviewed-by: David Ahern <dsahern@kernel.org>

Thanks

> 
> Any reason not to put this in -net with a Fixes tag?

I put it in the cover letter:

"Targeting at net-next since this use case never worked, the flow is
pretty obscure and such a large number of nexthops is unlikely to be
used in any real-world scenario."
