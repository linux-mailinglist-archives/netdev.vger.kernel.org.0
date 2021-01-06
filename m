Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4335F2EBFCF
	for <lists+netdev@lfdr.de>; Wed,  6 Jan 2021 15:48:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727307AbhAFOrV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jan 2021 09:47:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726780AbhAFOrU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jan 2021 09:47:20 -0500
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23B2BC06134C;
        Wed,  6 Jan 2021 06:46:40 -0800 (PST)
Received: by mail-pg1-x535.google.com with SMTP id 30so2367442pgr.6;
        Wed, 06 Jan 2021 06:46:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=8RtYlRfwSJShEtBkKPbMykBunRB098Pg/K11epxtPxI=;
        b=egbitT1INxyeLUr11UWjnSvF8BO5JDX3uwAHGYuayo2WKCdYKyqsbJKi3RxNAuAr49
         1GV376HCoB/tMwz7tbtzSzx0eCBxZiLvzCUfSik9b7fwDIR+nkgjeBxvimQxmqyVtOHg
         keX26FZ/Vbvsp+ODDw/GMDDCePrsCpmEB+JLmLsTI9gIyLF9P0uv2vWnC44W3nytPrCN
         0ns7h0pKyNH9vdgBmesS3eBuVQoj4m7FOJAOc4LEz5iQtBa67e7VXq6B3pL6yd9ylAHM
         dasbVBcM0JggxFKiokizl+IzXfHfLFMGVybjZqIKSQd/8CJxAPwRvDJLWdPijl3GBQOe
         ULxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=8RtYlRfwSJShEtBkKPbMykBunRB098Pg/K11epxtPxI=;
        b=qhU3xGRYTZPHYso0BNRZlYUVGRjPBoU5hZ5GYr57bb8mKbpPBhjZnzzxoL+1w0HKZ5
         AMqXFgpNjbnn8uPsxp01PxNsLwLEwFsasYrVKDCUPCGIkISbhAAGx65hbjjNXivKYhG5
         +dGQRvLpNtnaDh0pWB7dNO7kktTviBAwLw7AyI5grMIC1EMBVBAwevXgtGv/q6uBOq5S
         KUR6FcTC/1EpmfmKlrE2K8cGquLqMwzsSUDpNlNF6gkhX0h7JN9fVy/khTlAwy9okhyk
         rddz17Gkmixptux0/C2aLIAB0Q7VDUe9Nuazu/+3WnKOI2NL2W6FPGtaPJE4wZ9U31ZH
         44vA==
X-Gm-Message-State: AOAM533Dx49CWM4AuI1PA6T+Letb37NgV3vb8X7WejO8kYn7G9jm/w0y
        zDXzOO5ViHtJzLE8clDUnLc=
X-Google-Smtp-Source: ABdhPJyFqDZnj+I7FglNtd+4tePEgR3ckAW9tRvGDoyFDBxKOlhvMZrxJMCN2niIWSR/0fpQa47b5w==
X-Received: by 2002:a63:fe05:: with SMTP id p5mr4864089pgh.161.1609944399759;
        Wed, 06 Jan 2021 06:46:39 -0800 (PST)
Received: from hoboy.vegasvil.org (c-73-241-114-122.hsd1.ca.comcast.net. [73.241.114.122])
        by smtp.gmail.com with ESMTPSA id q23sm2867001pfg.192.2021.01.06.06.46.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Jan 2021 06:46:39 -0800 (PST)
Date:   Wed, 6 Jan 2021 06:46:36 -0800
From:   Richard Cochran <richardcochran@gmail.com>
To:     Randy Dunlap <rdunlap@infradead.org>
Cc:     linux-kernel@vger.kernel.org, kernel test robot <lkp@intel.com>,
        netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH] ptp: ptp_ines: prevent build when HAS_IOMEM is not set
Message-ID: <20210106144636.GB10150@hoboy.vegasvil.org>
References: <20210106042531.1351-1-rdunlap@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210106042531.1351-1-rdunlap@infradead.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 05, 2021 at 08:25:31PM -0800, Randy Dunlap wrote:
> ptp_ines.c uses devm_platform_ioremap_resource(), which is only
> built/available when CONFIG_HAS_IOMEM is enabled.
> CONFIG_HAS_IOMEM is not enabled for arch/s390/, so builds on S390
> have a build error:
> 
> s390-linux-ld: drivers/ptp/ptp_ines.o: in function `ines_ptp_ctrl_probe':
> ptp_ines.c:(.text+0x17e6): undefined reference to `devm_platform_ioremap_resource'
> 
> Prevent builds of ptp_ines.c when HAS_IOMEM is not set.

Acked-by: Richard Cochran <richardcochran@gmail.com>
