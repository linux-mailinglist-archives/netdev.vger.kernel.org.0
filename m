Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C91733A231
	for <lists+netdev@lfdr.de>; Sun, 14 Mar 2021 02:41:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234853AbhCNBk4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 13 Mar 2021 20:40:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234820AbhCNBku (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 13 Mar 2021 20:40:50 -0500
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 510D2C061574
        for <netdev@vger.kernel.org>; Sat, 13 Mar 2021 17:40:50 -0800 (PST)
Received: by mail-pl1-x631.google.com with SMTP id e2so8389528pld.9
        for <netdev@vger.kernel.org>; Sat, 13 Mar 2021 17:40:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=vpgi2Mq2BD+71xMEef8htvXfub7DhGyZbEVF5bkDTNk=;
        b=V14SfYe8t7206dSHElU32UekpHOCH8nZjdVuoEc+F+cLhVNUEcBiHEx8SjFZA7r0aV
         O8baG7Rj2NQ2OiGnemhyUa0zDongIixJYLwvDL1CVhFLrmdecZN75uB2GgqMq0zHNXye
         ohXIflO1jl9xwl0+NDkosXLWVVwl73JFJHsGzXWGo656PSKXOh2/V2Tl6hInZ23MhsDe
         XBibSJFbPgDuY+LfZhmvPIfYcLw0AvEoaTFgNuWahgRS708Vjqdo9d/BL9xnLxO+CHM1
         P9cS1BGUzr0BiADA6qNyH1Rb7ti65+y1m4cmDfIg4GASPwz1NPyGeaRKaDyW4viNFl4z
         p7DA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=vpgi2Mq2BD+71xMEef8htvXfub7DhGyZbEVF5bkDTNk=;
        b=FlinCzJZuArtx16pbKOoJwD/PndawTTAj4OYR8pT9vu1nHTvWSBJ/1tggeunW+iaCs
         +Wi/zzuAw0YBV9BsncScnwVX4u8nEP45ke16nqwSMvsgKUbBnfipSssu7eO/0fvmpitK
         id8H8tkcRsuIdPRNo6FtkaSuesZNxTd3FQvkqeWbgKh4eL9+YlgV9aEZqkWU3NeCvlqG
         SSza681EBUyrZaMl/I6/uVg7G5Td9ahkSgr3e7o6DhlYdTMbS1BM5Cd+g/aq7XzaUfOg
         /BmvaueIX3KhDDY0vKyEyUBU6XJy2VWzFs8WQiHGhDlss5AvyxC/1cWyGz68ezx55N3p
         aFyg==
X-Gm-Message-State: AOAM5300REVmS7O163pbpJ/GpAwewwlIEf4QigO3PPdNXWLfxKlMUsC7
        LQMPQklQLxrOB0MwUPGueCaEdUuMvPg=
X-Google-Smtp-Source: ABdhPJzk0C4mz+T33w4fBFj+Vpot/Y3uq36zk/IzNfQMoqjisa+X/YSvjapcRZJkZA4GAqUbhC0t0A==
X-Received: by 2002:a17:90b:3909:: with SMTP id ob9mr6049491pjb.181.1615686049511;
        Sat, 13 Mar 2021 17:40:49 -0800 (PST)
Received: from [10.230.29.33] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id g6sm9565327pfi.15.2021.03.13.17.40.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 13 Mar 2021 17:40:49 -0800 (PST)
Subject: Re: [PATCH net-next v2 1/4] net: dsa: hellcreek: Add devlink VLAN
 region
To:     Kurt Kanzenbach <kurt@kmk-computers.de>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
References: <20210313093939.15179-1-kurt@kmk-computers.de>
 <20210313093939.15179-2-kurt@kmk-computers.de>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <63fbbe25-6483-5ca7-a087-6460046c908d@gmail.com>
Date:   Sat, 13 Mar 2021 17:40:47 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210313093939.15179-2-kurt@kmk-computers.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 3/13/2021 1:39 AM, Kurt Kanzenbach wrote:
> Allow to dump the VLAN table via devlink. This especially useful, because the
> driver internally leverages VLANs for the port separation. These are not visible
> via the bridge utility.
> 
> Signed-off-by: Kurt Kanzenbach <kurt@kmk-computers.de>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
