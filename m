Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60AEE24A65B
	for <lists+netdev@lfdr.de>; Wed, 19 Aug 2020 20:55:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726851AbgHSSzK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Aug 2020 14:55:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726211AbgHSSzH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Aug 2020 14:55:07 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2536BC061383
        for <netdev@vger.kernel.org>; Wed, 19 Aug 2020 11:55:07 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id f1so22560646wro.2
        for <netdev@vger.kernel.org>; Wed, 19 Aug 2020 11:55:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ooMhFUs9RFhswhrwBkRtQX2o8ZbiuA0ZfSr1gShQi2Q=;
        b=TX+hzzw73D70v1zibyNZazPeJ9ek6hmB8R8NSrhcQoCsyGihMKlNkLYi/p8HHcsP5c
         mVo5+ZJbc1ovI8/cPwyp4Vjz4CxsW+oX1zTf8QchcKsNAOwL+sEx5yQWbBLeghwfJCle
         Wkg5vrD01Xy4SIl6gHkVt0z1pNAkZHY77Yn5k8QbW7C69vlHls42Dy6sPTBQlO4lQQ0e
         rSPhxlyNAL/9D7eqbaGX+k4H+U2CViB77Cj6WyI4Ev1S9cGBGCXkKimNslmC5K6P/env
         XlOMu4LXPpqLzipkAo66pFGSL87UxW1Kbprjz0XZGXFkD5k7+pOFxEluJF/wnTToyp7d
         VWzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ooMhFUs9RFhswhrwBkRtQX2o8ZbiuA0ZfSr1gShQi2Q=;
        b=b84ZKqsAXXE1yiAqXCs29ltLXFraMfPCRpcsK/PzzFRSdVxnA9bfjqqxZ4/OPpeCEx
         bGulxz/NaClaKGkaCU8UnDwnnQ8Ziepy3r/F+1AMc2+pIYkPNeaPV6gneNQipL8Aq5AX
         SinsiJUc6rGtSY8+nBFhDfcFWiDcf7OPqtD4CG4AohUve9r6PylvYTAnuf4Iku+6G7bz
         WZaRNQOCHBd8fHU0fBZ/Ztjle8vem3kspXCL5W9gyAPtUsOncdHN552LiAh54nGruUz2
         IGVNTMKFNASR8IrkRkG97JBrJ0jBGO5Ch298HhKlfodiQrpKxtEUBX425LYuWcc2vuIK
         XChA==
X-Gm-Message-State: AOAM532QNv+H749kWt14ov9oB+4gg2WRrEtL1cJcCQl2fgoTo96EDT/3
        fg69TM1YqC//3uIp7zhJ/bnjWw==
X-Google-Smtp-Source: ABdhPJx0Yv5S6txvI494QVf7VePMx3q8R6FTlG8yfzQhyZhSzunlCykNh+fbCmNLbxVhietRztfrow==
X-Received: by 2002:adf:a4d7:: with SMTP id h23mr5851348wrb.276.1597863305805;
        Wed, 19 Aug 2020 11:55:05 -0700 (PDT)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id w10sm7599043wmk.0.2020.08.19.11.55.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Aug 2020 11:55:05 -0700 (PDT)
Date:   Wed, 19 Aug 2020 20:55:04 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Moshe Shemesh <moshe@nvidia.com>,
        Moshe Shemesh <moshe@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jiri Pirko <jiri@mellanox.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next RFC v2 01/13] devlink: Add reload action option
 to devlink reload command
Message-ID: <20200819185504.GB2575@nanopsycho.orion>
References: <1597657072-3130-1-git-send-email-moshe@mellanox.com>
 <1597657072-3130-2-git-send-email-moshe@mellanox.com>
 <20200817163612.GA2627@nanopsycho>
 <3ed1115e-8b44-b398-55f2-cee94ef426fd@nvidia.com>
 <20200818171010.11e4b615@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <cd0e3d7e-4746-d26d-dd0c-eb36c9c8a10f@nvidia.com>
 <20200819124616.GA2314@nanopsycho.orion>
 <fc0d7c2f-afb5-c2e7-e44b-2ab5d21d8465@nvidia.com>
 <20200819151815.GA2575@nanopsycho.orion>
 <20200819092551.6d94de03@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200819092551.6d94de03@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Wed, Aug 19, 2020 at 06:25:51PM CEST, kuba@kernel.org wrote:
>On Wed, 19 Aug 2020 17:18:15 +0200 Jiri Pirko wrote:
>>>>> I will add counters on which reload were done. reload_down()/up() can return
>>>>> which actions were actually done and devlink will show counters.  
>>>> Why a counter? Just return what was done over netlink reply.  
>>>
>>> Such counters can be useful for debugging, telling which reload actions were
>>> done on this dev from the point it was up.  
>> 
>> Not sure why this is any different from other commands...
>
>Good question, perhaps because reset is more "dangerous"? The question
>of "what reset this NIC" does come up in practice. With live activation
>in the mix, knowing if the NIC FW was live activated will be very
>useful for dissecting failures, I'd imagine.

Okay, fair enough. Yet, I think that the info in the reply as I
suggested would be also nice to have, while we are at it.
