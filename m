Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9BCBCA0002
	for <lists+netdev@lfdr.de>; Wed, 28 Aug 2019 12:37:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726413AbfH1KhW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Aug 2019 06:37:22 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:44007 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726232AbfH1KhW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Aug 2019 06:37:22 -0400
Received: by mail-wr1-f68.google.com with SMTP id y8so1944683wrn.10
        for <netdev@vger.kernel.org>; Wed, 28 Aug 2019 03:37:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=WWoEGyHGKGRIppqQH/sp9veSY96MV4Qv+/K77i7UY8M=;
        b=LEDphWDB5zOuv+UNbfaTK5EPK1oD/3lOxZV8HXTBcYKwHYwEg8ctQHUzpjDBbfv3ba
         rRm/8d9/VuXouq+aB1mf7TP828hVOxEveZ0EBN/hlrpX4ffp3tvtIWgBbMUfjBvXNzwC
         uAVaUXSnhuVR4PuRS1xBztR/A/bG2AzrRPFXmaLEyZUvDivYOJta2l07ZavMhyczc9+J
         mB9M12EAD7YjRO790Vxe61aDIHoUQ3BcqG+37lnpoQyXjavUVoNPw0k/jMUY2jgXKIiP
         9ZxHVKpy0VE1P6XpiZmDWFgM+Vr7ATWFddIHmGOfKvmkHA5GYAVo6rblUdghO9QmXis+
         yi2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=WWoEGyHGKGRIppqQH/sp9veSY96MV4Qv+/K77i7UY8M=;
        b=Tnbq2tRJEzuKPG9myZo7WluxMiOLUHDQGKwMTq+fw1IJbZjYWEZMgja9QAG69Z7cR4
         oR2gz8+XuBJqQq0K8LOIhMfqdhqd2zHhlX5dA0ceF/hHu+o+0DGHmGbVWHoT64qQ0Fgj
         PQkmyVI6S9UITi1wzoDhcMpsDZmhrF5qBxX8uWHxD67LuLYR1EJayVqPi6vrFYegO83Z
         qoVyGCvYKw+tVxBLA+8cqWYN/jIgvcSIgYWMNb2NVlmh8633L3zXH4DBVxdunkUKY4Kd
         M1BaIVM1EKgJADkaxY68Egq1oY5BQtuag8VKslOvuZUajMVqy+DMS5IOn6WImteWY4ZA
         QUpA==
X-Gm-Message-State: APjAAAXGFYP+D+cnbvnrOSgvOeMterZbRW5o9vKJd3RsVzZbJPO4euxl
        FPN1RDt41DhLuYfDFJa6wonFlQ==
X-Google-Smtp-Source: APXvYqywTSaYzEoseWkTW8BYQIu1Qaq42/S27vmZqub+1j0fk3lXro3LMMmHO6K05UaZxXK7RL4+Qw==
X-Received: by 2002:adf:fc81:: with SMTP id g1mr3772276wrr.78.1566988639456;
        Wed, 28 Aug 2019 03:37:19 -0700 (PDT)
Received: from localhost (ip-78-45-163-186.net.upcbroadband.cz. [78.45.163.186])
        by smtp.gmail.com with ESMTPSA id f17sm2717700wmj.27.2019.08.28.03.37.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Aug 2019 03:37:18 -0700 (PDT)
Date:   Wed, 28 Aug 2019 12:37:18 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     David Ahern <dsahern@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH net] netdevsim: Restore per-network namespace accounting
 for fib entries
Message-ID: <20190828103718.GF2312@nanopsycho>
References: <20190806191517.8713-1-dsahern@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190806191517.8713-1-dsahern@kernel.org>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tue, Aug 06, 2019 at 09:15:17PM CEST, dsahern@kernel.org wrote:
>From: David Ahern <dsahern@gmail.com>
>
>Prior to the commit in the fixes tag, the resource controller in netdevsim
>tracked fib entries and rules per network namespace. Restore that behavior.

David, please help me understand. If the counters are per-device, not
per-netns, they are both the same. If we have device (devlink instance)
is in a netns and take only things happening in this netns into account,
it should count exactly the same amount of fib entries, doesn't it?

I re-thinked the devlink netns patchset and currently I'm going in
slightly different direction. I'm having netns as an attribute of
devlink reload. So all the port netdevices and everything gets
re-instantiated into new netns. Works fine with mlxsw. There we also
re-register the fib notifier.

I think that this can work for your usecase in netdevsim too:
1) devlink instance is registering a fib notifier to track all fib
   entries in a namespace it belongs to. The counters are per-device -
   counting fib entries in a namespace the device is in.
2) another devlink instance can do the same tracking in the same
   namespace. No problem, it's a separate counter, but the numbers are
   the same. One can set different limits to different devlink
   instances, but you can have only one. That is the bahaviour you have
   now.
3) on devlink reload, netdevsim re-instantiates ports and re-registers
   fib notifier
4) on devlink reload with netns change, all should be fine as the
   re-registered fib nofitier replays the entries. The ports are
   re-instatiated in new netns.

This way, we would get consistent behaviour between netdevsim and real
devices (mlxsw), correct devlink-netns implementation (you also
suggested to move ports to the namespace). Everyone should be happy.

What do you think?
