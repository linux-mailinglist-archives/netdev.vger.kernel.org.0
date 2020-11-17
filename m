Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 594BB2B5668
	for <lists+netdev@lfdr.de>; Tue, 17 Nov 2020 02:49:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726823AbgKQBtb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Nov 2020 20:49:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725730AbgKQBta (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Nov 2020 20:49:30 -0500
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 877D3C0613CF;
        Mon, 16 Nov 2020 17:49:30 -0800 (PST)
Received: by mail-pf1-x441.google.com with SMTP id v12so15925834pfm.13;
        Mon, 16 Nov 2020 17:49:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=qVlMrW/TYBHLQQxRZjCiFsfg0UaJrVYq50hk7EVwNTc=;
        b=CwKKHbTAbA9eRasruBLt5R49ZKjD9W11itiye3oGBbg6WbpVdMtSV7X4ADgqA08cVC
         AlYl096vNNQITnhdw/Bx+Dsbw4EyGHxIoRraox6xge9OqaFJqudfImT+6BkUow0v9I2U
         jmB7MovNElHNNOnGwOtwVMxM/QQXIdGlb9iwsVL/TS+gvIlAE/vP4HHxIKiFdSdBvtgp
         4cwbNblDGogluFOEtzPlIw4BUj9I+FosMqrrSkoGyMpPlEsHANszCB2eMK6JIYCOOoMy
         1UutzUqsbeJ5kEOGz16zDyJ7twmfaUw0PyDSrN3wWjUAEnWuGNGnvZO1zJztfXOZFKjb
         zlaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=qVlMrW/TYBHLQQxRZjCiFsfg0UaJrVYq50hk7EVwNTc=;
        b=SNRURmTEm7LwiYiYQABS+mm72AZlEd5gqIVp1r8quv4i457nDPfPjbEwtuswWNO+hv
         mr77PyzQc0NKGOgL774VmKDxrEkBeUb2laGLeC5/P9MRIab8LkhhpMHZdgDIKRvSlY+M
         UmqjpQ7i1P3CWX86JgGC4sP+INknjHins0EVGS7vUQd5X+zhlXw/8c0S2fZVq7J5Wqdn
         l+dNhoigOLY1mTPjIycP+jstzqnbgDtsr8eQ65fl7mPytl/+GSK3Ql2AbyX/KP6s6X+M
         9fWtkwwOFunan281kStpFCiwswLcCLSFZDDy9a4flv+t1BYjEd6CQyz1ixBiJsRwxSEu
         YTiw==
X-Gm-Message-State: AOAM5333dEVgZxwkJQwPUZNNMygVk/uCXlKfTB95nYHaghwp4eui68Vg
        hwqahPhBkFkkQSZKQTcC1gM=
X-Google-Smtp-Source: ABdhPJwgNjCXHUARq5qV1yIwzmK+tclFLwSQJ83ewczMR+FyB/eIGq90Nr+1wccTZGeCviNQsBsp7A==
X-Received: by 2002:a17:90a:5c86:: with SMTP id r6mr1877972pji.235.1605577769978;
        Mon, 16 Nov 2020 17:49:29 -0800 (PST)
Received: from hoboy.vegasvil.org (c-73-241-114-122.hsd1.ca.comcast.net. [73.241.114.122])
        by smtp.gmail.com with ESMTPSA id u197sm19850353pfc.127.2020.11.16.17.49.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Nov 2020 17:49:29 -0800 (PST)
Date:   Mon, 16 Nov 2020 17:49:26 -0800
From:   Richard Cochran <richardcochran@gmail.com>
To:     Vinicius Costa Gomes <vinicius.gomes@intel.com>
Cc:     Miroslav Lichvar <mlichvar@redhat.com>,
        intel-wired-lan@lists.osuosl.org, andre.guedes@intel.com,
        linux-pci@vger.kernel.org, netdev@vger.kernel.org,
        bhelgaas@google.com
Subject: Re: [Intel-wired-lan] [PATCH next-queue v2 3/3] igc: Add support for
 PTP getcrosststamp()
Message-ID: <20201117014926.GA26272@hoboy.vegasvil.org>
References: <20201114025704.GA15240@hoboy.vegasvil.org>
 <874klo7pwp.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <874klo7pwp.fsf@intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 16, 2020 at 05:06:30PM -0800, Vinicius Costa Gomes wrote:
> The PTM dialogs are a pair of messages: a Request from the endpoint (in
> my case, the NIC) to the PCIe root (or switch), and a Response from the
> other side (this message includes the Master Root Time, and the
> calculated propagation delay).
> 
> The interface exposed by the NIC I have allows basically to start/stop
> these PTM dialogs (I was calling them PTM cycles) and to configure the
> interval between each cycle (~1ms - ~512ms).

Ah, now I am starting to understand...

Just to be clear, this is yet another time measurement over PCIe,
different than the cross time stamp that we already have, right?

Also, what is the point of providing time measurements every 1
millisecond?

> Another thing of note, is that trying to start the PTM dialogs "on
> demand" syncronously with the ioctl() doesn't seem too reliable, it
> seems to want to be kept running for a longer time.

So, I think the simplest thing would be to have a one-shot
measurement, if possible.  Then you could use the existing API and let
the user space trigger the time stamps.

Thanks,
Richard
