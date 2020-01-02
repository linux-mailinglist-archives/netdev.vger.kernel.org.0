Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7A35912E8E1
	for <lists+netdev@lfdr.de>; Thu,  2 Jan 2020 17:46:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728881AbgABQqy convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 2 Jan 2020 11:46:54 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:41549 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728280AbgABQqy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jan 2020 11:46:54 -0500
Received: from mail-pj1-f70.google.com ([209.85.216.70])
        by youngberry.canonical.com with esmtps (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <kai.heng.feng@canonical.com>)
        id 1in3ca-0000uj-3w
        for netdev@vger.kernel.org; Thu, 02 Jan 2020 16:46:52 +0000
Received: by mail-pj1-f70.google.com with SMTP id 9so5468440pjn.8
        for <netdev@vger.kernel.org>; Thu, 02 Jan 2020 08:46:52 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=N+0SMH83DEMdXBxklWnpSdQi+VtqH5p+lcgEClqwKXc=;
        b=SEl6BjajWysF9LVBqmz9SIG8USAvu+vk8d1NRQ5dslth1w4j2wxDgPelvSheDOs1jT
         ICJImB3XlqBpJBh490DFbDF12OZTiJl3b+bILeb07WgWzW0Z12Qw9HviTC/QI52j7CUc
         W+BeD4lK/3u4vytx6jV7GvjcHP6VjXtCIWytAhYZRDEzputCyvsVzQCgxdVVC35HwGVR
         zcS20BgtnY9nlWfYFMKGXuYGCAIfGLwPuDulq6VyBz9rKmW2dvWfYVMHLxT+pY2zdLQS
         6S3m7LrZlMMUkmVObyMgwubvJ0kapt0fhUI/ZohDe3gNOxUTfg5MdxyGsOq1VfRBuSFY
         37kg==
X-Gm-Message-State: APjAAAU4NdrbBBEBtaH3Rt0ZkXtH6EpaW+1Iw9xOG7Ra5ZWbpexVKEcA
        I/hKimpciDE3MXgzIYw9Hi5v/ahga69IvrIfRW/xDWtlZyCWO3PyuVlPAubTngpDcfN7ujp6aXq
        yT/uJdNVC6YgRPNRkf2jUwZhHjJQGxHid+w==
X-Received: by 2002:a17:902:b609:: with SMTP id b9mr85940504pls.70.1577983610835;
        Thu, 02 Jan 2020 08:46:50 -0800 (PST)
X-Google-Smtp-Source: APXvYqzIk9aPVIqBcPxzYk6x48gY3qrrcgKVCBBz9vFSwtTE8Mot2uF3FKpgNC3MV0XYtVt/cJfSfw==
X-Received: by 2002:a17:902:b609:: with SMTP id b9mr85940479pls.70.1577983610489;
        Thu, 02 Jan 2020 08:46:50 -0800 (PST)
Received: from 2001-b011-380f-35a3-d94d-dd84-8131-7958.dynamic-ip6.hinet.net (2001-b011-380f-35a3-d94d-dd84-8131-7958.dynamic-ip6.hinet.net. [2001:b011:380f:35a3:d94d:dd84:8131:7958])
        by smtp.gmail.com with ESMTPSA id b4sm65574395pfd.18.2020.01.02.08.46.48
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 02 Jan 2020 08:46:49 -0800 (PST)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 13.0 \(3608.40.2.2.4\))
Subject: Re: SFP+ support for 8168fp/8117
From:   Kai-Heng Feng <kai.heng.feng@canonical.com>
In-Reply-To: <20200102152143.GB1397@lunn.ch>
Date:   Fri, 3 Jan 2020 00:46:46 +0800
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Linux Netdev List <netdev@vger.kernel.org>,
        Kernel development list <linux-kernel@vger.kernel.org>,
        Anthony Wong <anthony.wong@canonical.com>,
        Jason Yen <jason.yen@canonical.com>
Content-Transfer-Encoding: 8BIT
Message-Id: <DC28A43E-4F1A-40B6-84B0-3E79215527C9@canonical.com>
References: <2D8F5FFE-3EC3-480B-9D15-23CACE5556DF@canonical.com>
 <20200102152143.GB1397@lunn.ch>
To:     Andrew Lunn <andrew@lunn.ch>
X-Mailer: Apple Mail (2.3608.40.2.2.4)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew,

> On Jan 2, 2020, at 23:21, Andrew Lunn <andrew@lunn.ch> wrote:
> 
> On Thu, Jan 02, 2020 at 02:59:42PM +0800, Kai Heng Feng wrote:
>> Hi Heiner,
>> 
>> There's an 8168fp/8117 chip has SFP+ port instead of RJ45, the phy device ID matches "Generic FE-GE Realtek PHY" nevertheless.
>> The problems is that, since it uses SFP+, both BMCR and BMSR read are always zero, so Realtek phylib never knows if the link is up.
>> 
>> However, the old method to read through MMIO correctly shows the link is up:
>> static unsigned int rtl8169_xmii_link_ok(struct rtl8169_private *tp)
>> {
>>       return RTL_R8(tp, PHYstatus) & LinkStatus;
>> }
>> 
>> Few ideas here:
>> - Add a link state callback for phylib like phylink's phylink_fixed_state_cb(). However there's no guarantee that other parts of this chip works.
>> - Add SFP+ support for this chip. However the phy device matches to "Generic FE-GE Realtek PHY" which may complicate things.
>> 
>> Any advice will be welcome.
> 
> Hi Kai
> 
> Is the i2c bus accessible?

I don't think so. It seems to be a regular Realtek 8168 device with generic PCI ID [10ec:8168].

> Is there any documentation or example code?

Unfortunately no.

> 
> In order to correctly support SFP+ cages, we need access to the i2c
> bus to determine what sort of module has been inserted. It would also
> be good to have access to LOS, transmitter disable, etc, from the SFP
> cage.

Seems like we need Realtek to provide more information to support this chip with SFP+.

Kai-Heng

> 
>   Andrew

