Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4979D46404C
	for <lists+netdev@lfdr.de>; Tue, 30 Nov 2021 22:35:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240739AbhK3Vi4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Nov 2021 16:38:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235087AbhK3Vi4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Nov 2021 16:38:56 -0500
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F05BC061574
        for <netdev@vger.kernel.org>; Tue, 30 Nov 2021 13:35:36 -0800 (PST)
Received: by mail-wr1-x431.google.com with SMTP id i5so47459523wrb.2
        for <netdev@vger.kernel.org>; Tue, 30 Nov 2021 13:35:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:content-language:to:cc
         :references:from:subject:in-reply-to:content-transfer-encoding;
        bh=IISOlbFN0oDJ3K09m0ZKnHAoRqSPjkWaG/WFAfjkZ80=;
        b=RK6O82/aMnGNfKKTkf97w7zooeYE4HGv/91C/vMk2co1bG9QrQGZvxAjDrD/lWPd9Q
         yJpwWlMsb7tjruYx75kae90Dyn2VHXQEJ7fzvUqbL+3DcSM03rOwiCr28es6NrqKYJ4B
         RGhP3m++Dw+/xjAcghQnyfvIMF/i8cso88M9UulJ5wfVTOnrtZMkj2wi8TZiu3drUiy+
         C8n5Ke0AJhdRZBE6Z8rJi8XYF+rmnvakBhrlmFGrLVoaJFRVcnik2qu2lASJym6+RYpS
         LkKO4xSxLDXsqjuZU1ph4T9AwiPS0VS4D2Yz6bP+xKrOCYXp+Oqcpk+Zk33vMHrqvbY7
         IQXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent
         :content-language:to:cc:references:from:subject:in-reply-to
         :content-transfer-encoding;
        bh=IISOlbFN0oDJ3K09m0ZKnHAoRqSPjkWaG/WFAfjkZ80=;
        b=zqiMdB4zixpkjH5YuEFWdD436bcxUmMrX28ICgj/szIo7IcOaRd4ODMhDGaSiKiwch
         2bmUKe68tEzZ1GKYmuHn9siG0nKEjs8dBsOvvH79ffLAqhYC5DXoCeLFXWVCnF3469H4
         /UOP3U6Iwb8Sb7eb9FR6sNgXxktHC5SlafttyhcUOg1AWhYn4yQOY0Xvpq3BFV1Rh5/Q
         gOpykZxjz26PTo8ejwWMCp8GsNxK86U4wqV7h6GOFjOyve+p8yZehUrwvYHZmhk1XOFb
         V6q2sL/EEnv8fmTSWV2mrTrzNuGulJApUS8jrsTBzuMOeNvKSDpJ1TbN7SGemnyAxVRo
         iMnQ==
X-Gm-Message-State: AOAM533uv9Tx1i/WQHwDHcfIAhwD4n9Auf+NcwKcxG/hNmZJK96l/TS9
        FTMAb+RbEWM/Kmeb45KKn0dQ7wZxOj4=
X-Google-Smtp-Source: ABdhPJw+Ni8pb7eqQNgkIjQX+H84OsR2Q/Eo8b82uZVjh1TmhUm6W7dMAgaAsr8axbevov/usPulMA==
X-Received: by 2002:a5d:5385:: with SMTP id d5mr1720412wrv.132.1638308134716;
        Tue, 30 Nov 2021 13:35:34 -0800 (PST)
Received: from ?IPV6:2003:ea:8f1a:f00:cdea:1258:1cb4:5e92? (p200300ea8f1a0f00cdea12581cb45e92.dip0.t-ipconnect.de. [2003:ea:8f1a:f00:cdea:1258:1cb4:5e92])
        by smtp.googlemail.com with ESMTPSA id s63sm3787729wme.22.2021.11.30.13.35.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 30 Nov 2021 13:35:34 -0800 (PST)
Message-ID: <c6f3caef-dac2-cc4a-b5b5-70e7fa54d73f@gmail.com>
Date:   Tue, 30 Nov 2021 22:35:27 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.2
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     David Miller <davem@davemloft.net>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        intel-wired-lan <intel-wired-lan@lists.osuosl.org>
References: <6bb28d2f-4884-7696-0582-c26c35534bae@gmail.com>
 <20211129171712.500e37cb@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <6edc23a1-5907-3a41-7b46-8d53c5664a56@gmail.com>
 <20211130091206.488a541f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [PATCH net] igb: fix deadlock caused by taking RTNL in RPM resume
 path
In-Reply-To: <20211130091206.488a541f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 30.11.2021 18:12, Jakub Kicinski wrote:
> On Tue, 30 Nov 2021 07:46:22 +0100 Heiner Kallweit wrote:
>> On 30.11.2021 02:17, Jakub Kicinski wrote:
>>> On Mon, 29 Nov 2021 22:14:06 +0100 Heiner Kallweit wrote:  
>>>> -	rtnl_lock();
>>>> +	if (!rpm)
>>>> +		rtnl_lock();  
>>>
>>> Is there an ASSERT_RTNL() hidden in any of the below? Can we add one?
>>> Unless we're 100% confident nobody will RPM resume without rtnl held..
>>>   
>>
>> Not sure whether igb uses RPM the same way as r8169. There the device
>> is runtime-suspended (D3hot) w/o link. Once cable is plugged in the PHY
>> triggers a PME, and PCI core runtime-resumes the device (MAC).
>> In this case RTNL isn't held by the caller. Therefore I don't think
>> it's safe to assume that all callers hold RTNL.
> 
> No, no - I meant to leave the locking in but add ASSERT_RTNL() to catch
> if rpm == true && rtnl_held() == false.
> 
This is a valid case. Maybe it's not my day today, I still don't get
how we would benefit from adding an ASSERT_RTNL().

Based on the following I think that RPM resume and device open()
can't collide, because RPM resume is finished before open()
starts its actual work.

static int __igb_open(struct net_device *netdev, bool resuming)
{
...
if (!resuming)
		pm_runtime_get_sync(&pdev->dev);
