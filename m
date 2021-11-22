Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C07A045888D
	for <lists+netdev@lfdr.de>; Mon, 22 Nov 2021 05:11:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230033AbhKVEOW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Nov 2021 23:14:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229983AbhKVEOU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 21 Nov 2021 23:14:20 -0500
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F35BC061574
        for <netdev@vger.kernel.org>; Sun, 21 Nov 2021 20:11:15 -0800 (PST)
Received: by mail-pj1-x1033.google.com with SMTP id nh10-20020a17090b364a00b001a69adad5ebso14125235pjb.2
        for <netdev@vger.kernel.org>; Sun, 21 Nov 2021 20:11:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=doOlBozltHIgVrhnH/EDMERan++AjUdJfibC8ED5qds=;
        b=kvJB2GWbZnyj1V0FedAmCYFs/9x0nN7AZFBMOEGbZGRg2+SHumcqiAPedrzVrTMsbS
         Up0HS4K0TDnbHS5n3xnUieAo5NpZjIlXFFSUZIVQXvbqILEuRfAJ0IZr41ymA00PopFe
         +uykUB/g3szpSA6xuF/YtxPzo7XLy9X7gRtylx/PI2ylDbnS9Ibp1okQQ9K0WnIbRtsL
         E4rlGE3b9oGWXYYP9pFds8Qjg2FQOCyKYt5dS7zBJaYYSQontOMol5LfFYr4CkqdO4nm
         IAksDXZgF0qC/5BRoBLQiLPKehbhdaWv84M66b3wbtQR4v7xwv3VV0OHLQT4D3VCwflt
         Smkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=doOlBozltHIgVrhnH/EDMERan++AjUdJfibC8ED5qds=;
        b=EkitHMCj/UFNa8To/7hqdEUYnht1fCwmPwty4ktlfkxE0hbS2nw7F0xQxeAk6hWQ0t
         j1bJNewa6eIFX3pPF+FZW3O1BfRIVH/amiTXfNG71V6b10CRT4/LVwfuL1Z0RFbxUUmv
         6F1Oa03nRx/noFCWNmubc3DrQkuyY1mgYSGdtIjmAk+hO8LcSn6XnI2IHSLyhm/HoD1i
         dqoOXv0nHYyj96sBrptOd0OuvNZjFXiuwW0M2L+vhSCW9I6YmZGJ8rsLHqSH6KTctP7x
         M5QZ9eCR4mHCt9EKbDIJYDF8XLe9SNfbotSkuwN9KROIeLdUnYmHkJ7gRvw1264EmBc2
         ktuw==
X-Gm-Message-State: AOAM531gIEzxL14J+y21w8P1pACy/5wTDGGnLNWuyKyqnjNZdPJHlrbk
        LWvMk6nEiFfAxWeZhRJZOk00DA==
X-Google-Smtp-Source: ABdhPJzKOQgZnikkPV+HZzCyd49ADcPN6Ci17WPy6iPD6aKQot2NoX/BehogRav3ZbU/rvzJuznjeQ==
X-Received: by 2002:a17:90a:6886:: with SMTP id a6mr27735235pjd.78.1637554274562;
        Sun, 21 Nov 2021 20:11:14 -0800 (PST)
Received: from hermes.local (204-195-33-123.wavecable.com. [204.195.33.123])
        by smtp.gmail.com with ESMTPSA id c3sm6750804pfm.177.2021.11.21.20.11.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 21 Nov 2021 20:11:14 -0800 (PST)
Date:   Sun, 21 Nov 2021 20:11:11 -0800
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Parav Pandit <parav@nvidia.com>
Cc:     David Ahern <dsahern@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH iproute2] vdpa: align uapi headers
Message-ID: <20211121201111.043f8be9@hermes.local>
In-Reply-To: <PH0PR12MB54816468137C264E45CCE9C6DC9F9@PH0PR12MB5481.namprd12.prod.outlook.com>
References: <20211118180000.30627-1-stephen@networkplumber.org>
        <163725900883.587.15945763914190641822.git-patchwork-notify@kernel.org>
        <PH0PR12MB54816468137C264E45CCE9C6DC9F9@PH0PR12MB5481.namprd12.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 22 Nov 2021 02:52:29 +0000
Parav Pandit <parav@nvidia.com> wrote:

> > From: patchwork-bot+netdevbpf@kernel.org <patchwork-  
> > bot+netdevbpf@kernel.org>  
> > 
> > Hello:
> > 
> > This patch was applied to iproute2/iproute2.git (main) by Stephen Hemminger
> > <stephen@networkplumber.org>:
> > 
> > On Thu, 18 Nov 2021 10:00:00 -0800 you wrote:  
> > > Update vdpa headers based on 5.16.0-rc1 and remove redundant copy.
> > >
> > > Signed-off-by: Stephen Hemminger <stephen@networkplumber.org>
> > > ---
> > >  include/uapi/linux/vdpa.h            | 47 ----------------------------  
> 
> This will conflict with commit [1] in iproute2-next branch.
> [1] https://git.kernel.org/pub/scm/network/iproute2/iproute2-next.git/commit/?h=master&id=a21458fc35336108acd4b75b4d8e1ef7f7e7d9a1

No worries, Dave will do a header merge.
