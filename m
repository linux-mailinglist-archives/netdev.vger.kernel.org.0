Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 05F7111420
	for <lists+netdev@lfdr.de>; Thu,  2 May 2019 09:28:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726268AbfEBH2s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 May 2019 03:28:48 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:37984 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726249AbfEBH2s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 May 2019 03:28:48 -0400
Received: by mail-wr1-f68.google.com with SMTP id k16so1803659wrn.5
        for <netdev@vger.kernel.org>; Thu, 02 May 2019 00:28:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=6wind.com; s=google;
        h=reply-to:subject:to:cc:references:from:organization:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=qFic4ZCJHq3vK52L3neHzBnAuNqEWHD8/WodEeFmKUw=;
        b=EPCdfGR07x/XReMXooZCRNQ1xr9mPc2lIqPeZIXxH/bM5yQ6pWgVJGMbqr8SJlwrrw
         YUzXn4wQe731WM99IMPfq8Bb5FQqwrbzWA8UghmwEfX9+46BLXEqg+Vkf+yaCHPIKHij
         VlTxD5iAis+GFz/Y7sgPeOCnAmJ/IYX1Ja6rJtAL50TLO0KJErRimC1uE6JcMNMPnnjj
         15jnJaHE/cILH1GKg82No7AuvoU3tfg9R3foh65eEMgCmUFVBrgDUoOucYsGecOkXjdH
         Gslvnbu23HhzjT8X8Vrt8r1lf2wW3YfQxv1pTqJpblLV3bKbGBYreRfh/2Z73x8nEyI1
         pFEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:subject:to:cc:references:from
         :organization:message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=qFic4ZCJHq3vK52L3neHzBnAuNqEWHD8/WodEeFmKUw=;
        b=Lj1Ppk2mGEAFrjnadYJcyXKQ5dw0YMhRlMvZdU78voF+6c4OGDfpSdD3/pRvOE4xKw
         OgG+MVObgLD1HFjkH00pJmbdogCZpgX8lpPRh0q6YsG6/8VE0cmHCcwZkCTIvym7r+7Q
         c4OXByuDziYi3o9n5ayd4NH81F00HV7TV4FcZvk8Cb8uf+FkcOEoK8eMWHjHMFbC8Yjn
         Bqcacpz4g5dvJIrg8PLzNdVo3iGMq9blBBy7tyb3RmV1TEgDsag4swFOungQOJTYlPIx
         1gFZeqL53J3imPUZX0kLUQz7yXKhDYeaq8441575PU6qaWe0dCUKr7qeWqG5q82kELLM
         5d2A==
X-Gm-Message-State: APjAAAWY907RwRUIoSw6O5CuRa/OWNOZ/cwnXVgpHNFkwfxm5PnDG3fF
        TkUeBYKsO0XhpqXMHtRMQiI4OQU7kOQ=
X-Google-Smtp-Source: APXvYqzuK+iNfWJu3+vrAFi9NAetVXJfc70FYtdC2USIBs/yvwJaWyLAN9gMDHkiJjJ29rkM95paHQ==
X-Received: by 2002:adf:eb89:: with SMTP id t9mr1632853wrn.109.1556782125989;
        Thu, 02 May 2019 00:28:45 -0700 (PDT)
Received: from ?IPv6:2a01:e35:8b63:dc30:c51a:8579:612a:9e21? ([2a01:e35:8b63:dc30:c51a:8579:612a:9e21])
        by smtp.gmail.com with ESMTPSA id r8sm21128163wrg.22.2019.05.02.00.28.44
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 02 May 2019 00:28:44 -0700 (PDT)
Reply-To: nicolas.dichtel@6wind.com
Subject: Re: [PATCH 07/31] netfilter: ctnetlink: Support L3 protocol-filter on
 flush
To:     Kristian Evensen <kristian.evensen@gmail.com>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Netfilter Development Mailing list 
        <netfilter-devel@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Network Development <netdev@vger.kernel.org>
References: <20181008230125.2330-1-pablo@netfilter.org>
 <20181008230125.2330-8-pablo@netfilter.org>
 <33d60747-7550-1fba-a068-9b78aaedbc26@6wind.com>
 <CAKfDRXjY9J1yHz1px6-gbmrEYJi9P9+16Mez+qzqhYLr9MtCQg@mail.gmail.com>
From:   Nicolas Dichtel <nicolas.dichtel@6wind.com>
Organization: 6WIND
Message-ID: <51b7d27b-a67e-e3c6-c574-01f50a860a5c@6wind.com>
Date:   Thu, 2 May 2019 09:28:44 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <CAKfDRXjY9J1yHz1px6-gbmrEYJi9P9+16Mez+qzqhYLr9MtCQg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: fr
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le 01/05/2019 à 10:47, Kristian Evensen a écrit :
> Hello,
> 
> On Thu, Apr 25, 2019 at 12:07 PM Nicolas Dichtel
> <nicolas.dichtel@6wind.com> wrote:
>> Since this patch, there is a regression with 'conntrack -F', it does not flush
>> anymore ipv6 conntrack entries.
>> In fact, the conntrack tool set by default the family to AF_INET and forbid to
>> set the family to something else (the '-f' option is not allowed for the command
>> 'flush').
> 
> I am very sorry for my late reply and for the trouble my change has
> caused. However, I am not sure if I agree that it triggers a
> regression. Had conntrack for example not set any family and my change
> caused only IPv4 entries to be flushed, then I agree it would have
> been a regression. If you ask me, what my change has exposed is
> incorrect API usage in conntrack. One could argue that since conntrack
> explicitly sets the family to AF_INET, the fact that IPv6 entries also
> has been flushed has been incorrect. However, if the general consensus
> is that this is a regression, I am more than willing to help in
> finding a solution (if I have anything to contribute :)).
I understand your point, but this is a regression. Ignoring a field/attribute of
a netlink message is part of the uAPI. This field exists for more than a decade
(probably two), so you cannot just use it because nobody was using it. Just see
all discussions about strict validation of netlink messages.
Moreover, the conntrack tool exists also for ages and is an official tool.


Regards,
Nicolas
