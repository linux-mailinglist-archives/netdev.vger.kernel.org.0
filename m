Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7302D214660
	for <lists+netdev@lfdr.de>; Sat,  4 Jul 2020 16:17:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726752AbgGDOQq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Jul 2020 10:16:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726488AbgGDOQq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Jul 2020 10:16:46 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5DCBC061794
        for <netdev@vger.kernel.org>; Sat,  4 Jul 2020 07:16:45 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id o2so36986768wmh.2
        for <netdev@vger.kernel.org>; Sat, 04 Jul 2020 07:16:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=RyP58M97fR4d4gYrtVZFFIlbkVDeOHjRK6AV21s2HP0=;
        b=x8YsllirNzVCoMItskHCIy73oxoF9kpRfUgzpjsetHVOIQvNPXuELeOrV2QnKMfI3W
         YBOTYlBknhAYTfzFZol9WcxQiB3vDoDoHxUTEF5/WNM0LxBIfpRwQHNuoI+rvBqp6CkK
         Gh/kWuZHcJvzAkQdqRb+o3jtUzzybklNOmNRtRw+Xb7jsiIbqAWm1AY059kmakeAcrAG
         BpBDFbRbrGv9pTsMMoKk184xqImB/XwFhk2LpjEZB/t9z6VaDIGjX8b7MHJ2wukmsIhm
         jIHC/PjTq0yPE2GTLluX8qSYutUbKYm76hwfmoXEnac5O89E5eT0Io0Gt6QlMocWpQC3
         841w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=RyP58M97fR4d4gYrtVZFFIlbkVDeOHjRK6AV21s2HP0=;
        b=CY9UnKZJpPmbzOZEdQlybnvRxQl73aIReOHCGbe52PZTMfrJ+hkjGO7FALjamupoAC
         jKT4JW64BRLQw72f8rIJMj8WHR4ysze4Jg/Ddhr16/eaGDS7zlhZxAwGLPActmClboqM
         5uLsxrV1Tsv5/Uo/tZVR4uu4FooBtMBtm3ppoyNq+s6eKFX/2d3lr19IMmPP5bDtFc34
         2qH2cym2s6vKen/nQrUoTTe9duvrn3vOUfTWa4kpS2g1DkTPxuEsZBark6PBYm7Llcbm
         iTYss23KMDFAqHbHE8soGO/IRs7ZeB7//SbKv7v9hfH34zxMKFHjBFWUUKDUXgnQrJK5
         YwmQ==
X-Gm-Message-State: AOAM531qWTYhXLE/ZDFAzG6HJ3B+/wVp1MNBBWR3EMiwuiRe+HDOxxAu
        2FCBf3r5H68TvjjGk9/IqUEQ5Q==
X-Google-Smtp-Source: ABdhPJwhiI7UaUGYC7tHurzcdHr+gcKvPCgqPpG6hqhiIlSdKkbNIJziDYhmrizCK6wvyn/lY3G5RA==
X-Received: by 2002:a05:600c:2209:: with SMTP id z9mr40143484wml.178.1593872204404;
        Sat, 04 Jul 2020 07:16:44 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id g3sm7522235wrb.59.2020.07.04.07.16.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 04 Jul 2020 07:16:43 -0700 (PDT)
Date:   Sat, 4 Jul 2020 16:16:42 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Moshe Shemesh <moshe@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jiri Pirko <jiri@mellanox.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v2 0/7] Add devlink-health support for devlink
 ports
Message-ID: <20200704141642.GA4826@nanopsycho.orion>
References: <1593746858-6548-1-git-send-email-moshe@mellanox.com>
 <20200703164439.5872f809@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200703164439.5872f809@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sat, Jul 04, 2020 at 01:44:39AM CEST, kuba@kernel.org wrote:
>On Fri,  3 Jul 2020 06:27:31 +0300 Moshe Shemesh wrote:
>> Implement support for devlink health reporters on per-port basis. First
>> part in the series prepares common functions parts for health reporter
>> implementation. Second introduces required API to devlink-health and
>> mlx5e ones demonstrate its usage and effectively implement the feature
>> for mlx5 driver.
>> The per-port reporter functionality is achieved by adding a list of
>> devlink_health_reporters to devlink_port struct in a manner similar to
>> existing device infrastructure. This is the only major difference and
>> it makes possible to fully reuse device reporters operations.
>> The effect will be seen in conjunction with iproute2 additions and
>> will affect all devlink health commands. User can distinguish between
>> device and port reporters by looking at a devlink handle. Port reporters
>> have a port index at the end of the address and such addresses can be
>> provided as a parameter in every place where devlink-health accepted it.
>> These can be obtained from devlink port show command.
>> For example:
>> $ devlink health show
>> pci/0000:00:0a.0:
>>   reporter fw
>>     state healthy error 0 recover 0 auto_dump true
>> pci/0000:00:0a.0/1:
>>   reporter tx
>>     state healthy error 0 recover 0 grace_period 500 auto_recover true auto_dump true
>> $ devlink health set pci/0000:00:0a.0/1 reporter tx grace_period 1000 \
>> auto_recover false auto_dump false
>> $ devlink health show pci/0000:00:0a.0/1 reporter tx
>> pci/0000:00:0a.0/1:
>>   reporter tx
>>     state healthy error 0 recover 0 grace_period 1000 auto_recover flase auto_dump false
>
>What's the motivation, though?
>
>This patch series achieves nothing that couldn't be previously achieved.

Well, not really. If you have 2 ports, you have 2 set's of tx/rx health
reporters. Cannot achieve that w/o per-port health reporters.


>
>Is there no concern of uAPI breakage with moving the existing health
>reporters in patch 7?

No. This is bug by design that we are fixing now. No other way around :/
This is mlx5 only.
