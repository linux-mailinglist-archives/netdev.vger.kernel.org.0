Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B17349E644
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 16:39:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240689AbiA0PjM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jan 2022 10:39:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231590AbiA0PjL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jan 2022 10:39:11 -0500
Received: from mail-io1-xd2e.google.com (mail-io1-xd2e.google.com [IPv6:2607:f8b0:4864:20::d2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EDF7C061714;
        Thu, 27 Jan 2022 07:39:11 -0800 (PST)
Received: by mail-io1-xd2e.google.com with SMTP id z199so4001046iof.10;
        Thu, 27 Jan 2022 07:39:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=78e4n2ciJcS8eU8bfuJlxO2Papr5MMX9iCof5E4XjLk=;
        b=CLtTaY7+Xxz9g0vrwdVDfgTVs9AQVK9BwNMpi5WHG+C5zMemZLgbiw9k02CTXo0skQ
         tWjMZZ2/yPJcDx7ylT9SpYWXCBEIVUjqGjhF4J034Vuhmw+cM8TIz8LxToRq5TUqnPkK
         etcv/4yZ2uyS1gXxjGIT/sY8zee4FGsYwIK/Ey4QN4yoARde/6c9ZM11C1LXxScupLTg
         XG9888f46LSmvd2NZlv2vzN1JDiwWqykjNHJSfhhroQj2CbMHBadJRKuYPmoD24XmLLw
         WZ2GuBwhgkQLOMZvrG6l0BMFEECISTe8Pye8K7TaZfjPVHiTf7VuIgQR2Q4o7q61PFJP
         K8vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=78e4n2ciJcS8eU8bfuJlxO2Papr5MMX9iCof5E4XjLk=;
        b=XxmSiheFWm2CGubTl/BBSSzw75jZbD2Fayl7yY9nfEhsBtNMBmHN/TsEQx0J33Bqv1
         5w/wyHAa5PFC9qiHKcDIver+TO/8sWYoQV9E20wnh8Fp3JGJHYmYGdTd3Dhdn2WwQv7D
         vrTRIqW2Uuln8geoltZHIscI1ogdDXiLTNiz5jXnyguB+O4PKNT5sQERyNQnnUhMyGF9
         5VuxFwlAxDvtoO7vVXcGw9cAuterN4l9BdvgMeHYor/p9bLhxDB2SAURXAj7WSsMkOoi
         huERb4uTWWUoCjPZeMScuAX81T92nRPIRsBzsiRSnk313P2M/2LCm103i4mnrCl+uoPh
         ix3g==
X-Gm-Message-State: AOAM532iJoGVLsD/Qe4xVRjl9sBMC5ss+GtSZtrvBvuBNSDkFJmDd/q9
        PQPmLbOGAcxbO6PlrE9J9gs=
X-Google-Smtp-Source: ABdhPJwAmatGJNuoWFlMMpgE9UV1ElC/u55vsOPVt+D8Ce2lXtnjtEnBciNZiS7L9Zy9iD7byHequQ==
X-Received: by 2002:a02:6d11:: with SMTP id m17mr2035306jac.317.1643297950999;
        Thu, 27 Jan 2022 07:39:10 -0800 (PST)
Received: from ?IPV6:2601:282:800:dc80:182c:2e54:e650:90f5? ([2601:282:800:dc80:182c:2e54:e650:90f5])
        by smtp.googlemail.com with ESMTPSA id g11sm11319478iom.45.2022.01.27.07.39.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 27 Jan 2022 07:39:10 -0800 (PST)
Message-ID: <8621e28f-4849-dad7-e52d-8cdd7f290488@gmail.com>
Date:   Thu, 27 Jan 2022 08:39:07 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.5.1
Subject: Re: [PATCH v2 net-next 2/8] net: skb_drop_reason: add document for
 drop reasons
Content-Language: en-US
To:     menglong8.dong@gmail.com, dsahern@kernel.org, kuba@kernel.org
Cc:     rostedt@goodmis.org, mingo@redhat.com, davem@davemloft.net,
        yoshfuji@linux-ipv6.org, edumazet@google.com, pablo@netfilter.org,
        kadlec@netfilter.org, fw@strlen.de, imagedong@tencent.com,
        alobakin@pm.me, pabeni@redhat.com, cong.wang@bytedance.com,
        talalahmad@google.com, haokexin@gmail.com, keescook@chromium.org,
        memxor@gmail.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org, mengensun@tencent.com
References: <20220127091308.91401-1-imagedong@tencent.com>
 <20220127091308.91401-3-imagedong@tencent.com>
From:   David Ahern <dsahern@gmail.com>
In-Reply-To: <20220127091308.91401-3-imagedong@tencent.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/27/22 2:13 AM, menglong8.dong@gmail.com wrote:
> From: Menglong Dong <imagedong@tencent.com>
> 
> Add document for following existing drop reasons:
> 
> SKB_DROP_REASON_NOT_SPECIFIED
> SKB_DROP_REASON_NO_SOCKET
> SKB_DROP_REASON_PKT_TOO_SMALL
> SKB_DROP_REASON_TCP_CSUM
> SKB_DROP_REASON_SOCKET_FILTER
> SKB_DROP_REASON_UDP_CSUM
> 
> Signed-off-by: Menglong Dong <imagedong@tencent.com>
> ---
>  include/linux/skbuff.h | 12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)
> 

Reviewed-by: David Ahern <dsahern@kernel.org>


