Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32560319058
	for <lists+netdev@lfdr.de>; Thu, 11 Feb 2021 17:50:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230523AbhBKQtx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Feb 2021 11:49:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232106AbhBKQrv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Feb 2021 11:47:51 -0500
Received: from mail-ot1-x32b.google.com (mail-ot1-x32b.google.com [IPv6:2607:f8b0:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DB10C061574;
        Thu, 11 Feb 2021 08:47:10 -0800 (PST)
Received: by mail-ot1-x32b.google.com with SMTP id k10so5742142otl.2;
        Thu, 11 Feb 2021 08:47:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=5/Yz6keCPLS3+tINrvnKT5VxELdJ2l8Db2X2Isfn/1Q=;
        b=lZvadAo7+OH+biPsE8/lUEhkgr4xk8GtCJ1hZYGBzAGWj26zIw4Z9PrqrNIpNTdkyt
         D1MB+PIvSAUGT8YxrzV0u3HP6+yXgknMqF68ZsZpBmcARHYGpzOudx6WsQZVcT1X9IOE
         MXFCmJQFRdbjbjt3c7QuIJTtcg0DkMuMP6ee7VA3NQm6RrdApkM1j7t9kjNZWaG7jT5u
         FUGTSAd3BZeGcGwAyTqOoBseXsIPUdhDx/QsfAlTTEmk3HVRj1l0w2RtAT37DW8YCvvF
         rKgRqm58M3+08857kmNb9glLKTEiKNh2DCtrl4i/+EpJtQFcJKcIhNgBBnPIG5N1zwAN
         cYYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=5/Yz6keCPLS3+tINrvnKT5VxELdJ2l8Db2X2Isfn/1Q=;
        b=IMe0bfph/5foJEWvUG/Ed71Oe21rzDm041836RC8MxuyMpgaXupCZPbMV/W8yv//WS
         DTjVzl5blS3lk/v8wTy1CYSsfsxxEB5B7hr1696eRwYb/HnEM2b81yRfjVue75gYW/wv
         Chaq9OfEqqI5qL/3h4T4fRP7FNPhkz0y0h+xKiIYiXaIwORHTYac2VNWS+okXQEgEJhw
         n5pGko4nwZvEcO8HBvgq5B4sJVYNhNdsDhznZ0zVHSf2wxF3OSSZOpYQeJy+B7eRlsaw
         y9FZroNMXrDuzOkndG60QUM/wgZhR/NTOjHmHpwA7QshSMx6tIWZwV12hj4FklyvSPaa
         F62A==
X-Gm-Message-State: AOAM530omLCX0DxUTYJgcVO0ktS1sCj/SQDZBZMtFc7+3JALjZlFEklZ
        PSumB6T5mbwjQCYT3UV7JXM=
X-Google-Smtp-Source: ABdhPJzRotnnrNC6QU7qn326urnFVU8zpwcumua1Yt2pEUT/zLESmYQeUfWbDZ5Z0Fpii9gT5XsZPg==
X-Received: by 2002:a05:6830:1c6c:: with SMTP id s12mr6421999otg.125.1613062029952;
        Thu, 11 Feb 2021 08:47:09 -0800 (PST)
Received: from Davids-MacBook-Pro.local ([8.48.134.33])
        by smtp.googlemail.com with ESMTPSA id o14sm1092564otl.68.2021.02.11.08.47.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 11 Feb 2021 08:47:09 -0800 (PST)
Subject: Re: [PATCH iproute2-next V4] devlink: add support for port params
 get/set
To:     Oleksandr Mazur <oleksandr.mazur@plvision.eu>,
        netdev@vger.kernel.org
Cc:     jiri@nvidia.com, davem@davemloft.net, linux-kernel@vger.kernel.org,
        kuba@kernel.org
References: <20210209103151.2696-1-oleksandr.mazur@plvision.eu>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <cb7d21da-1300-fb6b-7c64-4caaf5601b34@gmail.com>
Date:   Thu, 11 Feb 2021 09:47:07 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210209103151.2696-1-oleksandr.mazur@plvision.eu>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/9/21 3:31 AM, Oleksandr Mazur wrote:
> Add implementation for the port parameters
> getting/setting.
> Add bash completion for port param.
> Add man description for port param.
> 
> Signed-off-by: Oleksandr Mazur <oleksandr.mazur@plvision.eu>
> ---

applied to iproute2-next.

In the future, please add example commands - get/set/show, and the show
commands should have examples for normal and json.
