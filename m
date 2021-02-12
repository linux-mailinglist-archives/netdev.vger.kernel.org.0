Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4545731A1BF
	for <lists+netdev@lfdr.de>; Fri, 12 Feb 2021 16:36:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232237AbhBLPd0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Feb 2021 10:33:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232191AbhBLPdP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Feb 2021 10:33:15 -0500
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B35EC061574;
        Fri, 12 Feb 2021 07:32:35 -0800 (PST)
Received: by mail-pg1-x532.google.com with SMTP id t25so6491298pga.2;
        Fri, 12 Feb 2021 07:32:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=WX/P9Y7j8yYly47Dz+Y05mhCHy0eD2ijBJOWsd7J+4c=;
        b=CCQFtbW9WwjHdN0fr59zZY5PmRmIIeLJRbVr0hfNUXXSKNI8yC2ul/BUTH/tqkjQSu
         Rb6iD4pFX3/Bv2v2T0otMhD7Krk9DECA6FGhW5Lj4Wfa61zvs22y+NS0EXFp0Bj8VHxQ
         jXFEKf1r9XE8+HMnjqgNUzukAgafQJQwvqNZqU4i0uoOmGJB6cJuaACjVFaopCiuTS8a
         aKG7ml6kLKmtjufQ9/tIZvffb+Q7Kw9245IWO/lGyTrGu3/PfCeg2t9KA8GDQ0O2ZYok
         /qFGKTdyFpMCBnxOQQrK20R00+/ombJ1CnLjZibdQka7IrWMWymK7x82BpuIeQFg1SdR
         /ONQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=WX/P9Y7j8yYly47Dz+Y05mhCHy0eD2ijBJOWsd7J+4c=;
        b=YRDhXhs/a6qLaDANFgHG+7UrLlBnyPlGVOBdzSEIHtESVNtzo7xNcAQRNz0YLvSa55
         x4+XBI1jWQMWZcchuDOA/MOSocKgt3MTlFcHS9YGTWrryKo3jZJ9neLKsBw4T+JbtSNm
         BLEtEStKgrELlpQGrzwMjRshy6aQpYTwntn83EqLC6TW+OADEAmeuyJc8mjQK1qBdaKv
         63ecOt108kquEs1W22VTtCYFASZ97b0XRIbXpeQPCtA/TKpO5cz9Lvvph9VL1XDfDc7q
         FkXAmINQULBjEdbC8JAAiUoJroarzohNeTQsEZ+rZzlo0ANh11kVmQ7mfn7fy7V8JwRf
         gsGw==
X-Gm-Message-State: AOAM532LZ/f8OV994vxFrGmZLzgwCvl7FKZaS4mzT6TBFhLtomKr6TcV
        1yDpM7m4cOkDeJI2XyIxwD6cRlsr+Gg=
X-Google-Smtp-Source: ABdhPJxVuGmJvFQD2hPlKHk+D5u8qJ0+u3wc46id29iPQO8Dy8JTDUolIHHlKkszEWU3fUmIdMC69Q==
X-Received: by 2002:a63:4507:: with SMTP id s7mr3677346pga.390.1613143954901;
        Fri, 12 Feb 2021 07:32:34 -0800 (PST)
Received: from hoboy.vegasvil.org (c-73-241-114-122.hsd1.ca.comcast.net. [73.241.114.122])
        by smtp.gmail.com with ESMTPSA id p2sm8978777pjj.0.2021.02.12.07.32.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Feb 2021 07:32:34 -0800 (PST)
Date:   Fri, 12 Feb 2021 07:32:32 -0800
From:   Richard Cochran <richardcochran@gmail.com>
To:     vincent.cheng.xh@renesas.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 2/2] ptp: ptp_clockmatrix: Add alignment of 1
 PPS to idtcm_perout_enable.
Message-ID: <20210212153232.GC23246@hoboy.vegasvil.org>
References: <1613104725-22056-1-git-send-email-vincent.cheng.xh@renesas.com>
 <1613104725-22056-3-git-send-email-vincent.cheng.xh@renesas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1613104725-22056-3-git-send-email-vincent.cheng.xh@renesas.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 11, 2021 at 11:38:45PM -0500, vincent.cheng.xh@renesas.com wrote:
> From: Vincent Cheng <vincent.cheng.xh@renesas.com>
> 
> When enabling output using PTP_CLK_REQ_PEROUT, need to align the output
> clock to the internal 1 PPS clock.
> 
> Signed-off-by: Vincent Cheng <vincent.cheng.xh@renesas.com>

Acked-by: Richard Cochran <richardcochran@gmail.com>
