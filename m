Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A3B143C446
	for <lists+netdev@lfdr.de>; Wed, 27 Oct 2021 09:45:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240613AbhJ0HsL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Oct 2021 03:48:11 -0400
Received: from new1-smtp.messagingengine.com ([66.111.4.221]:39675 "EHLO
        new1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240609AbhJ0HsK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Oct 2021 03:48:10 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailnew.nyi.internal (Postfix) with ESMTP id 32ACF580464;
        Wed, 27 Oct 2021 03:45:45 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Wed, 27 Oct 2021 03:45:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=DkDJ3l
        cmtZdA72BLSb8N8otaG02Ed1Gxqos8Wk9KsPg=; b=ijRR+n1s4F6t5e95Ax6RJJ
        Jv6p4CsvNjBHu2bIftVSjv91XHdnAFCieh3IqPbRzqj5ASYW3kYO5EdwTnWafkCC
        PF+8lrGQHLClbUqRfgO+DEQtPJiVGsBcLifPSQnHGD0jHH+C1idFFMiCctWJtElf
        VaaWvwCzyOfErzRd1sXYzoPuvsjwchHApemfw+/NtBmXYNYiNyzTbL2wN2S1I8M0
        f079vSrx/bt8faCkJV0T50I5j16Ugwe6NMK1FuYDqXjKcX6XN9wc1U5ThUarkYms
        6cegerJSOONvBdI4MslIL8Mmzb3r/O9PzkU2/lIjthur3XFvq4OKhodAID8IVmBQ
        ==
X-ME-Sender: <xms:qAN5YfIDNPj3fP_Vyaeoe38Cv8EX5L60zAsT0CTPy3QpbF_QNrre8g>
    <xme:qAN5YTI2vzCpUNYhcp_LFGJiv3kadzP3DWTr9Qohicrsf_DEjYVYN3f5PR84mZV51
    pMJ9U2CzAepL14>
X-ME-Received: <xmr:qAN5YXtXk9Vn4aHe07UG-BxD8FCBOaS1Z0UEzwiPqWGXcp46dDl4PcFJVzEuHXnmhieom9iJzwQH430jy5kGOlqO4tQ8jA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrvdefledguddujecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepkfguohcu
    ufgthhhimhhmvghluceoihguohhstghhsehiughoshgthhdrohhrgheqnecuggftrfgrth
    htvghrnheptdffkeekfeduffevgeeujeffjefhtefgueeugfevtdeiheduueeukefhudeh
    leetnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepih
    guohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:qAN5YYYtnORZraZA4scfF2AYFsWS_F-eBa4zyIxxqUlQQCwthr5Z1Q>
    <xmx:qAN5YWaKMQ_ZNMDIRc1SV4Vm3MELRSwFlMIHEYxIk6-iQw2-i_3aHg>
    <xmx:qAN5YcAtXoWAA-JwyNC8OBZL7ay-XJ0PZZk9XqbERMx_wZUOyNlN0w>
    <xmx:qQN5Ycm7z0ELZ6HFoL52iGCBZrFKQWRmAa3SR1ZynhkqlaRuulpdNw>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 27 Oct 2021 03:45:44 -0400 (EDT)
Date:   Wed, 27 Oct 2021 10:45:42 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, Ido Schimmel <idosch@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Jiri Pirko <jiri@nvidia.com>
Subject: Re: [PATCH net-next 1/8] net: bridge: remove fdb_notify forward
 declaration
Message-ID: <YXkDpsNdvHn4ujTl@shredder>
References: <20211026142743.1298877-1-vladimir.oltean@nxp.com>
 <20211026142743.1298877-2-vladimir.oltean@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211026142743.1298877-2-vladimir.oltean@nxp.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 26, 2021 at 05:27:36PM +0300, Vladimir Oltean wrote:
> fdb_notify() has a forward declaration because its first caller,
> fdb_delete(), is declared before 3 functions that fdb_notify() needs:
> fdb_to_nud(), fdb_fill_info() and fdb_nlmsg_size().
> 
> This patch moves the aforementioned 4 functions above fdb_delete() and
> deletes the forward declaration.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Ido Schimmel <idosch@nvidia.com>
