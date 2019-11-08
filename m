Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2212FF5AD5
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 23:22:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728633AbfKHWWC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Nov 2019 17:22:02 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:40069 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726095AbfKHWWB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Nov 2019 17:22:01 -0500
Received: by mail-wr1-f68.google.com with SMTP id i10so8702380wrs.7
        for <netdev@vger.kernel.org>; Fri, 08 Nov 2019 14:22:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=8VW7ZVBK+YAO0o+au+kCkhW3vuMonEY9Pz0PV59kQ9M=;
        b=EPFj5K7m3kgY+SL+t0JFkLTLgYQAeulxLqEIg5eRb5T7qX3qAa80qeXWdEUxAm7zhm
         vZBts0GQaUwrvGYhUawgUTrfucafvvg8PlbdZHgWg2TveRPtaNHmi2T00SkwGull10dC
         Ll7TQ465703PWueYt66SBVDUyol/SXrYCerzK6hkbzMSBy3WfNt6OAuCkEzimiN8GhyM
         OhXhLZUdEdeO4f/7dCgrVjMIt0RIfSSvZ4iW6O7sk+gGyDoFFKJT2yCJxgeZX/tHe8qw
         IfcufsTbuMgH8jSq5AYQ3NY9eGR56eoC4L+61Ewv49qcRXqymqAkNXgHwZxjpxy87KSj
         9gHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=8VW7ZVBK+YAO0o+au+kCkhW3vuMonEY9Pz0PV59kQ9M=;
        b=A0qfpMLihV0Wt2863l/xoLgj/Cr3/OZb3xkSUItXKvADmHdhc7QBWFRRm3+rs++uFM
         saHX0mUPAEzl56ZuFTYG9e8ZADvSMyQBVlGWELCvLYD3s7ULCzUTz2e70flNpxn4cdXD
         f9KTQc06ATpiRh1Ss1rczI5j/oE+fysF1ykEl3J9HpHXSdInEWd2Ya3HyYhudq+XUNtj
         LjavmhdIhROtzwosHPORaGp8BhOh06cr6xFE5lV/rVIjMN+rGQDH8y7sTWI+wYUVKy6c
         a3+JnfrxzAWOo2ZxilPHacnWzIylsRVxIdWdW7as484mKutcprF5HIobbv4Fq1pOv4es
         kTSw==
X-Gm-Message-State: APjAAAXO8d3SKLXvoDDQpIoWTuWULaz0iLsXP8BA9ySUqVEAU5hPJS24
        vOhlRVfSVaqq5aBYKRUFqndIbQ==
X-Google-Smtp-Source: APXvYqwLJ+xHNTc7EgKLeKLvowLL4K8rqbIV8juqoxylgCJWLK/zh3ujQdys2rlCFM6QL95KPZWsVw==
X-Received: by 2002:adf:ab4c:: with SMTP id r12mr10157594wrc.3.1573251720204;
        Fri, 08 Nov 2019 14:22:00 -0800 (PST)
Received: from localhost (ip-94-113-220-175.net.upcbroadband.cz. [94.113.220.175])
        by smtp.gmail.com with ESMTPSA id p15sm5277565wmb.10.2019.11.08.14.21.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Nov 2019 14:21:59 -0800 (PST)
Date:   Fri, 8 Nov 2019 23:21:59 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     Parav Pandit <parav@mellanox.com>, alex.williamson@redhat.com,
        davem@davemloft.net, kvm@vger.kernel.org, netdev@vger.kernel.org,
        saeedm@mellanox.com, kwankhede@nvidia.com, leon@kernel.org,
        cohuck@redhat.com, jiri@mellanox.com, linux-rdma@vger.kernel.org,
        Or Gerlitz <gerlitz.or@gmail.com>
Subject: Re: [PATCH net-next 00/19] Mellanox, mlx5 sub function support
Message-ID: <20191108222159.GA6990@nanopsycho>
References: <20191107160448.20962-1-parav@mellanox.com>
 <20191107153234.0d735c1f@cakuba.netronome.com>
 <20191108121233.GJ6990@nanopsycho>
 <20191108110640.225b2724@cakuba>
 <20191108194118.GY6990@nanopsycho>
 <20191108132120.510d8b87@cakuba>
 <20191108213952.GZ6990@nanopsycho>
 <20191108135109.0c833847@cakuba>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191108135109.0c833847@cakuba>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fri, Nov 08, 2019 at 10:51:09PM CET, jakub.kicinski@netronome.com wrote:
>On Fri, 8 Nov 2019 22:39:52 +0100, Jiri Pirko wrote:
>> >> Please let me understand how your device is different.
>> >> Originally Parav didn't want to have mlx5 subfunctions as mdev. He
>> >> wanted to have them tight to the same pci device as the pf. No
>> >> difference from what you describe you want. However while we thought
>> >> about how to fit things in, how to handle na phys_port_name, how to see
>> >> things in sysfs we came up with an idea of a dedicated bus.  
>> >
>> >The difference is that there is naturally a main device and subslices
>> >with this new mlx5 code. In mlx4 or nfp all ports are equal and
>> >statically allocated when FW initializes based on port breakout.  
>> 
>> Ah, I see. I was missing the static part in nfp. Now I understand. It is
>> just an another "pf", but not real pf in the pci terminology, right?
>
>Ack, due to (real and perceived) HW limitations what should have been
>separate PFs got squished into a single big one.
>
>Biggest NFP chip has an insane (for a NIC) number Ethernet ports.

Okay. So we'll endup in having flavour "mdev" for the SFs that are
spawned on fly by user and "sf" for the fixed one - that is your
patchset if I recall correctly.
