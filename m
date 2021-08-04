Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1050C3E02E6
	for <lists+netdev@lfdr.de>; Wed,  4 Aug 2021 16:16:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238659AbhHDORD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Aug 2021 10:17:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238560AbhHDORC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Aug 2021 10:17:02 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6499C0613D5
        for <netdev@vger.kernel.org>; Wed,  4 Aug 2021 07:16:49 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id j1so3178062pjv.3
        for <netdev@vger.kernel.org>; Wed, 04 Aug 2021 07:16:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=9S4mjDYlxG706jJ9ez20gM1cyQRhN79/fJLBwzXUuKg=;
        b=NBUw4CyKrAc19terhigXAFb6mYQ4Ko4Ux8/0m9SQxqTFp3O+YfluPXYrHIj6nQY7E5
         GWGro6oNVR+mArQXQ7+JImgbUMKyiDgk1hOiquT5XzjovzaN7y/BEZ2kVcB1zGCRMGTQ
         vrS4hBInD/E8kejt5P/NaT+im/LyYLgs37JgoKO1z4mH94A7R14EVNHXsA9IRKaL7RCY
         ThaVnk9reg5ne861J2QcIX+bgLsBGMSxStXnJZIHD2rF33d4v3kBKauyER9oQVmDbHFR
         KweANV5ODO0KiJ6kzvpr2mYRSJO5Cns9tWOwf8wYdKfII232VLiu506ODFQBLZt5rUxB
         ygZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=9S4mjDYlxG706jJ9ez20gM1cyQRhN79/fJLBwzXUuKg=;
        b=f1/6eI4RGw+Mnum658K+k88C7OeV/YM2r45tkOSL+b/d4pLRQV38BZsguVFT8CT7R7
         cexeCDnXJqJUGqTf6nRZQib15KDp69v2077IO07P4geYKXFwEHNDO8aO93QiYDZLunUM
         nz5vBz6NKLM1Z1cUHcCLMdvEEtEXgQP5QYcMIOcel0RVOLf9EJIIPNuiBiGgHYa6+G8C
         A/Wr+UdNO5HVRCqcx+DnLwkI9AmOAe5bVKzt7WyzrBnf67vvkmBeAUhCDbrxWyDtNPWV
         tOrSo/C01iFUPU0LZaJ1jYI/rXfA2HJ0sD+eFhBL9tC/fBpa0JdCob23ICo5ZVQY/Be4
         Wa3g==
X-Gm-Message-State: AOAM533Z9NyUr9nYPuT+1ywZx4RzobNyMW1WXH36jSDCUYW/ioSZhipy
        oVDn2aTzClEO48+5XfYiILk=
X-Google-Smtp-Source: ABdhPJy92stKVG2vLj5Nt8Y3EkSpbjovi23JFUiEKyBOcO+bVYOOqqnxM+W1BVUKc/wUw5Hzq4FbPQ==
X-Received: by 2002:a17:902:d4cc:b029:12c:dd57:d097 with SMTP id o12-20020a170902d4ccb029012cdd57d097mr316154plg.23.1628086609191;
        Wed, 04 Aug 2021 07:16:49 -0700 (PDT)
Received: from hoboy.vegasvil.org ([2601:645:c000:2163:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id j187sm3118303pfb.132.2021.08.04.07.16.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Aug 2021 07:16:48 -0700 (PDT)
Date:   Wed, 4 Aug 2021 07:16:46 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Jonathan Lemon <jonathan.lemon@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, kernel-team@fb.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next v4] ptp: ocp: Expose various resources on the
 timecard.
Message-ID: <20210804141646.GA1645@hoboy.vegasvil.org>
References: <20210804033327.345759-1-jonathan.lemon@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210804033327.345759-1-jonathan.lemon@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 03, 2021 at 08:33:27PM -0700, Jonathan Lemon wrote:
> The OpenCompute timecard driver has additional functionality besides
> a clock.  Make the following resources available:
> 
>  - The external timestamp channels (ts0/ts1)
>  - devlink support for flashing and health reporting
>  - GPS and MAC serial ports
>  - board serial number (obtained from i2c device)
> 
> Also add watchdog functionality for when GNSS goes into holdover.
> 
> The resources are collected under a timecard class directory:
> 
>   [jlemon@timecard ~]$ ls -g /sys/class/timecard/ocp1/
>   total 0
>   -r--r--r--. 1 root 4096 Aug  3 19:49 available_clock_sources
>   -rw-r--r--. 1 root 4096 Aug  3 19:49 clock_source
>   lrwxrwxrwx. 1 root    0 Aug  3 19:49 device -> ../../../0000:04:00.0/
>   -r--r--r--. 1 root 4096 Aug  3 19:49 gps_sync
>   lrwxrwxrwx. 1 root    0 Aug  3 19:49 i2c -> ../../xiic-i2c.1024/i2c-2/
>   drwxr-xr-x. 2 root    0 Aug  3 19:49 power/
>   lrwxrwxrwx. 1 root    0 Aug  3 19:49 pps ->
>   ../../../../../virtual/pps/pps1/
>   lrwxrwxrwx. 1 root    0 Aug  3 19:49 ptp -> ../../ptp/ptp2/
>   -r--r--r--. 1 root 4096 Aug  3 19:49 serialnum
>   lrwxrwxrwx. 1 root    0 Aug  3 19:49 subsystem ->
>   ../../../../../../class/timecard/
>   lrwxrwxrwx. 1 root    0 Aug  3 19:49 ttyGPS -> ../../tty/ttyS7/
>   lrwxrwxrwx. 1 root    0 Aug  3 19:49 ttyMAC -> ../../tty/ttyS8/
>   -rw-r--r--. 1 root 4096 Aug  3 19:39 uevent

I like this user friendly grouping.

Acked-by: Richard Cochran <richardcochran@gmail.com>
