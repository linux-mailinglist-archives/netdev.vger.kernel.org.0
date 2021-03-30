Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 476BF34DF7C
	for <lists+netdev@lfdr.de>; Tue, 30 Mar 2021 05:40:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229468AbhC3Dju (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Mar 2021 23:39:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230247AbhC3Djo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Mar 2021 23:39:44 -0400
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90CD3C061762
        for <netdev@vger.kernel.org>; Mon, 29 Mar 2021 20:39:44 -0700 (PDT)
Received: by mail-pg1-x536.google.com with SMTP id t140so3402785pgb.13
        for <netdev@vger.kernel.org>; Mon, 29 Mar 2021 20:39:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cooperlees-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=NXB505U811M5ykszWa9Yij+Cgv1CEnbTAFPAG8ARASo=;
        b=KPLp6gd4IVjJd0l3X0QkjBs80T469WWSG9Tqr++vJ8+vE2BG1hEUrF/VVwHpoTKUZh
         ePh5bo03RVscmKls4MUSUZPU2rXrlcxzgE3WPN7jdLZWyFbmpe8pcitreNqgcSRTTiYR
         zvmgR80Oa87FzKq1NXozsG29dU8/S1M5iozmU1qyKAQOtrDHEJXHTfD5XnLBxPqyNpfD
         gBBgjIrk5n53N5OSrmxVoposhVO6weMITeT0ImPtKaGN36o82RU+N5ZYTIdevtaPNuqD
         58jwtIx4j8P60RwuZW9HinutGtU4vbcvKdk932e88A3WIi7MnCe+vMYuyLkmD/wEPymu
         Iqlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=NXB505U811M5ykszWa9Yij+Cgv1CEnbTAFPAG8ARASo=;
        b=L2H7AV2GsPLBH+5024kl9vLIdwLnXnTi5+uPvw7kVaY07OBcf6/kjuPunsw9gpvN/v
         TdAufEHh2t2zZfTNsdhbHpKfgZcYFBVryjzs4YyP5IGYtk07JJZ7s4ePZbQAVaMtgYsC
         Jx0PKs27a9knL3ew+o+LNx3ZFe/XSZTRZWCZBbUAutqWCs5HyVtInReG2Zmzm1RQEepN
         uOREkp/Ekftz2XwCbO4LQevRX1l/QP2/czmEV2TVAsOcK2YTKWodmys0+lqY171KhjAz
         LQOpaO8scKJOjKP4OdYtAitAifdzPp6fzbjSnr+FkDqaV6WVXsL3Bu6mGe2avj3ObVmy
         naCA==
X-Gm-Message-State: AOAM5332u3ou5SGphKGItcI0mSofKSGH9WMY5wh+zf9MC1sKe+ZjMOrS
        qLsudCMsVAHaCxankbN6YIyR0Nhk73wxBg==
X-Google-Smtp-Source: ABdhPJz5EtOt2V4IfqoKqjHKIncKWr9XIVY9AJlBNsRht7qSDWsB5ghB2G4PktjfWY6+hblEydTcpg==
X-Received: by 2002:a63:d143:: with SMTP id c3mr10042100pgj.99.1617075583972;
        Mon, 29 Mar 2021 20:39:43 -0700 (PDT)
Received: from ?IPv6:2600:6c4e:2200:71:10a2:8f1f:def4:467a? ([2600:6c4e:2200:71:10a2:8f1f:def4:467a])
        by smtp.gmail.com with ESMTPSA id u84sm19270287pfc.90.2021.03.29.20.39.43
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 29 Mar 2021 20:39:43 -0700 (PDT)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 14.0 \(3654.60.0.2.21\))
Subject: Re: [PATCH] Add Open/R to rt_protos
From:   Cooper Lees <me@cooperlees.com>
In-Reply-To: <21b6c796-f225-44f3-da3a-f1f3635f5d6c@gmail.com>
Date:   Mon, 29 Mar 2021 20:39:41 -0700
Cc:     dsahern@kernel.org, netdev@vger.kernel.org
Content-Transfer-Encoding: 7bit
Message-Id: <24F80D82-87A4-4A6A-BE62-C414DA138A8B@cooperlees.com>
References: <20210326150513.6233-1-me@cooperlees.com>
 <21b6c796-f225-44f3-da3a-f1f3635f5d6c@gmail.com>
To:     David Ahern <dsahern@gmail.com>
X-Mailer: Apple Mail (2.3654.60.0.2.21)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thanks David!

Cooper

> On Mar 29, 2021, at 8:07 PM, David Ahern <dsahern@gmail.com> wrote:
> 
> On 3/26/21 9:05 AM, Cooper Ry Lees wrote:
>> From: Cooper Lees <me@cooperlees.com>
>> 
>> - Open Routing is using ID 99 for it's installed routes
>> - https://github.com/facebook/openr
>> - Kernel has accepted 99 in `rtnetlink.h`
>> 
>> Signed-of-by: Cooper Lees <me@cooperlees.com>
>> ---
>> etc/iproute2/rt_protos | 1 +
>> 1 file changed, 1 insertion(+)
>> 
> 
> applied to iproute2-next.

