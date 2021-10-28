Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C74E643E60B
	for <lists+netdev@lfdr.de>; Thu, 28 Oct 2021 18:24:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230258AbhJ1Q0Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Oct 2021 12:26:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229764AbhJ1Q0W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Oct 2021 12:26:22 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 937F5C061570
        for <netdev@vger.kernel.org>; Thu, 28 Oct 2021 09:23:55 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id n11-20020a17090a2bcb00b001a1e7a0a6a6so8383065pje.0
        for <netdev@vger.kernel.org>; Thu, 28 Oct 2021 09:23:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=SLos1s4MA33becVCWO18o60yJZKS53FeIqN19hIZHG0=;
        b=icXNNZN9mZCIBSozZCIaY3NNmU4QG9cKmWKlXql8eMHwT+SyQbgQk6g59Uk/8481mc
         Ix3iv4QzVw8KhteSX9uBGkQAA/HSR+Pqc4RqmIvI8Tw57vFaXBR8qqi8DZMq7qe3sMJq
         0XOGb8lWwzNVdSWsQLtKQszix5ymJrzKqJynioX0bHjupj9ZjzXN9vqvgELzpxYIKeLQ
         hMBCsiw/kOEd8i8Hpu9U/huew0G9Fcf4wHCMcjaBAb/axQYkcYulP1MPdc0KoctL9GFA
         1cK7/pYtJVdRRqwQ3PtAZpK1CBKQ8faIR3erFE5Lffh11nMXe/xMkrtxFxDYavB3x9wa
         oIiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=SLos1s4MA33becVCWO18o60yJZKS53FeIqN19hIZHG0=;
        b=H6wnmr+71EFS3aFb+vzVgv7vQIQN97GDgmqd+xCyXnzqfUr3gvIogR+RCwydIf90Dg
         u2RW22iVIJt1sZMpxqzpOwNBkf0yRj8ULlwe7M0kNnnPzBSXg28jxoIWkkOLUm+WL22n
         AQy/PefDG0B4NGfo68guoveheb9IJJ8/o7p2ov5vx0uUVYyIkR2KrJ8aYhMif9KBUSUp
         ZyTqRMAHaXob5dKRZdTwGRLQsCW4NnbqNfK3RduPNS6D4MOFn5hWQ1q/qPkmerFK+koU
         D86V28X6nnPgrUd9o90eOEUNRW4kDipodKALm3bSJyAtFBusG+YUvpgNGkwGm4OOh1S5
         BN7Q==
X-Gm-Message-State: AOAM53180ZmR9FIAWegQtmEROId4Z21kWPTixrFMQqstgJ7hlCspb7oo
        nIz2QHBBLLC5mFrl8+lmym1kMvWUq89wDw==
X-Google-Smtp-Source: ABdhPJxFnodY37deF6PwcAdrXLQlfoRVbw+bdNVIDa7PmuhkmPGeeXm1XM+PoJ7cdUnDMN/3pZTqhg==
X-Received: by 2002:a17:902:dad0:b0:140:3cd8:5901 with SMTP id q16-20020a170902dad000b001403cd85901mr4704031plx.74.1635438234778;
        Thu, 28 Oct 2021 09:23:54 -0700 (PDT)
Received: from [192.168.0.4] ([49.173.165.50])
        by smtp.gmail.com with ESMTPSA id x17sm3931600pfa.209.2021.10.28.09.23.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 28 Oct 2021 09:23:54 -0700 (PDT)
Subject: Re: [PATCH iproute2-next v2] ip: add AMT support
To:     David Ahern <dsahern@gmail.com>, stephen@networkplumber.org,
        netdev@vger.kernel.org
References: <20211026052808.1779-1-ap420073@gmail.com>
 <472c8693-80cf-0a62-918e-81004fa8acea@gmail.com>
From:   Taehee Yoo <ap420073@gmail.com>
Message-ID: <57982aae-d473-b2c5-22a4-b3b530202c68@gmail.com>
Date:   Fri, 29 Oct 2021 01:23:51 +0900
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <472c8693-80cf-0a62-918e-81004fa8acea@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David,
Thank you for your review!

