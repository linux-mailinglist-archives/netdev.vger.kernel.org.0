Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 593BD2F4E8C
	for <lists+netdev@lfdr.de>; Wed, 13 Jan 2021 16:29:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727146AbhAMP1L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jan 2021 10:27:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725801AbhAMP1L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jan 2021 10:27:11 -0500
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F809C061575
        for <netdev@vger.kernel.org>; Wed, 13 Jan 2021 07:26:31 -0800 (PST)
Received: by mail-pg1-x530.google.com with SMTP id n10so1684166pgl.10
        for <netdev@vger.kernel.org>; Wed, 13 Jan 2021 07:26:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Lmjyj7ebj6/bPHrUzXoSHwO5YPOwsA82BRIBKAamqyE=;
        b=GBYYtAFPKZvvHfQG+qnZoBvjAuPUCQ/PngIcebheEfiMMh63gy152/9E/TebFuYPAb
         /m+y/aEdM0H+JdmuEDCaS+cjyA2+D1Ao7AWc6n2pdVF82GAZSY6ZJg7Ln4MAp/nVA51y
         usk+ti1kTdrECNr4VlPIbUDDthiFebq1u64iYqPS2oiSkAxHPRQJhuvTwtbzG3KAn/lh
         XJSoJK2AV2c6uonf+XOPcjtZ9/oUkvCGYZH1QU1CBB9P9fjAZpscQaXPEvkzKzn3diDR
         A66pXU2rtt3sq1ptdEHdAS08ClCiSkwhGPXMjkJzKx31THN/pMcOZCpTwqGlLMEZRSJc
         Qb0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=Lmjyj7ebj6/bPHrUzXoSHwO5YPOwsA82BRIBKAamqyE=;
        b=Q8GYgSGb0RXSn5lS6ahWJTYRwQqVj7l2I4i7chvNp7AD15xrFQA17hHqy5yKgCRLHi
         X0p5TsfiPyG8H/+gailYpLshQwng76OTPylhgKJPpsaEi5QV1rmNC3FlcKlz3ammATzx
         waWsCCcNtMU90cP3Z+s2OcPV1sAuKhhBzrS8UHeEodij7ESDeviBZYx1uoUUQCwH7gaU
         XQAt1Tt3jzZYSxZDuPlj1HSkWqRUxp8/iKXf4QPaXkxiUuqFDVkdBzaICKOhZZZhky2S
         k/LmnknFj/zgVT/442oALJWWTsXciQev19X0PKVKf2BIQ0W2MiEKgqi2uvQV7cdFNmJt
         5HiQ==
X-Gm-Message-State: AOAM532zKksb4ewiUGrH6c59bGYKfHJ5DoTPEYfh701OH9Bdi3CUvqiw
        zFtWCVT2WJ/nm1MLtRLht/Eb
X-Google-Smtp-Source: ABdhPJzKTs4llV7m508zvZrYupWja/bBdVlgzIkoq4KzgU9bfDVVmE9+UHSYyJPSJDifMDNPkrRr5g==
X-Received: by 2002:a62:2585:0:b029:1ab:7fb7:b965 with SMTP id l127-20020a6225850000b02901ab7fb7b965mr2651009pfl.2.1610551590407;
        Wed, 13 Jan 2021 07:26:30 -0800 (PST)
Received: from work ([103.77.37.157])
        by smtp.gmail.com with ESMTPSA id iw4sm3185236pjb.55.2021.01.13.07.26.27
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 13 Jan 2021 07:26:29 -0800 (PST)
Date:   Wed, 13 Jan 2021 20:56:25 +0530
From:   Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
To:     gregkh@linuxfoundation.org
Cc:     gregkh@linuxfoundation.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org, jhugo@codeaurora.org,
        bbhatt@codeaurora.org, loic.poulain@linaro.org,
        netdev@vger.kernel.org
Subject: Re: [RESEND PATCH v18 0/3] userspace MHI client interface driver
Message-ID: <20210113152625.GB30246@work>
References: <1609958656-15064-1-git-send-email-hemantk@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1609958656-15064-1-git-send-email-hemantk@codeaurora.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Greg,

On Wed, Jan 06, 2021 at 10:44:13AM -0800, Hemant Kumar wrote:
> This patch series adds support for UCI driver. UCI driver enables userspace
> clients to communicate to external MHI devices like modem. UCI driver probe
> creates standard character device file nodes for userspace clients to
> perform open, read, write, poll and release file operations. These file
> operations call MHI core layer APIs to perform data transfer using MHI bus
> to communicate with MHI device. 
> 
> This interface allows exposing modem control channel(s) such as QMI, MBIM,
> or AT commands to userspace which can be used to configure the modem using
> tools such as libqmi, ModemManager, minicom (for AT), etc over MHI. This is
> required as there are no kernel APIs to access modem control path for device
> configuration. Data path transporting the network payload (IP), however, is
> routed to the Linux network via the mhi-net driver. Currently driver supports
> QMI channel. libqmi is userspace MHI client which communicates to a QMI
> service using QMI channel. Please refer to
> https://www.freedesktop.org/wiki/Software/libqmi/ for additional information
> on libqmi.
> 
> Patch is tested using arm64 and x86 based platform.
> 

