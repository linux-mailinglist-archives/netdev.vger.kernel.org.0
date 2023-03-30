Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB4166D1217
	for <lists+netdev@lfdr.de>; Fri, 31 Mar 2023 00:27:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230312AbjC3W1X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Mar 2023 18:27:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229663AbjC3W1V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Mar 2023 18:27:21 -0400
X-Greylist: delayed 135 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 30 Mar 2023 15:27:20 PDT
Received: from omta39.uswest2.a.cloudfilter.net (omta39.uswest2.a.cloudfilter.net [35.89.44.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58777CA23;
        Thu, 30 Mar 2023 15:27:20 -0700 (PDT)
Received: from eig-obgw-6007a.ext.cloudfilter.net ([10.0.30.247])
        by cmsmtp with ESMTP
        id hxrrpqykCCarni0gAph4Fd; Thu, 30 Mar 2023 22:23:34 +0000
Received: from gator4166.hostgator.com ([108.167.133.22])
        by cmsmtp with ESMTP
        id i0gApxqzmurZ1i0gApxrKi; Thu, 30 Mar 2023 22:23:34 +0000
X-Authority-Analysis: v=2.4 cv=KefBDCUD c=1 sm=1 tr=0 ts=64260be6
 a=1YbLdUo/zbTtOZ3uB5T3HA==:117 a=wTog8WU66it3cfrESHnF4A==:17
 a=dLZJa+xiwSxG16/P+YVxDGlgEgI=:19 a=IkcTkHD0fZMA:10 a=k__wU0fu6RkA:10
 a=wYkD_t78qR0A:10 a=NEAV23lmAAAA:8 a=mDV3o1hIAAAA:8 a=VwQbUJbxAAAA:8
 a=rQwXfPfrytjjklgZoK0A:9 a=QEXdDO2ut3YA:10 a=3IOs8h2EC4YA:10
 a=_FVE-zBwftR9WsbkzFJk:22 a=AjGcO6oz07-iQ99wixmX:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=embeddedor.com; s=default; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=l3o/jyRjjYZtQS+y9ls2XWWXSrLf5eob4Q58hRXkotc=; b=d8yLKcJFndnMbJmR3zRsn2dza4
        G7p4kIHYaNVYcDlrsHYSkPnl2HvEad2rDhE0Ic93bdQZHeS5NYGza4UOUMm5A450bffe7Dlksvq4B
        tTOhabpqHsGMoI0BXsgoF58Gb5mtpiFilerFq60kk60MapiSB6gPu5eQEQXn9xjRbRkGgWAUPAGkR
        Poguy6K4ynIkt9m0kLHL8jZ71Zh8RDE5Xo5eUreRfdtX8e27TKUvs2LWlIYXD9Xaq7KsVWsLg2d25
        EFrZ3BOjWj+SFgJB4zAYQW80S9RDtsUckufSC9Jpd9ka3qQ2FNR+TLOYlOOw4ybQdbUUCFaQS6JFW
        v9sSo9lQ==;
Received: from 187-162-31-110.static.axtel.net ([187.162.31.110]:34400 helo=[192.168.15.7])
        by gator4166.hostgator.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.95)
        (envelope-from <gustavo@embeddedor.com>)
        id 1phyg1-002tZP-BD;
        Thu, 30 Mar 2023 15:15:17 -0500
Message-ID: <ee4915e0-4b51-5ca8-daf9-f6d2f23b5b6f@embeddedor.com>
Date:   Thu, 30 Mar 2023 14:15:52 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH][next] rxrpc: Replace fake flex-array with flexible-array
 member
Content-Language: en-US
To:     "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        David Howells <dhowells@redhat.com>,
        Marc Dionne <marc.dionne@auristor.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     linux-afs@lists.infradead.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
References: <ZAZT11n4q5bBttW0@work>
From:   "Gustavo A. R. Silva" <gustavo@embeddedor.com>
In-Reply-To: <ZAZT11n4q5bBttW0@work>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - gator4166.hostgator.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - embeddedor.com
X-BWhitelist: no
X-Source-IP: 187.162.31.110
X-Source-L: No
X-Exim-ID: 1phyg1-002tZP-BD
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: 187-162-31-110.static.axtel.net ([192.168.15.7]) [187.162.31.110]:34400
X-Source-Auth: gustavo@embeddedor.com
X-Email-Count: 0
X-Org:  HG=hgshared;ORG=hostgator;
X-Source-Cap: Z3V6aWRpbmU7Z3V6aWRpbmU7Z2F0b3I0MTY2Lmhvc3RnYXRvci5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfAfXMEzYIUfgduhk6qX0iN2lhGPBkLUWEVQNjifpOqzuy8HZD0mKSsVgCc1a6KsyWzgX1KsuH4lX+gWYiNC7GGOublUi+jvoss4iWdlxCWwc/smvrwl3
 EsRNJlaXWZCuIFZ8nRq0H/LG9IIbpw64dzJMT/KNiOTlqf/RTN3LKXphZwUhpb1TjGz9FbzY4E5U5obt3PVf/OHZotXTLhxXCjkBAUMOUbHlx7JDzwvnZGPD
 Bj+DfUs0VrtGSVI475XJIigOj9TwR/2kmCZpOdA6ZXfnon2JnaHVRQIBkAZ6p0pE
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi all,

Friendly ping: who can take this, please? 😄

Thanks
-- 
Gustavo

On 3/6/23 14:57, Gustavo A. R. Silva wrote:
> Zero-length arrays as fake flexible arrays are deprecated and we are
> moving towards adopting C99 flexible-array members instead.
> 
> Transform zero-length array into flexible-array member in struct
> rxrpc_ackpacket.
> 
> Address the following warnings found with GCC-13 and
> -fstrict-flex-arrays=3 enabled:
> net/rxrpc/call_event.c:149:38: warning: array subscript i is outside array bounds of ‘uint8_t[0]’ {aka ‘unsigned char[]’} [-Warray-bounds=]
> 
> This helps with the ongoing efforts to tighten the FORTIFY_SOURCE
> routines on memcpy() and help us make progress towards globally
> enabling -fstrict-flex-arrays=3 [1].
> 
> Link: https://github.com/KSPP/linux/issues/21
> Link: https://github.com/KSPP/linux/issues/263
> Link: https://gcc.gnu.org/pipermail/gcc-patches/2022-October/602902.html [1]
> Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
> ---
>   net/rxrpc/protocol.h | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/rxrpc/protocol.h b/net/rxrpc/protocol.h
> index 6760cb99c6d6..e8ee4af43ca8 100644
> --- a/net/rxrpc/protocol.h
> +++ b/net/rxrpc/protocol.h
> @@ -126,7 +126,7 @@ struct rxrpc_ackpacket {
>   	uint8_t		nAcks;		/* number of ACKs */
>   #define RXRPC_MAXACKS	255
>   
> -	uint8_t		acks[0];	/* list of ACK/NAKs */
> +	uint8_t		acks[];		/* list of ACK/NAKs */
>   #define RXRPC_ACK_TYPE_NACK		0
>   #define RXRPC_ACK_TYPE_ACK		1
>   
