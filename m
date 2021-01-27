Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E17F3060F5
	for <lists+netdev@lfdr.de>; Wed, 27 Jan 2021 17:26:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237200AbhA0QZ1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jan 2021 11:25:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237138AbhA0QYp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jan 2021 11:24:45 -0500
Received: from mail-oi1-x229.google.com (mail-oi1-x229.google.com [IPv6:2607:f8b0:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC55AC061574
        for <netdev@vger.kernel.org>; Wed, 27 Jan 2021 08:24:05 -0800 (PST)
Received: by mail-oi1-x229.google.com with SMTP id n7so2702046oic.11
        for <netdev@vger.kernel.org>; Wed, 27 Jan 2021 08:24:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=GG0TpbUNYlPSbaljbB2iMXCGWpl1mkIqLneVjeynSxI=;
        b=npClNprtbGHfrypkEZsUQ3PuSwXQh/fi4c9lfxGBu8Qlf+BnFeh9oIQvmaP8+8tbzg
         OrJYeUVHzkqZyImR8NflmYa+Nf/2SdI+04KTcORok44TGC8U7hWuCUOqAnULmmC+bm3g
         BDLTVwmayP5Udz9KShPPO+COQcGKnWFs2do7trrl4gyeWwakPc/ptYhAEhfOYopdewzO
         6jxINa3vHCn8lzo1cpnHuZB5Wj1lOQcZannAvGVnHMbnR23NBsU6qbpwkWxzSG+vc7hw
         Ft37CYTOrgCk5VaqjPiq5S5Nnp8QFfESwq971Zd5052JPOhEmAlvgnXgrzJAqssrsJlE
         zDcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=GG0TpbUNYlPSbaljbB2iMXCGWpl1mkIqLneVjeynSxI=;
        b=HcCbixl4JMVI+JundAJiJUr2iCi07BwnflXN3bOwjfkAfDkNMxoBJWy3rcMNv6yeEE
         rrIjdZm8xE6X3L0OZqDZiTQy/clqtrtEcpuXc8xiYqzlxQM180wxzdreGqwgMqwEduv2
         5cCTQ6tAEcOcrIFGMNHCmQeme165LJ6exIJcJbgJUVnlAyKzcp1t8IJ1M0vhFPj7Od08
         yzBHYzdbJIjZyOYFo5UqdRv7anK9uW2cc8soZlX2Od/QSVosi2WEoY3dECOZCbNNq2nI
         PF3H/63rQWpD2JbMN1SA89WZhI1NIqYdqetaffmqXNt0vw9tbdyyrzTszizRRFtTQz6u
         X7Dw==
X-Gm-Message-State: AOAM533vQ0i09ryTHyd4a05HH2IwjD1j8hMdhyjKgX7r6YaeYM16yxKP
        zbiF3AVWt/uA0PgaU5ZkHQIWwKtJzosn5Q==
X-Google-Smtp-Source: ABdhPJxyRZTOu8oTpmszoVzALsoM139tiy9mfNWSYd34E76lJAP8S0iZ6e/JG3ZrP968DirOqzJ0Jw==
X-Received: by 2002:aca:4c03:: with SMTP id z3mr3710617oia.21.1611764645161;
        Wed, 27 Jan 2021 08:24:05 -0800 (PST)
Received: from builder.lan (104-57-184-186.lightspeed.austtx.sbcglobal.net. [104.57.184.186])
        by smtp.gmail.com with ESMTPSA id w194sm503278oiw.39.2021.01.27.08.24.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Jan 2021 08:24:04 -0800 (PST)
Date:   Wed, 27 Jan 2021 10:24:02 -0600
From:   Bjorn Andersson <bjorn.andersson@linaro.org>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        jhugo@codeaurora.org, bbhatt@codeaurora.org,
        loic.poulain@linaro.org, netdev@vger.kernel.org
Subject: Re: [RESEND PATCH v18 0/3] userspace MHI client interface driver
Message-ID: <YBGTooJ5tVgf1u/R@builder.lan>
References: <1609958656-15064-1-git-send-email-hemantk@codeaurora.org>
 <20210113152625.GB30246@work>
 <YBGDng3VhE1Yw6zt@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YBGDng3VhE1Yw6zt@kroah.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed 27 Jan 09:15 CST 2021, Greg KH wrote:

> On Wed, Jan 13, 2021 at 08:56:25PM +0530, Manivannan Sadhasivam wrote:
> > Hi Greg,
> > 
> > On Wed, Jan 06, 2021 at 10:44:13AM -0800, Hemant Kumar wrote:
> > > This patch series adds support for UCI driver. UCI driver enables userspace
> > > clients to communicate to external MHI devices like modem. UCI driver probe
> > > creates standard character device file nodes for userspace clients to
> > > perform open, read, write, poll and release file operations. These file
> > > operations call MHI core layer APIs to perform data transfer using MHI bus
> > > to communicate with MHI device. 
> > > 
> > > This interface allows exposing modem control channel(s) such as QMI, MBIM,
> > > or AT commands to userspace which can be used to configure the modem using
> > > tools such as libqmi, ModemManager, minicom (for AT), etc over MHI. This is
> > > required as there are no kernel APIs to access modem control path for device
> > > configuration. Data path transporting the network payload (IP), however, is
> > > routed to the Linux network via the mhi-net driver. Currently driver supports
> > > QMI channel. libqmi is userspace MHI client which communicates to a QMI
> > > service using QMI channel. Please refer to
> > > https://www.freedesktop.org/wiki/Software/libqmi/ for additional information
> > > on libqmi.
> > > 
> > > Patch is tested using arm64 and x86 based platform.
> > > 
> > 
> > This series looks good to me and I'd like to merge it into mhi-next. You
> > shared your reviews on the previous revisions, so I'd like to get your
> > opinion first.
> 
> If you get the networking people to give you an ack on this, it's fine
> with me.
> 

Why? As concluded in previous iterations of this series this does not
relate to networking.

Regards,
Bjorn
