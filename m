Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D392C1F347D
	for <lists+netdev@lfdr.de>; Tue,  9 Jun 2020 08:56:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728039AbgFIGzy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Jun 2020 02:55:54 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:45221 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726886AbgFIGzx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Jun 2020 02:55:53 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id B00815C0057;
        Tue,  9 Jun 2020 02:55:51 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Tue, 09 Jun 2020 02:55:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=K8ADmm
        X7v+hv/X8ogy48EiWtb/0gZSHGu5XCN38uzLo=; b=iianZOFy5NXWR1Q3QRxzAs
        TYGq2I78ucdzlzojnu3c1HIKqiWWb9EE1y1X0PIZ7QnBWShyUFgeQGdIJ44V0oZR
        thmfmqrlGRFWH61BP4mSxFih5Riimag7FTm4RYCMWWEdqCkDGagO6JrfJyeBiBso
        EVx7VdEZ0KlnQtEsq5W3DFOw2V+mnO02fyLcxoSYiwZO1BSviqR0guK2JKMkn0mo
        CQsnNHP+n/6AlCrpqPMMMwFwnA4D8gKVPowjHGud6nnzSmHLf2cIVKqGBZF5yrnT
        fG/gMeVRepjXAEXgkO9i1s+s3sVPAup0l5pbaST9Y+Nb67J+Ryzj5Un03wz9XaLQ
        ==
X-ME-Sender: <xms:dzLfXkBp8Ej708ahrJZ8hMkWh6g7Z-ap4qFSrTQb9p4HrUAymXq9ag>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrudehfedgudduiecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepkfguohcu
    ufgthhhimhhmvghluceoihguohhstghhsehiughoshgthhdrohhrgheqnecuggftrfgrth
    htvghrnhephefgueetjedtgfelffelhfehleelteeiuddtvefhfedvgfdvteejuedvgfdu
    veefnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghdpihgvthhfrdhorhhgnecukfhppe
    ejledrudejkedrgeehrddvvdefnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghm
    pehmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:dzLfXmhs4tuSyfhCuUzkC6RCMX6pk9Q5wjQ--zydiRfxPA6V3KNQIA>
    <xmx:dzLfXnnwDSTVUqFkaOQC_bzVlGhN28LsDEXW12srjUz1RPBp27BVYA>
    <xmx:dzLfXqyFa8LS_BxMNM0ZjVXDwsYRhg1rBm8woioD-XiNYbQsldB2qQ>
    <xmx:dzLfXkcCUJE_TIvTXnc0Qdcm5fR0ll78Euk28JADyGjv0CGS8q76oA>
Received: from localhost (bzq-79-178-45-223.red.bezeqint.net [79.178.45.223])
        by mail.messagingengine.com (Postfix) with ESMTPA id 13EEF328005D;
        Tue,  9 Jun 2020 02:55:50 -0400 (EDT)
Date:   Tue, 9 Jun 2020 09:55:48 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Ido Schimmel <idosch@mellanox.com>,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 5.7 264/274] vxlan: Avoid infinite loop when
 suppressing NS messages with invalid options
Message-ID: <20200609065548.GA2113611@splinter>
References: <20200608230607.3361041-1-sashal@kernel.org>
 <20200608230607.3361041-264-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200608230607.3361041-264-sashal@kernel.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 08, 2020 at 07:05:57PM -0400, Sasha Levin wrote:
> From: Ido Schimmel <idosch@mellanox.com>
> 
> [ Upstream commit 8066e6b449e050675df48e7c4b16c29f00507ff0 ]

Hi,

In the same patch set I also included a similar fix for the bridge
module:
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=53fc685243bd6fb90d90305cea54598b78d3cbfc

But I don't see it in the patch sets you sent.

Don't see it here as well:
https://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git/tree/queue-5.7
https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/log/?h=linux-5.7.y

Did it get lost or it's just pending somewhere else?

Thanks

> 
> When proxy mode is enabled the vxlan device might reply to Neighbor
> Solicitation (NS) messages on behalf of remote hosts.
> 
> In case the NS message includes the "Source link-layer address" option
> [1], the vxlan device will use the specified address as the link-layer
> destination address in its reply.
> 
> To avoid an infinite loop, break out of the options parsing loop when
> encountering an option with length zero and disregard the NS message.
> 
> This is consistent with the IPv6 ndisc code and RFC 4886 which states
> that "Nodes MUST silently discard an ND packet that contains an option
> with length zero" [2].
> 
> [1] https://tools.ietf.org/html/rfc4861#section-4.3
> [2] https://tools.ietf.org/html/rfc4861#section-4.6
> 
> Fixes: 4b29dba9c085 ("vxlan: fix nonfunctional neigh_reduce()")
> Signed-off-by: Ido Schimmel <idosch@mellanox.com>
> Acked-by: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
> Signed-off-by: David S. Miller <davem@davemloft.net>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  drivers/net/vxlan.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/drivers/net/vxlan.c b/drivers/net/vxlan.c
> index a5b415fed11e..779e56c43d27 100644
> --- a/drivers/net/vxlan.c
> +++ b/drivers/net/vxlan.c
> @@ -1924,6 +1924,10 @@ static struct sk_buff *vxlan_na_create(struct sk_buff *request,
>  	ns_olen = request->len - skb_network_offset(request) -
>  		sizeof(struct ipv6hdr) - sizeof(*ns);
>  	for (i = 0; i < ns_olen-1; i += (ns->opt[i+1]<<3)) {
> +		if (!ns->opt[i + 1]) {
> +			kfree_skb(reply);
> +			return NULL;
> +		}
>  		if (ns->opt[i] == ND_OPT_SOURCE_LL_ADDR) {
>  			daddr = ns->opt + i + sizeof(struct nd_opt_hdr);
>  			break;
> -- 
> 2.25.1
> 
