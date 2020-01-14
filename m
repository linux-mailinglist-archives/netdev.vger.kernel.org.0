Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B595E13ADCE
	for <lists+netdev@lfdr.de>; Tue, 14 Jan 2020 16:39:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726669AbgANPjn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jan 2020 10:39:43 -0500
Received: from mail-io1-f65.google.com ([209.85.166.65]:35100 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726265AbgANPjn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jan 2020 10:39:43 -0500
Received: by mail-io1-f65.google.com with SMTP id h8so14330227iob.2
        for <netdev@vger.kernel.org>; Tue, 14 Jan 2020 07:39:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=D9JUE8/tC02v7P9wG1dIUFbMsIMAWUcLH6RCg+tUe4I=;
        b=GnQJvCRYbTSufF70k7c9v3uc6r9di/rdE74OD+KO590AEE56mLh9/nAZHvBLO3xPxZ
         bf9DRKQ/nMC8p3aWCurQpj8NlLzJjouP6y/xpBrEJPjhC1xv+A51CisVTEYlf1n1AiXW
         jcr85GoLeum+LAaeHWttefck+FZCLlc8g2u6FjBs7Jv5XhWqHxr9PTg+obPhPdZoSHUQ
         tO7g2s/4TSPHbC7MBwB22hCqDfyuVQWPlWkI4MtBORgvWEKWeTeEzDkAoz2byxj81uPp
         ocOmxbQrLlc7mtKqWZJ8SfXMBNUA2D1JX81KzMx9v/SGdM9iLoGUIqoPnA8sL2MzFkuX
         st6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=D9JUE8/tC02v7P9wG1dIUFbMsIMAWUcLH6RCg+tUe4I=;
        b=U0nvjG7o1zk2+l5+BZoDINjMLmdrFfwgLMzZVJR3TVHUzxOBb9Pw8GEOjgVxhq23zu
         vReCstay3kFqyANzopPeN/9FBkPIV/XDpl/SNYDYECyS2eFzfUW6i6vSNQAG0YAYNbc5
         VUjuhoCL0nQL48bGnL2HTDpTRtHZtINhDGZDr43zevU+wux/oV6vjZxAIy6lXLrKZLVz
         8xA79M0ndrsjhEVZW1Glq1QJMJtHJtvsU2c1atDHfnxrJBsI4INTpnbNqPugh7QUBDEv
         znJfCHIKCTPxGHrxPwDCzUCh1Iq7vgKPdOGEZGlLyAi5K4I12poqi7tD4j1JqamEwAiF
         YL3w==
X-Gm-Message-State: APjAAAVuy2SpjA8mExaicr0mSKipHjmRfBriPybPQ4E0We+35oAO3Jvh
        eYUVGKkvPIs4wPlXVzRxnxo=
X-Google-Smtp-Source: APXvYqzlKObvMFKFNBsFtiAHHQ7iSX4WApgn1WYAgkeo940rfDWzTBfz/sOa8vR6fMKsn9fiXXzsNQ==
X-Received: by 2002:a05:6638:3b6:: with SMTP id z22mr19072708jap.35.1579016382504;
        Tue, 14 Jan 2020 07:39:42 -0800 (PST)
Received: from ?IPv6:2601:282:800:7a:ad53:3eb0:98a5:6359? ([2601:282:800:7a:ad53:3eb0:98a5:6359])
        by smtp.googlemail.com with ESMTPSA id g4sm5055945iln.81.2020.01.14.07.39.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Jan 2020 07:39:41 -0800 (PST)
Subject: Re: [PATCH net-next v2 02/10] ipv4: Encapsulate function arguments in
 a struct
To:     Ido Schimmel <idosch@idosch.org>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@mellanox.com,
        roopa@cumulusnetworks.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
References: <20200114112318.876378-1-idosch@idosch.org>
 <20200114112318.876378-3-idosch@idosch.org>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <0f99fc24-09ad-6f44-dec1-d2a5682af502@gmail.com>
Date:   Tue, 14 Jan 2020 08:39:40 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.3.1
MIME-Version: 1.0
In-Reply-To: <20200114112318.876378-3-idosch@idosch.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/14/20 4:23 AM, Ido Schimmel wrote:
> From: Ido Schimmel <idosch@mellanox.com>
> 
> fib_dump_info() is used to prepare RTM_{NEW,DEL}ROUTE netlink messages
> using the passed arguments. Currently, the function takes 11 arguments,
> 6 of which are attributes of the route being dumped (e.g., prefix, TOS).
> 
> The next patch will need the function to also dump to user space an
> indication if the route is present in hardware or not. Instead of
> passing yet another argument, change the function to take a struct
> containing the different route attributes.
> 
> v2:
> * Name last argument of fib_dump_info()
> * Move 'struct fib_rt_info' to include/net/ip_fib.h so that it could
>   later be passed to fib_alias_hw_flags_set()
> 
> Signed-off-by: Ido Schimmel <idosch@mellanox.com>
> ---
>  include/net/ip_fib.h     |  9 +++++++++
>  net/ipv4/fib_lookup.h    |  5 ++---
>  net/ipv4/fib_semantics.c | 26 ++++++++++++++++----------
>  net/ipv4/fib_trie.c      | 14 +++++++++-----
>  net/ipv4/route.c         | 12 +++++++++---
>  5 files changed, 45 insertions(+), 21 deletions(-)
> 

Reviewed-by: David Ahern <dsahern@gmail.com>


