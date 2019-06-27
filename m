Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 47B8B58ACD
	for <lists+netdev@lfdr.de>; Thu, 27 Jun 2019 21:12:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726441AbfF0TM4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jun 2019 15:12:56 -0400
Received: from mail.us.es ([193.147.175.20]:53778 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726384AbfF0TM4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 27 Jun 2019 15:12:56 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 9EC73C4146
        for <netdev@vger.kernel.org>; Thu, 27 Jun 2019 21:12:53 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 8DDD0202D2
        for <netdev@vger.kernel.org>; Thu, 27 Jun 2019 21:12:53 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 833A2DA4D1; Thu, 27 Jun 2019 21:12:53 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 65A43DA708;
        Thu, 27 Jun 2019 21:12:51 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 27 Jun 2019 21:12:51 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 419904265A32;
        Thu, 27 Jun 2019 21:12:51 +0200 (CEST)
Date:   Thu, 27 Jun 2019 21:12:50 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     wenxu@ucloud.cn
Cc:     fw@strlen.de, netfilter-devel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH 1/2 nf-next v2] netfilter: nft_meta: add
 NFT_META_BRI_O/IIFVPROTO support
Message-ID: <20190627191250.jttcfmt5uv7y536x@salvia>
References: <1561640835-4507-1-git-send-email-wenxu@ucloud.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1561640835-4507-1-git-send-email-wenxu@ucloud.cn>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 27, 2019 at 09:07:14PM +0800, wenxu@ucloud.cn wrote:
> From: wenxu <wenxu@ucloud.cn>
> 
> This patch provide a meta to get the bridge vlan proto
> 
> nft add rule bridge firewall zones counter meta br_iifvproto 0x8100
> 
> Signed-off-by: wenxu <wenxu@ucloud.cn>
> ---
>  include/uapi/linux/netfilter/nf_tables.h |  4 ++++
>  net/netfilter/nft_meta.c                 | 18 ++++++++++++++++++
>  2 files changed, 22 insertions(+)
> 
> diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
> index 8859535..0f75a6d 100644
> --- a/include/uapi/linux/netfilter/nf_tables.h
> +++ b/include/uapi/linux/netfilter/nf_tables.h
> @@ -796,6 +796,8 @@ enum nft_exthdr_attributes {
>   * @NFT_META_IIFKIND: packet input interface kind name (dev->rtnl_link_ops->kind)
>   * @NFT_META_OIFKIND: packet output interface kind name (dev->rtnl_link_ops->kind)
>   * @NFT_META_BRI_PVID: packet input bridge port pvid

An initial patch to re-name NFT_META_BRI_PVID to NFT_META_BRI_IIFVID
would be good, and to add NFT_META_BRI_OIFVID... if you have a usecase
for this, of course.

Thanks.
