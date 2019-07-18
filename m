Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E78D16CF63
	for <lists+netdev@lfdr.de>; Thu, 18 Jul 2019 16:02:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403763AbfGROCt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jul 2019 10:02:49 -0400
Received: from mail-io1-f65.google.com ([209.85.166.65]:44717 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727733AbfGROCs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Jul 2019 10:02:48 -0400
Received: by mail-io1-f65.google.com with SMTP id s7so51491001iob.11
        for <netdev@vger.kernel.org>; Thu, 18 Jul 2019 07:02:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=N24J+jmdN0lKgcrjm3AxPIDQpb2nNWH2GoBgCJq2grY=;
        b=a44Ogx8yhBjHD7qABQSqkr5enznNXtYgqI1iXd2mCVVKPh1tpLJni/TI0ZojQtJYz5
         +EfkjSyqcJCg8lrRYizJs6mn+x1tS5LM9/E7mSXhvm7vC9I94o9IfQ0+ZstKc7zZ5Bii
         l834vuoPlUIFmBpyYeMOiMiX8CR5daXKWDJBg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=N24J+jmdN0lKgcrjm3AxPIDQpb2nNWH2GoBgCJq2grY=;
        b=goHNAkDBdxNiGJDmcmJMxnQLNh+cPceXwHWLv611GkV2C3wcIZIQQfdAn7rVUpnP2s
         1+uJofXb5VMM7Szh7ZcsQ21HxsufzbbMMUxv7jXhQ48DfRF575eQuqzz5sJ+5QTEEsjL
         d697j14jxgYZz0p5bwRqxTCZhuTYy3UNNSBTomCHybAxfToZAAHgwathDwC3xsJLr3xv
         j3wPXS7bXz1m8XKWCyWHJNnW2UAqC88C/1GrflNVFaGFTlBENpIoHsWpyAFzJIAuYY9O
         AE3IK8jtBAr46zbWTpdb4sNsOUSsvl8KSG7huyX0anund4rQaJT59wVtKxKs2AvR3kDl
         OVcw==
X-Gm-Message-State: APjAAAUjAei8by5DaNglrD7jqJ1OWKrpA85uyiO/Q/qh9ks648YCzF+i
        PR+J+1UBYMBBu+WOpXcfTRp7OA==
X-Google-Smtp-Source: APXvYqzbPH7wSI0MnT9Mx4FrGE2zoAB/gDPIi+LM9imGGFG3EsRABb3Yx2dGWfJKo2lwgTwmADNM7Q==
X-Received: by 2002:a5e:d618:: with SMTP id w24mr7995031iom.73.1563458567767;
        Thu, 18 Jul 2019 07:02:47 -0700 (PDT)
Received: from ?IPv6:2601:282:800:fd80:54f6:cf0:7185:650f? ([2601:282:800:fd80:54f6:cf0:7185:650f])
        by smtp.googlemail.com with ESMTPSA id i4sm39896096iog.31.2019.07.18.07.02.46
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 18 Jul 2019 07:02:46 -0700 (PDT)
Subject: Re: [PATCH] Signed-off-by: Peter Kosyh <p.kosyh@gmail.com>
To:     Peter Kosyh <p.kosyh@gmail.com>
Cc:     davem@davemloft.net, Shrijeet Mukherjee <shrijeet@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20190718094114.13718-1-p.kosyh@gmail.com>
From:   David Ahern <dsa@cumulusnetworks.com>
Message-ID: <213bada2-fe81-3c14-1506-11abf0f3ca22@cumulusnetworks.com>
Date:   Thu, 18 Jul 2019 08:02:45 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20190718094114.13718-1-p.kosyh@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

your subject line needs a proper Subject - a one-line summary of the
change starting with 'vrf:'. See examples from 'git log drivers/net/vrf.c'


On 7/18/19 3:41 AM, Peter Kosyh wrote:
> vrf_process_v4_outbound() and vrf_process_v6_outbound() do routing
> using ip/ipv6 addresses, but don't make sure the header is available in
> skb->data[] (skb_headlen() is less then header size).
> 
> The situation may occures while forwarding from MPLS layer to vrf, for
> example.

so the use case is a label pop with the nexthop as the VRF device?

> 
> So, this patch adds pskb_may_pull() calls in is_ip_tx_frame(), just before
> call to vrf_process_... functions.
> 
> Signed-off-by: Peter Kosyh <p.kosyh@gmail.com>
> ---
>  drivers/net/vrf.c | 9 ++++++---
>  1 file changed, 6 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/vrf.c b/drivers/net/vrf.c
> index 54edf8956a25..d552f29a58d1 100644
> --- a/drivers/net/vrf.c
> +++ b/drivers/net/vrf.c
> @@ -292,13 +292,16 @@ static netdev_tx_t is_ip_tx_frame(struct sk_buff *skb, struct net_device *dev)
>  {
>  	switch (skb->protocol) {
>  	case htons(ETH_P_IP):
> +		if (!pskb_may_pull(skb, ETH_HLEN + sizeof(struct iphdr))
> +			break;

that check goes in vrf_process_v4_outbound.

>  		return vrf_process_v4_outbound(skb, dev);
>  	case htons(ETH_P_IPV6):
> +		if (!pskb_may_pull(skb, ETH_HLEN + sizeof(struct ipv6hdr))
> +			break;

that check goes in vrf_process_v6_outbound

leave this higher level sorter untouched.

>  		return vrf_process_v6_outbound(skb, dev);
> -	default:
> -		vrf_tx_error(dev, skb);
> -		return NET_XMIT_DROP;
>  	}
> +	vrf_tx_error(dev, skb);
> +	return NET_XMIT_DROP;
>  }
>  
>  static netdev_tx_t vrf_xmit(struct sk_buff *skb, struct net_device *dev)
> 

