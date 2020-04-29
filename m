Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CED591BE47A
	for <lists+netdev@lfdr.de>; Wed, 29 Apr 2020 18:58:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726914AbgD2Q6k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Apr 2020 12:58:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726423AbgD2Q6k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Apr 2020 12:58:40 -0400
Received: from mail-qk1-x72b.google.com (mail-qk1-x72b.google.com [IPv6:2607:f8b0:4864:20::72b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F16CC03C1AE
        for <netdev@vger.kernel.org>; Wed, 29 Apr 2020 09:58:40 -0700 (PDT)
Received: by mail-qk1-x72b.google.com with SMTP id t3so2743573qkg.1
        for <netdev@vger.kernel.org>; Wed, 29 Apr 2020 09:58:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=xGBKFUVUtucB7GNgB+zx3SfIb1lLf+RPO0+3Yl0E2kw=;
        b=QJM+FUBDYvFKxhzKTduclx+JGuzv8AMwq7F69LQFSMIfQQ0LpCJIKcIJGlTS8RRMaa
         p1QjE49wlk+SXiTHTpFuExFR4lcXf7zXNTmZI/lW5FLqE+hJVNqWa+5y2lXX0MPd33VU
         7XLuSeuY1ojD1dhaDJD0YYnw7LCoLwdI0+6+OWGMQkdCcnY+S+7puBOJWnbfbl7NLGSC
         QwJfUmabmzqC58jSYZ6mtn6aO5FPVJE26nXqscPTEQJwzMj81tbR4SqW2jlu2T7ra7SJ
         CmIuMD53j7GcH+4BGt+h50mlTKxhjaIIq3ywygkClojhgnOZjOna/NGM2FMQyOqk7qll
         GZUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=xGBKFUVUtucB7GNgB+zx3SfIb1lLf+RPO0+3Yl0E2kw=;
        b=tkyamXuWJxnfcrplqyr1gP3u56FCOTLwfO06NW2t0YFUYZyD9aLOSh+btebXqmaqKn
         bnKvaUiqPT4u70V2VsDBLNG8Mlpv1EJ/EPP36jS5glv7OGPVkkEc9mOBhfSSRyug7Eo1
         W1wM2aV8soDFSEFBh4jBD4XrfU47Fw3mc9y4uybGeAIjqAHflw0V1AofsudUULHoNEVL
         DNNOkuxoiCoWoLmpir9qoiQ9lznuyPnBz3ep3Q1UQSw0oHo8MMFla2a/GU3gDCBpEfG0
         203wboL31jN2hBFSR3D/r6JlLxn8QgPH5iMpiER4lF4Nznpz7vwSnBiO/S/oZ5cvKBrj
         Yd3g==
X-Gm-Message-State: AGi0PuYN/RFv3Xj972tqThSdE99b0bZ3+CX0J9zD7YuLbQHm6bp+oqcm
        CEnPMj2EHRX+ixBA4x1aY18=
X-Google-Smtp-Source: APiQypLFmmRuqK1lpiLMnnOL3DL3/JilwvGxzLrux64R8vtz2+YKWNb7GoY6283mEyl/QbssUeN9VA==
X-Received: by 2002:a37:4d3:: with SMTP id 202mr34005823qke.244.1588179519458;
        Wed, 29 Apr 2020 09:58:39 -0700 (PDT)
Received: from ?IPv6:2601:282:803:7700:3576:688b:325:4959? ([2601:282:803:7700:3576:688b:325:4959])
        by smtp.googlemail.com with ESMTPSA id 11sm16541384qkg.122.2020.04.29.09.58.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 29 Apr 2020 09:58:38 -0700 (PDT)
Subject: Re: [PATCHv4 iproute2-next 2/7] iproute_lwtunnel: add options support
 for vxlan metadata
To:     Xin Long <lucien.xin@gmail.com>,
        network dev <netdev@vger.kernel.org>,
        stephen@networkplumber.org
Cc:     David Ahern <dsahern@gmail.com>, Jakub Kicinski <kuba@kernel.org>
References: <cover.1587983178.git.lucien.xin@gmail.com>
 <a06922f5bd35b674caee4bd5919186ea1323202a.1587983178.git.lucien.xin@gmail.com>
 <838c55576eabd17db407a95bc6609c05bf5e174b.1587983178.git.lucien.xin@gmail.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <1cd96ed3-b2ec-6cc7-8737-0cc2ecd38f72@gmail.com>
Date:   Wed, 29 Apr 2020 10:58:36 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <838c55576eabd17db407a95bc6609c05bf5e174b.1587983178.git.lucien.xin@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/27/20 4:27 AM, Xin Long wrote:
> diff --git a/ip/iproute_lwtunnel.c b/ip/iproute_lwtunnel.c
> index 8599853..9945c86 100644
> --- a/ip/iproute_lwtunnel.c
> +++ b/ip/iproute_lwtunnel.c
> @@ -333,6 +333,26 @@ static void lwtunnel_print_geneve_opts(struct rtattr *attr)
>  	close_json_array(PRINT_JSON, name);
>  }
>  
> +static void lwtunnel_print_vxlan_opts(struct rtattr *attr)
> +{
> +	struct rtattr *tb[LWTUNNEL_IP_OPT_VXLAN_MAX + 1];
> +	struct rtattr *i = RTA_DATA(attr);
> +	int rem = RTA_PAYLOAD(attr);
> +	char *name = "vxlan_opts";
> +	__u32 gbp;
> +
> +	parse_rtattr(tb, LWTUNNEL_IP_OPT_VXLAN_MAX, i, rem);
> +	gbp = rta_getattr_u32(tb[LWTUNNEL_IP_OPT_VXLAN_GBP]);
> +
> +	print_nl();
> +	print_string(PRINT_FP, name, "\t%s ", name);
> +	open_json_array(PRINT_JSON, name);
> +	open_json_object(NULL);
> +	print_uint(PRINT_ANY, "gdp", "%u ", gbp);

gdp? should that be 'gbp'?

