Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 40D4F22784
	for <lists+netdev@lfdr.de>; Sun, 19 May 2019 19:12:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726914AbfESRMD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 May 2019 13:12:03 -0400
Received: from smtp-fw-9101.amazon.com ([207.171.184.25]:28200 "EHLO
        smtp-fw-9101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725766AbfESRMD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 May 2019 13:12:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1558285922; x=1589821922;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=J1vl5M1keleXlZgsvzi8J6frh7/gSA5HYBC6cZZStC4=;
  b=anUVXEEXpDspEKuxu4kcXuSynFtDCBVt8z3EKKbXOuc7dD08U3iWtGQJ
   rmbwWg8JdHQG4FGJzDou88psttp0tqzWkeNWv6XKvkTaI0LxqafJZBFqf
   0m/wi1AXKaoSuREk+KG9tgeppx+5jNO4AIq8VAWfYgqQLqX155q7H46Tv
   g=;
X-IronPort-AV: E=Sophos;i="5.60,488,1549929600"; 
   d="scan'208";a="805402622"
Received: from sea3-co-svc-lb6-vlan3.sea.amazon.com (HELO email-inbound-relay-2a-119b4f96.us-west-2.amazon.com) ([10.47.22.38])
  by smtp-border-fw-out-9101.sea19.amazon.com with ESMTP/TLS/DHE-RSA-AES256-SHA; 19 May 2019 15:26:22 +0000
Received: from EX13MTAUEA001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-2a-119b4f96.us-west-2.amazon.com (8.14.7/8.14.7) with ESMTP id x4JFQHfF006464
        (version=TLSv1/SSLv3 cipher=AES256-SHA bits=256 verify=FAIL);
        Sun, 19 May 2019 15:26:22 GMT
Received: from EX13D19EUB003.ant.amazon.com (10.43.166.69) by
 EX13MTAUEA001.ant.amazon.com (10.43.61.82) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Sun, 19 May 2019 15:26:22 +0000
Received: from 8c85908914bf.ant.amazon.com (10.43.160.4) by
 EX13D19EUB003.ant.amazon.com (10.43.166.69) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Sun, 19 May 2019 15:26:19 +0000
Subject: Re: [PATCH iproute2] rdma: Update node type strings
To:     Stephen Hemminger <stephen@networkplumber.org>
CC:     <netdev@vger.kernel.org>, Leon Romanovsky <leon@kernel.org>
References: <1557903516-14860-1-git-send-email-galpress@amazon.com>
From:   Gal Pressman <galpress@amazon.com>
Message-ID: <5ccc0a08-7932-4896-d0dc-9bbc8ea2b71e@amazon.com>
Date:   Sun, 19 May 2019 18:26:00 +0300
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.13; rv:60.0)
 Gecko/20100101 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <1557903516-14860-1-git-send-email-galpress@amazon.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.43.160.4]
X-ClientProxiedBy: EX13P01UWB003.ant.amazon.com (10.43.161.209) To
 EX13D19EUB003.ant.amazon.com (10.43.166.69)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 15/05/2019 9:58, Gal Pressman wrote:
> Fix typo in usnic_udp node type and add a string for the unspecified
> node type.
> 
> Signed-off-by: Gal Pressman <galpress@amazon.com>
> ---
>  rdma/dev.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/rdma/dev.c b/rdma/dev.c
> index 339625202200..904836221c1b 100644
> --- a/rdma/dev.c
> +++ b/rdma/dev.c
> @@ -170,7 +170,8 @@ static const char *node_type_to_str(uint8_t node_type)
>  	static const char * const node_type_str[] = { "unknown", "ca",
>  						      "switch", "router",
>  						      "rnic", "usnic",
> -						      "usnic_dp" };
> +						      "usnic_udp",
> +						      "unspecified" };
>  	if (node_type < ARRAY_SIZE(node_type_str))
>  		return node_type_str[node_type];
>  	return "unknown";
> 

Sorry, forgot to add Stephen.
