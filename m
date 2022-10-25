Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 56D3B60C075
	for <lists+netdev@lfdr.de>; Tue, 25 Oct 2022 03:07:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230527AbiJYBHI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Oct 2022 21:07:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231249AbiJYBGa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Oct 2022 21:06:30 -0400
Received: from mail-il1-x12c.google.com (mail-il1-x12c.google.com [IPv6:2607:f8b0:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78C595D115
        for <netdev@vger.kernel.org>; Mon, 24 Oct 2022 17:13:58 -0700 (PDT)
Received: by mail-il1-x12c.google.com with SMTP id l6so6036870ilq.3
        for <netdev@vger.kernel.org>; Mon, 24 Oct 2022 17:13:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=fKgDKCeDKNO9FBWEIojN7Xd6mduLIJo/sewHx/RV/2c=;
        b=bYRR2rD2Dh0ImULhoW76ziyExf5TzJeeqph8DmiYaR+mfOsi2t6bq3drAueJqCUtuJ
         PaJW0xjUFYUngKtcZ3RWtkTnLt+JOEV/jhfCaKZkbYx24aw2D6vY3pQ8m6hCh2NmeIih
         oTBzEpUWr9WabxG61nABChfVgf3/8n2ncNjxAFJ8UHTgwzuVCyIwE+Eij6+Xmi8O7V6Z
         RZYXjAPew3UcvoidMGa3YWeVLrLHERiVrE8S3+x8/tAt6VsKieHVV2jr+elJntwycWlM
         tsL8sQjo2ikuhbC2Idg3Nl5cLP3hihEtbh+TTmgCSdIKD1h+ZtGSqcBePNv0xhX1cDfe
         /wuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fKgDKCeDKNO9FBWEIojN7Xd6mduLIJo/sewHx/RV/2c=;
        b=fv0EqcSh9ULUIwQefX7otJ3a5hx7BCxDqGZY9j4FmZoendfJYY0ebXpgksg/N7EFe4
         YUzIycr//uQHSU+hzTrotXRCMWHEsTQ8TTHIvJMi8e4yNas/Apsy+o65x9cNYlkpIwjt
         UPh1cDqBsk4En7dIKXe996EwsM+7u2OWye3Vxr3mD0TwkT/HKDlQjKcIEPpqZN3eJo1t
         94ov9HSV/YQpTu5qS/h4NIjsiws99HpgK3CwScBnH9G68u9grIuJxydeWVda4kR+/5Es
         X/yCxR9ghPoQCA8D7qYvFPx7ilxLtTfdPFP1e+nZzIEBuUL5t/PASTkSpDfDXWVJkQYd
         G4fg==
X-Gm-Message-State: ACrzQf3iiWOKmmR0NixEWu5V9ITi4um4PFBeLSbBZUB+abIhaZZhNgvT
        d9RoSzyER8xjJh0YJmSBXG/omg==
X-Google-Smtp-Source: AMsMyM4Y1mAy+4pcdwgPu6VC6SRU/tWLtHHq+K7Q6COzkdbHJrHyRDCIW2jJMik5Wsrh7SrIcPgZiQ==
X-Received: by 2002:a05:6e02:1bc7:b0:2fa:876e:95a7 with SMTP id x7-20020a056e021bc700b002fa876e95a7mr23318130ilv.240.1666656837582;
        Mon, 24 Oct 2022 17:13:57 -0700 (PDT)
Received: from [172.22.22.4] ([98.61.227.136])
        by smtp.googlemail.com with ESMTPSA id o16-20020a056e02115000b002fff117027dsm499772ill.13.2022.10.24.17.13.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 Oct 2022 17:13:55 -0700 (PDT)
Message-ID: <5156132d-f55b-8d1a-1783-f82733400753@linaro.org>
Date:   Mon, 24 Oct 2022 19:13:53 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH] net: ipa: don't configure IDLE_INDICATION on v3.1
Content-Language: en-US
To:     Caleb Connolly <caleb.connolly@linaro.org>,
        Alex Elder <elder@linaro.org>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jami Kettunen <jami.kettunen@somainline.org>
Cc:     Alex Elder <elder@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
References: <20221024234850.4049778-1-caleb.connolly@linaro.org>
From:   Alex Elder <elder@linaro.org>
In-Reply-To: <20221024234850.4049778-1-caleb.connolly@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/24/22 6:48 PM, Caleb Connolly wrote:
> IPA v3.1 doesn't support the IDLE_INDICATION_CFG register, this was
> causing a harmless splat in ipa_idle_indication_cfg(), add a version
> check to prevent trying to fetch this register on v3.1
> 
> Fixes: 6a244b75cfab ("net: ipa: introduce ipa_reg()")

Actually, the bug first appeared long ago.  This commit:
   1bb1a117878b9 ("net: ipa: add IPA v3.1 configuration data")
marked IPA v3.1 supported.  But it did not update the code
to avoid accessing the IDLE_INDICATION register for IPA v3.1
(in ipa_reg_idle_indication_cfg_offset()).  That being said,
we have no evidence that it caused harm, and until we do I'd
rather not try to fix the problem that far back.

The commit you point out is the one where we actually
start checking (and WARNing), and I think it's reasonable
to say that's what this fixes.

> Signed-off-by: Caleb Connolly <caleb.connolly@linaro.org>
> ---
> This will need to wait for Jami's Tested-by as I don't have any v3.1 hardware.

I would very much like to get a Tested-by tag.

But from my perspective, this patch looks good.  Previously
offset 0x220 was used, even though it was not well-defined
for IPA v3.1.

This is a bug fix destined for the net/master branch.

Reviewed-by: Alex Elder <elder@linaro.org>

Thank you.

> ---
>   drivers/net/ipa/ipa_main.c | 3 +++
>   1 file changed, 3 insertions(+)
> 
> diff --git a/drivers/net/ipa/ipa_main.c b/drivers/net/ipa/ipa_main.c
> index 3461ad3029ab..49537fccf6ad 100644
> --- a/drivers/net/ipa/ipa_main.c
> +++ b/drivers/net/ipa/ipa_main.c
> @@ -434,6 +434,9 @@ static void ipa_idle_indication_cfg(struct ipa *ipa,
>   	const struct ipa_reg *reg;
>   	u32 val;
>   
> +	if (ipa->version < IPA_VERSION_3_5_1)
> +		return;
> +
>   	reg = ipa_reg(ipa, IDLE_INDICATION_CFG);
>   	val = ipa_reg_encode(reg, ENTER_IDLE_DEBOUNCE_THRESH,
>   			     enter_idle_debounce_thresh);

