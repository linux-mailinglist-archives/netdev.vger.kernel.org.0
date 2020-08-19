Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4EF12492F4
	for <lists+netdev@lfdr.de>; Wed, 19 Aug 2020 04:43:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727063AbgHSCnb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Aug 2020 22:43:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726982AbgHSCna (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Aug 2020 22:43:30 -0400
Received: from mail-oi1-x244.google.com (mail-oi1-x244.google.com [IPv6:2607:f8b0:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54059C061389
        for <netdev@vger.kernel.org>; Tue, 18 Aug 2020 19:43:29 -0700 (PDT)
Received: by mail-oi1-x244.google.com with SMTP id u63so19794434oie.5
        for <netdev@vger.kernel.org>; Tue, 18 Aug 2020 19:43:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=0V84eV3PsOfzNuhmGWZMkvchC2vPimAKhWK3tiGYf0o=;
        b=cFO+vLfp44H2vCA+DLx+JMMuGox7XfNDKVxKxQ5iitTyZCR/ahcQmGRQC0wfTexh9p
         ckyGXNeZT8jMl7eVBrvDYhUzVSV+nmdknU26nJd6s1vzy4amcdZoLSsItK5uELu8u5zr
         fVx9x0xtJZUYCbbcXS1MN+1B+26uM3ojwxnEv3UIIqL9jvQ/IqzaE4ao1xBQkMrjk/wP
         Gbk2/Lz7jwY166aNopiINpfQtjZ6F0YtvMoJBswuZygGxUWm95rGGF7rVgm66za6ON6Y
         YRqzQgUVFweU4xHCG1uv5TJTjZNTlO/w3KkCb0xx/xrJXS7If3f4X33DxCLI+g7IHwqb
         RPGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=0V84eV3PsOfzNuhmGWZMkvchC2vPimAKhWK3tiGYf0o=;
        b=JumGo718HH0GtwSoDNhg98lVtL1u4yTIKuvOrsP/SMqESWiqt/jpO7lE2BOETr4Ifd
         Csb2wKCK7cEACcWYOjgEsHf19+N7V7lCHWZbx8IeFeqaEq9Od1IJUardh3HMPeWXxIik
         rsFPvRIWcQh0SKvSNKylD7h8zE3ImHB9xDylX4qCPjWrebPpQdGALEATZmAfcCPEc4lj
         KqTLoWfniFSjNcA8VqfpEa2FjEjADwHQPayh2L/bd3HL2Up6RCXdf6WmYu5R7iOHU7Gm
         zqBi3lPObmKNRYMpW4MwNK10vnTYXdI5I4BGsbh+Iz0oGHSrZPq2eUqa9MXpHTOlwE6j
         SMyA==
X-Gm-Message-State: AOAM533MEc1SQgdlkJP6rPN4wpk6LihQm5vjZYvuXu1FhWRRQoOBIhE3
        +iAAiIdotYQ4hRUL7bk4Iu0=
X-Google-Smtp-Source: ABdhPJz8yWsln61cE4xBWZIqqJ57DOsqtCRT3ruJai6redskYEzFeVcltXfEWx+DIwuljPJ3yMG/4g==
X-Received: by 2002:aca:c5d6:: with SMTP id v205mr2035605oif.143.1597805008281;
        Tue, 18 Aug 2020 19:43:28 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([2601:282:803:7700:ed5e:5850:8cad:6cb])
        by smtp.googlemail.com with ESMTPSA id u20sm4524377ots.0.2020.08.18.19.43.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 18 Aug 2020 19:43:27 -0700 (PDT)
Subject: Re: [RFC PATCH net-next 0/6] devlink: Add device metric support
To:     Jakub Kicinski <kuba@kernel.org>, Ido Schimmel <idosch@idosch.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, jiri@nvidia.com,
        amcohen@nvidia.com, danieller@nvidia.com, mlxsw@nvidia.com,
        roopa@nvidia.com, andrew@lunn.ch, f.fainelli@gmail.com,
        vivien.didelot@gmail.com, saeedm@nvidia.com, tariqt@nvidia.com,
        ayal@nvidia.com, eranbe@nvidia.com, mkubecek@suse.cz,
        Ido Schimmel <idosch@nvidia.com>
References: <20200817125059.193242-1-idosch@idosch.org>
 <20200818172419.5b86801b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <58a0356d-3e15-f805-ae52-dc44f265661d@gmail.com>
Date:   Tue, 18 Aug 2020 20:43:11 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200818172419.5b86801b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/18/20 6:24 PM, Jakub Kicinski wrote:
> On Mon, 17 Aug 2020 15:50:53 +0300 Ido Schimmel wrote:
>> From: Ido Schimmel <idosch@nvidia.com>
>>
>> This patch set extends devlink to allow device drivers to expose device
>> metrics to user space in a standard and extensible fashion, as opposed
>> to the driver-specific debugfs approach.
> 
> I feel like all those loose hardware interfaces are a huge maintenance
> burden. I don't know what the solution is, but the status quo is not
> great.

I don't agree with the 'loose' characterization. Ido and team are
pushing what is arguably a modern version of `ethtool -S`, so it
provides a better API for retrieving data.

> 
> I spend way too much time patrolling ethtool -S outputs already.
> 

But that's the nature of detailed stats which are often essential to
ensuring the system is operating as expected or debugging some problem.
Commonality is certainly desired in names when relevant to be able to
build tooling around the stats. As an example, per-queue stats have been
essential to me for recent investigations. ethq has been really helpful
in crossing NIC vendors and viewing those stats as it handles the
per-vendor naming differences, but it requires changes to show anything
else - errors per queue, xdp stats, drops, etc. This part could be simpler.

As for this set, I believe the metrics exposed here are more unique to
switch ASICs. At least one company I know of has built a business model
around exposing detailed telemetry of switch ASICs, so clearly some find
them quite valuable.
