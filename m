Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74A3D4348D0
	for <lists+netdev@lfdr.de>; Wed, 20 Oct 2021 12:19:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229878AbhJTKVr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Oct 2021 06:21:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229639AbhJTKVp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Oct 2021 06:21:45 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC2FCC06161C
        for <netdev@vger.kernel.org>; Wed, 20 Oct 2021 03:19:31 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id q2-20020a17090a2e0200b001a0fd4efd49so3557186pjd.1
        for <netdev@vger.kernel.org>; Wed, 20 Oct 2021 03:19:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=i1gZ2O7Vihvk5IxmWV6VCkw5T9xJGnRMe+izg7VgwK0=;
        b=WHC2EpbrT0nGCHISViDRuUOIZOg4dkY0559ooJRqha1TErSMzv5XZTdEJjzZD/m4QQ
         4BsiI03VbR9h8Q0LqUaEsOQ3fuRruVKUvAyN3C4dA+S2oL1H7Ws4HSRkPsGSQUES+nVV
         pfnBjgSAjW9Dfdrqn6XUte2zjRGpB/jps0ulx4Oo2zRuUHF357dQOqNM4zaGsk5tNHYE
         t91UykFSDZcR5n0e2s+oFvmGgY9OJKhidQT16ajYq4Bm4N8hXyYA1Uo2F0+VDOuKEcVu
         3tghTkPFvt6rfdfYIUGPjXKhblVTe186Yr3w1uSemrhj3POCt7+iLJeSXT221jnDywGB
         HGMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=i1gZ2O7Vihvk5IxmWV6VCkw5T9xJGnRMe+izg7VgwK0=;
        b=DA/Aqs0/UiIKcDRf1XilQQI+LxNdfvCxhPJQ8jmlskiwboqbcspdnI+9JMu0TRdDzE
         A5qUnR2un/KF5iaMzy0HGFotYDilQdir/8NV0fya5f9YeeHt57HP3lcn2PA6GXu3MFII
         x24yg74M2Ar3Zn76Ve5W/v1pP3gCJ0Cp8MqPRZziZgjpqt6GRiSULEgdUbmILqsvuVhD
         Mjbg3x6OXbpTBOgqf8qW/wefA5joVSr9ij31AE+OhfrY3kgFLr5kGs1tLEm8EPV5QLyj
         gFIuGnb+uUdQ860PaB2/ZamEnfwwgndEOZ1OZv6yI6vgAvGlJkd9kyb9m2OejasUQ3pw
         PcNg==
X-Gm-Message-State: AOAM531pQIMhKWmlgu1Ocqj3ELQCbjdcWJYwJbN1LG7xnpLC4nvt72D+
        sGQK2GDu7Vv9HkhWkKz1tSYK4JJZsts=
X-Google-Smtp-Source: ABdhPJzA1g2F7Y+LAca1eff4AWDyapoURxFwwzu/DOTWvZA7RQ4ciJabCui4tYETWsJW/BGiyhMFVw==
X-Received: by 2002:a17:90b:1bc3:: with SMTP id oa3mr6257340pjb.75.1634725171340;
        Wed, 20 Oct 2021 03:19:31 -0700 (PDT)
Received: from Laptop-X1 ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id u3sm2053713pfl.155.2021.10.20.03.19.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Oct 2021 03:19:31 -0700 (PDT)
Date:   Wed, 20 Oct 2021 18:19:25 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     Nikolay Aleksandrov <nikolay@nvidia.com>
Cc:     netdev@vger.kernel.org, Nikolay Aleksandrov <razor@blackwall.org>,
        roopa@nvidia.com, bridge@lists.linux-foundation.org,
        davem@davemloft.net, kuba@kernel.org
Subject: Re: [PATCHv2 net] net: bridge: mcast: QRI must be less than QI
Message-ID: <YW/tLekS17ZF9/w1@Laptop-X1>
References: <20211020023604.695416-1-liuhangbin@gmail.com>
 <20211020024016.695678-1-liuhangbin@gmail.com>
 <c041a184-92cb-0ebd-25e9-13bfc6413fc9@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c041a184-92cb-0ebd-25e9-13bfc6413fc9@nvidia.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 20, 2021 at 12:49:17PM +0300, Nikolay Aleksandrov wrote:
> Nacked-by: Nikolay Aleksandrov <nikolay@nvidia.com>
> 
> I think we just discussed this a day ago? It is the same problem -
> while we all agree the values should follow the RFC, users have had
> the option to set any values forever (even non-RFC compliant ones).
> This change risks breaking user-space.

OK, I misunderstood your reply in last mail. I thought you only object to
disabling no meaning values(e.g. set timer to 0, which not is forbid by the
RFC). I don't know you also reject to follow a *MUST* rule defined in the RFC.
> 
> Users are free to follow the RFC or not, we can't force them at this
> point. This should've been done when the config option was added long
> time ago.

OK, I will stop working on this path.

Thanks
Hangbin
