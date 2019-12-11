Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 80F9D11A793
	for <lists+netdev@lfdr.de>; Wed, 11 Dec 2019 10:40:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728608AbfLKJkf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Dec 2019 04:40:35 -0500
Received: from mail-lf1-f65.google.com ([209.85.167.65]:34353 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727318AbfLKJke (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Dec 2019 04:40:34 -0500
Received: by mail-lf1-f65.google.com with SMTP id l18so16159664lfc.1
        for <netdev@vger.kernel.org>; Wed, 11 Dec 2019 01:40:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=VEiTqs3AdcOOADsYpDlYWqADQJ1OE+9BmLTpHWgdwWA=;
        b=GhxoZKc5XN75PQaqV66FqdkPlEFs9NHr8vay7vPpK0Gv0Z4gZO1JVarSAkNVUdqq1y
         QEWyzyKj+hk2Qp2pcqlZrcZyOuFMz/eXRj3m7X+mIpseNgHSFSy/0EBoPEH/xqswnpmR
         2iAtAb1XVFSqUfQqJzTM9ogWBjvBWefgWMkeY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=VEiTqs3AdcOOADsYpDlYWqADQJ1OE+9BmLTpHWgdwWA=;
        b=Xn/AFSyLKUAftfrpG01mr3igh6LUmC1KUv7hzVKdNFqHtmdlrWux8+MzjAJjphVK5c
         B4Lykp4MiyPY7yh+bqDsrRXBTm7mEPs7x9thxfaRS4lRgZER9iLRW/h9Xk2IW+U5fXDY
         yWv+NN+FH7xELKv3xA3GqQZYw3QEN0veXKltth2sKgM1AmYPRyvyxMapLclb3qQNnq7t
         gRlPm2XxSkqalpYGz4ijNiZjnQUpCnvhf+KrpAeutDLyV6SHerkcyDnYF6rxNZEzg7Zt
         /mfT48jfUi6sZ1umfR2Gwd6RFOzSgSYtURiWFuS9ySufZa/+BuFVwSfU+eenwFg8EN+A
         mhQA==
X-Gm-Message-State: APjAAAWpiovcFl55PnA5VT+/XSrxH9qrR7pTMuRmEW05QIpKZvQPGlOm
        XkduU+ZRsD4T3IDQPE9tjnTApQ==
X-Google-Smtp-Source: APXvYqyEVpct9K2sXUM2MbItPcfiRlNPGv5wGFyBRzyiYOJTrwmV0Fui86l9vGvO/+SvYo9HZ0OzvA==
X-Received: by 2002:ac2:424d:: with SMTP id m13mr1526102lfl.13.1576057233234;
        Wed, 11 Dec 2019 01:40:33 -0800 (PST)
Received: from [192.168.0.107] (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id t14sm771137ljh.52.2019.12.11.01.40.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 Dec 2019 01:40:32 -0800 (PST)
Subject: Re: [PATCH net-next v2] net: bridge: add STP xstats
To:     Vivien Didelot <vivien.didelot@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Roopa Prabhu <roopa@cumulusnetworks.com>,
        netdev@vger.kernel.org, bridge@lists.linux-foundation.org,
        Stephen Hemminger <stephen@networkplumber.org>
References: <20191210212050.1470909-1-vivien.didelot@gmail.com>
 <30e93cfb-cc2c-c484-a743-479cce19d8a9@cumulusnetworks.com>
 <20191210210203.GB1480973@t480s.localdomain>
From:   Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Message-ID: <498b31ea-bafc-1f44-d4bd-354f30a71972@cumulusnetworks.com>
Date:   Wed, 11 Dec 2019 11:40:31 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20191210210203.GB1480973@t480s.localdomain>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/12/2019 04:02, Vivien Didelot wrote:
> Hi Nikolay,
> 
> On Tue, 10 Dec 2019 23:45:13 +0200, Nikolay Aleksandrov <nikolay@cumulusnetworks.com> wrote:
>>> +	if (p) {
>>> +		nla = nla_reserve_64bit(skb, BRIDGE_XSTATS_STP,
>>> +					sizeof(p->stp_xstats),
>>> +					BRIDGE_XSTATS_PAD);
>>> +		if (!nla)
>>> +			goto nla_put_failure;
>>> +
>>> +		memcpy(nla_data(nla), &p->stp_xstats, sizeof(p->stp_xstats));
>>
>> You need to take the STP lock here to get a proper snapshot of the values.
> 
> Good catch! I see a br->multicast_lock but no br->stp_lock. Is this what
> you expect?
> 
>     spin_lock_bh(&br->lock);
>     memcpy(nla_data(nla), &p->stp_xstats, sizeof(p->stp_xstats));
>     spin_unlock_bh(&br->lock);
> 

Yeah, this is a very old lock (pre-git) which needs some attention. :)
That is the lock and the above looks good to me.

> 
> Thanks,
> 
> 	Vivien
> 

Cheers,
 Nik
