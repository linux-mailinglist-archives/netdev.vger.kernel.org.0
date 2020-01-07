Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B0063132E00
	for <lists+netdev@lfdr.de>; Tue,  7 Jan 2020 19:08:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728583AbgAGSIv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jan 2020 13:08:51 -0500
Received: from mail-wm1-f51.google.com ([209.85.128.51]:35330 "EHLO
        mail-wm1-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728537AbgAGSIv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jan 2020 13:08:51 -0500
Received: by mail-wm1-f51.google.com with SMTP id p17so562148wmb.0
        for <netdev@vger.kernel.org>; Tue, 07 Jan 2020 10:08:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=leZH/hyPq1HdCmvzNKu8P8e45+GKLsiInMdhc5pNFYE=;
        b=FoFeUEpwmgInfkhgPEk7Pek3DR6i0HrV/knpEhN/3tGhczrD1aPN2ANsFY07M1Epyg
         SuyBhe1kaDSrUuWjOyS44HZyXn17/Plm8petLwiuzuNOUFdLw/HIG+TkIUZufvi+swEP
         qxcnPQWpdHAXhjGujXyhkEchTeOmpgi3l6g9H3EbPFzU0g4U8yN2k93QkQ2JDKfKncKu
         Yg32KK2lEt5sXttWdCOwHRPaZZ6L+Fz2dID6byFNhAt+5X7gFN+QpkAb8B/FObCorFq5
         IYc/ZyXfy3Fcd+2Ldj9vM9nRVOvrttdK5QQMjC3VthxjdIKjMSkNZpsxiIJmka6QYbP1
         gcZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=leZH/hyPq1HdCmvzNKu8P8e45+GKLsiInMdhc5pNFYE=;
        b=qTAdFIvZfkA0L8QB5gmyL+Bqoew6RvoaCedBhgmDHf+hEFnJzSChcukeI4rWH6V715
         FfQ+4pdSEk0kI0Wjae6JM4MkmBh6tgDAAEf4a4SRQiIGvIEPHJX8kW1KUeMwZbQk6bxe
         fsBMsfyEArtu/QEk2NgygK+hE8uFwWZzSLkO+2aCl6MKM3/WRsNjZEhItoWX4inigtx0
         y7yEXSTm6/qLYSKvltgUJX8rWEqkM+83D7sMqzTyg3CGavfXIrErWIlm+LW1/KwbtyiA
         TrOOHfYCIioayl15cQKzlEWNoKkU4oM+isumDhrLKvk+azfQQrl2we3p4sZ2LJxk+uhl
         BkBg==
X-Gm-Message-State: APjAAAUwMlOlzi+xUu0gHM1TdrgfaK/gECbwkJJ+1L2hHO6Rt28hIWcg
        gCZNifUnhOmmmOIPVM1xIjE=
X-Google-Smtp-Source: APXvYqxPVTpjxx8/KcW29Al+6XlZKWg5gYC2ZMbChGCuta74x2uYzEsi5/wzvNsQbKd1puAckBTfxQ==
X-Received: by 2002:a1c:61d6:: with SMTP id v205mr297744wmb.91.1578420529794;
        Tue, 07 Jan 2020 10:08:49 -0800 (PST)
Received: from [192.168.178.85] (pD9F901D9.dip0.t-ipconnect.de. [217.249.1.217])
        by smtp.googlemail.com with ESMTPSA id o16sm534602wmc.18.2020.01.07.10.08.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Jan 2020 10:08:49 -0800 (PST)
Subject: Re: Freescale network device not activated on mpc8360 (kmeter1 board)
To:     Matteo Ghidoni <matteo.ghidoni@ch.abb.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Li Yang <leoyang.li@nxp.com>
Cc:     "sux@loplof.de" <sux@loplof.de>, linuxppc-dev@lists.ozlabs.org
References: <AM0PR06MB5427E4BDF8FB1BEC5DF3D45FB33F0@AM0PR06MB5427.eurprd06.prod.outlook.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <55f4ba5d-fd05-4a14-6319-d5d76c9675f2@gmail.com>
Date:   Tue, 7 Jan 2020 19:08:42 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.1
MIME-Version: 1.0
In-Reply-To: <AM0PR06MB5427E4BDF8FB1BEC5DF3D45FB33F0@AM0PR06MB5427.eurprd06.prod.outlook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 07.01.2020 14:05, Matteo Ghidoni wrote:
>  Hi all,
> 
> With the introduction of the following patch, we are facing an issue with the activation of the Freescale network device (ucc_geth driver) on our kmeter1 board based on a MPC8360:

+Li as ucc_geth maintainer

Can you describe the symptoms of the issue?

> 
> commit 124eee3f6955f7aa19b9e6ff5c9b6d37cb3d1e2c
> Author: Heiner Kallweit <hkallweit1@gmail.com>
> Date:   Tue Sep 18 21:55:36 2018 +0200
> 
>     net: linkwatch: add check for netdevice being present to linkwatch_do_dev
> 
> Based on my observations, just before trying to activate the device through linkwatch_event, the controller wants to adjust the MAC configuration and in order to achieve this it detaches the device. This avoids the activation of the net device.
> 
It sounds a little bit odd to rely on an asynchronous linkwatch event here.
Can you give a call trace?

The driver is quite old and maybe some parts need to be improved. The referenced change is more than a year old
and I'm not aware of any other problem with it. So it seems the change isn't wrong.

> This is already happening with older versions (I checked with the v4.14.162) and also there the situation is the same, but without the additional check in the if condition the device is activated.
> 
> I am currently working with the v5.4.8 kernel version, but the behavior remains the same also with the latest v5.5-rc4.
> 
> Any idea how to solve this? Any help is appreciated.
> 
> Regards,
> Matteo
> 
Heiner

