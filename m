Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1618443E4E3
	for <lists+netdev@lfdr.de>; Thu, 28 Oct 2021 17:18:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230070AbhJ1PVB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Oct 2021 11:21:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229946AbhJ1PVA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Oct 2021 11:21:00 -0400
Received: from mail-ot1-x332.google.com (mail-ot1-x332.google.com [IPv6:2607:f8b0:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1AFCC061570
        for <netdev@vger.kernel.org>; Thu, 28 Oct 2021 08:18:33 -0700 (PDT)
Received: by mail-ot1-x332.google.com with SMTP id 71-20020a9d034d000000b00553e24ce2b8so4368743otv.7
        for <netdev@vger.kernel.org>; Thu, 28 Oct 2021 08:18:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=XslRbcCtEf6Nfyp1TMSp0icL2Pnffcrdcolgw4C/FmE=;
        b=IR/MVzt439gw+pLk+Zd8s5mdG/SlLMePUV06CLwIK12o8LM11Ao67UiQ0KbVRXJ14w
         tQTGcecGr2xYiKDTUlTRE13SvqtCsGXQKMfyNXzrwuLtchiBlfIFZeNdpZuqqi+OESdq
         TpST9G3+J6mnhcqGzPC74qsD2ifltCSi5u0VX2J7Z/DzycdJF+GUzNu//J668321I11+
         wllmToQWXtdx6DpM1Jx+riiLePMD974PLpWMgKCzaPxnJrBzcdJqOs+qduTTTrVYL7b4
         7uyvP/x0/m/1GKmSfTv6tCglEuYEKxdOpo6kGe1WTDHbmaaUr13yJu3IQSHYSGH0gHj7
         clhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=XslRbcCtEf6Nfyp1TMSp0icL2Pnffcrdcolgw4C/FmE=;
        b=bNfcMCsgFIgSRCJjkUc85YgQhDdS80aeXAAWpa5i+iwnItC3qIfqF3tuJkeDh8Al/C
         cNeP5EHFDsqvsAj76CRW9OZYYJh5TQIHx+c5D9LzcyRSkCOPVUK2OL6NrlvQ3UofeN1W
         maLOj28rkRhu0BjXQHFaT90+SYWp2cSX8HXkjXq7gp2C/4oIO010NZH4/k8efB1QsB5j
         GdePVcEf88A15onSJ3En/NOAN2UEPLuUvC6V3BJ3jRxOj3Y6C0hc2htDpY1YYFGbkApQ
         UC0+YF6/tqN4BS53QcgwBRDfD9l3ji3sM6nWUqHgD0YIwsUIM0ObSnXvcBJPtPPNCe8e
         yuYw==
X-Gm-Message-State: AOAM532pnlNtyAkP4ePKukvmsDLQtrvki0Q4YUWBVi1WJKVm3ee6NkhI
        A61Uqxi/C7JfTq9FcdEkMnQtnQzAnp4=
X-Google-Smtp-Source: ABdhPJx2shToJufck9BjCcCQJ/iSn5N8rVXXPL66qw4+2mvyrMPo9Y0t24lBDzXIvUkRuPmEcDrC4g==
X-Received: by 2002:a9d:7655:: with SMTP id o21mr3930142otl.126.1635434312899;
        Thu, 28 Oct 2021 08:18:32 -0700 (PDT)
Received: from [172.16.0.2] ([8.48.134.30])
        by smtp.googlemail.com with ESMTPSA id m23sm1101614oom.34.2021.10.28.08.18.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 28 Oct 2021 08:18:32 -0700 (PDT)
Message-ID: <472c8693-80cf-0a62-918e-81004fa8acea@gmail.com>
Date:   Thu, 28 Oct 2021 09:18:31 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.2.1
Subject: Re: [PATCH iproute2-next v2] ip: add AMT support
Content-Language: en-US
To:     Taehee Yoo <ap420073@gmail.com>, stephen@networkplumber.org,
        netdev@vger.kernel.org
References: <20211026052808.1779-1-ap420073@gmail.com>
From:   David Ahern <dsahern@gmail.com>
In-Reply-To: <20211026052808.1779-1-ap420073@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/25/21 11:28 PM, Taehee Yoo wrote:
> +static void amt_print_opt(struct link_util *lu, FILE *f, struct rtattr *tb[])
> +{
> +	if (!tb)
> +		return;
> +
> +	if (tb[IFLA_AMT_MODE]) {
> +		print_string(PRINT_ANY,
> +			     "mode",
> +			     "%s ",
> +			     modename[rta_getattr_u32(tb[IFLA_AMT_MODE])]);
> +	}
> +
> +	if (tb[IFLA_AMT_GATEWAY_PORT]) {
> +		print_uint(PRINT_ANY,
> +			   "gateway_port",
> +			   "gateway_port %u ",
> +			   rta_getattr_be16(tb[IFLA_AMT_GATEWAY_PORT]));
> +	}
> +
> +	if (tb[IFLA_AMT_RELAY_PORT]) {
> +		print_uint(PRINT_ANY,
> +			   "relay_port",
> +			   "relay_port %u ",
> +			   rta_getattr_be16(tb[IFLA_AMT_RELAY_PORT]));
> +	}
> +
> +	if (tb[IFLA_AMT_LOCAL_IP]) {
> +		__be32 addr = rta_getattr_u32(tb[IFLA_AMT_LOCAL_IP]);
> +
> +		if (addr)
> +			print_string(PRINT_ANY,
> +				     "local",
> +				     "local %s ",
> +				     format_host(AF_INET, 4, &addr));

if you only print the address when it is non-zero, why send it at all?
ie., kernel side can default to 0 (any address) but that value should
not be allowed or sent as part of the API. Same with the remote and
discovery addresses.

> +	}
> +
> +	if (tb[IFLA_AMT_REMOTE_IP]) {
> +		__be32 addr = rta_getattr_u32(tb[IFLA_AMT_REMOTE_IP]);
> +
> +		if (addr)
> +			print_string(PRINT_ANY,
> +				     "remote",
> +				     "remote %s ",
> +				     format_host(AF_INET, 4, &addr));
> +	}
> +
> +	if (tb[IFLA_AMT_DISCOVERY_IP]) {
> +		__be32 addr = rta_getattr_u32(tb[IFLA_AMT_DISCOVERY_IP]);
> +
> +		if (addr) {
> +			print_string(PRINT_ANY,
> +				     "discovery",
> +				     "discovery %s ",
> +				     format_host(AF_INET, 4, &addr));
> +		}
> +	}
> +
> +	if (tb[IFLA_AMT_LINK]) {
> +		unsigned int link = rta_getattr_u32(tb[IFLA_AMT_LINK]);
> +
> +		if (link)
> +			print_string(PRINT_ANY, "link", "dev %s ",
> +				     ll_index_to_name(link));

similar argument here: IFLA_AMT_LINK should only be sent if an actual
link association is configured.

> +	}
> +
> +	if (tb[IFLA_AMT_MAX_TUNNELS]) {
> +		unsigned int tunnels = rta_getattr_u32(tb[IFLA_AMT_MAX_TUNNELS]);
> +
> +		if (tunnels)
> +			print_uint(PRINT_ANY, "max_tunnels", "max_tunnels %u ",
> +				   rta_getattr_u32(tb[IFLA_AMT_MAX_TUNNELS]));

and here.

> +	}
> +}
> +


