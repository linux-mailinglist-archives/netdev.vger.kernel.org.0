Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07774277B8F
	for <lists+netdev@lfdr.de>; Fri, 25 Sep 2020 00:15:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726631AbgIXWPZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Sep 2020 18:15:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726205AbgIXWPZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Sep 2020 18:15:25 -0400
Received: from mail-ot1-x341.google.com (mail-ot1-x341.google.com [IPv6:2607:f8b0:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C26CC0613CE;
        Thu, 24 Sep 2020 15:15:25 -0700 (PDT)
Received: by mail-ot1-x341.google.com with SMTP id s66so461680otb.2;
        Thu, 24 Sep 2020 15:15:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=6X1D7CAuSpwgwAh0duUap99z61sTcof5jqH1venAV7Q=;
        b=U7K+b/k6R6F8eOPDKqyqgSsneBYtTdirJ3OIE5FJQlFv47vr7D6zedCwX2SuNep0+8
         q2OxULG1Ts8hGlGPwQk6qJTLmHXdFO+/NPF07O1484iLFVRutXcKskzXGaHfbky999kp
         b809SR0lUtJ55XTitZ5AQOskuPNafwOZwHXW18UN/m8q8pgKGn3fAjia/UraVuTFDYK/
         f/EAds8qVWb69LAwrRvaqrgasktj4XZ5tPCilbQ5vATH8B3pun79Z0CfPlgvJ334kvD9
         OoMssMNkb/tUH409CcJn95EXQ6ILDvAnb/7td9T6H1qCabVr+RbbLT7+kwn2TT8MOHND
         R5uA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=6X1D7CAuSpwgwAh0duUap99z61sTcof5jqH1venAV7Q=;
        b=KPs5tAcFhUxBaJEjTZLmo3q/IWuhoekbOesgDuYtRKoihyReB0oJVcfij92QavvzAO
         8LpDQwuA2lZiOI7RZtHvWfMnO37Din7KNlV2HWI/TuXB1sECnrcxWHEWK9K7PDkOrxOx
         O+fUN56PV/NdJwSHHupWlDWbFopXp+iblSowGuHK9vyDLKABkPVi6c4+HtFlJv9lchbT
         BYJvqBuXiu3GzIZM8iiU8kbq3hG0wN+35llQ2kOltqp7np9AXqDsUfRFMfrloerOwAIQ
         ThiytcJy1fMwtEW24nVFqSleo57ntHrHLaUaW7fA0RblNAuubSSpvDA31v9nXw4uPN06
         rFdw==
X-Gm-Message-State: AOAM531/7MGoaPrEJHv3KmRU6h7Md16weu9P01VQV/eU83llWpWX08xF
        dPlsuapSk7TjmLFuRGvjDdA=
X-Google-Smtp-Source: ABdhPJyR7R2EpKR/olTRn0CCY16Jgay6QTr5Vx5PXEWWItEZuQiWrDfaTDc652nSLxKxi3RpwkiicQ==
X-Received: by 2002:a05:6830:1241:: with SMTP id s1mr838373otp.219.1600985723230;
        Thu, 24 Sep 2020 15:15:23 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([2601:282:803:7700:f921:c3fe:6d94:b608])
        by smtp.googlemail.com with ESMTPSA id b1sm193755oop.47.2020.09.24.15.15.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 24 Sep 2020 15:15:22 -0700 (PDT)
Subject: Re: [PATCH bpf-next v5] bpf: Add bpf_ktime_get_real_ns
To:     bimmy.pujari@intel.com, bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, mchehab@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, kafai@fb.com, maze@google.com,
        ashkan.nikravesh@intel.com
References: <20200924220736.23002-1-bimmy.pujari@intel.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <42da4525-d09e-4be9-7d3c-a4662276b721@gmail.com>
Date:   Thu, 24 Sep 2020 16:15:21 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20200924220736.23002-1-bimmy.pujari@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/24/20 4:07 PM, bimmy.pujari@intel.com wrote:
> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> index a22812561064..198e69a6508d 100644
> --- a/include/uapi/linux/bpf.h
> +++ b/include/uapi/linux/bpf.h
> @@ -3586,6 +3586,13 @@ union bpf_attr {
>   * 		the data in *dst*. This is a wrapper of **copy_from_user**\ ().
>   * 	Return
>   * 		0 on success, or a negative error in case of failure.
> + *
> + * u64 bpf_ktime_get_real_ns(void)
> + *	Description
> + *		Return the real time in nanoseconds.
> + *		See: **clock_gettime**\ (**CLOCK_REALTIME**)

This should be a little more explicit -- something like "See the caveats
regarding use of CLOCK_REALTIME in clock_gettime man page."


> + *	Return
> + *		Current *ktime*.
>   */
>  #define __BPF_FUNC_MAPPER(FN)		\
>  	FN(unspec),			\
> @@ -3737,6 +3744,7 @@ union bpf_attr {
>  	FN(inode_storage_delete),	\
>  	FN(d_path),			\
>  	FN(copy_from_user),		\
> +	FN(ktime_get_real_ns),		\
>  	/* */
>  
>  /* integer value in 'imm' field of BPF_CALL instruction selects which helper

