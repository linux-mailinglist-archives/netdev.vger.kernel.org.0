Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87A113D0A28
	for <lists+netdev@lfdr.de>; Wed, 21 Jul 2021 09:59:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234183AbhGUHRz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Jul 2021 03:17:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235538AbhGUHQh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Jul 2021 03:16:37 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0197C061574
        for <netdev@vger.kernel.org>; Wed, 21 Jul 2021 00:57:12 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id l26so1228567eda.10
        for <netdev@vger.kernel.org>; Wed, 21 Jul 2021 00:57:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tessares-net.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=SKftEz5hMtjmzeC7mmP/ePiStoRjieAtu2Sh2sFnsKc=;
        b=BXG4mDwttEjc1/nE/7EGJbk7IZieqHhHgBq5xoiFMgVB0MszorzBjB4IJoU42nK6hQ
         QBwy2EejZQ5utb4dY+F2nCDmsdD0AfQplkrXPCURX9A4Ow7rw+5T6cy/dCT0dj3tYQ1b
         8dV88cs2VsyGxrZKNOk4VSoClhj0QQ2WAg1mGtLlatf3nYJclgSz4APWNgThblLCQDdb
         Oo4p9IzgWBLeS6oLqTLJCJb8qHRhEX/21M4YZJ/Q6NAQr0ujy468aGhDPoUFEBnsCcVB
         6dZFvotOD7ym8vL68zJyDLgRaBM91dR3JC/oaEkRPcIGDPl41XVAbEFtqiMB5w3zERtq
         oLXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=SKftEz5hMtjmzeC7mmP/ePiStoRjieAtu2Sh2sFnsKc=;
        b=SL4dzOozRnUIQET/1BoQ/x6EuqnP8rFyXjU+VvqJMs6LGHTuhekFkrre17j3vIE+Mn
         MsH08WREtqm3IJXwwTYSldexIqmSEUcIkUW2knSJUb221YTb9b+tGTKS5kvn31yioWV9
         Cc8Iu1J1zJKVF4tauWEpNbRCDwYaSiQ8j6S6iy1IOvK81WqcH3+RXDIn00xzvOKKTy9l
         2lLecBYMzL8liYEozufaoXNeKmv4lKNvHiiGOJ6TF0Qoa9Yzvx/nqVx8m+8vGm66kwFr
         Wg8yddA3H79lkqstxo7qRMzM6GhKWKr628rgbugqkMNCZjD8S3KPwJTaSH9IOPxNAGNy
         rKiQ==
X-Gm-Message-State: AOAM531Udw7JosOyAMyHd2npvCn2Xibd3XljP1olGNNCr042HGcgxVKR
        eooV5B5a3o6N2Dbyd/hgjZTr8g==
X-Google-Smtp-Source: ABdhPJwhpf6Z7+77HDHxQSNqLj9QQejqfdBzFWiDQs6tO0ZtU4lC6IWHSCY7izhkRp7EfbaHao3dkg==
X-Received: by 2002:aa7:d809:: with SMTP id v9mr47125400edq.146.1626854231472;
        Wed, 21 Jul 2021 00:57:11 -0700 (PDT)
Received: from tsr-lap-08.nix.tessares.net ([2a02:578:85b0:e00:465a:316b:228:fc83])
        by smtp.gmail.com with ESMTPSA id v16sm9698756edc.52.2021.07.21.00.57.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 21 Jul 2021 00:57:11 -0700 (PDT)
Subject: Re: [PATCH net-next 1/2] net: switchdev: remove stray semicolon in
 switchdev_handle_fdb_del_to_device shim
To:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     kernel test robot <lkp@intel.com>
References: <20210720173557.999534-1-vladimir.oltean@nxp.com>
 <20210720173557.999534-2-vladimir.oltean@nxp.com>
From:   Matthieu Baerts <matthieu.baerts@tessares.net>
Message-ID: <c09a370b-7ce3-0b4f-c758-793f59bbdad5@tessares.net>
Date:   Wed, 21 Jul 2021 09:57:10 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210720173557.999534-2-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Vladimir,

On 20/07/2021 19:35, Vladimir Oltean wrote:
> With the semicolon at the end, the compiler sees the shim function as a
> declaration and not as a definition, and warns:
> 
> 'switchdev_handle_fdb_del_to_device' declared 'static' but never defined

Thank you for the patch!

My CI also reported the same issue and I confirm it removes the warning.

Tested-by: Matthieu Baerts <matthieu.baerts@tessares.net>

Cheers,
Matt
-- 
Tessares | Belgium | Hybrid Access Solutions
www.tessares.net
