Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C11C42E02BB
	for <lists+netdev@lfdr.de>; Mon, 21 Dec 2020 23:57:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726463AbgLUW4n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Dec 2020 17:56:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725833AbgLUW4m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Dec 2020 17:56:42 -0500
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4548CC0613D3;
        Mon, 21 Dec 2020 14:56:02 -0800 (PST)
Received: by mail-pl1-x631.google.com with SMTP id x12so6387314plr.10;
        Mon, 21 Dec 2020 14:56:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=8TYqe8vAvyETIoFjDJe7k8PDEfE+M1o06Wss8zKrbDM=;
        b=CGjvxxcxxgP+UmvuS+zLAu81K2hFvaWWH32wEf3Nhy7WbtUBdhuOKzVnKnPLcPnRsu
         7J4jmHsjR1+1vu4Y3fEDp45X6VFTI7zjXtha+3MqVjuzQudQSOuMGYwvGqg3+0OK9+lu
         FCH5Fw2hS8y9SmJD54lElGTM82X+pE+vwk3Nn2Y+Nhp+zjy7GLHcz7xRjdGpKALiknz1
         /5XZLDU3Zf5447cXEp4mOJv7GRbizQeg+um32B4RxDBVrKSBpf4cis/8o6Wm1nYQBr2Y
         jBakT7ArRPPQIXI4QLvDNDuYWyxEra7fTpBHvP4fjNN8jTivPfATVE83mMDdVwqNLZ6W
         +Isw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=8TYqe8vAvyETIoFjDJe7k8PDEfE+M1o06Wss8zKrbDM=;
        b=MQOkgRQfrs1GB49S33Grbd1yvCvEEPEV9+98XpnnqjEUiMO5+JWoCrrUAb/CKnPEXP
         gTzrjTXbTlPbQQpCmpb0/9x49/cRTYIDItH/JqgIjmwC3dOqHm7IRsAaf+uIqOhmwR4E
         IE3EVF/AUUxKTK0KVRFpYu9id4trWgeaOhgFKTHBs3l5SEqWCPFm4bZ5l6/AIYGfxnUL
         9m33hV0HmrGFRKgVuQvddiWxQr1JZasxGjWweB2cAu+WlZfnXq+hhtz13wiX52U504du
         wln4sv7faTXb/9Wfi7DxsQc7+kMsTtqKrR03itVq2308qh0l2t6BS9DuWuL0IyZDj243
         dK8g==
X-Gm-Message-State: AOAM533GbTglAtocze8/z01BhF8wdTR6ER2zVYsfOqAiHw+Y5C03IOiw
        Sth+iRD3BjT57Pp1FTbla9VmtCq72YM=
X-Google-Smtp-Source: ABdhPJw7n4W2FseOuVsAGlTtin2nWhQsFCTIQmGpS54j/AqBDIf/e9wnPh3/fhajSoAOSLd9tDm4tw==
X-Received: by 2002:a17:90a:ae07:: with SMTP id t7mr18695213pjq.115.1608591361341;
        Mon, 21 Dec 2020 14:56:01 -0800 (PST)
Received: from [10.230.29.166] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id nk11sm16610557pjb.26.2020.12.21.14.55.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Dec 2020 14:56:00 -0800 (PST)
Subject: Re: [PATCH net] net: systemport: set dev->max_mtu to
 UMAC_MAX_MTU_SIZE
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     netdev@vger.kernel.org, andrew@lunn.ch,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Murali Krishna Policharla <murali.policharla@broadcom.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        "open list:BROADCOM SYSTEMPORT ETHERNET DRIVER" 
        <bcm-kernel-feedback-list@broadcom.com>,
        open list <linux-kernel@vger.kernel.org>
