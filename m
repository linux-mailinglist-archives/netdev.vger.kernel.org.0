Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8442482C21
	for <lists+netdev@lfdr.de>; Sun,  2 Jan 2022 17:45:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229522AbiABQpP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Jan 2022 11:45:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229515AbiABQpO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Jan 2022 11:45:14 -0500
Received: from mail-io1-xd34.google.com (mail-io1-xd34.google.com [IPv6:2607:f8b0:4864:20::d34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04B88C061761
        for <netdev@vger.kernel.org>; Sun,  2 Jan 2022 08:45:14 -0800 (PST)
Received: by mail-io1-xd34.google.com with SMTP id l3so35659722iol.10
        for <netdev@vger.kernel.org>; Sun, 02 Jan 2022 08:45:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=8iD61ggUb3gwYWGxe14jO8A6voeqSHv452r75cpLQLY=;
        b=id0g+0M7wxhyvg3ku5BnhNiOjpeHgcTIGfMeXwRUybgwIZ7+mqhze6gPusS/q9qyul
         /meuQra6OkIWxLmlXxTseRH+h2jZlzUZruAjV6DgrIDPiYvsBHE0nsVoUftcbuwDKNw1
         a8TNS7VgRFZjFO3PddRDcfjpYxrUcL7W0ji/c3suI7++Bf/1BKYN/W8/et6LGMsVl8VE
         I0N2zUZHWLc1yK5I2tueeMvxzNVwjnveSR2dpMcpezKT8EWdj+We4oyP8qFRZF1fQ8HS
         lCkPYsYgK4Ri4ZRfy+7EKY9z0K8LKZanNGam+S5NaU0/1CY9Ei5l0Ta1uNUTriaMMunw
         wobA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=8iD61ggUb3gwYWGxe14jO8A6voeqSHv452r75cpLQLY=;
        b=5LpRaLZdPr2eJy3wJ1qtgbOkgRkS2zbhKNJ4DEtRq4DIbFHppyzoDfAB6m1A26SPVm
         K4vjhcZzZXYMUC2r6lkJ0AlVcB7X2oMcAONbLE9MevptV6bYUmKPWPklUXTDQij4UVKm
         LCnWnH2nIa2kN1b5TbETVqQQOf5iJUNwpPmOcanIyA47Y0ceCmGnMyRInGqzOCH7LHoH
         I+7QJlYOJhnhCpMK0DZ1XfEPvEG3izSOSXjGEQW3neCsVeR5rrW1z3IYg1Uj1CNWJK+D
         zKX3EtAOwTGe291rJGKU67osC/RDHxjHeyk8AtYVx9IUqE1PIwey7+z2eN5KaAFJzFvu
         HQLQ==
X-Gm-Message-State: AOAM533VTCRhjocagcxVi+hGYGyVovj3t6/A6K7+N6CVRl1XQUthjJER
        nyXfR3CT1Iiqn567getrecE/PBTsVoc=
X-Google-Smtp-Source: ABdhPJynX/A/NJqKryd6EY2QEdPhBypAU4orCTWDOlIfDUKtQDlHNOxMMGt9PfWXTbcmJh0geJHuMQ==
X-Received: by 2002:a05:6638:387:: with SMTP id y7mr18638833jap.135.1641141913189;
        Sun, 02 Jan 2022 08:45:13 -0800 (PST)
Received: from [172.16.0.2] ([8.48.134.30])
        by smtp.googlemail.com with ESMTPSA id s20sm19975876iog.25.2022.01.02.08.45.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 02 Jan 2022 08:45:12 -0800 (PST)
Message-ID: <a9706c13-a519-9942-958e-20bc4ce6df9e@gmail.com>
Date:   Sun, 2 Jan 2022 09:45:11 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.4.1
Subject: Re: [PATCH net 3/5] ipv6: Check attribute length for RTA_GATEWAY in
 multipath route
Content-Language: en-US
To:     nicolas.dichtel@6wind.com, netdev@vger.kernel.org
Cc:     idosch@idosch.org
References: <20211231003635.91219-1-dsahern@kernel.org>
 <20211231003635.91219-4-dsahern@kernel.org>
 <468b1a92-7613-e89e-d89d-48c0aa48e71c@6wind.com>
From:   David Ahern <dsahern@gmail.com>
In-Reply-To: <468b1a92-7613-e89e-d89d-48c0aa48e71c@6wind.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/31/21 8:30 AM, Nicolas Dichtel wrote:
> Le 31/12/2021 à 01:36, David Ahern a écrit :
>> Commit referenced in the Fixes tag used nla_memcpy for RTA_GATEWAY as
>> does the current nla_get_in6_addr. nla_memcpy protects against accessing
>> memory greater than what is in the attribute, but there is no check
>> requiring the attribute to have an IPv6 address. Add it.
>>
>> Fixes: 51ebd3181572 ("ipv6: add support of equal cost multipath (ECMP)")
>> Signed-off-by: David Ahern <dsahern@kernel.org>
>> Cc: Nicolas Dichtel <nicolas.dichtel@6wind.com>
>> ---
>>  net/ipv6/route.c | 21 ++++++++++++++++++++-
>>  1 file changed, 20 insertions(+), 1 deletion(-)
>>
> [snip]
>> @@ -5264,7 +5277,13 @@ static int ip6_route_multipath_add(struct fib6_config *cfg,
>>  
>>  			nla = nla_find(attrs, attrlen, RTA_GATEWAY);
>>  			if (nla) {
>> -				r_cfg.fc_gateway = nla_get_in6_addr(nla);
>> +				int ret;
>> +
>> +				ret = fib6_gw_from_attr(&r_cfg.fc_gateway, nla,
>> +							extack);
>> +				if (ret)
>> +					return ret;
> A 'goto cleanup;' is needed is case of error.

good catch; will send a followup.
