Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1F01330313
	for <lists+netdev@lfdr.de>; Thu, 30 May 2019 21:59:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726509AbfE3T7a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 May 2019 15:59:30 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:44214 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725897AbfE3T7a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 May 2019 15:59:30 -0400
Received: by mail-pl1-f193.google.com with SMTP id c5so2979818pll.11
        for <netdev@vger.kernel.org>; Thu, 30 May 2019 12:59:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=7Kh8DTIY3KFXDtpfwS8ya3tmUW37sq2ILgUTDH1kq0s=;
        b=Eec6+oXFiJmj5cYdDlC3FxqpN0kBS1YocoaglgbujQgDWlNJ0bX9QqWEoRtoyI2u7e
         QJXfp8cPIH1jZ472pzLmTAlbEk/D3xpSkhTG6vpvdrbn5eM1+ITA8zVzH5IGmSUKFKFS
         RvUmMWm4Pu+8DFx/n8NCbKbZJH45xrrjtsz3dVulUJHgP2N2jIASpSX+62NdPXb2E4ev
         uVvLdgCtRDZbHE6Eqj+2Qe6l+GA2pYXJ6yG3TFNskE+9wbuWX2MgR7ELtX6xSqjokoMg
         mj5NVg6AuGk3frMLeBdP75G0ti70d8sTGs0scID2ErbBy++m0F2CRaA41+5NHUqF9RA0
         dDZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=7Kh8DTIY3KFXDtpfwS8ya3tmUW37sq2ILgUTDH1kq0s=;
        b=SV2oBbTHLxJIDUr/8Zj5U1F3y0Q3P06xgrqjN6GguB38J7mLfE/GBoY0dwJQMtjrA4
         XOwr6NEDmpfMMZ9wTww5BIee7OrU0rSzFGacsnm4+xD7KVKMdpGN3IlyPBgLTBiR05ot
         o9Ho5xwc+gNP5OZIyWmxoJo83egAPHpAsYEVsu0uSoNp/yEZliqSzzzKtE282J+nBM/C
         4CFr6A9bOYaleqjYODQobFdk65Xppi06ovOZ059jPBAZraz5NM7UByf19kJapWY2wdIl
         /icVasmEV5abMloa+1qzqBQX9TkzRxpFY6zVSQKWqQWfttf3jKCIgaSSxqMtg3dHrGed
         TkDA==
X-Gm-Message-State: APjAAAW8zX82N1XYMFBbBwHfYAIpkvNggwd9y10oP+iQGZmq/2ARSDmr
        BO5Y9c07Asc14MblrTYMr6p17yH0je0=
X-Google-Smtp-Source: APXvYqzfvjjAAuW2yd99YZ/ywZDFkgS+dSf8chghhVQ39PNQSOX470wzbiZd6+61kAAX2mDgM32Z5g==
X-Received: by 2002:a17:902:2884:: with SMTP id f4mr5018143plb.230.1559246369726;
        Thu, 30 May 2019 12:59:29 -0700 (PDT)
Received: from [172.27.227.250] ([216.129.126.118])
        by smtp.googlemail.com with ESMTPSA id h14sm2709285pgj.8.2019.05.30.12.59.28
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 30 May 2019 12:59:28 -0700 (PDT)
Subject: Re: [PATCH iproute2-next 5/9] libnetlink: Add helper to create
 nexthop dump request
To:     Roopa Prabhu <roopa@cumulusnetworks.com>,
        David Ahern <dsahern@kernel.org>
Cc:     Stephen Hemminger <stephen@networkplumber.org>,
        netdev <netdev@vger.kernel.org>
References: <20190530031746.2040-1-dsahern@kernel.org>
 <20190530031746.2040-6-dsahern@kernel.org>
 <CAJieiUjM5-4up5RU5KV=yJALH67+MReqBZ2DymoeDz0YzNN=dA@mail.gmail.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <30fa885d-67a7-e04d-3f17-07b7cdc599f7@gmail.com>
Date:   Thu, 30 May 2019 13:59:27 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <CAJieiUjM5-4up5RU5KV=yJALH67+MReqBZ2DymoeDz0YzNN=dA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/30/19 1:56 PM, Roopa Prabhu wrote:

>> diff --git a/lib/libnetlink.c b/lib/libnetlink.c
>> index eb85bbdf01ee..c1cdda3b8d4e 100644
>> --- a/lib/libnetlink.c
>> +++ b/lib/libnetlink.c
>> @@ -25,6 +25,7 @@
>>  #include <linux/fib_rules.h>
>>  #include <linux/if_addrlabel.h>
>>  #include <linux/if_bridge.h>
>> +#include <linux/nexthop.h>
>>
>>  #include "libnetlink.h"
>>
>> @@ -252,6 +253,32 @@ int rtnl_open(struct rtnl_handle *rth, unsigned int subscriptions)
>>         return rtnl_open_byproto(rth, subscriptions, NETLINK_ROUTE);
>>  }
>>
>> +int rtnl_nexthopdump_req(struct rtnl_handle *rth, int family,
>> +                        req_filter_fn_t filter_fn)
>> +{
>> +       struct {
>> +               struct nlmsghdr nlh;
>> +               struct nhmsg nhm;
>> +               char buf[128];
>> +       } req = {
>> +               .nlh.nlmsg_len = NLMSG_LENGTH(sizeof(struct ifaddrmsg)),
> 
> sizeof(struct nhmsg) ?
> 

good catch. fixed.

