Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 591592FF9D3
	for <lists+netdev@lfdr.de>; Fri, 22 Jan 2021 02:13:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726057AbhAVBMQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jan 2021 20:12:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725775AbhAVBMP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jan 2021 20:12:15 -0500
Received: from mail-ot1-x331.google.com (mail-ot1-x331.google.com [IPv6:2607:f8b0:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED508C0613D6
        for <netdev@vger.kernel.org>; Thu, 21 Jan 2021 17:11:34 -0800 (PST)
Received: by mail-ot1-x331.google.com with SMTP id v21so3611772otj.3
        for <netdev@vger.kernel.org>; Thu, 21 Jan 2021 17:11:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=UXx7BWuoMYCvHJqURfT9sjwsJKtVlcy+yL9cdDPFaos=;
        b=eoirGusi6t2BSR0q1/mPSgB9AkItSGT5Z2ZAOBNpKo0JPb/iLPrPcD6286iL4IKbos
         Sh58KUD+zf4gBpe7hmbmvUui5+j3Du0RTuOsg9IYKescj9r+y/UX90DSVX61ACGsrIl+
         8iPQqQsIWYaSc+pdWw9BpwZgwydYKqHjG3cwKVP3yGVMJGiKS4zwl9k0//6+LcCls6Zf
         B+ElgSie/t+0YkXk8GDvrOl8EDux7jC1/s+PWCJVd0XAXTcwNnEQUl2RljzZ9d7OdD0w
         eYCObaOibr0sSqKJ/fyJNOFC1e6sX2hSZIZ68psy3lLtfomjIaZ0RlFKM9ImBo8LDxc+
         PXfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=UXx7BWuoMYCvHJqURfT9sjwsJKtVlcy+yL9cdDPFaos=;
        b=tE7dq0130Cu8LQTw1fc14CP9fcwaUuEJjbEHFGllw9RFnoK65T7bQ8dG7ftMhlRH4a
         XZRrrL1QMc0gCs5RbqLJKgdXT4VBt6V1BF90LQ6GtgOlzuN//NuEdaFTHhMNjIPwV1tk
         yqk0vCS71dZ6xcQNoglmC56aCEbXAfRjIZrTPjCmoR6ASNdj9WmMeAdsfaMI67mguNkx
         lGJsSXcYkkyAVRyuIBHvyQIKiyFkattwcdPUs0vGWM47nGzfSygB9HkWExqNSxwugZp0
         QBgrB8BIKd6rETiYcZZHtE/c4COSioul3t02lFM5TMXBTTHT/abe2Lki38CxIoxmy3X7
         +NOQ==
X-Gm-Message-State: AOAM530aE0ExZWUBgIeR1wFkE+iq8lFTMLvFG87H0XJirGHaulIVoiq8
        GNMvIBqswR87V9FIv3SwquA=
X-Google-Smtp-Source: ABdhPJz/KJgZDt4032ov+pAojEVnOzPY1TRj8T+IkWiWWF5Xm4ZOoFI547fSMl2aIcLysboslpUpjg==
X-Received: by 2002:a05:6830:1689:: with SMTP id k9mr1486163otr.154.1611277894139;
        Thu, 21 Jan 2021 17:11:34 -0800 (PST)
Received: from Davids-MacBook-Pro.local ([8.48.134.50])
        by smtp.googlemail.com with ESMTPSA id i9sm1419643oii.34.2021.01.21.17.11.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Jan 2021 17:11:33 -0800 (PST)
Subject: Re: [PATCH iproute2] man: tc-taprio.8: document the full offload
 feature
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     netdev@vger.kernel.org,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Vedang Patel <vedang.patel@intel.com>
References: <20210121214708.2477352-1-olteanv@gmail.com>
 <20210121215719.fimgnp5j6ngckjkl@skbuf>
 <229d141f-2335-7e6d-838d-6ff7cd3723a0@gmail.com>
 <20210122003735.33op5zc7cxvrl7cu@skbuf>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <bf45ea89-5b92-7265-8fdc-f4d280aae291@gmail.com>
Date:   Thu, 21 Jan 2021 18:11:32 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <20210122003735.33op5zc7cxvrl7cu@skbuf>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/21/21 5:37 PM, Vladimir Oltean wrote:
> On Thu, Jan 21, 2021 at 04:10:06PM -0700, David Ahern wrote:
>> On 1/21/21 2:57 PM, Vladimir Oltean wrote:
>>> On Thu, Jan 21, 2021 at 11:47:08PM +0200, Vladimir Oltean wrote:
>>>> +Enables the full-offload feature. In this mode, taprio will pass the gate
>>>> +control list to the NIC which will execute cyclically it in hardware.
>>>
>>> Ugh, I meant "execute it cyclically" not "execute cyclically it".
>>> David, could you fix this up or do I need to resend?
>>>
>>
>> I'll fix up
> 
> And I just noticed that ".BR etf(8)" needs to be on a line of its own. Sorry...
> 

send a new version
