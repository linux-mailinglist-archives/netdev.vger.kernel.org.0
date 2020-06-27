Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC19520C29C
	for <lists+netdev@lfdr.de>; Sat, 27 Jun 2020 17:02:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726447AbgF0PBv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Jun 2020 11:01:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726094AbgF0PBv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 27 Jun 2020 11:01:51 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01A99C061794;
        Sat, 27 Jun 2020 08:01:51 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id s14so5389445plq.6;
        Sat, 27 Jun 2020 08:01:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=9lher+rQxC0kRrcoezVIymaqZSTGLdetiTQ54P1L/Qc=;
        b=nlMVQLA0jQBARLHqP/GFmOdd7QX7HfxH5YBnecu+434yb/XWokEqmSaKLQfaQcamSB
         zuQBtk54DIYk9Ip2JCMSvjdpb8dFAZt1Kgmt9B6tsJ/TnQZoK0yUUxxpDKXNEmzK/bXd
         aylGDdU46wZK0GF8aoHcYHX5SWRE6EVYjXVHlyzMhzWv143Wp7rd9HAJbCkpWilZ5KE3
         RWhaCLT4OG/YmTTUWOCi58DWrHh47OvmF4CHMGvKNnc1fvfueTJLzSWqyaOmxv4YffWr
         J502vMRa2YH5d1/k1hfhXmLvsSjKeZViHgKMMdHqceaDs6QzVpQwYelzu9rPW/nQlYTi
         8zmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=9lher+rQxC0kRrcoezVIymaqZSTGLdetiTQ54P1L/Qc=;
        b=CmJ8CV4+G7UJeh7qVdsjuWP42PuK+cflHW+RPCc+MGbABzC2P73DVhXYiHNCcR4NFQ
         YnOmFLaOmEYLF5i18o6OjOwExAl9hVa2c1BR0HB6L2tm2GxwIEh3vEfXo6RRKOk2rj9w
         9qsOScjedhhP88Ot20JMgLED4KpJdtVkiiOlGUrpzlAkWKjmv0L7HKrQZhjNKDdC2caq
         0M1WW4yUQ3Ra3L9RofS2pAWNpxn/Idjr6tYvcWxIQk3xVdj/yeRIgqVAN6tuGNBTmhz9
         8/Iz6YV79Bojvph8M4tsbc7zbn2Jfu9vXU208nu8cnIORcTCloJ0+nOPZlaVtVOipIVM
         MHcA==
X-Gm-Message-State: AOAM531PLusjRBbs0gLhxnMzDrFkp7ea6+ucSMfFGgBsLi5FkOQVva+6
        b0yvKUsOlUAeu7QKVG1n47A=
X-Google-Smtp-Source: ABdhPJw9oECpaLZ/lIFVcCCPrnE7fCPYaId7ioMgiD3ZzwIUDxtHteJpqVOUN8uK/vDAJKSZMUcfdQ==
X-Received: by 2002:a17:902:b48f:: with SMTP id y15mr6823297plr.284.1593270110619;
        Sat, 27 Jun 2020 08:01:50 -0700 (PDT)
Received: from localhost ([2001:e42:102:1532:160:16:113:140])
        by smtp.gmail.com with ESMTPSA id 66sm12902375pfd.93.2020.06.27.08.01.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 27 Jun 2020 08:01:50 -0700 (PDT)
From:   Coiby Xu <coiby.xu@gmail.com>
X-Google-Original-From: Coiby Xu <Coiby.Xu@gmail.com>
Date:   Sat, 27 Jun 2020 23:01:42 +0800
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     devel@driverdev.osuosl.org,
        "supporter:QLOGIC QLGE 10Gb ETHERNET DRIVER" 
        <GR-Linux-NIC-Dev@marvell.com>,
        Manish Chopra <manishc@marvell.com>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:QLOGIC QLGE 10Gb ETHERNET DRIVER" <netdev@vger.kernel.org>,
        joe@perches.com, dan.carpenter@oracle.com
Subject: Re: [PATCH 1/4] fix trailing */ in block comment
Message-ID: <20200627150142.nukckb2ezyxiuemm@Rk>
References: <20200627101447.167370-1-coiby.xu@gmail.com>
 <20200627101447.167370-2-coiby.xu@gmail.com>
 <20200627104708.GA1581263@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20200627104708.GA1581263@kroah.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jun 27, 2020 at 12:47:08PM +0200, Greg Kroah-Hartman wrote:
>On Sat, Jun 27, 2020 at 06:14:44PM +0800, Coiby Xu wrote:
>> Remove trailing "*/" in block comments.
>>
>> Signed-off-by: Coiby Xu <coiby.xu@gmail.com>
>
>The subject lines of all of your patches should match other patches for
>this driver.  It should look like "staging: qlge: ..."
>
>Please fix up and resend a v2 of this series.
>
>thanks,
>
>greg k-h

Thank you for pointing out this issue!

--
Best regards,
Coiby
