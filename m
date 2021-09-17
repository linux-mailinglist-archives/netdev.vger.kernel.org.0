Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2236740F59C
	for <lists+netdev@lfdr.de>; Fri, 17 Sep 2021 12:14:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242075AbhIQKOo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Sep 2021 06:14:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232222AbhIQKOg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Sep 2021 06:14:36 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B2EBC061574
        for <netdev@vger.kernel.org>; Fri, 17 Sep 2021 03:13:14 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id x6so14241578wrv.13
        for <netdev@vger.kernel.org>; Fri, 17 Sep 2021 03:13:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=tgZKfQsD/mVPjl2rf6f+j7ho+tNfBCjFkmtHraxHK1U=;
        b=arMnvkIKDq5ZnCqYTwi8g5dCSSdEqSIqR0VOZrdBW/mJfI1OhskpehuHXA7gWhKpNG
         N8YVwh9tqv32gPcHtawGEs4wmckqJk3rL1GCkhIWBGJEer3etl/RzNTlCSuZaIjoytlH
         ZqD7zSfFm4G3yPJwy1rYs+xQkJ2aF8I+gqkLtYXKM7RaTOkbBqse60z5G5USR3/fcL5l
         N2AT/C6xxE0GmjBCjDARgblhmxhMfSlRzzPaFQZu8vLCWCJDaoC12xQ1P9/nquKfFAOz
         pLjwUTBzyk2oONKhV5C7h+hfPaRlZsASaI+KxASSBdR8xdgt0JDaiu5PGcoKfBxICXOf
         axhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=tgZKfQsD/mVPjl2rf6f+j7ho+tNfBCjFkmtHraxHK1U=;
        b=EQuEiZhjzPvy8VdJuT3e+zTZ0/C1mgtUU5lCrDBPlATgBFOcpf8yQBzaxrr3k2+smW
         hmONuEZG7hiaHfdwnb5gPa/qKIUKKzPFkmvaD/QwAw73mbiXqgVG/FXkG7abXjnAmyZf
         MQavmAJMiq6JKoYeG4Ass9qkQXb7/kLYoxEacwXIa5Z81vaIUpoPBP7REuPClHyk6PDb
         tVnu32g61sqsXoiWkbMjarBXfmRmylESOnEp0p24lgKRrIY8vHIAUqTQB5tuy1cH7PHL
         L/An2sgkZ1VBOpx0pfwO+Cph+Gn1yL5EWa9eUqSztXWHYsSQ2DZVDSpu26Upxt6WeUJ5
         ipbg==
X-Gm-Message-State: AOAM5336Duy2KSGv/iyM94qhGG/yV49Ijlbr6JJTFH1p2iuukwAD9CoO
        ezdBYup+YTWA4ZjmjPOcbSMSB4W3TPFnz2SbJJs=
X-Google-Smtp-Source: ABdhPJzd6APFEp/JCjkPRGr/NSbX9x2Q/ZeZOsbk5SYqdyyd5iDdNl2GPHQLTi+2U3RS/1r+ipqG+g==
X-Received: by 2002:a5d:4a08:: with SMTP id m8mr10905382wrq.263.1631873592828;
        Fri, 17 Sep 2021 03:13:12 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id q11sm6160112wrn.65.2021.09.17.03.13.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Sep 2021 03:13:12 -0700 (PDT)
Date:   Fri, 17 Sep 2021 12:13:11 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Leon Romanovsky <leonro@nvidia.com>,
        Jiri Pirko <jiri@nvidia.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next] devlink: Delete not-used devlink APIs
Message-ID: <YURqNxDNjk9J41p8@nanopsycho>
References: <a45674a8cb1c1e0133811d95756357b787673e52.1631788678.git.leonro@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a45674a8cb1c1e0133811d95756357b787673e52.1631788678.git.leonro@nvidia.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thu, Sep 16, 2021 at 12:38:33PM CEST, leon@kernel.org wrote:
>From: Leon Romanovsky <leonro@nvidia.com>
>
>Devlink core exported generously the functions calls that were used
>by netdevsim tests or not used at all.
>
>Delete such APIs with one exception - devlink_alloc_ns(). That function
>should be spared from deleting because it is a special form of devlink_alloc()
>needed for the netdevsim.
>
>Signed-off-by: Leon Romanovsky <leonro@nvidia.com>

Reviewed-by: Jiri Pirko <jiri@nvidia.com>
