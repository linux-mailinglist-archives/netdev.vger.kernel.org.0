Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E971A13B469
	for <lists+netdev@lfdr.de>; Tue, 14 Jan 2020 22:33:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728895AbgANVdS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jan 2020 16:33:18 -0500
Received: from mail-wm1-f43.google.com ([209.85.128.43]:51529 "EHLO
        mail-wm1-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726491AbgANVdS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jan 2020 16:33:18 -0500
Received: by mail-wm1-f43.google.com with SMTP id d73so15538623wmd.1
        for <netdev@vger.kernel.org>; Tue, 14 Jan 2020 13:33:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20161025;
        h=from:reply-to:subject:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=BihVo8Jhp4Oc2mpdisRpvI0Vb9SjCcgAm3IJVwAgErU=;
        b=QqbLvJ3tyTTNv+yL0uGHvcKaIG3yxbcJaYkC2BtwNowOxnx3zyzvw6DCWhe3zD6rqx
         +9cqX+GXI75PvDVoIzNHOKvtfXvOIcl4b3y2HC+EVJZmN4yKnRAKDThTd9sIiqYYT1cA
         UNfz6hd1Fe3IyWv3uP99+Frw2S+ahC02MOorziuNLIrPoKbLHZ/Lehgs4dxWuRWb4q3v
         F7he/C7mFh76KjHUlpiFDMbXiKxBPyA2xaX/xpZ3zwAIFsN3D9ru/37xR3BYNkaqIkqz
         /UtCGcEDIu2AHJ/acA9o0QX112idJ3nMBLF/9/l3ATiaf2cK9k5/FoRIdGUALgowTYUp
         0wXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:reply-to:subject:to:cc:references
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-transfer-encoding:content-language;
        bh=BihVo8Jhp4Oc2mpdisRpvI0Vb9SjCcgAm3IJVwAgErU=;
        b=UF5MSG/IwWcoJN0H/GpZn2ql3Amge5VrD7dAhm3l3gyxcUeb8Wfur3j03hODcg9N1z
         Z/qBeGOgOG14PlNZ8JOz1UGzIJOUmpxj+/WUKW21J1rBERzxZi9FM5CvuqNHsrfINifI
         ub2BtWwDe755kaBlE8QQm89bl2Bx0QenXOs3g5QR3W72hvLDoRSAsVruTNhPe5K5drjC
         2qBrEdcYCOzgNOe3LlpOAkXIe+SE9JvElvlH3/w2H6F9SlmKq0xlnz30KnAxih8EeGB0
         rMqLdwajXvcuLH+wrl+nBElvvD/+Sinkq9ZZPKIK0hVUXseER9RffeFTO9N1iZtjXzMJ
         ISaw==
X-Gm-Message-State: APjAAAWMFNP42Y2oxC9SrDjpmfJsVdaDThSM/ViM7IeLTjUGxz1xA7LU
        f/a1f39P5eVT8UkDj01b1GA=
X-Google-Smtp-Source: APXvYqxD5Dn5zUfO0VWDoCk35diHqLWfbSVpGnfzt7JRH1Kl3b3KEbFW8JqCs1uYq91ngOW7ij+amg==
X-Received: by 2002:a7b:cb91:: with SMTP id m17mr29769828wmi.146.1579037596119;
        Tue, 14 Jan 2020 13:33:16 -0800 (PST)
Received: from [192.168.84.205] ([149.233.160.217])
        by smtp.gmail.com with ESMTPSA id s8sm20876613wrt.57.2020.01.14.13.33.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Jan 2020 13:33:15 -0800 (PST)
From:   "=?UTF-8?B?4oSi1p/imLvSh8ytING8INKJIMKu?=" <vtolkm@googlemail.com>
X-Google-Original-From: =?UTF-8?B?4oSi1p/imLvSh8ytING8INKJIMKu?= <vtolkm@gmail.com>
Reply-To: vtolkm@gmail.com
Subject: Re: loss of connectivity after enabling vlan_filtering
To:     netdev@vger.kernel.org
Cc:     Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>
References: <e5252bf0-f9c1-3e40-aebd-8c091dbb3e64@gmail.com>
 <20190629224927.GA26554@lunn.ch>
 <6226b473-b232-e1d3-40e9-18d118dd82c4@gmail.com>
 <20190629231119.GC26554@lunn.ch>
 <53bd8ffc-1c0a-334d-67d5-3a74b76670e8@gmail.com>
 <20190705132957.GB6495@t480s.localdomain>
Message-ID: <4af746cc-b86a-f083-49f7-558df05148bd@gmail.com>
Date:   Tue, 14 Jan 2020 21:33:11 +0000
User-Agent: Mozilla/5.0 (Windows NT 10.0; rv:68.0) Gecko/20100101 Firefox/68.0
MIME-Version: 1.0
In-Reply-To: <20190705132957.GB6495@t480s.localdomain>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-GB
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 05/07/2019 17:29, Vivien Didelot wrote:
> On Sun, 30 Jun 2019 01:23:02 +0200, vtolkm@googlemail.com wrote:
>> A simple soul might infer that mv88e6xxx includes MV88E6060, at least
>> that happened to me apparently (being said simpleton).
> I agree that is confusing, that is why I don't like the 'xxx' naming
> convention in general, found in many drivers. I'd prefer to stick with a
> reference model, or product category, like soho in this case. But it was
> initially written like this, so no reason to change its name now. I still
> plan to merge mv88e6060 into mv88e6xxx, but it is unfortunately low priority
> because I still don't have a platform with a 88E6060 on it.
>
> Thanks,
>
> 	Vivien

At long last discovered (accidentality) what causes the loss of 
connectivity when enabling vlan_filtering, the node being dual-core and 
each core providing a port facing the switchdev:

cpu0 - eht0 [RGMII] <--- > switchdev port 6
cpu1 - eth1 [RGMII] <--- > switchdev port 5

If only one of the CPU ports is connected to the respective switchdev 
port connectivity to the node gets severed when enabling vlan_filtering.
With both CPU ports connected to the respective switchdev ports 
connectivity remains uninterrupted to the node when enabling 
vlan_filtering.
