Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 68B9F51FC78
	for <lists+netdev@lfdr.de>; Mon,  9 May 2022 14:17:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234105AbiEIMUi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 May 2022 08:20:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234018AbiEIMUe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 May 2022 08:20:34 -0400
Received: from mail-qk1-x72c.google.com (mail-qk1-x72c.google.com [IPv6:2607:f8b0:4864:20::72c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DA92FFA90
        for <netdev@vger.kernel.org>; Mon,  9 May 2022 05:16:40 -0700 (PDT)
Received: by mail-qk1-x72c.google.com with SMTP id z126so10554945qkb.2
        for <netdev@vger.kernel.org>; Mon, 09 May 2022 05:16:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=0nDlU/9f6qu18CA/fdbhsVXEzdC8yH3R4M1Pbh76l24=;
        b=2L2FW+K2phCc0Dz0nYxelJxUBC6axSJ2ZGxL+eeVVrC+jp9b/US2rlwIkjKtuZZk/2
         GpVxhv0ffCBUrStWZL7cN2dnwA/FPHyuhzAt2e/GBUU9JiRAUlChlkzVDQlTzJg/IcjD
         eVcedtjH5UgMw4xTVVWny2F+6ND5xVjIoapKLM6Q7zPMKcMTRLtLkJIJMH7lOGlEcHOv
         xcPCMUpJTVMMnXACRww9k4bi62ZEMtGCId3kj8UDm7G6rW6nnQmpqI/dzTxgybAU7bfJ
         rMlw32kbsq/WJZVxSWvya0Jbo8lo875/4OPc71N5/OG8BDr4FEOEP71ybfXBJogrGfbu
         Cdew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=0nDlU/9f6qu18CA/fdbhsVXEzdC8yH3R4M1Pbh76l24=;
        b=5GqjFu9105Lja6IjbIu8G9GPofx/fXfPDAvaEhrGCcW5UsBotM/pw4X1O/Y68VGMTr
         8cdUnRmm3rjKXy/o+HfGWB1h0x79EKDS2saqGTcFwlA6gmJzBSH2F7Pp3NXvF80PCLar
         ySXYDvl2w/LYr0KB4UFDKgvuHOLzt6B0F5ASfQFSbCZFfSfhXo41p86tnyXYImpf/yrR
         rP9TiSHDfDiemD5ST+K5wrJAlornInR174jyFQhrDwFNG44ac8pDW5FLZ83KzIbFemuA
         oHlcYzqk2wkFKCJxIgdyn38VPQSAoNrY3OAEL0NILeYbZJ1EWQKSqPKTlcdxeJ8kCGmE
         airA==
X-Gm-Message-State: AOAM531yUJH7O2r/e6N9XlRvuilyDSr9Dz3xbb1yJM/9/kwPuj6QWrc5
        UI7ElSQviaVEDzJYOLhs/2Zssw==
X-Google-Smtp-Source: ABdhPJxzknHng3uOAX6f5gxQ/7lDNUdxfuDCYrpJVBTjyHWq5bqSeVKi7b7+yhc/J0b5SoZmkk0jmQ==
X-Received: by 2002:a05:620a:45a7:b0:6a0:3399:c9ce with SMTP id bp39-20020a05620a45a700b006a03399c9cemr11187103qkb.590.1652098598831;
        Mon, 09 May 2022 05:16:38 -0700 (PDT)
Received: from [192.168.1.173] (bras-base-kntaon1617w-grc-27-184-148-44-6.dsl.bell.ca. [184.148.44.6])
        by smtp.googlemail.com with ESMTPSA id x13-20020ac86b4d000000b002f39b99f69asm7563558qts.52.2022.05.09.05.16.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 May 2022 05:16:38 -0700 (PDT)
Message-ID: <b898299d-7361-f5e9-2e0e-aa5a0686faab@mojatatu.com>
Date:   Mon, 9 May 2022 08:16:37 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH v2 net] net/sched: act_pedit: really ensure the skb is
 writable
Content-Language: en-US
To:     Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Cc:     Cong Wang <xiyou.wangcong@gmail.com>, Jiri Pirko <jiri@resnulli.us>
References: <004a9eddf22a44b415a6573bdc67040b995c14dc.1652095998.git.pabeni@redhat.com>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
In-Reply-To: <004a9eddf22a44b415a6573bdc67040b995c14dc.1652095998.git.pabeni@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022-05-09 07:33, Paolo Abeni wrote:

[..]
>   	goto_ch = tcf_action_set_ctrlact(*a, parm->action, goto_ch);
> @@ -308,13 +320,18 @@ static int tcf_pedit_act(struct sk_buff *skb, const struct tc_action *a,
>   			 struct tcf_result *res)
>   {
>   	struct tcf_pedit *p = to_pedit(a);
> +	u32 max_offset;
>   	int i;
>   
> -	if (skb_unclone(skb, GFP_ATOMIC))
> -		return p->tcf_action;
> -
>   	spin_lock(&p->tcf_lock);
>   
> +	max_offset = (skb_transport_header_was_set(skb) ?
> +		      skb_transport_offset(skb) :
> +		      skb_network_offset(skb)) +
> +		     p->tcfp_off_max_hint;
> +	if (skb_ensure_writable(skb, min(skb->len, max_offset)))
> +		goto unlock;
> +

goto bad; would have been better so we can record it in the stats?

Other than that LGTM.
The commit message is good - but it would be better if you put that
example that triggered it.

cheers,
jamal
