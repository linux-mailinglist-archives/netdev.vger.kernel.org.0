Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 792AD26320A
	for <lists+netdev@lfdr.de>; Wed,  9 Sep 2020 18:34:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731003AbgIIQeY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Sep 2020 12:34:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730776AbgIIQeM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Sep 2020 12:34:12 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D0DCC061573
        for <netdev@vger.kernel.org>; Wed,  9 Sep 2020 09:34:11 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id e17so2922167wme.0
        for <netdev@vger.kernel.org>; Wed, 09 Sep 2020 09:34:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=mss8MK33fopB1tzfoyvJfAwWlaNQqq3EvgTqO4IgP3c=;
        b=XooBhKOoh8n9QdPT8Yk+8tiE6N5X+M+lKJEO62wQZtgFyLv8LkrEmNfwnd/uFBoMLI
         jb3zFSKZtS+DRVIEqfQb8i9XsPCKyKX1O1Skxa3VNTewkAEBMROnu5ePF5qckcJIaSm1
         0uk2MhQRoS5FED/0/N/FWfo5EOhFfZhciwwbT0xeOVZBDTowd1cObrW9yD60KIQUFEDY
         sKdQr5kIjcsbTkFtki4veVj9KQNjVSdiMx3BX0C3bnWraTDXaJdMNHQidyYDWZTqhpRC
         n0h6hAiCieP+LFXsl8BhGwPEjZ2MH37QVf3q+1xNfSN9TUhbCg0V+six6iIbAGvXMrel
         Lpvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=mss8MK33fopB1tzfoyvJfAwWlaNQqq3EvgTqO4IgP3c=;
        b=afMI3/+giLBi4ptufRz8+81o2ixEEyt2B/pdZka5KdQdWpFjyZeM05TpjOTnaHiNpT
         T1zt4EYPd/j1ONBBC+Aeyo2TuRVcSktFocp2KSl21rD8xyRk4JWg21u7MoyPSb6a0BpL
         WK1DrTFJ471DdVk8tEjSqZUB8cVX7WF9afLRdS/A6Te8veDqaTdzKJHG5SQJ70dOtREL
         Zn8ETvhV8JIT2ghAlZwGnowF6tFANAiC4M7awdye+Syyl7Y4Y1m4bEhSa9BbKEWG+sRK
         ylcP5gFBIEZCM8ZWV8t8SwO64ASke2YZetr10tyeZJ1S7ejSmjnXMqrSoqKCXTBaZrj6
         6wEg==
X-Gm-Message-State: AOAM530H6qHm9mvzI4csq3B+wpmpzUxHfnM46Avbm+9tFqYDxfc5uK7+
        AvaXmjtDtb97x2HMwSsrDZRwTA==
X-Google-Smtp-Source: ABdhPJy936mVi8yqv0y8gzDPgayRCZbOz8Jseznw5XOFbh036kBtUjZVLc1WXoRryvgzUTHHNIQ7ew==
X-Received: by 2002:a1c:9d4b:: with SMTP id g72mr4454776wme.68.1599669250162;
        Wed, 09 Sep 2020 09:34:10 -0700 (PDT)
Received: from netronome.com ([2001:982:7ed1:403:9eeb:e8ff:fe0d:5b6a])
        by smtp.gmail.com with ESMTPSA id j14sm4855630wrr.66.2020.09.09.09.34.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Sep 2020 09:34:09 -0700 (PDT)
Date:   Wed, 9 Sep 2020 18:34:08 +0200
From:   Simon Horman <simon.horman@netronome.com>
To:     Wang Qing <wangqing@vivo.com>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net/netfilter: fix a typo for nf_conntrack_proto_dccp.c
Message-ID: <20200909163407.GB28336@netronome.com>
References: <1599653567-27147-1-git-send-email-wangqing@vivo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1599653567-27147-1-git-send-email-wangqing@vivo.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Wang,

On Wed, Sep 09, 2020 at 08:12:44PM +0800, Wang Qing wrote:
> Change the comment typo: "direcly" -> "directly".
> 
> Signed-off-by: Wang Qing <wangqing@vivo.com>

git log  tells me that the correct prefix for this patch
is "netfilter: conntrack:"  rather than "net/netfilter:"

Probably this patch is targeted at nf-next and should include nf-next
in the subject like this: [PATCH nf-next] ...

> ---
>  net/netfilter/nf_conntrack_proto_dccp.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/netfilter/nf_conntrack_proto_dccp.c b/net/netfilter/nf_conntrack_proto_dccp.c
> index b3f4a33..d9bb0ce
> --- a/net/netfilter/nf_conntrack_proto_dccp.c
> +++ b/net/netfilter/nf_conntrack_proto_dccp.c
> @@ -340,7 +340,7 @@ dccp_state_table[CT_DCCP_ROLE_MAX + 1][DCCP_PKT_SYNCACK + 1][CT_DCCP_MAX + 1] =
>  		 * sNO -> sIV		No connection
>  		 * sRQ -> sIV		No connection
>  		 * sRS -> sIV		No connection
> -		 * sPO -> sOP -> sCG	Move direcly to CLOSING
> +		 * sPO -> sOP -> sCG	Move directly to CLOSING
>  		 * sOP -> sCG		Move to CLOSING
>  		 * sCR -> sIV		Close after CloseReq is invalid
>  		 * sCG -> sCG		Retransmit
> -- 
> 2.7.4
> 
