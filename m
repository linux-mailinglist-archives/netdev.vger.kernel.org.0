Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9F5226A010
	for <lists+netdev@lfdr.de>; Tue, 15 Sep 2020 09:46:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726132AbgIOHpN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Sep 2020 03:45:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726157AbgIOHoF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Sep 2020 03:44:05 -0400
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA92CC061788
        for <netdev@vger.kernel.org>; Tue, 15 Sep 2020 00:44:04 -0700 (PDT)
Received: by mail-ej1-x643.google.com with SMTP id i26so3552108ejb.12
        for <netdev@vger.kernel.org>; Tue, 15 Sep 2020 00:44:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=bVk5ziYF94Toafe35ecOS7d2MqTzFsDTBdEA3MQSQJU=;
        b=SYtgTycQtyXYM41h5Hp5WxBfd6nX4yMCaFMLKp9fX6L9pfNRCbL4nl/LUHtmnzWe/K
         ZK9LRiCJb4hR4W+jQDcGrdEXej45PsPx+cWvmLv9AElLjWqfuqOuNho9JYMSyDS+tb2x
         dxGcXw9DsyMm0GLWrAsOw0wnIG0Dej64WgE2IMK8e1I0G43LRRWvslqaSNX+8eVSggdV
         hCbJH0WEB1cg70Piv5y4Zm8lBK31VKL/ulx2ISzad1nw8XZxWZTTI4PH2r+abE8cdo2W
         1Qaj6B109Y2lL0aXATRnSzUmouzYnlKnfCy3ie/2/NmLii5I2LkEK16upRjdAPu1F9hC
         sZMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=bVk5ziYF94Toafe35ecOS7d2MqTzFsDTBdEA3MQSQJU=;
        b=Nq4i/hmOj6PifC325gEi9outveUxZs4TSMBT68bsMDNEcrpPgLZZp8G6skqXkEzEy1
         0ZLhrFM4lHtYyrcyJxJBrRvpGsALuBlsloifiH/J8HsApjEVT3RMt3BUpmdd9cfxiKkk
         u6rwZIxuXr4MhibDamDVuekrNm5P6MlZMxTnE9RvLkweZr9NWMuDQdqFMDqWSh/ikXOH
         SHEp9TrMh0wmVNQhoceTm3m37lNH8U8dOC4JctG+VGk4B7PR2UYtQvQaxqtBJmGcWVlc
         muxpDyZxv1ZDBrbaf6oZmIOqSv4kjK0dH8zMl1MulFd47XAR0gNWr+/Mukr7WDerZ/ca
         WCjQ==
X-Gm-Message-State: AOAM531LCWh6OKgEMi6qkiHXym1cuEIAYkyd1e0Nfz2l/bBdNepJa+LC
        cTIiA9O7Hjy143d4erPeLoKX+g==
X-Google-Smtp-Source: ABdhPJwSNpRt4PF7QqyfvTp3IHkDf7OiKPmP4SM79becnDyGX2tGNHYASYk/CD/0JvbGNRgAY/uLpQ==
X-Received: by 2002:a17:906:cec9:: with SMTP id si9mr18210890ejb.351.1600155843496;
        Tue, 15 Sep 2020 00:44:03 -0700 (PDT)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id mb16sm9519149ejb.45.2020.09.15.00.44.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Sep 2020 00:44:02 -0700 (PDT)
Date:   Tue, 15 Sep 2020 09:44:02 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     Moshe Shemesh <moshe@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jiri Pirko <jiri@mellanox.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next RFC v4 04/15] devlink: Add reload actions stats
 to dev get
Message-ID: <20200915074402.GM2236@nanopsycho.orion>
References: <1600063682-17313-1-git-send-email-moshe@mellanox.com>
 <1600063682-17313-5-git-send-email-moshe@mellanox.com>
 <20200914134500.GH2236@nanopsycho.orion>
 <20200915064519.GA5390@shredder>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200915064519.GA5390@shredder>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tue, Sep 15, 2020 at 08:45:19AM CEST, idosch@idosch.org wrote:
>On Mon, Sep 14, 2020 at 03:45:00PM +0200, Jiri Pirko wrote:
>> Mon, Sep 14, 2020 at 08:07:51AM CEST, moshe@mellanox.com wrote:
>> >Expose devlink reload actions stats to the user through devlink dev
>> >get command.
>> >
>> >Examples:
>> >$ devlink dev show
>> >pci/0000:82:00.0:
>> >  reload_action_stats:
>> >    driver_reinit 2
>> >    fw_activate 1
>> >    driver_reinit_no_reset 0
>> >    fw_activate_no_reset 0
>> >pci/0000:82:00.1:
>> >  reload_action_stats:
>> >    driver_reinit 1
>> >    fw_activate 1
>> >    driver_reinit_no_reset 0
>> >    fw_activate_no_reset 0
>> 
>> I would rather have something like:
>>    stats:
>>      reload_action:
>>        driver_reinit 1
>>        fw_activate 1
>>        driver_reinit_no_reset 0
>>        fw_activate_no_reset 0
>> 
>> Then we can easily extend and add other stats in the tree.
>> 
>> 
>> Also, I wonder if these stats could be somehow merged with Ido's metrics
>> work:
>> https://github.com/idosch/linux/commits/submit/devlink_metric_rfc_v1
>> 
>> Ido, would it make sense?
>
>I guess. My original idea for devlink-metric was to expose
>design-specific metrics to user space where the entity registering the
>metrics is the device driver. In this case the entity would be devlink
>itself and it would be auto-registered for each device.

Yeah, the usecase is different, but it is still stats, right.


>
>> 
>> 
>> >
>> >$ devlink dev show -jp
>> >{
>> >    "dev": {
>> >        "pci/0000:82:00.0": {
>> >            "reload_action_stats": [ {
>> >                    "driver_reinit": 2
>> >                },{
>> >                    "fw_activate": 1
>> >                },{
>> >                    "driver_reinit_no_reset": 0
>> >                },{
>> >                    "fw_activate_no_reset": 0
>> >                } ]
>> >        },
>> >        "pci/0000:82:00.1": {
>> >            "reload_action_stats": [ {
>> >                    "driver_reinit": 1
>> >                },{
>> >                    "fw_activate": 1
>> >                },{
>> >                    "driver_reinit_no_reset": 0
>> >                },{
>> >                    "fw_activate_no_reset": 0
>> >                } ]
>> >        }
>> >    }
>> >}
>> >
>> 
>> [..]
