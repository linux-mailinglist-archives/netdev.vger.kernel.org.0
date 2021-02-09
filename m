Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9183314D6A
	for <lists+netdev@lfdr.de>; Tue,  9 Feb 2021 11:48:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231824AbhBIKrI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Feb 2021 05:47:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230097AbhBIKln (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Feb 2021 05:41:43 -0500
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE2EAC061788
        for <netdev@vger.kernel.org>; Tue,  9 Feb 2021 02:40:28 -0800 (PST)
Received: by mail-ej1-x62f.google.com with SMTP id w2so30402435ejk.13
        for <netdev@vger.kernel.org>; Tue, 09 Feb 2021 02:40:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20150623.gappssmtp.com; s=20150623;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=5EMiA+M1EX7S3s6Ide6XiQEzuV5Nt4cOUQ27APguNU0=;
        b=i4VcfUSqsS8YrEjOZD9RaQ1v7H59645vHWrG1Uuvb+TbUpummDTt5+SJddPabnAZd5
         NzHwp1r/cZMNkEx+4f5a5Dt/KOGSODEwSbC4sJRbhxk8fFfmQ4/VtFNfd3dk+PfOQJfT
         QPwECEoR+M7TCUnVicsfkJIuY1EFKwO/5Kmj5MMSZw4dRtnZF9/U0wNtiOD3goz7IKVH
         qxq2F3f4cHHnWd1ppXrTDCac6gmIy6I9j5WrHgJEdnHwZz592RkRaL1O5Nn6+QutUMJI
         vdjK0gvVjvkgQ5OBBn5cP5JOAPsmK0EnS5pmnv+PD/gpHGiUPgv4zOmLdSKZvGmwtIz0
         zOIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=5EMiA+M1EX7S3s6Ide6XiQEzuV5Nt4cOUQ27APguNU0=;
        b=WdavfzuZIGLVOcQBWcpmnD7H/6vB3xPT6s22bnW4jTUeyJHIWOUBNb+Y6L7sglPkHd
         vTdJcpN7yokvqWi5s6YjW0k7B1KhRBwn1ziU21NvEXtyv7kNVKXlrfcVevmNU2bI7FmV
         baoBEjtzQ2XjypaFMxeEYUKq/Ax0NPStCy2oX2QL7NYceAPcO0HIzjau3kkVof+cfLZd
         yDmIy7R0diHOIa8qhPSfJTJd5vs8idluCth2iCjt/1dcrJ34EncqWyCWTI2ytHuR3f8D
         4mdTwlRBLGoEDvNT77574vS87fMA+6m6nyBrlWZLL2yl8t9X/+K7QP8QmtUuGvu03rCA
         /l9w==
X-Gm-Message-State: AOAM532MEnGZtuWSsyajGtm/i7OpmE8FRFmMXIsEnp+0m/CJRkAIoWnB
        VxvTtiXLRPNMmMHKlZwBCS41rA==
X-Google-Smtp-Source: ABdhPJxGcvuqQyCWgb9RUGTA1z8jMVUXIlzQKrvrUIJSOil5ncVlDfKXXrZyHUvGRgUfdXMt5pjCeA==
X-Received: by 2002:a17:906:3ac3:: with SMTP id z3mr21548623ejd.449.1612867227682;
        Tue, 09 Feb 2021 02:40:27 -0800 (PST)
Received: from [192.168.0.104] (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id cb21sm11454323edb.57.2021.02.09.02.40.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 Feb 2021 02:40:27 -0800 (PST)
Subject: Re: [PATCH net-next 3/3] bonding: 3ad: Use a more verbose warning for
 unknown speeds
From:   Nikolay Aleksandrov <razor@blackwall.org>
To:     netdev@vger.kernel.org
Cc:     roopa@nvidia.com, idosch@nvidia.com, andy@greyhouse.net,
        j.vosburgh@gmail.com, vfalico@gmail.com, kuba@kernel.org,
        davem@davemloft.net
References: <20210209103209.482770-1-razor@blackwall.org>
 <20210209103209.482770-4-razor@blackwall.org>
Message-ID: <65f725fb-b6fb-af89-53b5-3718b43fe552@blackwall.org>
Date:   Tue, 9 Feb 2021 12:40:25 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210209103209.482770-4-razor@blackwall.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 09/02/2021 12:32, Nikolay Aleksandrov wrote:
> From: Ido Schimmel <idosch@nvidia.com>
> 
> The bond driver needs to be patched to support new ethtool speeds.
> Currently it emits a single warning [1] when it encounters an unknown
> speed. As evident by the two previous patches, this is not explicit
> enough. Instead, use WARN_ONCE() to get a more verbose warning [2].
> 
> [1]
> bond10: (slave swp1): unknown ethtool speed (200000) for port 1 (set it to 0)
> 
> [2]
> bond20: (slave swp2): unknown ethtool speed (400000) for port 1 (set it to 0)
> WARNING: CPU: 5 PID: 96 at drivers/net/bonding/bond_3ad.c:317 __get_link_speed.isra.0+0x110/0x120
> Modules linked in:
> CPU: 5 PID: 96 Comm: kworker/u16:5 Not tainted 5.11.0-rc6-custom-02818-g69a767ec7302 #3243
> Hardware name: Mellanox Technologies Ltd. MSN4700/VMOD0010, BIOS 5.11 01/06/2019
> Workqueue: bond20 bond_mii_monitor
> RIP: 0010:__get_link_speed.isra.0+0x110/0x120
> Code: 5b ff ff ff 52 4c 8b 4e 08 44 0f b7 c7 48 c7 c7 18 46 4a b8 48 8b 16 c6 05 d9 76 41 01 01 49 8b 31 89 44 24 04 e8 a2 8a 3f 00 <0f> 0b 8b 44 24 04 59 c3 0
> f 1f 84 00 00 00 00 00 48 85 ff 74 3b 53
> RSP: 0018:ffffb683c03afde0 EFLAGS: 00010282
> RAX: 0000000000000000 RBX: ffff96bd3f2a9a38 RCX: 0000000000000000
> RDX: ffff96c06fd67560 RSI: ffff96c06fd57850 RDI: ffff96c06fd57850
> RBP: 0000000000000000 R08: ffffffffb8b49888 R09: 0000000000009ffb
> R10: 00000000ffffe000 R11: 3fffffffffffffff R12: 0000000000000000
> R13: ffff96bd3f2a9a38 R14: ffff96bd49c56400 R15: ffff96bd49c564f0
> FS:  0000000000000000(0000) GS:ffff96c06fd40000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007f327ad804b0 CR3: 0000000142ad5006 CR4: 00000000003706e0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> Call Trace:
>  ad_update_actor_keys+0x36/0xc0
>  bond_3ad_handle_link_change+0x5d/0xf0
>  bond_mii_monitor.cold+0x1c2/0x1e8
>  process_one_work+0x1c9/0x360
>  worker_thread+0x48/0x3c0
>  kthread+0x113/0x130
>  ret_from_fork+0x1f/0x30
> 
> Signed-off-by: Ido Schimmel <idosch@nvidia.com>
> ---
>  drivers/net/bonding/bond_3ad.c | 9 ++++-----
>  1 file changed, 4 insertions(+), 5 deletions(-)
> 

Oops, forgot to add my acked-by. :)
Acked-by: Nikolay Aleksandrov <nikolay@nvidia.com>


