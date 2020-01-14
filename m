Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 08F8813AF89
	for <lists+netdev@lfdr.de>; Tue, 14 Jan 2020 17:36:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726946AbgANQgv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jan 2020 11:36:51 -0500
Received: from mail-lf1-f68.google.com ([209.85.167.68]:39667 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726121AbgANQgv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jan 2020 11:36:51 -0500
Received: by mail-lf1-f68.google.com with SMTP id y1so10317380lfb.6
        for <netdev@vger.kernel.org>; Tue, 14 Jan 2020 08:36:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=V2/KACwQfuatGD6xiBWykj7BNbLnSCoeL08Mx230O9w=;
        b=KMHOAoyODqv/sIwy3dOoTEhjU3Z918xwkAGL76mJjmwpi2a3LbUK16dHfaL3Xaf4WK
         q4sgR/qtO07q+q7i699yKKMRfcTKsXsfvN0Pr70rsCT2nWjhzvMEj+VV7B6RBo/mGMHk
         5iAh92DBrZ1TS+8hwQcrAiK9UATl3+6N5Kpfg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=V2/KACwQfuatGD6xiBWykj7BNbLnSCoeL08Mx230O9w=;
        b=WoadLL19HpJUSDyf5gDtxTQ4PF0diLq49IubONjzMjA2DLluUVZ0SibUFJ+EznN7xc
         kGEATJW6EBSJV9FsoHgYAuW7dlsHKCaNJiZi+GpOrje1AW22JkhoZons2TqpkTJcsIO9
         WQEoaXTNV2nCLEskdvrWIj4XBwOGVXCQ3c6VNlXvS41+IxGSYfIU+zStQDuKL2ZRK/G+
         2pymGFlVnTrYLd870IAlqMtR47P0O6rqgR0oD9WAsUCUI6t6h159YEnU2W7UikSge619
         Sc8y8Q8/D/NMoklnU99AnIva1ByD4Q3eEb9l9QduDqlDTU16E63DWXfXun7FFJQfcFsg
         G7uQ==
X-Gm-Message-State: APjAAAUoSAk+FqHqUtBa62gJuepKKIl8/GG2p7zsEwF1jqboTWRWBpEJ
        5JMkrHaHRdbsCeZcxnU+asSPJw==
X-Google-Smtp-Source: APXvYqxCBUsAFl2wOUpsoWrmjTzIQuWo/Akdp2UkvaQFIQvYpa8q+WkhJB4KSifekgs05tQw4ojVSA==
X-Received: by 2002:ac2:4316:: with SMTP id l22mr2274218lfh.115.1579019809333;
        Tue, 14 Jan 2020 08:36:49 -0800 (PST)
Received: from [192.168.0.107] (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id n11sm7751988ljg.15.2020.01.14.08.36.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Jan 2020 08:36:48 -0800 (PST)
Subject: Re: [PATCH net-next 3/8] net: bridge: vlan: add rtm definitions and
 dump support
To:     David Ahern <dsahern@gmail.com>, Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, roopa@cumulusnetworks.com,
        davem@davemloft.net, bridge@lists.linux-foundation.org
References: <20200113155233.20771-1-nikolay@cumulusnetworks.com>
 <20200113155233.20771-4-nikolay@cumulusnetworks.com>
 <20200114055544.77a7806f@cakuba.hsd1.ca.comcast.net>
 <076a7a9f-67c6-483a-7b86-f9d70be6ad47@gmail.com>
From:   Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Message-ID: <00c4bc6b-2b31-338e-a9ad-b4ea28fc731c@cumulusnetworks.com>
Date:   Tue, 14 Jan 2020 18:36:47 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <076a7a9f-67c6-483a-7b86-f9d70be6ad47@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 14/01/2020 17:34, David Ahern wrote:
> On 1/14/20 6:55 AM, Jakub Kicinski wrote:
>> On Mon, 13 Jan 2020 17:52:28 +0200, Nikolay Aleksandrov wrote:
>>> +static int br_vlan_rtm_dump(struct sk_buff *skb, struct netlink_callback *cb)
>>> +{
>>> +	int idx = 0, err = 0, s_idx = cb->args[0];
>>> +	struct net *net = sock_net(skb->sk);
>>> +	struct br_vlan_msg *bvm;
>>> +	struct net_device *dev;
>>> +
>>> +	if (cb->nlh->nlmsg_len < nlmsg_msg_size(sizeof(*bvm))) {
>>
>> I wonder if it'd be useful to make this a strict != check? At least
>> when strict validation is on? Perhaps we'll one day want to extend 
>> the request?
>>
> 
> +1. All new code should be using the strict checks.
> 

IIRC, I did it to be able to add filter attributes later, but it should just use nlmsg_parse()
instead and all will be taken care of.
I'll respin v2 with that change.

Thanks,
 Nik



