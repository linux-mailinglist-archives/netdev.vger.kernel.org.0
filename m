Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 36F8013ADBB
	for <lists+netdev@lfdr.de>; Tue, 14 Jan 2020 16:34:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728755AbgANPeI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jan 2020 10:34:08 -0500
Received: from mail-il1-f194.google.com ([209.85.166.194]:43344 "EHLO
        mail-il1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726342AbgANPeH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jan 2020 10:34:07 -0500
Received: by mail-il1-f194.google.com with SMTP id v69so11844214ili.10
        for <netdev@vger.kernel.org>; Tue, 14 Jan 2020 07:34:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=IA2delY+nvouL7k3WAzaksVLLZyCKVj7Nj88hB3F63s=;
        b=GYrmOPaepSu5FE6sfqecFvPZF773kgYg1vEEYvE1MbxANRsiSYvBfYILVlNDEdGhFO
         JUSGMofsQoayPlsa6FZcB9iMp9QZ0BrtlSbXser6l9hz1+MXlF8TIJWV9wu8l0juOa4e
         g+Zd5QNvCFTXHNT/JnUbdNFiuWpvINsRHcohiM3zW2UMJng0/82ZQq6UDkgO3zABBHkn
         1AMokmHlCQgEhi9uKoARCID/6Ta4moGt3wXoN83JCl34IPN/6jrsj0PfjOTejxnjS1sh
         huOkILHsB+O0ZM1bk7RezUbAMXZVrgZKNX5za1Uz/p/g4YOXIriT2aTCYk9PONAM+IFu
         WsiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=IA2delY+nvouL7k3WAzaksVLLZyCKVj7Nj88hB3F63s=;
        b=uXb7fkTlxcL9Zn6r7wgTtTpJsnHBQRLYn90mF0H4aPnRYe8lW+TVd47pFJdKeh2LQn
         P73T+dYVq7PHDCga0r46wQw7OK3NJNAB5R98oC7/jtePRl5S8r0a5Mce2+prqAzF4VIL
         e37R9J3gJJf51HnMuGKMshqeQD1LOFDo1FExs0+o064wzsYvNOZiHrCi0mevHzT5zPHW
         0q50CbyRQtnt5KDquB82AlIwqHzTbaT0+5UFybObopV9zBoo2GOhY0HhnKx5s/SgmGMN
         CmhdegGENYSGySWUx8377G4mQ34dIzLZMZLEvsjawYN5vEvlaYomyWqRYEvDV7XLBXmy
         yFXA==
X-Gm-Message-State: APjAAAXstaKINjBfUo8m8wkB10Xatx4S/gS52lNYxqWqhRXD3gvpPsZa
        hlzZxfUdJwAkjSEskg61VZU=
X-Google-Smtp-Source: APXvYqy4EQ5q2vS5jOO1rALE9FgwCv5EWidXPJI6HFMbhK/OkGw95obVhBdcrJjmlNTgASF9EEMw4A==
X-Received: by 2002:a92:5e13:: with SMTP id s19mr3756428ilb.305.1579016047199;
        Tue, 14 Jan 2020 07:34:07 -0800 (PST)
Received: from ?IPv6:2601:282:800:7a:ad53:3eb0:98a5:6359? ([2601:282:800:7a:ad53:3eb0:98a5:6359])
        by smtp.googlemail.com with ESMTPSA id k22sm3554959ioj.24.2020.01.14.07.34.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Jan 2020 07:34:06 -0800 (PST)
Subject: Re: [PATCH net-next 3/8] net: bridge: vlan: add rtm definitions and
 dump support
To:     Jakub Kicinski <kuba@kernel.org>,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Cc:     netdev@vger.kernel.org, roopa@cumulusnetworks.com,
        davem@davemloft.net, bridge@lists.linux-foundation.org
References: <20200113155233.20771-1-nikolay@cumulusnetworks.com>
 <20200113155233.20771-4-nikolay@cumulusnetworks.com>
 <20200114055544.77a7806f@cakuba.hsd1.ca.comcast.net>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <076a7a9f-67c6-483a-7b86-f9d70be6ad47@gmail.com>
Date:   Tue, 14 Jan 2020 08:34:05 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.3.1
MIME-Version: 1.0
In-Reply-To: <20200114055544.77a7806f@cakuba.hsd1.ca.comcast.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/14/20 6:55 AM, Jakub Kicinski wrote:
> On Mon, 13 Jan 2020 17:52:28 +0200, Nikolay Aleksandrov wrote:
>> +static int br_vlan_rtm_dump(struct sk_buff *skb, struct netlink_callback *cb)
>> +{
>> +	int idx = 0, err = 0, s_idx = cb->args[0];
>> +	struct net *net = sock_net(skb->sk);
>> +	struct br_vlan_msg *bvm;
>> +	struct net_device *dev;
>> +
>> +	if (cb->nlh->nlmsg_len < nlmsg_msg_size(sizeof(*bvm))) {
> 
> I wonder if it'd be useful to make this a strict != check? At least
> when strict validation is on? Perhaps we'll one day want to extend 
> the request?
> 

+1. All new code should be using the strict checks.

