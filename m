Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E2534A354C
	for <lists+netdev@lfdr.de>; Sun, 30 Jan 2022 10:12:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354420AbiA3JM1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 Jan 2022 04:12:27 -0500
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:32783 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1354000AbiA3JM0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 30 Jan 2022 04:12:26 -0500
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id 61ECA5C00B2;
        Sun, 30 Jan 2022 04:12:24 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Sun, 30 Jan 2022 04:12:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=lbirjujgVm4plokI+
        I3hqA6TThhnxYuCVw0vfAVWVJ0=; b=RxfMLSNOJeNm8dBZqnM0w43/h9UnUpOiz
        8eLbY+pNyCHrXj1L0pb+vwQo+txa23vQsiMVCWWXlGKrytqiR9PdbYFgmk1gRjmG
        CgY1tCXpHDDhMqsh3qbCke22BpRwnmh7x75vHVyZruxFyA5weR64uuQg+VWZa/b1
        QIXXTP5B5jrpcYPhOfBc7h4VwcOevVOVmerCSloZ2nolJ+bHAvk88TWOxgczBcXl
        8o3yUyHyIJ+Y+SuSGYWiAp9WFtLBFbTxeFf2/wxLoGMz+wUHw346PYp3epNCf6td
        wDeoXpTR/pR+MLJIWlHV2MukfzPcz4aUJTMuMMmUpqua2B5cHjBiQ==
X-ME-Sender: <xms:d1b2Yfij0LmOPMpmsN81m_YkqQZzZsgq9QJ5dpYXKlwUV36JcM-uCQ>
    <xme:d1b2YcC8vBGwoLnXaQ0f-1FXXmjadM1MXpRh7NINdtnrCE4fW9eLoS-zoX3NqB5Cb
    YlnT2jhgpzPCNE>
X-ME-Received: <xmr:d1b2YfE1UZd1rymercKTYyjVn3bjO0VlVqS1quQIlOfV2b0EzW_lQ6gUAasRZBwJe2IqmcJVkISLbQIixAlHnSln1_-DoQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvvddrfeelgddtudcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepkfguohcuufgt
    hhhimhhmvghluceoihguohhstghhsehiughoshgthhdrohhrgheqnecuggftrfgrthhtvg
    hrnheptdffkeekfeduffevgeeujeffjefhtefgueeugfevtdeiheduueeukefhudehleet
    necuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepihguoh
    hstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:d1b2YcTpGWHiZDJWAselaF0UNlSxOkHAcSPNiXdcsbnSTAwjH2A96g>
    <xmx:d1b2YcxkAlW_PApHvAokKm6XeI-hOflyXrPDTbvsv8h-cOE8zAue9g>
    <xmx:d1b2YS7Piq2wQsOzYKNXbSpC5CQZP9Nywn7j0lOG53cxCMBQsLiJdw>
    <xmx:eFb2YTn3DsfoEQFNP1mpq9qg9R9XP9il5ZFaAUbTZgTyJ21FLxyXQg>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 30 Jan 2022 04:12:22 -0500 (EST)
Date:   Sun, 30 Jan 2022 11:12:19 +0200
From:   Ido Schimmel <idosch@idosch.org>
To:     menglong8.dong@gmail.com
Cc:     kuba@kernel.org, rostedt@goodmis.org, nhorman@tuxdriver.com,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, dsahern@kernel.org,
        Menglong Dong <imagedong@tencent.com>
Subject: Re: [PATCH v4 net-next] net: drop_monitor: support drop reason
Message-ID: <YfZWcxX/3eDM+x/5@shredder>
References: <20220128045727.910974-1-imagedong@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220128045727.910974-1-imagedong@tencent.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 28, 2022 at 12:57:27PM +0800, menglong8.dong@gmail.com wrote:
>  #define NET_DM_SKB_CB(__skb) ((struct net_dm_skb_cb *)&((__skb)->cb[0]))
> @@ -498,6 +509,7 @@ static void net_dm_packet_trace_kfree_skb_hit(void *ignore,
>  {
>  	ktime_t tstamp = ktime_get_real();
>  	struct per_cpu_dm_data *data;
> +	struct net_dm_skb_cb *cb;
>  	struct sk_buff *nskb;
>  	unsigned long flags;
>  
> @@ -508,7 +520,9 @@ static void net_dm_packet_trace_kfree_skb_hit(void *ignore,
>  	if (!nskb)
>  		return;
>  
> -	NET_DM_SKB_CB(nskb)->pc = location;
> +	cb = NET_DM_SKB_CB(nskb);
> +	cb->reason = reason;
> +	cb->pc = location;
>  	/* Override the timestamp because we care about the time when the
>  	 * packet was dropped.
>  	 */
> @@ -606,7 +620,7 @@ static int net_dm_packet_report_in_port_put(struct sk_buff *msg, int ifindex,
>  static int net_dm_packet_report_fill(struct sk_buff *msg, struct sk_buff *skb,
>  				     size_t payload_len)
>  {
> -	u64 pc = (u64)(uintptr_t) NET_DM_SKB_CB(skb)->pc;
> +	struct net_dm_skb_cb *cb = NET_DM_SKB_CB(skb);
>  	char buf[NET_DM_MAX_SYMBOL_LEN];
>  	struct nlattr *attr;
>  	void *hdr;
> @@ -620,10 +634,15 @@ static int net_dm_packet_report_fill(struct sk_buff *msg, struct sk_buff *skb,
>  	if (nla_put_u16(msg, NET_DM_ATTR_ORIGIN, NET_DM_ORIGIN_SW))
>  		goto nla_put_failure;
>  
> -	if (nla_put_u64_64bit(msg, NET_DM_ATTR_PC, pc, NET_DM_ATTR_PAD))
> +	if (nla_put_u64_64bit(msg, NET_DM_ATTR_PC, (u64)(uintptr_t)cb->pc,
> +			      NET_DM_ATTR_PAD))
> +		goto nla_put_failure;
> +
> +	if (nla_put_string(msg, NET_DM_ATTR_REASON,
> +			   drop_reasons[cb->reason]))
>  		goto nla_put_failure;

Need to take the size into account when performing the allocation in
net_dm_packet_report_size()

>  
> -	snprintf(buf, sizeof(buf), "%pS", NET_DM_SKB_CB(skb)->pc);
> +	snprintf(buf, sizeof(buf), "%pS", cb->pc);
>  	if (nla_put_string(msg, NET_DM_ATTR_SYMBOL, buf))
>  		goto nla_put_failure;
>  
> -- 
> 2.27.0
> 
