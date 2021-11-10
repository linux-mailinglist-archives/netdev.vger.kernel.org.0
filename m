Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 033A744B99B
	for <lists+netdev@lfdr.de>; Wed, 10 Nov 2021 01:30:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230487AbhKJAcd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Nov 2021 19:32:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230508AbhKJAcc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Nov 2021 19:32:32 -0500
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11939C061767
        for <netdev@vger.kernel.org>; Tue,  9 Nov 2021 16:29:46 -0800 (PST)
Received: by mail-pg1-x52c.google.com with SMTP id n23so602172pgh.8
        for <netdev@vger.kernel.org>; Tue, 09 Nov 2021 16:29:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=/HlAJkz8z+WvcY1CNW3q9RpILjfIUidoFI5uK5K0/NY=;
        b=GB5GtDe36Kfotz+SAUI0Z8GpWiH2kk8PQ5lNYJGw6bgIQyDnZ/HG4DwavAtQn1aEUr
         20vfcZXTxD35Oava+sQSijJxHDN8BshQVGo743YxNC/BiFp+zW2DVQ/vjQWp8AsSy+Mc
         rvT9WDKB+MEZvwaXMzoTnKV1j3Rn3uuoqVD59pgzA75gmmpKzj0OvH2E+BZwLhOhH/5V
         0IqWEe+4PlkE950mD+Hix0dSGHzNqia1ezeGjXchD3O+208/5S6yYHL1hZS08gz4EuhI
         fhi6H0g+dZ4mZ11lh99Y06blEdW3Z4e8/Y97vl1LgXWv8YC/3GIgHleCYUQHUYedsTJ+
         sf3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=/HlAJkz8z+WvcY1CNW3q9RpILjfIUidoFI5uK5K0/NY=;
        b=y6eQsJWDv0folm/HG6EeOAsI6EuCOrXxZBiA3jwBX3pQ/qNpIG276ZcUdZTb0QMu89
         oWLdR2I6sG1xvd4QLyr9LYEn7z31e+doasGO2bVu1F2iyaLv0CnLeo5i/fy/l9bhutuX
         S2onNT7tx7+zVMt/K2sWbAM0hS+iMbO7Fe7ruCqTJIlSxiTVCuZcDvsHrhYg1rlEWRXu
         Gh93dg/VDVQMyWcuNlT/1mgs0ePxIBeh7q2pPS3e4GHLRdlqoHB1eIBETXtQOk7/e4WG
         1zn35EDaUZI4JwhjD/PIU6SMmJwtEr/m//8urDtgJlt/gd97O1iOWtWtpsq30744vpC+
         EwbA==
X-Gm-Message-State: AOAM530mdd++f2hDWoW3raO5dpZJkKeHKHOhz0JeIA3BBS2wPcgebaRx
        dX0z/CmYt04vNS3AOCgavgd3NHJdtBQ=
X-Google-Smtp-Source: ABdhPJypDhouvq0pwS01V6Vg3ru+o+9AX7Pj1GlHdbnxzl5D7BhQEpcSiyE5xBQ3q5GQSpTdEhWUjw==
X-Received: by 2002:a65:460f:: with SMTP id v15mr9102237pgq.430.1636504185346;
        Tue, 09 Nov 2021 16:29:45 -0800 (PST)
Received: from [192.168.86.235] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id a11sm7097406pfh.108.2021.11.09.16.29.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 Nov 2021 16:29:44 -0800 (PST)
Subject: Re: Suitable value for bonding module's tx_queues?
To:     Johannes Lundberg <johalun0@gmail.com>, netdev@vger.kernel.org
References: <948e62ad-2fe5-11e3-03a9-8382f7e8b6f1@gmail.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <edcf2233-4da9-b756-150d-114285b860d1@gmail.com>
Date:   Tue, 9 Nov 2021 16:29:38 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <948e62ad-2fe5-11e3-03a9-8382f7e8b6f1@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/9/21 12:58 PM, Johannes Lundberg wrote:
> Hi
> 
> Please cc me on reply since I'm not subscribed.
> 
> I'm wondering when you want to change tx_queues from default 16. Should this match the total number of queues of all the members of the bond? Let's say I got 2 interfaces, each with 24 queues on a 24 CPU system in a bond. Should I load bonding with 24 to match the number of CPUs or 48 to match the total number of queues of the members, or leave at default because it's not relevant?
> 
> Thanks!
> 

Unless you add a mq qdisc on the bonding device, "number of tx queues" does not matter
because bonding is a virtual device, with NETIF_F_LLTX



