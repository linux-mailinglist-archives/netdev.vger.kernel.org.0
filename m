Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C3453660CF
	for <lists+netdev@lfdr.de>; Tue, 20 Apr 2021 22:24:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233873AbhDTUYA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Apr 2021 16:24:00 -0400
Received: from gateway22.websitewelcome.com ([192.185.47.79]:47360 "EHLO
        gateway22.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233548AbhDTUX7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Apr 2021 16:23:59 -0400
Received: from cm13.websitewelcome.com (cm13.websitewelcome.com [100.42.49.6])
        by gateway22.websitewelcome.com (Postfix) with ESMTP id BA0DD19747
        for <netdev@vger.kernel.org>; Tue, 20 Apr 2021 15:23:26 -0500 (CDT)
Received: from gator4166.hostgator.com ([108.167.133.22])
        by cmsmtp with SMTP
        id Ywu6lPxvumJLsYwu6lmyQJ; Tue, 20 Apr 2021 15:23:26 -0500
X-Authority-Reason: nr=8
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=embeddedor.com; s=default; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=nKsGWZKmz5l1HXMaU8LILLT9LIU27G49jkyG+Xsurs4=; b=HgiFk4IdwutBybeef14/asu0P6
        a+vyVbBKOH1OOonccuOf42EiiMFdoH6J7j6mTRcl8N7FHs1XMRAdrB4dE0Po6tMVQq1FG9WkGzxUX
        doZuBIwidnlSL9ZycPDa0H9iv1VfCJ71lEGrhNwYvpDH9z3nftPZgTJpe27AJsLv27izc7bW/MsqS
        TgZaFvgX5gACQ6guam2wyharEPMF5W1hxIUwApD6lzyMV4J/gG+yMq67Hz3uT9aEyyu68bzBFFRx0
        ePF2lTCN2Ay4BWBSDvbZwA2Y7zsVeWIXbGvzHDcptXkX3dolSz5+CAIZ1bOq1psqLI0HYrkEeNVhL
        bueT8Vxw==;
Received: from 187-162-31-110.static.axtel.net ([187.162.31.110]:49024 helo=[192.168.15.8])
        by gator4166.hostgator.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94)
        (envelope-from <gustavo@embeddedor.com>)
        id 1lYwu3-0030Jp-9x; Tue, 20 Apr 2021 15:23:23 -0500
Subject: Re: [PATCH RESEND][next] nfp: Fix fall-through warnings for Clang
To:     Simon Horman <simon.horman@netronome.com>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, oss-drivers@netronome.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-hardening@vger.kernel.org
References: <20210305094937.GA141307@embeddedor>
 <20210305121949.GF8899@netronome.com>
From:   "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Message-ID: <b4fd4c37-ccd6-3cbb-a127-3b2ad9516871@embeddedor.com>
Date:   Tue, 20 Apr 2021 15:23:39 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210305121949.GF8899@netronome.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - gator4166.hostgator.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - embeddedor.com
X-BWhitelist: no
X-Source-IP: 187.162.31.110
X-Source-L: No
X-Exim-ID: 1lYwu3-0030Jp-9x
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: 187-162-31-110.static.axtel.net ([192.168.15.8]) [187.162.31.110]:49024
X-Source-Auth: gustavo@embeddedor.com
X-Email-Count: 148
X-Source-Cap: Z3V6aWRpbmU7Z3V6aWRpbmU7Z2F0b3I0MTY2Lmhvc3RnYXRvci5jb20=
X-Local-Domain: yes
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi all,

Friendly ping: who can take this, please?

Thanks
--
Gustavo

On 3/5/21 06:19, Simon Horman wrote:
> On Fri, Mar 05, 2021 at 03:49:37AM -0600, Gustavo A. R. Silva wrote:
>> In preparation to enable -Wimplicit-fallthrough for Clang, fix a warning
>> by explicitly adding a break statement instead of letting the code fall
>> through to the next case.
>>
>> Link: https://github.com/KSPP/linux/issues/115
>> Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
> 
> Thanks Gustavo,
> 
> this looks good to me.
> 
> Acked-by: Simon Horman <simon.horman@netronome.com>
> 
>> ---
>>  drivers/net/ethernet/netronome/nfp/nfp_net_repr.c | 1 +
>>  1 file changed, 1 insertion(+)
>>
>> diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_repr.c b/drivers/net/ethernet/netronome/nfp/nfp_net_repr.c
>> index b3cabc274121..3b8e675087de 100644
>> --- a/drivers/net/ethernet/netronome/nfp/nfp_net_repr.c
>> +++ b/drivers/net/ethernet/netronome/nfp/nfp_net_repr.c
>> @@ -103,6 +103,7 @@ nfp_repr_get_stats64(struct net_device *netdev, struct rtnl_link_stats64 *stats)
>>  	case NFP_PORT_PF_PORT:
>>  	case NFP_PORT_VF_PORT:
>>  		nfp_repr_vnic_get_stats64(repr->port, stats);
>> +		break;
>>  	default:
>>  		break;
>>  	}
>> -- 
>> 2.27.0
>>