This series looks good to me and I'd like to merge it into mhi-next. You
shared your reviews on the previous revisions, so I'd like to get your
opinion first.

Thanks,
Mani

> V18:
> - Updated commit text for UCI to clarify why this driver is required for QMI
>   over MHI. Also updated cover letter with same information.
> 
> v17:
> - Updated commit text for UCI driver by mentioning about libqmi open-source
>   userspace program that will be talking to this UCI kernel driver.
> - UCI driver depends upon patch "bus: mhi: core: Add helper API to return number
>   of free TREs".
> 
> v16:
> - Removed reference of WLAN as an external MHI device in documentation and
>   cover letter.
> 
> v15:
> - Updated documentation related to poll and release operations.
> 
> V14:
> - Fixed device file node format to /dev/<mhi_dev_name> instead of
>   /dev/mhi_<mhi_dev_name> because "mhi" is already part of mhi device name.
>   For example old format: /dev/mhi_mhi0_QMI new format: /dev/mhi0_QMI.
> - Updated MHI documentation to reflect index mhi controller name in
>   QMI usage example.
> 
> V13:
> - Removed LOOPBACK channel from mhi_device_id table from this patch series.
>   Pushing a new patch series to add support for LOOPBACK channel and the user
>   space test application. Also removed the description from kernel documentation.
> - Added QMI channel to mhi_device_id table. QMI channel has existing libqmi
>   support from user space.
> - Updated kernel Documentation for QMI channel and provided external reference
>   for libqmi.
> - Updated device file node name by appending mhi device name only, which already
>   includes mhi controller device name.
> 
> V12:
> - Added loopback test driver under selftest/drivers/mhi. Updated kernel
>   documentation for the usage of the loopback test application.
> - Addressed review comments for renaming variable names, updated inline
>   comments and removed two redundant dev_dbg.
> 
> V11:
> - Fixed review comments for UCI documentation by expanding TLAs and rewording
>   some sentences.
> 
> V10:
> - Replaced mutex_lock with mutex_lock_interruptible in read() and write() file
>   ops call back.
> 
> V9:
> - Renamed dl_lock to dl_pending _lock and pending list to dl_pending for
>   clarity.
> - Used read lock to protect cur_buf.
> - Change transfer status check logic and only consider 0 and -EOVERFLOW as
>   only success.
> - Added __int to module init function.
> - Print channel name instead of minor number upon successful probe.
> 
> V8:
> - Fixed kernel test robot compilation error by changing %lu to %zu for
>   size_t.
> - Replaced uci with UCI in Kconfig, commit text, and comments in driver
>   code.
> - Fixed minor style related comments.
> 
> V7:
> - Decoupled uci device and uci channel objects. uci device is
>   associated with device file node. uci channel is associated
>   with MHI channels. uci device refers to uci channel to perform
>   MHI channel operations for device file operations like read()
>   and write(). uci device increments its reference count for
>   every open(). uci device calls mhi_uci_dev_start_chan() to start
>   the MHI channel. uci channel object is tracking number of times
>   MHI channel is referred. This allows to keep the MHI channel in
>   start state until last release() is called. After that uci channel
>   reference count goes to 0 and uci channel clean up is performed
>   which stops the MHI channel. After the last call to release() if
>   driver is removed uci reference count becomes 0 and uci object is
>   cleaned up.
> - Use separate uci channel read and write lock to fine grain locking
>   between reader and writer.
> - Use uci device lock to synchronize open, release and driver remove.
> - Optimize for downlink only or uplink only UCI device.
> 
> V6:
> - Moved uci.c to mhi directory.
> - Updated Kconfig to add module information.
> - Updated Makefile to rename uci object file name as mhi_uci
> - Removed kref for open count
> 
> V5:
> - Removed mhi_uci_drv structure.
> - Used idr instead of creating global list of uci devices.
> - Used kref instead of local ref counting for uci device and
>   open count.
> - Removed unlikely macro.
> 
> V4:
> - Fix locking to protect proper struct members.
> - Updated documentation describing uci client driver use cases.
> - Fixed uci ref counting in mhi_uci_open for error case.
> - Addressed style related review comments.
> 
> V3: Added documentation for MHI UCI driver.
> 
> V2:
> - Added mutex lock to prevent multiple readers to access same
> - mhi buffer which can result into use after free.
> 
> Hemant Kumar (3):
>   bus: mhi: core: Move MHI_MAX_MTU to external header file
>   docs: Add documentation for userspace client interface
>   bus: mhi: Add userspace client interface driver
> 
>  Documentation/mhi/index.rst     |   1 +
>  Documentation/mhi/uci.rst       |  95 ++++++
>  drivers/bus/mhi/Kconfig         |  13 +
>  drivers/bus/mhi/Makefile        |   3 +
>  drivers/bus/mhi/core/internal.h |   1 -
>  drivers/bus/mhi/uci.c           | 664 ++++++++++++++++++++++++++++++++++++++++
>  include/linux/mhi.h             |   3 +
>  7 files changed, 779 insertions(+), 1 deletion(-)
>  create mode 100644 Documentation/mhi/uci.rst
>  create mode 100644 drivers/bus/mhi/uci.c
> 
> -- 
> The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
> a Linux Foundation Collaborative Project
> 
