Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 307631BEE66
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 04:43:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726811AbgD3Cnf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Apr 2020 22:43:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726180AbgD3Cnf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Apr 2020 22:43:35 -0400
Received: from mail-qk1-x744.google.com (mail-qk1-x744.google.com [IPv6:2607:f8b0:4864:20::744])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA27BC035494
        for <netdev@vger.kernel.org>; Wed, 29 Apr 2020 19:43:34 -0700 (PDT)
Received: by mail-qk1-x744.google.com with SMTP id m67so4289872qke.12
        for <netdev@vger.kernel.org>; Wed, 29 Apr 2020 19:43:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=mtepWqujaofxmhGIAstikWzN5vdczYMaohbu8sSsGyE=;
        b=kB1GwFCglSy4t7NWpFt+6SjNxqCJiDiTvDi68ujI6ofbAWDyYkfNAeQqZUNT1k+zxI
         AiN8TxpW3ysdxHOZiXc47muRk1uB+3rziNXP59S/1gh8kTU3ZIakaGUihrukd3U8fgfG
         rLjk3b4ewgCvaENF3BkTqfiE8irITt9/RuiHG9V2BTHUxm69fqpfhj1Q7x7Tj0kBFdYf
         Oj2iZW0te4KZcNZHh10pg6B6NvQMtZisSe/fa/Jlx5snE9YMdE8tM3q4sa0Is8FXd7Yf
         j4XHF52uooVw/aqh29z3ZmWWedXrIOo7dwvEiewxj8vaaVXJOAwzPnIqA9KdEqJAxiBB
         O9qA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=mtepWqujaofxmhGIAstikWzN5vdczYMaohbu8sSsGyE=;
        b=Cnvu3Tdy78YcUYA6aPMfwUppKnypWvQ5GwEJi5hDUZstFagrzOwG4De3ap2djsDLhB
         NyeDyn6z+QAaJA+/9igyWFl9oYpCWPT/MN/jMY/gZGaHwXye8nJ74FyhoUfASy9QGWgw
         1jkc2efZd/KUdltQyB13EQJMWpYAdqrxZKK+tDxBXC/VJ0WKXingxAnduewvH0KcHdKJ
         YdgXtJmE9kwfFQX1ONOb9rJl4Atwmmh9RvJQ1b8CvM+hdTCiZqWeFBKak45SVS8BbG8V
         /F0aweep7U3J2rt+qJkT990QVnkcPPjVhdiwNXd0TnAfCQwD1IIDn16eNKRoD9i+XGCv
         V8Iw==
X-Gm-Message-State: AGi0PuaOMwYLqyZbMu/DCkXvWgal9FK0Wann2g1V7PQX0IyRm6KZ9stA
        1QdiEtamVBC7yfzU7Yu5ovWTz2AJ
X-Google-Smtp-Source: APiQypLDoo4xTCONlFPN8Se/NU16zqOZBmcMCqH3wq2XppRXYFatBi3O+Sb5AIPvU6LC4qIBoT7/aA==
X-Received: by 2002:a05:620a:1521:: with SMTP id n1mr1512640qkk.293.1588214614049;
        Wed, 29 Apr 2020 19:43:34 -0700 (PDT)
Received: from ?IPv6:2601:282:803:7700:ec9c:e6ab:797a:4bad? ([2601:282:803:7700:ec9c:e6ab:797a:4bad])
        by smtp.googlemail.com with ESMTPSA id q15sm797493qkn.100.2020.04.29.19.43.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 29 Apr 2020 19:43:33 -0700 (PDT)
Subject: Re: [PATCH iproute2-next v2] tc: pedit: Support JSON dumping
To:     Petr Machata <petrm@mellanox.com>, netdev@vger.kernel.org
Cc:     dsahern@gmail.com, stephen@networkplumber.org
References: <65858649cfcbad9e7dbedf392906d8aa31139735.1588074203.git.petrm@mellanox.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <aea4f633-b4b4-4b3c-79b4-9b4876833e96@gmail.com>
Date:   Wed, 29 Apr 2020 20:43:32 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <65858649cfcbad9e7dbedf392906d8aa31139735.1588074203.git.petrm@mellanox.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/28/20 5:44 AM, Petr Machata wrote:
> The action pedit does not currently support dumping to JSON. Convert
> print_pedit() to the print_* family of functions so that dumping is correct
> both in plain and JSON mode. In plain mode, the output is character for
> character the same as it was before. In JSON mode, this is an example dump:
> 
> $ tc filter add dev dummy0 ingress prio 125 flower \
>          action pedit ex munge udp dport set 12345 \
> 	                 munge ip ttl add 1        \
> 			 munge offset 10 u8 clear
> $ tc -j filter show dev dummy0 ingress | jq
> [
>   {
>     "protocol": "all",
>     "pref": 125,
>     "kind": "flower",
>     "chain": 0
>   },
>   {
>     "protocol": "all",
>     "pref": 125,
>     "kind": "flower",
>     "chain": 0,
>     "options": {
>       "handle": 1,
>       "keys": {},
>       "not_in_hw": true,
>       "actions": [
>         {
>           "order": 1,
>           "kind": "pedit",
>           "control_action": {
>             "type": "pass"
>           },
>           "nkeys": 3,
>           "index": 1,
>           "ref": 1,
>           "bind": 1,
>           "keys": [
>             {
>               "htype": "udp",
>               "offset": 0,
>               "cmd": "set",
>               "val": "3039",
>               "mask": "ffff0000"
>             },
>             {
>               "htype": "ipv4",
>               "offset": 8,
>               "cmd": "add",
>               "val": "1000000",
>               "mask": "ffffff"
>             },
>             {
>               "htype": "network",
>               "offset": 8,
>               "cmd": "set",
>               "val": "0",
>               "mask": "ffff00ff"
>             }
>           ]
>         }
>       ]
>     }
>   }
> ]
> 
> Signed-off-by: Petr Machata <petrm@mellanox.com>
> ---
> 

applied to iproute2-next

