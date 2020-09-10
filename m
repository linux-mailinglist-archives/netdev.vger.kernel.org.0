Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0AB0264E53
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 21:10:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727776AbgIJTKM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 15:10:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725951AbgIJTJZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Sep 2020 15:09:25 -0400
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 850D8C061573
        for <netdev@vger.kernel.org>; Thu, 10 Sep 2020 12:09:25 -0700 (PDT)
Received: by mail-pf1-x42a.google.com with SMTP id d6so5216311pfn.9
        for <netdev@vger.kernel.org>; Thu, 10 Sep 2020 12:09:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Jco3Ismu2CDzwE6Bt+8XP2PPTeNDXzayulaFQH4v3j8=;
        b=XjFVcWAQ2mr5TjvPK7J1wCPsbQXWp0z5KvcCXh5GFJHz+naVGqOzNsYfb+5hm2HHCT
         /y8FmH2iGWmAVn7XFGKeVEW7enXGHqVox6Ox5jDC7gtG9L9RUMnC3n36iMU6dLt4KcvK
         aURBbHmY0cvVaFmwE/M2lkMrXRu3fakRutTyHnosTCjKXh8JFPS2h6z2oU0vTtvnd3bk
         Kbe3Tt8MkRSknXBxSJljGutktJ7htkX/JxfWU5Ua5Tegnm1crTYwFSBWC0Sgi4PaB2Mk
         mjV8mBfZoclFPLlrcFRdJxetVaPB7xyLNZqcwzqkNxq89PIQPFhzRn6gqB9sbp68hhin
         3A0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Jco3Ismu2CDzwE6Bt+8XP2PPTeNDXzayulaFQH4v3j8=;
        b=V6gCpYYujKp/zN+kMehiff/RKCMOkmIE+17ncBnVxNXQeZWgpAyij6E0LVv9xP22Ti
         cnXrReyZ9fLr//04XtSa+Qsi7nYHfn/QwJ1bsOsCZfc1DuAxQ3t9eolWFbBPzn0eEjHM
         gAtY/R5bBZoe/ktKkcLR3M2oL1dEI1i0d+4Jvo0s9Jd+d9j+2/5wbQEsx/kKTISeBDPq
         4jDiKp6LtJ+RC5pRY5+Ur0T4/tUnaslj0D2NKzNXIyxzR8M4a6hoDkv5MA8G+tgSM9Yi
         VvmA6X1a0RYOTikiLF4BNCSUkrw666OUdyHa1iUNdPEXNiDXU4F42YFNqTr7G6ZkCF9U
         fCYg==
X-Gm-Message-State: AOAM531oSTY0s2bWuMbxTAdsevWytre4DpDLgoEDFJzdb7ci6mjBX9BF
        B6miS+aCPAEzIRPrtt5ZaeI=
X-Google-Smtp-Source: ABdhPJw6ycxWPuDJgVx+3HCAmgkoLfHwxinKiiq3Yrmb69cT4nR4kjhJ/M7lhI/5+2tNt/3QR5XE6w==
X-Received: by 2002:a63:1257:: with SMTP id 23mr5269095pgs.401.1599764964845;
        Thu, 10 Sep 2020 12:09:24 -0700 (PDT)
Received: from [192.168.1.3] (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id n7sm6548466pfq.114.2020.09.10.12.09.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Sep 2020 12:09:24 -0700 (PDT)
Subject: Re: VLAN filtering with DSA
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     netdev <netdev@vger.kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>
References: <20200910150738.mwhh2i6j2qgacqev@skbuf>
 <86ebd9ca-86a3-0938-bf5d-9627420417bf@gmail.com>
 <20200910190119.n2mnqkv2toyqbmzn@skbuf>
 <7b23a257-6ac2-e6b2-7df8-9df28973e315@gmail.com>
 <20200910190817.xfckbgxxuzupmnhb@skbuf>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <55f93f28-76a2-90ad-8bee-3d45693a9018@gmail.com>
Date:   Thu, 10 Sep 2020 12:09:19 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.2.1
MIME-Version: 1.0
In-Reply-To: <20200910190817.xfckbgxxuzupmnhb@skbuf>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/10/2020 12:08 PM, Vladimir Oltean wrote:
> On Thu, Sep 10, 2020 at 12:05:17PM -0700, Florian Fainelli wrote:
>> On 9/10/2020 12:01 PM, Vladimir Oltean wrote:
>>> On Thu, Sep 10, 2020 at 11:42:02AM -0700, Florian Fainelli wrote:
>>>> On 9/10/2020 8:07 AM, Vladimir Oltean wrote:
>>>> Yes, doing what you suggest would make perfect sense for a DSA master that
>>>> is capable of VLAN filtering, I did encounter that problem with e1000 and
>>>> the dsa-loop.c mockup driver while working on a mock-up 802.1Q data path.
>>>
>>> Yes, I have another patch where I add those VLANs from tag_8021q.c which
>>> I did not show here.
>>>
>>> But if the DSA switch that uses tag_8021q is cascaded to another one,
>>> that's of little use if the upper switch does not propagate that
>>> configuration to its own upstream.
>>
>> Yes, that would not work. As soon as you have a bridge spanning any of those
>> switches, does not the problem go away by virtue of the switch port forcing
>> the DSA master/upstream to be in promiscuous mode?
> 
> Well, yes, bridged it works but standalone it doesn't. A bit strange if
> you ask me.

Agreed there is no question this should be fixed.
-- 
Florian
