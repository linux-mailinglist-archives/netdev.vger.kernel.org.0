Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1ED1C45D58C
	for <lists+netdev@lfdr.de>; Thu, 25 Nov 2021 08:34:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234555AbhKYHhr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Nov 2021 02:37:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229894AbhKYHfq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Nov 2021 02:35:46 -0500
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D87CC061748
        for <netdev@vger.kernel.org>; Wed, 24 Nov 2021 23:32:28 -0800 (PST)
Received: by mail-wr1-x42f.google.com with SMTP id j3so9567238wrp.1
        for <netdev@vger.kernel.org>; Wed, 24 Nov 2021 23:32:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:content-language:to:cc
         :references:from:subject:in-reply-to:content-transfer-encoding;
        bh=0wumoxdwiC2xVkrh3efLAeW5BPOHPs6sn4vBMFf8av4=;
        b=mktYqABrSZu2kyUYkNFaKFx5QxmJT9/Zr1CKE7CX158MekvmelS+X39CotlLzZVUC4
         f2WoCe1IS6QKuVVHb2iOdjx/nDr9JmLxeKkGnFztB2Th3ukBanmlpxG8QQVOXfLJKvco
         oV3Pv8qD8o8ZxhCbkpIT4+LZlQEJ89Q5R5DPqfvA5WpAo8qXwCCUqQZvuDJc/iqNU1Sp
         kJh4ZSHSGntQzdmK8UBlnuPeSKibmX5ghLQUuO2K2kiXt6nJNxXUsAaX/9VUwgT2xaki
         swmNOS0dm5JtwcnJXKeDNJyh7atFIIuVsvUjiZVE1gNnKF951C0qfVHr3ucjlf+CtLbM
         raQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent
         :content-language:to:cc:references:from:subject:in-reply-to
         :content-transfer-encoding;
        bh=0wumoxdwiC2xVkrh3efLAeW5BPOHPs6sn4vBMFf8av4=;
        b=iKoOajLJ8o9F4JKJYYGPknBe8xllZ1DyQgcVZ5lKkprO+v6lRC0+eGBCPpZUwR8ic6
         XkEOwuBfQhQ0JFpsZ6wemUkOh6HcRjbk9B/0nJAACWN8OqfswKTn2sz5UDyNYdS0Ypp0
         dyOzw5fTbvSnrrEOGsHPenUutgh4GHRyYZOCOrUuKe7G9bw6VyiQtDlFzejAc95Q78Wj
         bH1NAesv7psOlX3rviFWY7w2nc2T1fPjRA6C9Uf5LCLROhfPAutrV6qkWDilzVHqInF1
         1wPRnVIwDpGLkmOcn6Li9FbVLcWYqDRVDYF1C29alzIp9Oxy6gLuRRtmWh9d2BPGufeC
         kicg==
X-Gm-Message-State: AOAM5322jHtytUADgetJGLIZrG5yCi9KRrjokq36nvRFRmNZz3he0IrT
        MJiwJJhdlyK7FM0pF1aMVwg=
X-Google-Smtp-Source: ABdhPJxpZLAM50YbYXZyY4ctZf7s37K7ojfjrwRe8oqZUQIqUoMNHZjCNJSz0yAAg0q8oxdFB5t2KA==
X-Received: by 2002:adf:dc8c:: with SMTP id r12mr4294940wrj.510.1637825546781;
        Wed, 24 Nov 2021 23:32:26 -0800 (PST)
Received: from ?IPV6:2003:ea:8f1a:f00:6832:ca58:d1ea:870e? (p200300ea8f1a0f006832ca58d1ea870e.dip0.t-ipconnect.de. [2003:ea:8f1a:f00:6832:ca58:d1ea:870e])
        by smtp.googlemail.com with ESMTPSA id o4sm2414434wry.80.2021.11.24.23.32.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 24 Nov 2021 23:32:26 -0800 (PST)
