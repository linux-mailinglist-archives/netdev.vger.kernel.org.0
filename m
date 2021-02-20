Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19DA13205F4
	for <lists+netdev@lfdr.de>; Sat, 20 Feb 2021 16:37:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229847AbhBTPh2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 20 Feb 2021 10:37:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229789AbhBTPhY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 20 Feb 2021 10:37:24 -0500
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9300DC061574;
        Sat, 20 Feb 2021 07:36:43 -0800 (PST)
Received: by mail-ed1-x529.google.com with SMTP id i14so15761886eds.8;
        Sat, 20 Feb 2021 07:36:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=wATcNsGQ/oV+qooew2j8xDn4vI42JsAWo32QGZmbb+A=;
        b=AQKgtrORd7lVQvhYFCJGbh54yA4gHgnvGqhfD8teU9m9JkLBm00/WfHj+n2Q6Rqf1o
         y81V0R1sgDacJle7587rarWwNrTlCJEUqambWUUSU7PeqB2wavdcZKq8LM5xchzi/k6w
         XGkdrj7e+3xPxqcdTYtqHxyJA/N+189HCp0ZMYjDr8ptk4VCHw51UF2QWVEPbbQl9D7g
         uWfvnWrUyivssb30xF68qNsF4PgejkxLNEjUEs/LuKQXq/Ii3cQ/aHNLrojqgok5L9hc
         S7zb3q3+DrwycU1eaaGMk2YA5TwlNCfv2kXjKnEkKvb10Cf3NC7d8SuUrF5Ko6rgBdm9
         VQDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=wATcNsGQ/oV+qooew2j8xDn4vI42JsAWo32QGZmbb+A=;
        b=ue+jO1Jlz1VRYOAT+C4cVgbXDHGshryDy23XTWaUauo/DE+mVd7gGs6JfHrgCEyqKR
         G/h1GlLrX3pCwO+DOEbSLumQHU2hZWQLAxtaEPHxJDVs4uub0+dFNTV8GMnrq4EnsXUy
         1qsF9iz70FRvlWyyU6IraVI27kGVIFwpjLGJ9SiLvLHUtYIooDP86lxv2WfqXcJBL4t2
         5GVa7sA2tFGi57CASYjL758X9H1Tg3hQaQhARJFEG/vEMMWdFnn4+4oHsemv7ZKguPEP
         sOszSF5yS31GaGMCfvI5H2SkTlt1apqjfxjhIY1bk8U8Gig1lrcz+uxivDb8Gwe8J9a6
         yvhg==
X-Gm-Message-State: AOAM533jc3ucXm6H/BjCYt7mYYMAmDDAsmgUSCuN+5OAyWN0gUDWvVyR
        pEFC4bX/A4m5SuzYwoMYhoM=
X-Google-Smtp-Source: ABdhPJzMRQJuL4I/MR+1TXRJxgbhFwcSAU6UjxvcxOz/JpyQtqYhLWqM3JhNDrsODD5KLTCWouhnTA==
X-Received: by 2002:aa7:d9c4:: with SMTP id v4mr5221087eds.15.1613835402333;
        Sat, 20 Feb 2021 07:36:42 -0800 (PST)
Received: from skbuf ([188.25.217.13])
        by smtp.gmail.com with ESMTPSA id f4sm3499779edt.53.2021.02.20.07.36.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 20 Feb 2021 07:36:41 -0800 (PST)
Date:   Sat, 20 Feb 2021 17:36:40 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     netdev@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        George McCollister <george.mccollister@gmail.com>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next] net: dsa: Fix dependencies with HSR
Message-ID: <20210220153640.gj4fwpnzjhursumb@skbuf>
References: <20210220051222.15672-1-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210220051222.15672-1-f.fainelli@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 19, 2021 at 09:12:21PM -0800, Florian Fainelli wrote:
> The core DSA framework uses hsr_is_master() which would not resolve to a
> valid symbol if HSR is built-into the kernel and DSA is a module.
> 
> Fixes: 18596f504a3e ("net: dsa: add support for offloading HSR")
> Reported-by: kernel test robot <lkp@intel.com>
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
> ---

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
Tested-by: Vladimir Oltean <olteanv@gmail.com>
