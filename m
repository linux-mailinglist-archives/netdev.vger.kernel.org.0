Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FB8B281646
	for <lists+netdev@lfdr.de>; Fri,  2 Oct 2020 17:13:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388247AbgJBPNx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Oct 2020 11:13:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387990AbgJBPNx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Oct 2020 11:13:53 -0400
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4340C0613D0
        for <netdev@vger.kernel.org>; Fri,  2 Oct 2020 08:13:52 -0700 (PDT)
Received: by mail-wm1-x341.google.com with SMTP id j136so2128452wmj.2
        for <netdev@vger.kernel.org>; Fri, 02 Oct 2020 08:13:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=XCoSMtm8uK3alwTQ0gtx5gTHymtT/Ql9p6LoQ1R/800=;
        b=nv9CIGD0tPIKUSfSb6iiuIo5RJEy6udMlu0r0mNDAe8YdLnp28haJZAJpuZBGdnyNs
         y7PXkfnRspF0hv4HQgdsuZKoxQ6OnYflzpk6VIyh/rj8G1UMTvzgQ6zk/+76obwNawkt
         GrnzHLCQvN/F2AluBuQuBQMlTr3GHOgGSOia0tLZSpPZsmxtTQ2nlyPIK5DDk7kTgbHo
         9XTlClnIH9ZSnVaRGQ6+k6OvlM7aVcwAYD+1vjeL1kTxNVVz+zdUfnh8Px8WzWrOG1Sw
         y2nlrPqf5Ar54h5tJ4KSw/elJfsD7XLh+lek5tfA79yXnNyaJMVW2wY0+UmszYJpilO8
         CCCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=XCoSMtm8uK3alwTQ0gtx5gTHymtT/Ql9p6LoQ1R/800=;
        b=FuAfkC+BgdCUZDoVsdmbhzVWHdgC9eCYfiPThehjSI60mmQ3zaTb649rIaG/m9G1Ce
         X4kfdZrIkQiVOG39W3GqR5FxygIV1TXrsXDdAjh3a4534ns93JNvYK4FJoqZbRYk2VYq
         dKIAMhAcvgbbZH1luvQ7ioqHo0aTmJbs2efrw1PVbkJDKSMwXb2ISjDibVMxRNd4shaU
         o7eRH9vXgkc8Lk9ziBd7ccQ7tY9GI85uPTBUg1a1RzH4gpkW1WLqMD+Sto5IxGEaHym7
         OCJeViZE1bXKeDGCn6DTLq7Y2vmEBrEpuLGFBB+yeENIkSC/VxZs3pCNnERhNBT9xbDd
         JhaA==
X-Gm-Message-State: AOAM533dQCQ4ZAVC9drmPROwdppkbXwsl2Ipg8s5qXRPOCAg320qCApH
        N7xu6S2uRX9Cp2AOGYPNZen64A==
X-Google-Smtp-Source: ABdhPJzw3li7zEFTPQF+L2nzFjno5LMp/+4HXHh0JaLeoy7k/krCjHFUNy5oFql7h64xkcNUj/OiJA==
X-Received: by 2002:a7b:c387:: with SMTP id s7mr3415926wmj.171.1601651631598;
        Fri, 02 Oct 2020 08:13:51 -0700 (PDT)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id i9sm2059947wma.47.2020.10.02.08.13.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Oct 2020 08:13:51 -0700 (PDT)
Date:   Fri, 2 Oct 2020 17:13:49 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Moshe Shemesh <moshe@mellanox.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Jiri Pirko <jiri@nvidia.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 01/16] devlink: Change
 devlink_reload_supported() param type
Message-ID: <20201002151349.GA3159@nanopsycho.orion>
References: <1601560759-11030-1-git-send-email-moshe@mellanox.com>
 <1601560759-11030-2-git-send-email-moshe@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1601560759-11030-2-git-send-email-moshe@mellanox.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thu, Oct 01, 2020 at 03:59:04PM CEST, moshe@mellanox.com wrote:
>Change devlink_reload_supported() function to get devlink_ops pointer
>param instead of devlink pointer param.
>This change will be used in the next patch to check if devlink reload is
>supported before devlink instance is allocated.
>
>Signed-off-by: Moshe Shemesh <moshe@mellanox.com>

Reviewed-by: Jiri Pirko <jiri@nvidia.com>