Message-ID: <1849b7a3-cdfe-f9dc-e4d1-172e8b1667d2@gmail.com>
Date:   Thu, 25 Nov 2021 08:32:18 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.2
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        intel-wired-lan <intel-wired-lan@lists.osuosl.org>,
        Kalle Valo <kvalo@codeaurora.org>
Cc:     netdev@vger.kernel.org, ath10k@lists.infradead.org,
        Stephen Hemminger <stephen@networkplumber.org>
References: <20211124144505.31e15716@hermes.local>
 <20211124164648.43c354f4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [Bug 215129] New: Linux kernel hangs during power down
In-Reply-To: <20211124164648.43c354f4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 25.11.2021 01:46, Jakub Kicinski wrote:
> Adding Kalle and Hainer.
> 
> On Wed, 24 Nov 2021 14:45:05 -0800 Stephen Hemminger wrote:
>> Begin forwarded message:
>>
>> Date: Wed, 24 Nov 2021 21:14:53 +0000
>> From: bugzilla-daemon@bugzilla.kernel.org
>> To: stephen@networkplumber.org
>> Subject: [Bug 215129] New: Linux kernel hangs during power down
>>
>>
>> https://bugzilla.kernel.org/show_bug.cgi?id=215129
>>
>>             Bug ID: 215129
>>            Summary: Linux kernel hangs during power down
>>            Product: Networking
>>            Version: 2.5
>>     Kernel Version: 5.15
>>           Hardware: All
>>                 OS: Linux
>>               Tree: Mainline
>>             Status: NEW
>>           Severity: normal
>>           Priority: P1
>>          Component: Other
>>           Assignee: stephen@networkplumber.org
>>           Reporter: martin.stolpe@gmail.com
>>         Regression: No
>>
>> Created attachment 299703
>>   --> https://bugzilla.kernel.org/attachment.cgi?id=299703&action=edit    
>> Kernel log after timeout occured
>>
>> On my system the kernel is waiting for a task during shutdown which doesn't
>> complete.
>>
>> The commit which causes this behavior is:
>> [f32a213765739f2a1db319346799f130a3d08820] ethtool: runtime-resume netdev
>> parent before ethtool ioctl ops
>>
>> This bug causes also that the system gets unresponsive after starting Steam:
>> https://steamcommunity.com/app/221410/discussions/2/3194736442566303600/
>>
> 

I think the reference to ath10k_pci is misleading, Kalle isn't needed here.
The actual issue is a RTNL deadlock in igb_resume(). See log snippet:

Nov 24 18:56:19 MartinsPc kernel:  igb_resume+0xff/0x1e0 [igb 21bf6a00cb1f20e9b0e8434f7f8748a0504e93f8]
Nov 24 18:56:19 MartinsPc kernel:  pci_pm_runtime_resume+0xa7/0xd0
Nov 24 18:56:19 MartinsPc kernel:  ? pci_pm_freeze_noirq+0x110/0x110
Nov 24 18:56:19 MartinsPc kernel:  __rpm_callback+0x41/0x120
Nov 24 18:56:19 MartinsPc kernel:  ? pci_pm_freeze_noirq+0x110/0x110
Nov 24 18:56:19 MartinsPc kernel:  rpm_callback+0x35/0x70
Nov 24 18:56:19 MartinsPc kernel:  rpm_resume+0x567/0x810
Nov 24 18:56:19 MartinsPc kernel:  __pm_runtime_resume+0x4a/0x80
Nov 24 18:56:19 MartinsPc kernel:  dev_ethtool+0xd4/0x2d80

We have at least two places in net core where runtime_resume() is called
under RTNL. This conflicts with the current structure in few Intel drivers
that have something like the following in their resume path.

	rtnl_lock();
	if (!err && netif_running(netdev))
		err = __igb_open(netdev, true);

	if (!err)
		netif_device_attach(netdev);
	rtnl_unlock();

Other drivers don't do this, so it's the question whether it's actually
needed here to take RTNL. Some discussion was started [0], but it ended
w/o tangible result and since then it has been surprisingly quiet.

[0] https://www.spinics.net/lists/netdev/msg736880.html
