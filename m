Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBE543EE45A
	for <lists+netdev@lfdr.de>; Tue, 17 Aug 2021 04:24:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236599AbhHQCZW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Aug 2021 22:25:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236397AbhHQCZU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Aug 2021 22:25:20 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EAA7C0613C1
        for <netdev@vger.kernel.org>; Mon, 16 Aug 2021 19:24:48 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id a20so23037478plm.0
        for <netdev@vger.kernel.org>; Mon, 16 Aug 2021 19:24:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ManiP7GKO0f/oM7FlsW8ivdlyIxTUHK7LDqkTqzSAXg=;
        b=Yd0VSz1X6h2OpVHq3Ay1KVbeAYpZtRQAHjDqNODuWZeV0XzQ9qbq7ylf93iNUIFGBX
         G2cTd5+/P0qAnA+taz2ZhK4h8O/RvmTXUTtIr5TqrqSNJgXJ0G5lMGjYYbTvATDZIH/W
         j7KbFUG3VPiQoiMVvBLcVgZ+WE8xRsjcLdBWTd/NQWHcDrEceVg/18eSj1N14h0QoL0U
         FT0RMdvM+ZRhiIgv0ZDGr9X+rSru/IxRR1EATow778WRr8NLxToO7tvsYsqfYnsAC886
         ivjOnlZRPjZ1cl+rJCnWpuo72455oQtoSTqDqBlW4N2Q1OgMhPCBge+605+4OklORqsI
         02sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ManiP7GKO0f/oM7FlsW8ivdlyIxTUHK7LDqkTqzSAXg=;
        b=YATe2zDEc6yQCV/vTUU22+/VCym6bAJOG/3x0gt5mI+xUn8YBC8btgcVW0gq5oY3AR
         bPUtc/HONkRPNzghd+rq4tbUHeEakNirUqXRPuT1aTB4JtLFxC3Vdf8ZvNaPWeY6jNZr
         0D4y+0DR2ou9ezK0JW0CN/ry17CNpgPDzF7dRJa57xJjpAlkut9cz9m1jCZEOldlZRTg
         rmJvdJxsU74w2G8UUmMBgMeDMF0Gyy0L29GJDCr+pyHAKQka26RPUQqHT0p2bUN/Qx9M
         xpkYLcWJ8kZ5KJeSLxbbaNm2hJv5tg2sBpFt/Y1xweRmRD7kkqRS1br54Dz5aPenNhw2
         k3kw==
X-Gm-Message-State: AOAM533F6HyMNylbC3yWqHIarUx3FIHdAUEzf9es20ZEcpJzkqZvX/1d
        VyRV+wQu1jXl7gOeTel4hCk=
X-Google-Smtp-Source: ABdhPJx5pylG5Ti6zfefoNqqtSAC4V1gXhIT1pE6v8ZvuAEGz6uWpAqkNHT6xEopJTK5WhZhSAA78w==
X-Received: by 2002:a17:90a:6782:: with SMTP id o2mr1059897pjj.165.1629167087846;
        Mon, 16 Aug 2021 19:24:47 -0700 (PDT)
Received: from Laptop-X1 ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id m2sm470129pfo.45.2021.08.16.19.24.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Aug 2021 19:24:47 -0700 (PDT)
Date:   Tue, 17 Aug 2021 10:24:43 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     netdev@vger.kernel.org, David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH iproute2-next] ip/bond: add arp_validate filter support
Message-ID: <YRsd68TVjHeirHfk@Laptop-X1>
References: <20210816074905.297294-1-liuhangbin@gmail.com>
 <20210816182620.273bb1e4@hermes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210816182620.273bb1e4@hermes.local>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 16, 2021 at 06:26:20PM -0700, Stephen Hemminger wrote:
> On Mon, 16 Aug 2021 15:49:05 +0800
> Hangbin Liu <liuhangbin@gmail.com> wrote:
> 
> > Add arp_validate filter support based on kernel commit 896149ff1b2c
> > ("bonding: extend arp_validate to be able to receive unvalidated arp-only traffic")
> > 
> > Signed-off-by: Hangbin Liu <liuhangbin@gmail.com
> 
> Since this has been in since 2014, it can skip going to iproute2-next

Fine with me. I thought all new features need to be submitted to -next branch
first.

Thanks
Hangbin
