Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 050523DD739
	for <lists+netdev@lfdr.de>; Mon,  2 Aug 2021 15:35:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233875AbhHBNfy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Aug 2021 09:35:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233719AbhHBNfx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Aug 2021 09:35:53 -0400
Received: from mail-oi1-x230.google.com (mail-oi1-x230.google.com [IPv6:2607:f8b0:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64D7DC06175F;
        Mon,  2 Aug 2021 06:35:44 -0700 (PDT)
Received: by mail-oi1-x230.google.com with SMTP id q6so24068191oiw.7;
        Mon, 02 Aug 2021 06:35:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=X53LpF2kO65kz803KOIFSNLqcQAq/CJTKMFv1axedq0=;
        b=GszpJG+QV6Tr45bD/TAem8TbYsT69ak6AZLfwtetur1m18YxkhllwVNq3IFUiyzHX6
         O9kr3M5wkRktx9eD5vN/DoZGn/bDIRGuC5jipqH0AssiPS8AMjAZ/lEOcMyovVnB/+pV
         1bkREY8Y8hug1n9cCwYluAkXYzK8gyU+T+fGKMmCKJqjul/OJsGbQ9SZjIuzODnFd4hj
         z5kAtpR2vUuw1Mr2PEkiO3VnshktUwur84+HWkEQi72BsKXjDcW/trbPY/DOf1bbxM0x
         MD8uLONZd+qImcZozj3AOjWd5QkzzQRbJTP3TowTHXpA0SaeOPYz7/URJD0KsfZt0+Po
         y63w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=X53LpF2kO65kz803KOIFSNLqcQAq/CJTKMFv1axedq0=;
        b=npnVEobdEESBtqbfAigqeYoifCsiGdreFAupkntwEfZql2L6x70uIn55WvroQi9kIp
         /MzlnZQFKxEZsC900dbuN+bXwqcUY7m2FeTfQC/WjOHdFgwptglj9vDox2hFv9DDopmn
         LJobg3BcD2Q06dVCowoB5indC63CGNbjWYBY78va4mKnMgNO6RRyGXSgbcBRbq/6Id73
         CerIXaGmNmz1tYCOJ+Q97Da9+hwNu872oUVKVVIZYsPs9xsQl3NAf+4BmN0dnciYNv3y
         MJ5hoOhFvKW75p6Y0ecj9M1fMD0RqGPqiOSWKxkO6xaQB8YBcza97NT0fe7X+CIfYJxM
         /RuQ==
X-Gm-Message-State: AOAM533iaf2ZBUfkWOY+zTJ6WUda9qYZAgQwaCPckxFMibdMZHlqEbP6
        ISxW2Yfw7IhKtWKO3hkCueM=
X-Google-Smtp-Source: ABdhPJyH3oocCaQRCCUiP6oA4SY0kwqhDuto+HIg3zCsoXTPSDhN6JNZdaflsgv6M2wgMpoecvZ+pw==
X-Received: by 2002:aca:240b:: with SMTP id n11mr10753237oic.63.1627911343834;
        Mon, 02 Aug 2021 06:35:43 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.48.134.27])
        by smtp.googlemail.com with ESMTPSA id z8sm1534840oog.19.2021.08.02.06.35.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 02 Aug 2021 06:35:43 -0700 (PDT)
Subject: Re: [PATCH net-next v2] ipv6: add IFLA_INET6_RA_MTU to expose mtu
 value in the RA message
To:     Rocco Yue <rocco.yue@mediatek.com>,
        David Ahern <dsahern@kernel.org>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, rocco.yue@gmail.com,
        chao.song@mediatek.com, zhuoliang.zhang@mediatek.com
References: <20210802031924.3256-1-rocco.yue@mediatek.com>
 <20210802124039.13231-1-rocco.yue@mediatek.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <c20aa306-81a9-f083-25e8-85002063b4cc@gmail.com>
Date:   Mon, 2 Aug 2021 07:35:39 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210802124039.13231-1-rocco.yue@mediatek.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/2/21 6:40 AM, Rocco Yue wrote:
> On Sat, 2021-07-31 at 11:17 -0600, David Ahern wrote:
> On 7/30/21 7:52 PM, Rocco Yue wrote:
> 
>> IFLA_INET6_RA_MTU set. You can set "reject_message" in the policy to
>> return a message that "IFLA_INET6_RA_MTU can not be set".
> 
> Hi David,
> 
> Regarding setting "reject_message" in the policy, after reviewing
> the code, I fell that it is unnecessary, because the cost of
> implementing it seems to be a bit high, which requires modifying
> the function interface. The reasons is as follows:

The policy can be setup now to do the right thing once the extack
argument is available.

do_setlink() has an extack argument. It calls validate_linkmsg which
calls validate_link_af meaning support can be added in a single patch.
If you decide to do it, then it should be a separate patch preceding
this one.
