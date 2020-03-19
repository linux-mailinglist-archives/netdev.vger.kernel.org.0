Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ADBF818C3FE
	for <lists+netdev@lfdr.de>; Fri, 20 Mar 2020 00:56:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727189AbgCSX4L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Mar 2020 19:56:11 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:33432 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726663AbgCSX4L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Mar 2020 19:56:11 -0400
Received: by mail-pf1-f194.google.com with SMTP id n7so2308370pfn.0
        for <netdev@vger.kernel.org>; Thu, 19 Mar 2020 16:56:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=883PN8YA43EanZa0bWy5zdEYbli6+XjvMMIZjAkfTYY=;
        b=SwAnxIX3flpea8Ev1CqskvUVsBXBT9x63m8sBnBWOpTEt8vw900RWkvC6Q6r/oSvRN
         U7mOd8AGDZDK6M5BI2Laa5PkfUst/KBUr1CFK87ExPaxiKI2LQsiQnTi124L/NI1fQFa
         Mudl/lcn4fQpvTElpyWV9QQIsgdAa0YE/hACX5XSze69U8DE0Eu+HZEVMHCKPUkobvu7
         EmsWvNG0N5/NUzR5ix+Q0YltWroET4Pk+JKj58m7fQfTKgrMadOtjedolkiRGRBlaBuG
         BTFwQCzUlvX9koLjeTEIl7dh9UK3lAeC6XLZ9xC+fwLOS+kPxRPCTRkj9PKy3yXE/JCG
         1aTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=883PN8YA43EanZa0bWy5zdEYbli6+XjvMMIZjAkfTYY=;
        b=D5BzCm6I55uPbO1zpJGH5fvHkS0GSGMHKVG+NNj7AdqK2g7q/7du/2d+x3y/+RBYZn
         akHfpIoNUegtIdWhMhWpzrV3ZcyHKOUQBfmutbeb8poIfmKqWZT0HiQLMnDyZL+AVQbc
         OtAOA9vuZipZ+u0ZAk/+ZTh111/rE5i7yZP2TyDxpQlm1Y+h7axXJ4LXMTQEKT4AVlnH
         KyGo8j6FSD5Tu8zZPpusFV0zSAOzrfdpKVtgCyQLhd+qgSKCbHQ0LCHc820t0Zdlc1Tm
         zNgXCBRBtt/aZQhSFqji7LuvtIYo5D4HEL6uNOFXJGy9woaUMNC5NWe/dfRijS0818wq
         00/w==
X-Gm-Message-State: ANhLgQ2r6Ct3RwOXg5TIaz/nPhrPUIbD8Wk0En51pg3kFxuIGAVY3cBt
        U+D5ht/++6fv3da62JGbYtE=
X-Google-Smtp-Source: ADFU+vsiYO/QawVwwOuGcoPjOkbFQbGu0laHpZjw2hOTx7IlyDaOJeHvZzGiiz4ur15AJy25GCpILA==
X-Received: by 2002:a62:778d:: with SMTP id s135mr6986648pfc.21.1584662170589;
        Thu, 19 Mar 2020 16:56:10 -0700 (PDT)
Received: from ?IPv6:2601:282:803:7700:e986:7672:8e0d:7fbd? ([2601:282:803:7700:e986:7672:8e0d:7fbd])
        by smtp.googlemail.com with ESMTPSA id x75sm3597067pfc.161.2020.03.19.16.56.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 19 Mar 2020 16:56:09 -0700 (PDT)
Subject: Re: [patch iproute2/net-next v5] tc: m_action: introduce support for
 hw stats type
To:     Jiri Pirko <jiri@resnulli.us>, netdev@vger.kernel.org
Cc:     stephen@networkplumber.org, mlxsw@mellanox.com
References: <20200314092548.27793-1-jiri@resnulli.us>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <ee32e79b-5db3-f6e0-cb89-f19b078ca3d5@gmail.com>
Date:   Thu, 19 Mar 2020 17:56:08 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200314092548.27793-1-jiri@resnulli.us>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/14/20 3:25 AM, Jiri Pirko wrote:
> From: Jiri Pirko <jiri@mellanox.com>
> 
> Introduce support for per-action hw stats type config.
> 
> This patch allows user to specify one of the following types of HW
> stats for added action:
> immediate - queried during dump time
> delayed - polled from HW periodically or sent by HW in async manner
> disabled - no stats needed
> 
> Note that if "hw_stats" option is not passed, user does not care about
> the type, just expects any type of stats.
> 
> Examples:
> $ tc filter add dev enp0s16np28 ingress proto ip handle 1 pref 1 flower skip_sw dst_ip 192.168.1.1 action drop hw_stats disabled

...

> @@ -149,6 +150,59 @@ new_cmd(char **argv)
>  		(matches(*argv, "add") == 0);
>  }
>  
> +static const struct hw_stats_type_item {
> +	const char *str;
> +	__u8 type;
> +} hw_stats_type_items[] = {
> +	{ "immediate", TCA_ACT_HW_STATS_TYPE_IMMEDIATE },
> +	{ "delayed", TCA_ACT_HW_STATS_TYPE_DELAYED },
> +	{ "disabled", 0 }, /* no bit set */
> +};
> +
> +static void print_hw_stats(const struct rtattr *arg)
> +{
> +	struct nla_bitfield32 *hw_stats_type_bf = RTA_DATA(arg);
> +	__u8 hw_stats_type;
> +	int i;
> +
> +	hw_stats_type = hw_stats_type_bf->value & hw_stats_type_bf->selector;
> +	print_string(PRINT_FP, NULL, "\t", NULL);
> +	open_json_array(PRINT_ANY, "hw_stats");

I still do not understand how the type can be multiple. The command line
is an 'or' : immediate, delayed, or disabled. Further, the filter is
added to a specific device which has a single driver. Seems like at
install / config time the user is explicitly stating a single type.

