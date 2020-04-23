Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B18D1B533E
	for <lists+netdev@lfdr.de>; Thu, 23 Apr 2020 05:54:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726050AbgDWDyh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Apr 2020 23:54:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725854AbgDWDyg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Apr 2020 23:54:36 -0400
Received: from mail-vk1-xa43.google.com (mail-vk1-xa43.google.com [IPv6:2607:f8b0:4864:20::a43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73FDDC03C1AB
        for <netdev@vger.kernel.org>; Wed, 22 Apr 2020 20:54:36 -0700 (PDT)
Received: by mail-vk1-xa43.google.com with SMTP id i185so1351035vki.12
        for <netdev@vger.kernel.org>; Wed, 22 Apr 2020 20:54:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/0RR9PXzOBUwR5pVwpT7zfK7pAQee0sOeBD8lOubnPs=;
        b=EfCiAmOgD0TuH+PfZAS0O/UAk6Arh0i/Dy7L7yegSd8mc+aGcoiqRBR9CGN+o4mUTG
         +k2laW5K6bTqUCa96tOoPYU92eNpowC8JjytwIowHY2hR+BLH+GqeT+nsGHr0wBPVY9i
         nz9EQdmjwtUosSVoUaSWKjSDKuSsNLs/sj/JuXoyHK+kQjBXL6C+sDPP4eRBJT/P9wt4
         9THo3WRHtxaRrkzb3s4xTpVPhOYF5elm8gP6+11ic1+BfDFCnC7vrVcHSumfUfONViZ2
         1nz9MmXPaAInfhGSp965Ef9ou/ucXmHj7pSkG2AHhFuuz/oCsj2WCSdKj3AoFYaQVTKW
         X1og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/0RR9PXzOBUwR5pVwpT7zfK7pAQee0sOeBD8lOubnPs=;
        b=nd9o091qOCys+hXrr1QXG0Rh+Yz3S3l0cZ7Zd2FkhkCky1XJmERXiYdc2n/7YEWS4c
         3r3UPhX1ZkDGmOZFFAA0yclpfr56NAHHFsKGOluIWe1PqfIIUZqQdCJqFzU3nWup756r
         VFo3L1urYy8rYmJyqb+gHwHCdvl/gg4avB9SsDflPKlL4lPdFyw22emr2nwGvoclDe27
         tWXAILA52KxegyTtcFwU6EGX8vNrqe6mG3QySaqyDHcMfId7IvJgpr6ig7ERPEAraHnE
         OBBFeBzv382tWNNepWd8sBnDVUgZ9ybxH9W+FNODO0NsfuTMq3fTQ6XWVBQpWX/WZ7jU
         BRBQ==
X-Gm-Message-State: AGi0Pubg7o5swwdRIZMnyKTo6hE7MOsU3dv7Jf5qurEnh5hNXkkn3H8K
        AfTg5ZsfAZnXjiZy1itSdJO5EA+mLvAbLuYQFWY=
X-Google-Smtp-Source: APiQypLrdqqFgwh5FcudNFqHmLUnZEf1QeLLMkU6LrWpSvPl/doEamIl4nhmWfmCs44HJC0kog9U7SFhUtgyv9bxNzQ=
X-Received: by 2002:a1f:2c50:: with SMTP id s77mr1962740vks.14.1587614075486;
 Wed, 22 Apr 2020 20:54:35 -0700 (PDT)
MIME-Version: 1.0
References: <1584969039-74113-1-git-send-email-xiangxia.m.yue@gmail.com>
 <1587575340-6790-1-git-send-email-xiangxia.m.yue@gmail.com> <1587575340-6790-2-git-send-email-xiangxia.m.yue@gmail.com>
In-Reply-To: <1587575340-6790-2-git-send-email-xiangxia.m.yue@gmail.com>
From:   Pravin Shelar <pravin.ovn@gmail.com>
Date:   Wed, 22 Apr 2020 20:54:24 -0700
Message-ID: <CAOrHB_CDy1KwXjvdncZ+aYc9FYSr4+PYckspR7HPDYwWEQeisw@mail.gmail.com>
Subject: Re: [PATCH net-next v3 1/5] net: openvswitch: expand the meters
 supported number
To:     Tonghao Zhang <xiangxia.m.yue@gmail.com>
Cc:     Andy Zhou <azhou@ovn.org>, Ben Pfaff <blp@ovn.org>,
        William Tu <u9012063@gmail.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        ovs dev <dev@openvswitch.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 22, 2020 at 10:10 AM <xiangxia.m.yue@gmail.com> wrote:
>
> From: Tonghao Zhang <xiangxia.m.yue@gmail.com>
>
> In kernel datapath of Open vSwitch, there are only 1024
> buckets of meter in one datapath. If installing more than
> 1024 (e.g. 8192) meters, it may lead to the performance drop.
> But in some case, for example, Open vSwitch used as edge
> gateway, there should be 20K at least, where meters used for
> IP address bandwidth limitation.
>
> [Open vSwitch userspace datapath has this issue too.]
>
> For more scalable meter, this patch use meter array instead of
> hash tables, and expand/shrink the array when necessary. So we
> can install more meters than before in the datapath.
> Introducing the struct *dp_meter_instance, it's easy to
> expand meter though changing the *ti point in the struct
> *dp_meter_table.
>
> Cc: Pravin B Shelar <pshelar@ovn.org>
> Cc: Andy Zhou <azhou@ovn.org>
> Signed-off-by: Tonghao Zhang <xiangxia.m.yue@gmail.com>
> ---
>  net/openvswitch/datapath.h |   2 +-
>  net/openvswitch/meter.c    | 240 ++++++++++++++++++++++++++++---------
>  net/openvswitch/meter.h    |  16 ++-
>  3 files changed, 195 insertions(+), 63 deletions(-)
>
Acked-by: Pravin B Shelar <pshelar@ovn.org>

Thanks.