References: <20201218173843.141046-1-f.fainelli@gmail.com>
 <20201218202441.ppcxswvlix3xszsn@skbuf>
 <c178b5db-3de4-5f02-eee3-c9e69393174a@gmail.com>
 <20201218205220.jb3kh7v23gtpymmx@skbuf>
 <b8e61c3f-179f-7d8f-782a-86a8c69c5a75@gmail.com>
 <20201218210250.owahylqnagtssbsw@skbuf>
 <cf2daa3c-8f64-0f58-5a42-2182cec5ba4a@gmail.com>
 <20201218211435.mjdknhltolu4gvqr@skbuf>
 <f558368a-ec7f-c604-9be5-bd5b810b5bfa@gmail.com>
 <6d54c372-86bc-b28f-00b0-c22e46215116@gmail.com>
 <20201221222534.ln4onsjpryqzzfqq@skbuf>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <ae506e45-c4fe-7c36-6c9c-67b47818e7ba@gmail.com>
Date:   Mon, 21 Dec 2020 14:55:58 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20201221222534.ln4onsjpryqzzfqq@skbuf>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12/21/2020 2:25 PM, Vladimir Oltean wrote:
> On Mon, Dec 21, 2020 at 01:49:03PM -0800, Florian Fainelli wrote:
>> On 12/18/2020 1:17 PM, Florian Fainelli wrote:
>>>>>>>>> SYSTEMPORT Lite does not actually validate the frame length, so setting
>>>>>>>>> a maximum number to the buffer size we allocate could work, but I don't
>>>>>>>>> see a reason to differentiate the two types of MACs here.
>>>>>>>>
>>>>>>>> And if the Lite doesn't validate the frame length, then shouldn't it
>>>>>>>> report a max_mtu equal to the max_mtu of the attached DSA switch, plus
>>>>>>>> the Broadcom tag length? Doesn't the b53 driver support jumbo frames?
>>>>>>>
>>>>>>> And how would I do that without create a horrible layering violation in
>>>>>>> either the systemport driver or DSA? Yes the b53 driver supports jumbo
>>>>>>> frames.
>>>>>>
>>>>>> Sorry, I don't understand where is the layering violation (maybe it doesn't
>>>>>> help me either that I'm not familiar with Broadcom architectures).
>>>>>>
>>>>>> Is the SYSTEMPORT Lite always used as a DSA master, or could it also be
>>>>>> used standalone? What would be the issue with hardcoding a max_mtu value
>>>>>> which is large enough for b53 to use jumbo frames?
>>>>>
>>>>> SYSTEMPORT Lite is always used as a DSA master AFAICT given its GMII
>>>>> Integration Block (GIB) was specifically designed with another MAC and
>>>>> particularly that of a switch on the other side.
>>>>>
>>>>> The layering violation I am concerned with is that we do not know ahead
>>>>> of time which b53 switch we are going to be interfaced with, and they
>>>>> have various limitations on the sizes they support. Right now b53 only
>>>>> concerns itself with returning JMS_MAX_SIZE, but I am fairly positive
>>>>> this needs fixing given the existing switches supported by the driver.
>>>>
>>>> Maybe we don't need to over-engineer this. As long as you report a large
>>>> enough max_mtu in the SYSTEMPORT Lite driver to accomodate for all
>>>> possible revisions of embedded switches, and the max_mtu of the switch
>>>> itself is still accurate and representative of the switch revision limits,
>>>> I think that's good enough.
>>>
>>> I suppose that is fair, v2 coming, thanks!
>>
>> I was going to issue a v2 for this patch, but given that we don't
>> allocate buffers larger than 2KiB and there is really no need to
>> implement ndo_change_mtu(), is there really a point not to use
>> UMAC_MAX_MTU_SIZE for both variants of the SYSTEMPORT MAC?
> 
> After your first reply that "the Lite doesn't validate the frame length", I was
> under the impression that it is sufficient to declare a larger max_mtu such as
> JMS_MAX_SIZE and 9K jumbo frames would just work. But with the current buffer
> allocation in bcm_sysport_rx_refill it clearly wouldn't. A stupid confusion
> really. So yeah, sorry for having you resend a v2 with no change.
> If it helps you could add to the patch:
> 
> Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
> 
> Thanks again for explaining.

No worries, Jakub, David, do you need me to resend or can you pick it up
from patchwork?
-- 
Florian
