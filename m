Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C087C2D7224
	for <lists+netdev@lfdr.de>; Fri, 11 Dec 2020 09:48:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437085AbgLKIrM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Dec 2020 03:47:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2437030AbgLKIpR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Dec 2020 03:45:17 -0500
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09015C06179C
        for <netdev@vger.kernel.org>; Fri, 11 Dec 2020 00:44:14 -0800 (PST)
Received: by mail-pj1-x1044.google.com with SMTP id iq13so1858365pjb.3
        for <netdev@vger.kernel.org>; Fri, 11 Dec 2020 00:44:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=P2Z6Y0mUdQeKOQLOjiTLkiK3ZL1MPGjCu+/e0XcmQCM=;
        b=qtrNGKWEs0pS1HMrMSqaw+g7SDQLDMhb0dmAR0ftJz1Ngo0yhFyOTqBA7/78VkTrvY
         3U/nmki1WTl1Bqtm2eQjYTF2CMyU8TgiO/3IEHZcQAWPnOXX2yYRVzp4w+k/qc0/1wCT
         Gb0LCDBabkcqYOnaql/GbeytRptw2inXyGdsF3liQBj9xlWTs7Zg/lwh9GZ07AzhQMQz
         FjWSV9hLYZmtKF+42zBfv4MnsmtBychbdjTVVDQbiKITJXe57Hsx7eXvZq5RX+p1EDo9
         OR3uWFj439wOfLmtXro2VIusypKZUiBZwP+0CXgBZ9jp4TZtO/f7VWwpSe/bdrZsugaD
         5Zow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=P2Z6Y0mUdQeKOQLOjiTLkiK3ZL1MPGjCu+/e0XcmQCM=;
        b=mZowwMmFPG+7gAe9KgYsBZWcNxlfK3uv9DctZNxADP/Q0UyHe5XMIlxkh/CX9RPZ5P
         RMpY8R2Ud9mqcpZAm0yUhMKL9hHPt9B0ZPLI9fBqmKnvXu8M4Gu+ul7xxYPiM7QWvj6p
         +4SH0ILOCLR+6bSTp+CuGngpwwjbwY061RhioqIguFt+RcSFBwnMJHI7+IMUq4H7gkM8
         AexADXT3Ve8owWyj9OiVkVnXOFoQmHy/lU6zqRt5T/WWy3aB1CFU6RqW3dAboG+XQ0iX
         /iK9MjyjSUEj/RHy4Hjut9ZGqRWo5ARkXZReW0hbxXOHljcVxByWWZUgENn16Em+uAjJ
         neiA==
X-Gm-Message-State: AOAM531EjeenOwsddIUg3D6AljOIXMhBCVs3mlL/z5+9Z8T6dsptRkpv
        oZOoZz+oxLYByRfjNCNFaq2U0OemLekI
X-Google-Smtp-Source: ABdhPJxlBAnuSeMbO6G2dvObyyrDJ6gjwUricuMX1GW3rhQQzBKJJEv4a1q8wOPag0d5i+6xfWq5fw==
X-Received: by 2002:a17:90a:9d88:: with SMTP id k8mr12379074pjp.141.1607676253388;
        Fri, 11 Dec 2020 00:44:13 -0800 (PST)
Received: from work ([103.59.133.81])
        by smtp.gmail.com with ESMTPSA id 21sm9490160pfx.84.2020.12.11.00.44.10
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 11 Dec 2020 00:44:12 -0800 (PST)
Date:   Fri, 11 Dec 2020 14:14:06 +0530
From:   Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Hemant Kumar <hemantk@codeaurora.org>,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        jhugo@codeaurora.org, bbhatt@codeaurora.org,
        loic.poulain@linaro.org, netdev@vger.kernel.org
Subject: Re: [PATCH v17 3/3] bus: mhi: Add userspace client interface driver
Message-ID: <20201211084406.GD4222@work>
References: <1607670251-31733-1-git-send-email-hemantk@codeaurora.org>
 <1607670251-31733-4-git-send-email-hemantk@codeaurora.org>
 <X9MjXWABgdJIpyIw@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <X9MjXWABgdJIpyIw@kroah.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Greg,

On Fri, Dec 11, 2020 at 08:44:29AM +0100, Greg KH wrote:
> On Thu, Dec 10, 2020 at 11:04:11PM -0800, Hemant Kumar wrote:
> > This MHI client driver allows userspace clients to transfer
> > raw data between MHI device and host using standard file operations.
> > Driver instantiates UCI device object which is associated to device
> > file node. UCI device object instantiates UCI channel object when device
> > file node is opened. UCI channel object is used to manage MHI channels
> > by calling MHI core APIs for read and write operations. MHI channels
> > are started as part of device open(). MHI channels remain in start
> > state until last release() is called on UCI device file node. Device
> > file node is created with format
> > 
> > /dev/<mhi_device_name>
> > 
> > Currently it supports QMI channel. libqmi is userspace MHI client which
> > communicates to a QMI service using QMI channel. libqmi is a glib-based
> > library for talking to WWAN modems and devices which speaks QMI protocol.
> > For more information about libqmi please refer
> > https://www.freedesktop.org/wiki/Software/libqmi/
> 
> This says _what_ this is doing, but not _why_.
> 
> Why do you want to circumvent the normal user/kernel apis for this type
> of device and move the normal network handling logic out to userspace?
> What does that help with?  What does the current in-kernel api lack that
> this userspace interface is going to solve, and why can't the in-kernel
> api solve it instead?
> 

Well, this driver is not moving the network handling logic out. Instead
this driver just exposes a channel which can be used to configure the
modem using the existing userspace library like libqmi. Then the networking
logic is handled by a separate in kernel driver called mhi-net which is queued
for v5.11.

This is same for most of the Qualcomm USB modems as well. They expose a chardev
node like /dev/cdc_wdm0 for configuration and once configured the networking
logic is handled by usual network interface wwan0.

The difference here is that the underlying physical layer is PCIe and there is
this MHI bus which sits on top of it.

> You are pushing a common user/kernel api out of the kernel here, to
> become very device-specific, with no apparent justification as to why
> this is happening.
> 
> Also, because you are going around the existing network api, I will need
> the networking maintainers to ack this type of patch.
> 

No, this driver is not at all touching the networking part. As said, the
networking logic is all handled by mhi-net driver.

Thanks,
Mani
> thanks,
> 
> greg k-h
