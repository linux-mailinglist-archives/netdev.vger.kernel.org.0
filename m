Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98320212AC5
	for <lists+netdev@lfdr.de>; Thu,  2 Jul 2020 19:04:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726997AbgGBREA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jul 2020 13:04:00 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:24158 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726796AbgGBREA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jul 2020 13:04:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1593709439;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=1/9+KeCe2WNKRx5vGEhbWsRnptSfm4e+Ye8oXhAjQ3Q=;
        b=KFXqoJqZbBes1oBuVyjldSPzvPVd4KLQD9W/LbxpSuxuf4MxcHHXn4F8rsUPqi5/YZPgI8
        oyckzlPGxydR4qpuyBPF2dC9g1ptmDw+KjAmU2z66RTlg38rkATlRvBEx91BLFfg3tcCbs
        vdqAdgAWtTlU/+h8wXoML1FTLQEWBjk=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-438-DNAoBlm_MtSyDR7RqQJgrQ-1; Thu, 02 Jul 2020 13:03:57 -0400
X-MC-Unique: DNAoBlm_MtSyDR7RqQJgrQ-1
Received: by mail-wr1-f69.google.com with SMTP id y18so7300592wrq.4
        for <netdev@vger.kernel.org>; Thu, 02 Jul 2020 10:03:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=1/9+KeCe2WNKRx5vGEhbWsRnptSfm4e+Ye8oXhAjQ3Q=;
        b=VrlfKu3nl6hNcoMqFhH0y/v+ItD9TSPrGhqRFxbXDx4ql50I4tYG5d+n0MrO10W+zZ
         zfmthYBPF5wbj/4Fuvi/5PhLg6+/MueXLhk32d4kN/2jE97hWKENKK0BtCnKFeqhX2WZ
         Q2cS6tVsukYRyJWSbsZ4PBD/LrRsyCHhXOnGVdBQxbkHjh92bPjVHMO+FvFtKJI2eHmf
         QvxNuHtW0i9BWjsGnN+p3+9soVHmuH3A050I7t/ECzEsFOxGHoZtihZzYDcYfd8odd8R
         RRuHfzUjYSYrgBq4zYPVllnlxTUnFuqLBSboTmgoZWaLDLAIInxp5p28936lBKrhrVjP
         u57A==
X-Gm-Message-State: AOAM530PdW1zvTuQiAyVmOfTDFIOLNf0sed4OmgbhEMbPgY7jC6uCtV3
        260y/Yrx6Q/GWoLgx+lggy8bre6dRQlFLB0DFMECZ6tTP6YsPwuC8peXpbxtcaNHrE1QrS9q7p7
        K4eCe99F/IJksl75t
X-Received: by 2002:adf:de12:: with SMTP id b18mr34952269wrm.390.1593709435982;
        Thu, 02 Jul 2020 10:03:55 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyjhFO5Y0TK4WBf6GhhQXOvIYIvPLHxortlGPCab91KqGbpv7BwU6YwmGJNlDW8QPOkqJimmA==
X-Received: by 2002:adf:de12:: with SMTP id b18mr34952254wrm.390.1593709435778;
        Thu, 02 Jul 2020 10:03:55 -0700 (PDT)
Received: from pc-2.home (2a01cb0585138800b113760e11343d15.ipv6.abo.wanadoo.fr. [2a01:cb05:8513:8800:b113:760e:1134:3d15])
        by smtp.gmail.com with ESMTPSA id 1sm10943923wmf.0.2020.07.02.10.03.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Jul 2020 10:03:55 -0700 (PDT)
Date:   Thu, 2 Jul 2020 19:03:53 +0200
From:   Guillaume Nault <gnault@redhat.com>
To:     Martin Varghese <martinvarghesenokia@gmail.com>
Cc:     Stephen Hemminger <stephen@networkplumber.org>,
        netdev@vger.kernel.org
Subject: Re: [PATCH iproute2] ip link: initial support for bareudp devices
Message-ID: <20200702170353.GA7852@pc-2.home>
References: <f3401f1acfce2f472abe6f89fe059a5fade148a3.1593630794.git.gnault@redhat.com>
 <20200702160221.GA3720@martin-VirtualBox>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200702160221.GA3720@martin-VirtualBox>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 02, 2020 at 09:32:21PM +0530, Martin Varghese wrote:
> On Wed, Jul 01, 2020 at 09:45:04PM +0200, Guillaume Nault wrote:
> 
> I couldnt apply the patch to master.Could you please confirm if it was rebased to the master

Hi Martin,

Yes, it's based on the latest iproute2 master branch.
I can apply it with "git am" without any problem.

Which command did you use?