On 10/29/21 12:18 AM, David Ahern wrote:
 > On 10/25/21 11:28 PM, Taehee Yoo wrote:
 >> +static void amt_print_opt(struct link_util *lu, FILE *f, struct 
rtattr *tb[])
 >> +{
 >> +	if (!tb)
 >> +		return;
 >> +
 >> +	if (tb[IFLA_AMT_MODE]) {
 >> +		print_string(PRINT_ANY,
 >> +			     "mode",
 >> +			     "%s ",
 >> +			     modename[rta_getattr_u32(tb[IFLA_AMT_MODE])]);
 >> +	}
 >> +
 >> +	if (tb[IFLA_AMT_GATEWAY_PORT]) {
 >> +		print_uint(PRINT_ANY,
 >> +			   "gateway_port",
 >> +			   "gateway_port %u ",
 >> +			   rta_getattr_be16(tb[IFLA_AMT_GATEWAY_PORT]));
 >> +	}
 >> +
 >> +	if (tb[IFLA_AMT_RELAY_PORT]) {
 >> +		print_uint(PRINT_ANY,
 >> +			   "relay_port",
 >> +			   "relay_port %u ",
 >> +			   rta_getattr_be16(tb[IFLA_AMT_RELAY_PORT]));
 >> +	}
 >> +
 >> +	if (tb[IFLA_AMT_LOCAL_IP]) {
 >> +		__be32 addr = rta_getattr_u32(tb[IFLA_AMT_LOCAL_IP]);
 >> +
 >> +		if (addr)
 >> +			print_string(PRINT_ANY,
 >> +				     "local",
 >> +				     "local %s ",
 >> +				     format_host(AF_INET, 4, &addr));
 >
 > if you only print the address when it is non-zero, why send it at all?
 > ie., kernel side can default to 0 (any address) but that value should
 > not be allowed or sent as part of the API. Same with the remote and
 > discovery addresses.
 >

Thanks, I will remove this check and I will add ipv4_is_zeronet() to the 
kernel.

 >> +	}
 >> +
 >> +	if (tb[IFLA_AMT_REMOTE_IP]) {
 >> +		__be32 addr = rta_getattr_u32(tb[IFLA_AMT_REMOTE_IP]);
 >> +
 >> +		if (addr)
 >> +			print_string(PRINT_ANY,
 >> +				     "remote",
 >> +				     "remote %s ",
 >> +				     format_host(AF_INET, 4, &addr));
 >> +	}
 >> +
 >> +	if (tb[IFLA_AMT_DISCOVERY_IP]) {
 >> +		__be32 addr = rta_getattr_u32(tb[IFLA_AMT_DISCOVERY_IP]);
 >> +
 >> +		if (addr) {
 >> +			print_string(PRINT_ANY,
 >> +				     "discovery",
 >> +				     "discovery %s ",
 >> +				     format_host(AF_INET, 4, &addr));
 >> +		}
 >> +	}
 >> +
 >> +	if (tb[IFLA_AMT_LINK]) {
 >> +		unsigned int link = rta_getattr_u32(tb[IFLA_AMT_LINK]);
 >> +
 >> +		if (link)
 >> +			print_string(PRINT_ANY, "link", "dev %s ",
 >> +				     ll_index_to_name(link));
 >
 > similar argument here: IFLA_AMT_LINK should only be sent if an actual
 > link association is configured.
 >

Thanks, I will remove it too.

 >> +	}
 >> +
 >> +	if (tb[IFLA_AMT_MAX_TUNNELS]) {
 >> +		unsigned int tunnels = rta_getattr_u32(tb[IFLA_AMT_MAX_TUNNELS]);
 >> +
 >> +		if (tunnels)
 >> +			print_uint(PRINT_ANY, "max_tunnels", "max_tunnels %u ",
 >> +				   rta_getattr_u32(tb[IFLA_AMT_MAX_TUNNELS]));
 >
 > and here.
 >

here too.

 >> +	}
 >> +}
 >> +
 >
 >

Thanks a lot for your detailed review!
I will send the v3 patch soon.

Thanks,
Taehee
