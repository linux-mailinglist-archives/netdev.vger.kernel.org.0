Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 40ED0732F9
	for <lists+netdev@lfdr.de>; Wed, 24 Jul 2019 17:44:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728336AbfGXPow (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jul 2019 11:44:52 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:36092 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728051AbfGXPow (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jul 2019 11:44:52 -0400
Received: by mail-pg1-f193.google.com with SMTP id l21so21428833pgm.3;
        Wed, 24 Jul 2019 08:44:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=BZV2OjLCkki70WlOWWuVHAiyKZZrtSyMSuszIqWROFY=;
        b=jaddU6+Yp5ArGjc1K6ididv1JsBAZI3vN8s9mDlCMC/bTf4+jjkSGRP0+MRXmnxske
         ZKY6SIATaqdwXPK4WQes3MiQWbf/ls795lr1cKKYne1hbyYTn9Thl7r9oSWZEhFZJuLc
         zo8X078KoAI0ArmvaF2+JLSe9izSX7A2gWuF5x/O1ZKjDmBWNNU8Xp8gH6q489Dxzo6c
         uIs3CK2OgV0ef8m9zcavQ49nTZuuT7MJymEokMZU0Xnkezeew0Hx4jVV7WhnPQKtYqkQ
         aptPOW4yl0/0w5zrJBAh0df9SbbH1+M1jahOfNe2jXWDo58C3OENeDP2E5IH8oTmERuu
         y/5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=BZV2OjLCkki70WlOWWuVHAiyKZZrtSyMSuszIqWROFY=;
        b=EtqTUgug/CgyF7eKYCCWj5KkaZKZSRTtAP36/fxrQ7AkxOmB8sp6OZyXB5TOChWNaP
         o92MWy4zp29JFRKjCNA7kSYcg+jFG9M4DCNMFIr2lbhGLno8hHuPzbCU0rDXW+PRMsfF
         MhON2Io7L0IZRTWin93SsWaCb4PJY998E/S8APOk/9pkz7CBBRjnVFwf6LFJEx0V26Di
         Dq39P1AytV0G2iBxZAfSKooy/ofRc4xLwFGtafQbA2omKFPduunyTTe8T6i+K8pVq1nq
         2Tpuj+pb20T8IY1l0NBI4ko93myx+aGs09syA3v9+HuLsOMqZwo/wpLO/r60dM4a1wb7
         YOEA==
X-Gm-Message-State: APjAAAVjyYpygInAGmQxtjEqT2njCBnSR/4JueijO1tfisDBN0sN554u
        +rcwH/f5dO4r1+PNyu5HRWht4uaO
X-Google-Smtp-Source: APXvYqwH3Y/wUMv1LE+IPpYLYtjyg7bFZSFpQ19tltDJMe4iz25Aox+JJwL3ntXl4Spx0QXc7qmSCQ==
X-Received: by 2002:a17:90a:d58c:: with SMTP id v12mr86698269pju.7.1563983091046;
        Wed, 24 Jul 2019 08:44:51 -0700 (PDT)
Received: from gmail.com ([66.170.99.2])
        by smtp.gmail.com with ESMTPSA id a3sm55566210pje.3.2019.07.24.08.44.50
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 24 Jul 2019 08:44:50 -0700 (PDT)
Date:   Wed, 24 Jul 2019 08:44:46 -0700
From:   William Tu <u9012063@gmail.com>
To:     Haishuang Yan <yanhaishuang@cmss.chinamobile.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ip6_gre: reload ipv6h in prepare_ip6gre_xmit_ipv6
Message-ID: <20190724154446.GA13067@gmail.com>
References: <1563969642-11843-1-git-send-email-yanhaishuang@cmss.chinamobile.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1563969642-11843-1-git-send-email-yanhaishuang@cmss.chinamobile.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 24, 2019 at 08:00:42PM +0800, Haishuang Yan wrote:
> Since ip6_tnl_parse_tlv_enc_lim() can call pskb_may_pull()
> which may change skb->data, so we need to re-load ipv6h at
> the right place.
> 
> Fixes: 898b29798e36 ("ip6_gre: Refactor ip6gre xmit codes")
> Cc: William Tu <u9012063@gmail.com>
> Signed-off-by: Haishuang Yan <yanhaishuang@cmss.chinamobile.com>

LGTM, thanks for the fix
Acked-by: William Tu <u9012063@gmail.com>

> ---
>  net/ipv6/ip6_gre.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/net/ipv6/ip6_gre.c b/net/ipv6/ip6_gre.c
> index c2049c7..dd2d0b96 100644
> --- a/net/ipv6/ip6_gre.c
> +++ b/net/ipv6/ip6_gre.c
> @@ -660,12 +660,13 @@ static int prepare_ip6gre_xmit_ipv6(struct sk_buff *skb,
>  				    struct flowi6 *fl6, __u8 *dsfield,
>  				    int *encap_limit)
>  {
> -	struct ipv6hdr *ipv6h = ipv6_hdr(skb);
> +	struct ipv6hdr *ipv6h;
>  	struct ip6_tnl *t = netdev_priv(dev);
>  	__u16 offset;
>  
>  	offset = ip6_tnl_parse_tlv_enc_lim(skb, skb_network_header(skb));
>  	/* ip6_tnl_parse_tlv_enc_lim() might have reallocated skb->head */
> +	ipv6h = ipv6_hdr(skb);
>  
>  	if (offset > 0) {
>  		struct ipv6_tlv_tnl_enc_lim *tel;
> -- 
> 1.8.3.1
> 
> 
> 
