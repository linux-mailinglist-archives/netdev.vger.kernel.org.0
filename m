Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6EE7F4143F6
	for <lists+netdev@lfdr.de>; Wed, 22 Sep 2021 10:44:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233992AbhIVIp1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Sep 2021 04:45:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233996AbhIVIpZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Sep 2021 04:45:25 -0400
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BCDFC061757
        for <netdev@vger.kernel.org>; Wed, 22 Sep 2021 01:43:55 -0700 (PDT)
Received: by mail-wr1-x433.google.com with SMTP id t8so4571360wri.1
        for <netdev@vger.kernel.org>; Wed, 22 Sep 2021 01:43:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=IVHH/asQRF7YsaKGXEpUUspPb4yTWhFk0EthuY4rbcQ=;
        b=mYoOMhWMZVJOVa+RcLsJzZSrZckeFQ33tF4zjKQQB3pjaI8CQFvxeP/ztlwnO9FAnK
         zeC7defB8mAHNf1eI52wV3E0AK0t6KK9JvTn54ancNhMYHSr5ltugMlJqe2pVoCYFY26
         xovkbxkaHEt2aJ0Es1jOKEN5Yg90oOzktfcrqmGlUVEigyTZh4hgYXLXp9WQkTexV9aX
         xRJHJODLZD3PHbTxIOeJi+/NAHetV8x3lPgYLsNrN0tcF0zID/kZAhPfMlBSButM1wn+
         kCqg1ZoiSQ1TiPEpn92CEyY2f4Jv/qAxJmVNPfu1gjdScXS/RO5PppXlDLLCuX2xSn23
         +I9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=IVHH/asQRF7YsaKGXEpUUspPb4yTWhFk0EthuY4rbcQ=;
        b=sXhm4d590rl/9kw5G/QGowgeno7LwTSXchTkrVdY8JXIZpW76p8rT1baKJD2WxybT/
         +VSv5YDC5KjMApi01Vh5ckeA7Gw1MxccjOjV+Aw25x360VsItHp1mEwQj4cLgThaP5RW
         3cVmPwWbNMfaFYUCI8/szCwt+LxmzHH1JPb8FDbPushhjo2Ehy6A59Y8GfEIwzf7TMuQ
         OKexKAwrx1HbX6zeIvRmIQY0zdZDqBCc8IolyaASLBlJ7TcVTUdtbo5E02UrbXVdYBeU
         LsHRA2C4/MUh2ZdHai86Lks+zH55MhQJ3YmvyuXAMo9YsEyWCRaPsb+4YznGK22NWNQK
         fdMw==
X-Gm-Message-State: AOAM531qt+kJSh42wGHqvaskDJsAAz4NaSLSLIjPtqT+i0OUKKwm36r/
        1tjPcLcL39sg5yxELaGoQDT/JA==
X-Google-Smtp-Source: ABdhPJw4dLPhYwXubuHwRW7dR76WjAgT4cpTgvnZMkRjzxUD2osq8KvbsbGGY5YJJPN1o5D3T2RTEA==
X-Received: by 2002:a5d:58cd:: with SMTP id o13mr40436981wrf.416.1632300233554;
        Wed, 22 Sep 2021 01:43:53 -0700 (PDT)
Received: from localhost ([85.163.43.78])
        by smtp.gmail.com with ESMTPSA id s2sm1440740wrn.77.2021.09.22.01.43.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Sep 2021 01:43:53 -0700 (PDT)
Date:   Wed, 22 Sep 2021 10:43:52 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        jiri@nvidia.com, mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: Re: [PATCH net-next 1/2] mlxsw: spectrum_router: Add trap adjacency
 entry upon first nexthop group
Message-ID: <YUrsyHrL961YqPZ8@nanopsycho>
References: <20210922073642.796559-1-idosch@idosch.org>
 <20210922073642.796559-2-idosch@idosch.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210922073642.796559-2-idosch@idosch.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Wed, Sep 22, 2021 at 09:36:41AM CEST, idosch@idosch.org wrote:
>From: Ido Schimmel <idosch@nvidia.com>
>
>In commit 0c3cbbf96def ("mlxsw: Add specific trap for packets routed via
>invalid nexthops"), mlxsw started allocating a new adjacency entry
>during driver initialization, to trap packets routed via invalid
>nexthops.
>
>This behavior was later altered in commit 983db6198f0d ("mlxsw:
>spectrum_router: Allocate discard adjacency entry when needed") to only
>allocate the entry upon the first route that requires it. The motivation
>for the change is explained in the commit message.
>
>The problem with the current behavior is that the entry shows up as a
>"leak" in a new BPF resource monitoring tool [1]. This is caused by the
>asymmetry of the allocation/free scheme. While the entry is allocated
>upon the first route that requires it, it is only freed during
>de-initialization of the driver.
>
>Instead, track the number of active nexthop groups and allocate the
>adjacency entry upon the creation of the first group. Free it when the
>number of active groups reaches zero.
>
>The next patch will convert mlxsw to start using the new entry and
>remove the old one.
>
>[1] https://github.com/Mellanox/mlxsw/tree/master/Debugging/libbpf-tools/resmon
>
>Signed-off-by: Ido Schimmel <idosch@nvidia.com>

Reviewed-by: Jiri Pirko <jiri@nvidia.com>
