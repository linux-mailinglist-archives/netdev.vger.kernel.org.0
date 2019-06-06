Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 26D6937973
	for <lists+netdev@lfdr.de>; Thu,  6 Jun 2019 18:25:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728024AbfFFQZk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jun 2019 12:25:40 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:34646 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727862AbfFFQZk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jun 2019 12:25:40 -0400
Received: by mail-pf1-f195.google.com with SMTP id c85so1838103pfc.1
        for <netdev@vger.kernel.org>; Thu, 06 Jun 2019 09:25:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=54g1qCHnqWUExp8cO530YyqnwPyJ1hfkMkpyQdkc4FA=;
        b=JWNjXL8mDIltcl5k1i9fQ3f4LqhHiBNdN2UiLT3pnI2n2MMO9OnffwwdbAf+vmKPSX
         f7KvBhSWIal375rH0lI4pUFjEQ41h8FSeGxLYlIVcQvly5BNI3x4ORkn4YLuBxKNL2tX
         oQPf7TU4b/BkoWhqMNAuzSRDMeWh/3IglGNoBSKRbi38esePAX2weUyuPqPWn55Eb/hy
         tg60PnfnwHNipGBORl7irumwmuS87bNNmZsMgJVp/r78q/cR+SpwEEi46VqcjMKXaTfY
         gwHk4CwD9KQnCkXAfUTLXNrGPv38kSsYLKFYcO5LSRmTRFZcQ19+3Xf7FINfmnJbwnTc
         Wa0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=54g1qCHnqWUExp8cO530YyqnwPyJ1hfkMkpyQdkc4FA=;
        b=PkARp/NbIvDkYalRE5cvAxXUD0myXnxcKrAsTenSrFLT99nG++JJinb+nvDcp1cRls
         6IStpUgSDnffDe5ysle33Zbwifi5CQbV80O4Jf1XazdnI2uHJMlgH9RmPbTHheTTVobN
         DIxWMpjw5YdEHywLMTiPcdbi/921NWVJhuqRSEerPXrggoIalLQk/rPSVmzyuYkDqcQA
         yINp/SFrPoyAVZ/TZi+I086lmYHz7i7l99fejDJbF7ebrdOo2gh+JhazXR/xD34CGAtp
         aDJg1TYKyjZbyIoGiJSwsmHYVHGKKWqUYCkJP3RNqYk/2w+dnNu7y4UErJ6OadRqhQVU
         PyuQ==
X-Gm-Message-State: APjAAAVoRZABjWvpKcPNFqHYDL4+mgIgDzNt1FC3jsRjEYk4bqFfZiYn
        CWJMGn+nfO+4PpEs5lWKcbQ/eObGAh4=
X-Google-Smtp-Source: APXvYqz1T9BRb/XmGIylzi2A6g49wcptCZn96sE1dsejyzJouxOHtx+N1jrRxWulEU5rcPeDn2jDgw==
X-Received: by 2002:a63:49:: with SMTP id 70mr4171852pga.163.1559838339100;
        Thu, 06 Jun 2019 09:25:39 -0700 (PDT)
Received: from [172.27.227.242] ([216.129.126.118])
        by smtp.googlemail.com with ESMTPSA id e66sm2888300pfe.50.2019.06.06.09.25.37
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 06 Jun 2019 09:25:38 -0700 (PDT)
Subject: Re: [PATCH net] vrf: Increment Icmp6InMsgs on the original netdev
To:     Stephen Suryaputra <ssuryaextr@gmail.com>
Cc:     netdev@vger.kernel.org
References: <20190530050815.20352-1-ssuryaextr@gmail.com>
 <c438f6b0-bb3c-7568-005e-68d7fcd406c3@gmail.com>
 <20190601181429.GB16560@ubuntu>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <892ec6a9-a85b-3d58-2598-b2aa169a3880@gmail.com>
Date:   Thu, 6 Jun 2019 10:25:35 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20190601181429.GB16560@ubuntu>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/1/19 12:14 PM, Stephen Suryaputra wrote:
> On Fri, May 31, 2019 at 05:06:16PM -0600, David Ahern wrote:
>> On 5/29/19 11:08 PM, Stephen Suryaputra wrote:
>>> diff --git a/net/ipv6/reassembly.c b/net/ipv6/reassembly.c
>>> index 1a832f5e190b..9b365c345c34 100644
>>> --- a/net/ipv6/reassembly.c
>>> +++ b/net/ipv6/reassembly.c
>>> @@ -260,6 +260,9 @@ static int ip6_frag_reasm(struct frag_queue *fq, struct sk_buff *skb,
>>>  	int payload_len;
>>>  	u8 ecn;
>>>  
>>> +	if (netif_is_l3_master(dev))
>>> +		dev = dev_get_by_index_rcu(net, inet6_iif(skb));
>>> +
>>>  	inet_frag_kill(&fq->q);
>>>  
>>>  	ecn = ip_frag_ecn_table[fq->ecn];
>>>
>>
>> this part changes skb->dev. Seems like it has an unintended effect if
>> the packet is delivered locally.
> 
> Ah, right. How about this then?
> 

looks ok to me.
