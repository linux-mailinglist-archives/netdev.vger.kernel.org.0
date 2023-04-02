Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F0EC6D3B03
	for <lists+netdev@lfdr.de>; Mon,  3 Apr 2023 01:58:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230321AbjDBX6h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Apr 2023 19:58:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230292AbjDBX6g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Apr 2023 19:58:36 -0400
X-Greylist: delayed 906 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sun, 02 Apr 2023 16:58:35 PDT
Received: from sender11-op-o11.zoho.eu (sender11-op-o11.zoho.eu [31.186.226.225])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 858865241
        for <netdev@vger.kernel.org>; Sun,  2 Apr 2023 16:58:35 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1680478986; cv=none; 
        d=zohomail.eu; s=zohoarc; 
        b=ga8OY/nbDa0UZUODAAyuB7UDvHr1K1jR45KHgmdPRUIM1rNMfgvm754d9z6Eiq4N9OBG8o+Eps3l6kdzOdr1BPliVG6Q8t/xIt936vS+rTcUnN46AdEvkA+iTacSuVMAyPFLMH0H8x3B9RVI1t+w62zQ3++XbfqRMdzNoolt048=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
        t=1680478986; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=U1rXoYumoYcKZFnPPR3s49+uZFff4p+7bEQE/flFm0g=; 
        b=frRMJ/xiq/EwJMiVLOqQKT1oj80WoRlFwwubbNiCztfdmSlQj1dOU67wsT8IuaB5BRJEZ0IboQ+QmCgOkLtKmYUvGqLSJ1fhkDph/c1pkrdUkwnZEs6Q6sGdIFqD+6FBLDkp2eCe++m6MD78IImLFDB6Cf25qedQccjkSErufUA=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
        spf=pass  smtp.mailfrom=jes@trained-monkey.org;
        dmarc=pass header.from=<jes@trained-monkey.org>
Received: from [192.168.99.41] (pool-98-113-67-206.nycmny.fios.verizon.net [98.113.67.206]) by mx.zoho.eu
        with SMTPS id 1680478985147643.8234160036232; Mon, 3 Apr 2023 01:43:05 +0200 (CEST)
Message-ID: <24836c4f-75b1-75f5-dfb0-2a3007aba458@trained-monkey.org>
Date:   Sun, 2 Apr 2023 19:43:02 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH] net: alteon: remove unused len variable
Content-Language: en-US
To:     Tom Rix <trix@redhat.com>, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        nathan@kernel.org, ndesaulniers@google.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20230331205545.1863496-1-trix@redhat.com>
From:   Jes Sorensen <jes@trained-monkey.org>
In-Reply-To: <20230331205545.1863496-1-trix@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ZohoMailClient: External
X-Spam-Status: No, score=-2.4 required=5.0 tests=NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/31/23 16:55, Tom Rix wrote:
> clang with W=1 reports
> drivers/net/ethernet/alteon/acenic.c:2438:10: error: variable
>    'len' set but not used [-Werror,-Wunused-but-set-variable]
>                  int i, len = 0;
>                         ^
> This variable is not used so remove it.
> 
> Signed-off-by: Tom Rix <trix@redhat.com>

Signed-off-by: Jes Sorensen <jes@trained-monkey.org>


> ---
>   drivers/net/ethernet/alteon/acenic.c | 3 +--
>   1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/drivers/net/ethernet/alteon/acenic.c b/drivers/net/ethernet/alteon/acenic.c
> index d7762da8b2c0..eafef84fe3be 100644
> --- a/drivers/net/ethernet/alteon/acenic.c
> +++ b/drivers/net/ethernet/alteon/acenic.c
> @@ -2435,7 +2435,7 @@ static netdev_tx_t ace_start_xmit(struct sk_buff *skb,
>   	} else {
>   		dma_addr_t mapping;
>   		u32 vlan_tag = 0;
> -		int i, len = 0;
> +		int i;
>   
>   		mapping = ace_map_tx_skb(ap, skb, NULL, idx);
>   		flagsize = (skb_headlen(skb) << 16);
> @@ -2454,7 +2454,6 @@ static netdev_tx_t ace_start_xmit(struct sk_buff *skb,
>   			const skb_frag_t *frag = &skb_shinfo(skb)->frags[i];
>   			struct tx_ring_info *info;
>   
> -			len += skb_frag_size(frag);
>   			info = ap->skb->tx_skbuff + idx;
>   			desc = ap->tx_ring + idx;
>   

