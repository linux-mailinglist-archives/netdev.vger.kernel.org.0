Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5EB10368A12
	for <lists+netdev@lfdr.de>; Fri, 23 Apr 2021 02:55:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237106AbhDWAzF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Apr 2021 20:55:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229865AbhDWAzC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Apr 2021 20:55:02 -0400
Received: from mail-io1-xd32.google.com (mail-io1-xd32.google.com [IPv6:2607:f8b0:4864:20::d32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7B1FC061574
        for <netdev@vger.kernel.org>; Thu, 22 Apr 2021 17:54:25 -0700 (PDT)
Received: by mail-io1-xd32.google.com with SMTP id b10so47410085iot.4
        for <netdev@vger.kernel.org>; Thu, 22 Apr 2021 17:54:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ieee.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=EsRGHADRe1bBPp1jvPhK9op/n2B30dQYA9YS40rYISw=;
        b=dQOQ9GDTt365qQAFRODcnSQlqUZYq2h3tiO5Y9N5+hruwghg3M6favMmdexJEyVITm
         WgGGVeim2qWMF7Vj9PITZlEpZ9i6M0/5O876gTib5T6ECTlLpewmUwbedxDni2yFUn2g
         eXyzRgZpuso53fhZC2bAyhFGXNUq/wb52/xRs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=EsRGHADRe1bBPp1jvPhK9op/n2B30dQYA9YS40rYISw=;
        b=sToc9a9C4CE9UvLP8zEIrVA4y6aKCshJnbEOada6Px8SksQZ1PNmK9nGgGathIuAnW
         7y8NgDqhOFIMvq8NQrV8NmdyMp1w4AaoCp0N6DM1lp7Bh+tDnCDwyKXAqrY+lLFEBbcy
         oAJi8Vs4I6R9QqZk9MQgFFB/ys4PjOSekpcmz9F5AKZXR7fq/RF/VtQe+/vlqWFXSVIN
         apmm9nqWOwu9mllRkYsOU5QNA8aFdlu2L/tFOBUdKwRycWqxKz/+QDOcDAQIve4LyqD2
         tZ+PPPa7Ds9p2TEdaFE8uzaZpSSIIprnUhCo7GfL7qf0TrTv1vmSFsRV8qyaCSmFFBQR
         nEwQ==
X-Gm-Message-State: AOAM531J20ebFleFbI73+rHuyfWAvl0jGhk5+tuI6Y+lYZ+W+0rwQuI0
        W7ObXttJyKZ4O83Ht0QYwjrFhRgJhB8VSw==
X-Google-Smtp-Source: ABdhPJyjX6RrbO26k7NMgyFcWXzu19xGXwfPz9p5VH/n75XN0+5Yxgl5l4IvIzClvVstgpeB2xQsBw==
X-Received: by 2002:a05:6638:35a2:: with SMTP id v34mr1426437jal.94.1619139265344;
        Thu, 22 Apr 2021 17:54:25 -0700 (PDT)
Received: from [172.22.22.4] (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.googlemail.com with ESMTPSA id z4sm2048471ioi.37.2021.04.22.17.54.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 22 Apr 2021 17:54:24 -0700 (PDT)
Subject: Re: [PATCH net-next v4 0/3] net: qualcomm: rmnet: Enable Mapv5
To:     subashab@codeaurora.org
Cc:     Sharath Chandra Vurukala <sharathv@codeaurora.org>,
        davem@davemloft.net, kuba@kernel.org, elder@kernel.org,
        cpratapa@codeaurora.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1619121731-17782-1-git-send-email-sharathv@codeaurora.org>
 <ed00501e-d558-a47f-5444-b1a5a895d6db@ieee.org>
 <8ada4250d370acfb995cfa68b72de091@codeaurora.org>
From:   Alex Elder <elder@ieee.org>
Message-ID: <8c975b46-a5bf-f4c2-6738-1d81579b96a0@ieee.org>
Date:   Thu, 22 Apr 2021 19:54:23 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <8ada4250d370acfb995cfa68b72de091@codeaurora.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/22/21 6:14 PM, subashab@codeaurora.org wrote:
> On 2021-04-22 14:14, Alex Elder wrote:
>> On 4/22/21 3:02 PM, Sharath Chandra Vurukala wrote:
>>> This series introduces the MAPv5 packet format.
>>>
>>>    Patch 0 documents the MAPv4/v5.
>>>    Patch 1 introduces the MAPv5 and the Inline checksum offload for 
>>> RX/Ingress.
>>>    Patch 2 introduces the MAPv5 and the Inline checksum offload for 
>>> TX/Egress.
>>
>> Was this supposed to be version 5?
>>
>> I already reviewed version 4.
>>
>> Please post version 5.  I am going to ignore this series.
>>
>>                     -Alex
>>
> 
> What are you talking about?
> 
> Patchwork shows that Sharath has posted upto v3 so far.

Sorry about that.  Sharath posted a series version 4 last week, which
I reviewed.  I mistakenly thought he had posted it for upstream review
and didn't realize he sent it to me (and others) privately.

Still, I said he should tag the second patch "Acked-by:" me and
he did not, so I assumed it was a repost of the same code.

I'll review this after all.

					-Alex

> 
> https://patchwork.kernel.org/project/netdevbpf/list/?submitter=197703&state=%2A&archive=both 
> 

