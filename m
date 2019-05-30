Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DC7FC30045
	for <lists+netdev@lfdr.de>; Thu, 30 May 2019 18:39:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726589AbfE3QjR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 May 2019 12:39:17 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:45391 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726045AbfE3QjR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 May 2019 12:39:17 -0400
Received: by mail-wr1-f67.google.com with SMTP id b18so4604577wrq.12
        for <netdev@vger.kernel.org>; Thu, 30 May 2019 09:39:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=tLjJMkmfb2IVnP0rR8CEM39O4i3tznoi2HlaN0Fb7No=;
        b=Nw4g3mQk0W7dhDUDH0Lqd/I6AbhlpcbY8E1wBiTArYYDpfO24pLH9Z1oWRytr6xbNO
         4vN7t1zQu8pHrTsYb6l/3zw9mZXGSfj+/JawOBYEwSrZ1ZBL9PSgUABDicD0bMK2zZ5N
         uFQ7bEwTfKyPlQ1h1mIBdhV9iV2466iYvCxSPl5iggCzmdPRDdIoDyd+/04O1c+O38ZF
         lVa4bhxAbX03ZNYohYq5/f6aLhs71Pbf2O5Xnrw8LFQ6wsIQ9u76qz64M3ntfPpVplrd
         HuT7lV7WIkOOmJz6bzHynHmd6odCMylsRCtl47Spz0qHVfpOKgIU6RH1/hV2at/MtJBz
         c+Rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=tLjJMkmfb2IVnP0rR8CEM39O4i3tznoi2HlaN0Fb7No=;
        b=tJ33KLXTALMLkGK5NdilGO3I0HY8nrXms8gktgfdh2xvisWNulbzvLi3w/Fpyfp1sJ
         hGbdUA0sWp6QHjnEuXNlT1YamIWCvTGILrNTEd2OLTsQ2EbPF98gAPBOIqG5pFUi5aem
         R/evkM0wE55sA8Kr6hkf2UhKGoZWOrfZFJQMt/KVVSqnx5VQdzO0kCPKlhNbGZTWSAL9
         xnYdq1+8KJjbMyoTH07v2MXH2KCtBual5TySe8ac9YLAugRD3kxPMfl7XvOYc2/3+0IO
         YUTnwFyOLw+8h18m5VRLwnEjvx24df55PxkIT1h3Ne9fqskQoqfkfK9mDOx+AcsJwTvt
         DguA==
X-Gm-Message-State: APjAAAV1+FX4GO82r1/D216rLqMtZIzydEWgs5BPXchFR26ydl56jYF3
        rSWa4XktQvAg8UnsPOecttOPZHxI
X-Google-Smtp-Source: APXvYqyADpPqjsDSxxRCvt2+7RNiuFdysd9KZMPGvfNqYPSVEGMqHsT5AbIYdVoaphONFY1Twbz2/A==
X-Received: by 2002:a5d:4604:: with SMTP id t4mr3317857wrq.93.1559234355139;
        Thu, 30 May 2019 09:39:15 -0700 (PDT)
Received: from ?IPv6:2003:ea:8bf3:bd00:7d95:5542:24c5:5635? (p200300EA8BF3BD007D95554224C55635.dip0.t-ipconnect.de. [2003:ea:8bf3:bd00:7d95:5542:24c5:5635])
        by smtp.googlemail.com with ESMTPSA id x21sm12129094wmi.1.2019.05.30.09.39.14
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 30 May 2019 09:39:14 -0700 (PDT)
Subject: Re: Gigabit ethernet r8168/r8169
To:     Roman Hergenreder <mail@romanh.de>, netdev@vger.kernel.org
References: <c63b1079-a5df-f3f3-da0c-c3ed08277a0c@romanh.de>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <7df3dadc-28b2-3541-39f0-bb35cc61c10b@gmail.com>
Date:   Thu, 30 May 2019 18:39:08 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <c63b1079-a5df-f3f3-da0c-c3ed08277a0c@romanh.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 30.05.2019 17:21, Roman Hergenreder wrote:
> Dear Realtek crew,
> 
> i hope it is okay, that I contact you this way. If not, please tell me,
> who is responsible for this kind of issues.
> 
> I am currently using Arch Linux (5.1.5-arch1-2-ARCH) on a Lenvo Flex
> 2-14
> (https://www.lenovo.com/us/en/laptops/lenovo/flex-series/flex-2-14/) and
> somehow it only operates at 100 mbps (100baseT/Full or 100baseT/Half). I
> already tried various drivers e.g. r8168, r8168-dkms, r8169 (both
> distribution packages and direct download from the realtek site). Also
> different patch cables (cat 5e, cat6) and different communication
> partners (gigabit router + switch) were tried.
> 
Maybe the chip in your system supports fast ethernet only.
We would need to know at least which exact chip version you have
(grep for XID in dmesg output).
And check with ethtool which modes both link partners support and advertise.

> I wonder if it's a driver/kernel problem or a hardware malfunction.
> 
> If you need any further information or command outputs (lspci, lshw,
> dmesg, journal, ethtool), please contact me.
> 
> I am looking forward for your response if you have time to deal with
> this problem.
> 
> 
> Best Regards
> 
> Roman Hergenreder
> 
> P.S. Sorry for the last failed mail
> 

