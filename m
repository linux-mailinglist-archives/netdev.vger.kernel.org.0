Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EABC7246CEF
	for <lists+netdev@lfdr.de>; Mon, 17 Aug 2020 18:37:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731153AbgHQQhH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Aug 2020 12:37:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388790AbgHQQgR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Aug 2020 12:36:17 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2651C061389
        for <netdev@vger.kernel.org>; Mon, 17 Aug 2020 09:36:14 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id f7so15642563wrw.1
        for <netdev@vger.kernel.org>; Mon, 17 Aug 2020 09:36:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=tMKZiqsnqbFn8irAos+7042bqmvB89r7nqqfmhiQHfo=;
        b=K78QVysR/ZXWdJzwnTE9+KxjBbE/Y/0ZpwohxOrT5y9/OftqWcr5xzJIlbwLekGgCD
         AzjyOmMsCnAhIHmANFO6PcZk+f7jw38DIFVqAdauXUn0no6OoCnzSGALl/llQxwVMyB9
         dmfjQa/P08oKzJr/KjIMmquNjKfIIJlYZfnDOh0XrhTENT4dpLcNJt8xOseOAFKRdWuy
         /Msww2d8SNJQ0uK56YuwOQRD/NnF+WNHPLbOmqWKGMGVfi9BUXxjeL98ly5tajpGMEQ4
         9/vi7KAW+rxQBqUxJh3LiN67WOZWgRIBEyiviGwh/1zjIEoaxeNLt28s3ieKrnvkmPOQ
         RmeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=tMKZiqsnqbFn8irAos+7042bqmvB89r7nqqfmhiQHfo=;
        b=UMz6jLJZ5ZjL7rOQKvm209WvDx5xMcnJXxEiLw8eTSyHULSyddlUgBEDIktnce95QZ
         RbYLdQBUJ6d5W/yPgYhrgSD/EwLShtds0ZGGI9Z5h+Q+cyeUE2YMlDIniHE+eLbDKswy
         nMg3cXrnwr4Hvo5Clk3Fn+00UkBDS1aCyopvLkGz14cC/1/gJXb+R/dFmC8eHOZSwfNT
         GIdWWSU0Vysyws9fYvjb7gP8X5T+EErWMQ6+dmDZThWDdV+VJ2sYVbpcFmtIB3IvxTto
         CIxXmyQ08WTDS3VPoY48eypBLV2yQkU8QRvd0aRBs3fChX5dEr34DwqkmSkofN+z5VCG
         P6CQ==
X-Gm-Message-State: AOAM533hY64xuWFwSQhTwj39N7KkxnTGAq+zVekeddfbrTnRjGkM4Utd
        Sk2NTXBLajTfQk3YiEXB2jTyKQ==
X-Google-Smtp-Source: ABdhPJwDBmTguVh7tFQOOiwAudU2uFsHEUGITgyfcQtT/I3p0LfCTVZrNU6xs66eYZbi2RKBqrEmdg==
X-Received: by 2002:adf:a1c6:: with SMTP id v6mr16170552wrv.197.1597682173655;
        Mon, 17 Aug 2020 09:36:13 -0700 (PDT)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id f124sm30083480wmf.7.2020.08.17.09.36.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Aug 2020 09:36:13 -0700 (PDT)
Date:   Mon, 17 Aug 2020 18:36:12 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Moshe Shemesh <moshe@mellanox.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jiri Pirko <jiri@mellanox.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next RFC v2 01/13] devlink: Add reload action option
 to devlink reload command
Message-ID: <20200817163612.GA2627@nanopsycho>
References: <1597657072-3130-1-git-send-email-moshe@mellanox.com>
 <1597657072-3130-2-git-send-email-moshe@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1597657072-3130-2-git-send-email-moshe@mellanox.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Mon, Aug 17, 2020 at 11:37:40AM CEST, moshe@mellanox.com wrote:
>Add devlink reload action to allow the user to request a specific reload
>action. The action parameter is optional, if not specified then devlink
>driver re-init action is used (backward compatible).
>Note that when required to do firmware activation some drivers may need
>to reload the driver. On the other hand some drivers may need to reset

Sounds reasonable. I think it would be good to indicate that though. Not
sure how...


>the firmware to reinitialize the driver entities.
>Reload actions supported are:
>driver_reinit: driver entities re-initialization, applying devlink-param
>               and devlink-resource values.
>fw_activate: firmware activate.
>fw_live_patch: firmware live patching.
>
