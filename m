Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C97D449E6F0
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 17:03:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243471AbiA0QDJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jan 2022 11:03:09 -0500
Received: from wout4-smtp.messagingengine.com ([64.147.123.20]:33395 "EHLO
        wout4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S243470AbiA0QDD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jan 2022 11:03:03 -0500
Received: from compute2.internal (compute2.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id 654A832022BA;
        Thu, 27 Jan 2022 11:03:01 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute2.internal (MEProxy); Thu, 27 Jan 2022 11:03:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=5DAjFJrfQui823l8q
        iWTFnZAur3Gan3zT89TW6AziVE=; b=dO+yAa+hgpt88zcdnql0EQJsP7RPqI3fK
        SEazh//IStN3oxVwskw6z3LJAdyj3CrUnwfIKyWriR5mbj4+wVeEIl2h8+ZD5oa9
        yEwHIgCxcg1ke+CR439CZD5kkJQS/oEuQcVW2c58Y/cenrJYeKq3bItjSOW20WKm
        AcsMvOPNdDKNmOI3SZokyDUrPUuWljBjPhmXeKWvXVuA9CNmxoMx8BLgWGwnG6pK
        G5DDyaJjoXhHes5PvJTs6szKr1vD+71f9Mjkl4C/jU0Ct3zIkJAclemiOUw/ONn4
        qIrz9bCHqkdN1ZuujAniYC/nU5J0u2fcMrooY+FAq70hIn0bJuPgg==
X-ME-Sender: <xms:NMLyYX-ySmWh2AkAR3OpINigCb561Mmr19335UmovcgupgNRQM7w8Q>
    <xme:NMLyYTs2NjSQDLwXxKSYXMcM5A3ZEVWu6RDz9FCMVsNoJrs9sw-K2HIzKvvytx6pD
    tI5PQ16pKPI3YE>
X-ME-Received: <xmr:NMLyYVBxkg-AuXU6MiYDD5tMU1zcSJ_U9Hj1Dvx08m_BFqx0iS6rmjrxjel6r9iPXoGKl2Yh1KdR1XW_VaP6uadKqEdLDA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvvddrfeefgdekgecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepkfguohcuufgt
    hhhimhhmvghluceoihguohhstghhsehiughoshgthhdrohhrgheqnecuggftrfgrthhtvg
    hrnhephedugeduudeigfejteehiedvjedtgefhfefhvddukeekhefggeegudeifffhgfei
    necuffhomhgrihhnpeifihhrvghshhgrrhhkrdhorhhgnecuvehluhhsthgvrhfuihiivg
    eptdenucfrrghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhr
    gh
X-ME-Proxy: <xmx:NMLyYTeLy02XlHTxiMHl7mriZsPPeayj0wMoXLb-jSkg05ISHbJJSg>
    <xmx:NMLyYcN0tUPg0fKOPcn7AIzA1lkPCKz_dA6PZJT7T8szHHMxdBgiFg>
    <xmx:NMLyYVmF1Bn8UexkSQt4h-f-0MIHqJObF6k5_SID9MrCmfDUSKMIwQ>
    <xmx:NMLyYTfFVVPhYfLL-ixUK3UF4dRgG8gCpiRB_2RmwfS9N9rMNuyrCQ>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 27 Jan 2022 11:02:59 -0500 (EST)
Date:   Thu, 27 Jan 2022 18:02:56 +0200
From:   Ido Schimmel <idosch@idosch.org>
To:     David Ahern <dsahern@gmail.com>
Cc:     menglong8.dong@gmail.com, kuba@kernel.org, nhorman@tuxdriver.com,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, dsahern@kernel.org,
        rostedt@goodmis.org, Menglong Dong <imagedong@tencent.com>
Subject: Re: [PATCH v3 net-next] net: drop_monitor: support drop reason
Message-ID: <YfLCMFXbGTgef5Uu@shredder>
References: <20220127033356.4050072-1-imagedong@tencent.com>
 <cdb189e9-a804-bb02-9490-146acf8ca0a6@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cdb189e9-a804-bb02-9490-146acf8ca0a6@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 27, 2022 at 08:53:04AM -0700, David Ahern wrote:
> On 1/26/22 8:33 PM, menglong8.dong@gmail.com wrote:
> > From: Menglong Dong <imagedong@tencent.com>
> > 
> > In the commit c504e5c2f964 ("net: skb: introduce kfree_skb_reason()")
> > drop reason is introduced to the tracepoint of kfree_skb. Therefore,
> > drop_monitor is able to report the drop reason to users by netlink.
> > 
> > For now, the number of drop reason is passed to users ( seems it's
> > a little troublesome to pass the drop reason as string ). Therefore,
> > users can do some customized description of the reason.
> > 
> > Signed-off-by: Menglong Dong <imagedong@tencent.com>
> > ---
> > v3:
> > - referring to cb->reason and cb->pc directly in
> >   net_dm_packet_report_fill()
> > 
> > v2:
> > - get a pointer to struct net_dm_skb_cb instead of local var for
> >   each field
> > ---
> >  include/uapi/linux/net_dropmon.h |  1 +
> >  net/core/drop_monitor.c          | 16 ++++++++++++----
> >  2 files changed, 13 insertions(+), 4 deletions(-)
> > 
> > diff --git a/include/uapi/linux/net_dropmon.h b/include/uapi/linux/net_dropmon.h
> > index 66048cc5d7b3..b2815166dbc2 100644
> > --- a/include/uapi/linux/net_dropmon.h
> > +++ b/include/uapi/linux/net_dropmon.h
> > @@ -93,6 +93,7 @@ enum net_dm_attr {
> >  	NET_DM_ATTR_SW_DROPS,			/* flag */
> >  	NET_DM_ATTR_HW_DROPS,			/* flag */
> >  	NET_DM_ATTR_FLOW_ACTION_COOKIE,		/* binary */
> > +	NET_DM_ATTR_REASON,			/* u32 */
> >  
> 
> For userspace to properly convert reason from id to string, enum
> skb_drop_reason needs to be moved from skbuff.h to a uapi file.
> include/uapi/linux/net_dropmon.h seems like the best candidate to me.
> Maybe others have a better idea.

I think the best option would be to convert it to a string in the kernel
(or report both). Then you don't need to update user space tools such as
the Wireshark dissector [1] and DropWatch every time a new reason is
added.

[1] https://www.wireshark.org/docs/dfref/n/net_dm.html
