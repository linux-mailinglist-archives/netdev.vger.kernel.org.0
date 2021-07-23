Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E784A3D3176
	for <lists+netdev@lfdr.de>; Fri, 23 Jul 2021 03:57:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233220AbhGWBQa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Jul 2021 21:16:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233192AbhGWBQ3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Jul 2021 21:16:29 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2D5AC061575;
        Thu, 22 Jul 2021 18:57:02 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id gv20-20020a17090b11d4b0290173b9578f1cso5011098pjb.0;
        Thu, 22 Jul 2021 18:57:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=SaBBsKSooT2THR7y3tZObTkjeHzlpmexL9S+wtcTGhQ=;
        b=XPQ4FL8MYHQ3dClLMXwF2ZgyfNQIqAPq7pvGf6q8iuRzTJl0C+Tp0ySafmQ4kqFjUM
         lKFTAkQqtVBaXhe88UA9Lj8lHIC6tS1QVvxlXZaxQvhOlXHYw6Ylg+DeuDS5drJJLzUu
         ev/hf3dCb8y3JTNTeX4fS8d1Dyy64Uyy2IAwWQdhv7ZH0jvyMwv757JSGb9d4ORais9v
         ecICqev5i4FsIdHYk34PuR0lIYW75BYbeklBfXpVvnAzVJC0FbXX5ICTQXHNSi2fNji+
         BTDJoGWK0wKkCwFBy9yvqtRtPiiKNYs4Iz5gDuTeI63N2kyiJuvtx9bFh4MPpQQ4FugM
         VWWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=SaBBsKSooT2THR7y3tZObTkjeHzlpmexL9S+wtcTGhQ=;
        b=fg/TEHQv45sQpYEusRNePC/NF52JKRMVpjTDPh+r+PRnUjc5g0epSFdVAd9oO+FDBn
         9MkXQrdvCONotNgYcHvc+sOrGhPgyzkZXxbvjIBnDYYSFZVcqIXnqe7B1ai1yZTkkQ5K
         kLLINplKgmWXoYx/hQZkZeqI8qa7+EiNqq1KF5UD7SGbBicLtN8swNkZJWD9YUMRVXla
         KCaqnTp5chkjQSFUPlMuGbTJBuP8P3euoeOAgIincQX0Wi9DpJVVpLKwtyfzjrX/r1ja
         XfQvbNBJ0J4tblUrR7OztnE7qpRORSbE5LDno2zZSbn/myliR8u4Nms9G5aBjFOC7uAH
         n5xw==
X-Gm-Message-State: AOAM533/0cBl2WJ/cJ/6c17Qoy1eIGBpA5oAvZPpbk/3FLKAbLaEq/h2
        +XBAj+5yffR7LCMH2h50yhMRYwQ/hNo=
X-Google-Smtp-Source: ABdhPJx54k3pFrN07l3RGpnf1QxzOBbyrmz/sPOSp6sjFYxfBkgaV+IzsRqg5X+Vhf8a1nGLWvYUhQ==
X-Received: by 2002:a17:90a:aa14:: with SMTP id k20mr11817758pjq.88.1627005421983;
        Thu, 22 Jul 2021 18:57:01 -0700 (PDT)
Received: from [192.168.1.121] (99-44-17-11.lightspeed.irvnca.sbcglobal.net. [99.44.17.11])
        by smtp.gmail.com with ESMTPSA id bv22sm23799703pjb.21.2021.07.22.18.57.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 22 Jul 2021 18:57:01 -0700 (PDT)
Subject: Re: [PATCH net backport to 4.4,4.9] net: bcmgenet: ensure
 EXT_ENERGY_DET_MASK is clear
To:     Doug Berger <opendmb@gmail.com>, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        bcm-kernel-feedback-list@broadcom.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20210723001552.3274565-1-opendmb@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <d58ab19d-b80a-b0db-668a-6c467bd6e0ea@gmail.com>
Date:   Thu, 22 Jul 2021 18:56:59 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210723001552.3274565-1-opendmb@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/22/2021 5:15 PM, Doug Berger wrote:
> [ Upstream commit 5a3c680aa2c12c90c44af383fe6882a39875ab81 ]
> 
> Setting the EXT_ENERGY_DET_MASK bit allows the port energy detection
> logic of the internal PHY to prevent the system from sleeping. Some
> internal PHYs will report that energy is detected when the network
> interface is closed which can prevent the system from going to sleep
> if WoL is enabled when the interface is brought down.
> 
> Since the driver does not support waking the system on this logic,
> this commit clears the bit whenever the internal PHY is powered up
> and the other logic for manipulating the bit is removed since it
> serves no useful function.
> 
> Fixes: 1c1008c793fa ("net: bcmgenet: add main driver file")
> Signed-off-by: Doug Berger <opendmb@gmail.com>

Acked-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
