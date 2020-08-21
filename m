Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C24524E2D1
	for <lists+netdev@lfdr.de>; Fri, 21 Aug 2020 23:46:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726876AbgHUVqv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Aug 2020 17:46:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726829AbgHUVqt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Aug 2020 17:46:49 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCFE3C061573
        for <netdev@vger.kernel.org>; Fri, 21 Aug 2020 14:46:48 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id kr4so1384957pjb.2
        for <netdev@vger.kernel.org>; Fri, 21 Aug 2020 14:46:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=qb989HWbq/ZzV3fwvEQwcdlwCr6v3YD2Pixcybnr0AI=;
        b=eNuOsgT8yan9DL5MpsmBAJDi5x8cKXySoVDohJ+MVQmcflTQxCiBZ6N5LIuxTrP6+b
         3RgRPYnxa3OV21SQzaWyYztVnAaJBoRAeHl81/jNtceMzv9pwF5qPKPWQrQVSt3swobB
         NBlfhZ8O1+Uny7h4aI/693i3/7oIX1etDDqAuvjE2L7H+QOdqKPq42dNVZwCqikNss5S
         K1rDcA/6+ILCZwwOOdrKqCJgSonenu6LOk01KzyPHzBZFHFXaTWffD03544FudqwgkfB
         Gnp7BXWrIRdbO9nDi8TdHOfNinQM/fGbO4tDLhbXIk8o/Aw1zNELdOZ5hnkfzYJdN/or
         oUKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=qb989HWbq/ZzV3fwvEQwcdlwCr6v3YD2Pixcybnr0AI=;
        b=j65FM6u5+BWvyeJ02eYpCeQ/Inp+fUBUOUw2yiNkB/UrCJt0mcL6879W2vrwz8GcfN
         vL5TgMczG8sfKl8tuj1yNrij/84ZlBtx/Wgnik5NtCpQWBqrtkzoCosgCZhth33yegiJ
         LUVLQEgUvb9ihgVRbPOVFPCFe7mUz2usFtjeRjRgVOGXDEn0SsF3rCgTe1VlIkjuLRjJ
         9WZ6G0LXr53pAW209likXoc6UxsDDp7vNPfAY14ivBeTVvFX9wnL/pfVOEDEU28FrWKO
         rhjo26ZHMh4Wt6SaALvAFY7CBxFqAV+34vxGfc7F9b+H5dr9pVk3VqkgCLPhghSFbam9
         +jJQ==
X-Gm-Message-State: AOAM533E1XVfMXzAWZ5P0CiqsXcIMNjLqqdF5CRz0hVTHvuxvNt3fkKy
        Xh/WaF7AdhVXqRscI+UEFzBSRFLqEd4=
X-Google-Smtp-Source: ABdhPJzKoCW3SdJga99KBY0Dyfl+6ELWfmUSYJutGnEgcAkDPz3Q6fQnScBai0gHSoqLzh64mvlrTg==
X-Received: by 2002:a17:90a:d986:: with SMTP id d6mr3739456pjv.134.1598046407760;
        Fri, 21 Aug 2020 14:46:47 -0700 (PDT)
Received: from [10.1.10.11] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id l78sm3565354pfd.130.2020.08.21.14.46.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 21 Aug 2020 14:46:46 -0700 (PDT)
Subject: Re: [PATCH 6/6] xfrm: add espintcp (RFC 8229)
To:     Steffen Klassert <steffen.klassert@secunet.com>,
        David Miller <davem@davemloft.net>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>, netdev@vger.kernel.org
References: <20200121073858.31120-1-steffen.klassert@secunet.com>
 <20200121073858.31120-7-steffen.klassert@secunet.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <77263327-2fc7-6ba0-567e-0d3643d57c2d@gmail.com>
Date:   Fri, 21 Aug 2020 14:46:44 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200121073858.31120-7-steffen.klassert@secunet.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/20/20 11:38 PM, Steffen Klassert wrote:
> From: Sabrina Dubroca <sd@queasysnail.net>
> 
> TCP encapsulation of IKE and IPsec messages (RFC 8229) is implemented
> as a TCP ULP, overriding in particular the sendmsg and recvmsg
> operations. A Stream Parser is used to extract messages out of the TCP
> stream using the first 2 bytes as length marker. Received IKE messages
> are put on "ike_queue", waiting to be dequeued by the custom recvmsg
> implementation. Received ESP messages are sent to XFRM, like with UDP
> encapsulation

...

> +
> +static int espintcp_sendskb_locked(struct sock *sk, struct espintcp_msg *emsg,
> +				   int flags)
> +{
> +	do {
> +		int ret;
> +
> +		ret = skb_send_sock_locked(sk, emsg->skb,
> +					   emsg->offset, emsg->len);
> +		if (ret < 0)
> +			return ret;
> +
> +		emsg->len -= ret;
> +		emsg->offset += ret;
> +	} while (emsg->len > 0);
> +
> +	kfree_skb(emsg->skb);
> +	memset(emsg, 0, sizeof(*emsg));
> +
> +	return 0;
> +}


Is there any particular reason we use kfree_skb() here instead of consume_skb() ?

Same remark for final kfree_skb() in espintcp_recvmsg()

Thanks.


