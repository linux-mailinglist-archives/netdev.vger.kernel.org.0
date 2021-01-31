Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C50E4309AD4
	for <lists+netdev@lfdr.de>; Sun, 31 Jan 2021 07:23:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229484AbhAaGRR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 31 Jan 2021 01:17:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229460AbhAaGRQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 31 Jan 2021 01:17:16 -0500
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2912C061573
        for <netdev@vger.kernel.org>; Sat, 30 Jan 2021 22:16:35 -0800 (PST)
Received: by mail-pl1-x62e.google.com with SMTP id q2so8159528plk.4
        for <netdev@vger.kernel.org>; Sat, 30 Jan 2021 22:16:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:references:to:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-transfer-encoding:content-language;
        bh=DVzxFygV83bKjott3/gtqmzkbtzEwaJThTr7S/uX7KA=;
        b=U3a0E8gJDt1nlq6mJa0pZ97OClUFtcdYK4bmTgLC/OXqkfnCZmH22BXzU8aw9jJZRV
         JhZBMO86xtjuGEpOrw1n18x2E2IvDrHy4kDCHgHU9+Zs5BH4zNMMb1qANteJNtTzF1d/
         SpEbZ7yvbhOxcgaYaAijOw9Ak8+stiZItT0NlkdlqJITp0p2UQNkAx/mg8NOBKGiZlWA
         1HWCtsOcNX/uvb6ZG2o3oBBrIIsadkbpM61t1ybt2NPUNlIjfcUUboXGfGSGhA/H9OZ0
         rlwxOZK3rhfM9SgddFdY7rX52gE1V0gE5BlfDj1OFHPmRQQcW+uaUKys6W2oD8lPNXEA
         csYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:references:to:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=DVzxFygV83bKjott3/gtqmzkbtzEwaJThTr7S/uX7KA=;
        b=Uppxr68ybcsdVUhNNG/be8my+Sv+2bfgEYYIX3dadUNYyVPsVs3BnrBxPGO2CaQCXR
         viEZ9pnnqscnYD/61ZdM68wJde5TEz7uUY8HNgwTy+dTPXSBuIq+Ux/WxB+7/CoNDkIr
         0QpglgDvFmMuAyMQaPgRaZQQqkwuvAyU00Tox6hScLtOKm907LO8a3Dx+dkqYY54+1ZV
         vhgVyTRvxcn1jaSaJst0O8i0Llw/C6aq2eu5YkA+zoVdVMSCoS7H66PWxWupxNNkhk6A
         nQ62swPYHfL3H459gM7IcLBSDxrc/1qzJ4gSer8KpSOtMTgxSO/OZW6Bq1BXv/gszld/
         wXxQ==
X-Gm-Message-State: AOAM530FdTsld3nULfUgh9LaTWyqbY9Bj7NzZZwzYdI5Kidsjy7PSo4L
        vnziOY3HMCfsA29DxXh6i3GGv/uWJ1sNXw==
X-Google-Smtp-Source: ABdhPJzIWV7NbX0ausb6Sd14HXoeOm9YsQe/pxtAsbOiauabxF6d5hJtD5rP1+tRmFTfXlVREzcR9A==
X-Received: by 2002:a17:90a:9a83:: with SMTP id e3mr11732130pjp.210.1612073794625;
        Sat, 30 Jan 2021 22:16:34 -0800 (PST)
Received: from [192.168.2.7] (c-67-182-242-199.hsd1.ut.comcast.net. [67.182.242.199])
        by smtp.gmail.com with ESMTPSA id s11sm12366510pfu.69.2021.01.30.22.16.33
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 30 Jan 2021 22:16:33 -0800 (PST)
Subject: Re: [PATCH] Add documentation of ss filter to man page
References: <20210128081018.9394-1-astrothayne@gmail.com>
To:     netdev@vger.kernel.org
From:   Thayne McCombs <astrothayne@gmail.com>
Message-ID: <d50d811a-e6a2-a062-63af-15faf933d5e2@gmail.com>
Date:   Sat, 30 Jan 2021 23:16:32 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210128081018.9394-1-astrothayne@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Oh. I think I should have added "[PATCH iproute2-next] ss:" to my 
subject line.

Sorry, this was my first post to this list.

