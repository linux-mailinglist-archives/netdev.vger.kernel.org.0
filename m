Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3A2324EB20
	for <lists+netdev@lfdr.de>; Sun, 23 Aug 2020 06:16:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725885AbgHWEPm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Aug 2020 00:15:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725648AbgHWEPm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Aug 2020 00:15:42 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0449C061574
        for <netdev@vger.kernel.org>; Sat, 22 Aug 2020 21:15:41 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id u128so3080353pfb.6
        for <netdev@vger.kernel.org>; Sat, 22 Aug 2020 21:15:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Eiosga/qagR3C9gYuMR7EHBVLO+uLZbegdD5rhWbiSU=;
        b=rdwjo19YoaY7gwE0KX3I5hlr+Qja1Oq7gu9RcwSvo0vqozspi22t3IchXeYlqmpHg7
         d1Mzo7xTo4ilHpBlyz4HSXlMPIskV+X1/+MYxGnswbhEQNPJdl+cCf3CgCYj4akSsp95
         FOVMIhib3nzIGT/e4DQg4Nk9B/dySfoTF6jB0h7qtfj6BRoPYiuTBq7M6za2SW5ZbB1G
         wAr1ig+p0/YUUzPmNU9QwZgqUAVvUEWG4xEODMVnwtPt5eYsHuokqya3BvLqRyxX7cPc
         eVgIUkovx1kI38CzSGCSBNly0yDyn4kNqGH3ctkzRbEWRb/x4hEdKHXgiianvsegcPsu
         mvLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Eiosga/qagR3C9gYuMR7EHBVLO+uLZbegdD5rhWbiSU=;
        b=GYdMDyI6yLN4L7e1wlvJ1lANUQdO9BRjQTi3ykAlOPvqTr2ZZZRHJdb1tlrJ84ZgA1
         HHRd6S0syM3bVVWvbL6KcAGlZAa0DV9PqePrbUsZHC0iqG99wysciSvzmp1UAIuUnJAn
         jQhrvKpJWFkxm66H0kBuWaATG1EOGcNWxFOXkJM2Du+LX2HeQmZMen4dl56+6pj0H1dM
         SkE/VqCElOQ7lFbFGq0YahR5h1Rys26iWbBtrBr4KeDegVX0B5DuC4VfH6h7j5q4XGYD
         6mCbO1/W+nmj75Rz35/XEf5bW0vwjebJaIZm7T3NzKAIY1zqvJAEue54nGVwH1AERaIC
         0nTg==
X-Gm-Message-State: AOAM532QYeLxMeggw2/jnXohsLZ4APHgSDq7lUym6O9Tpd2FoCKnuPZs
        DRcJi5BDUs7+nZba9G+yS0iKag==
X-Google-Smtp-Source: ABdhPJw3AWXPJc4NQHorWrZQKh8kgFaW93zl4K6ZlfuMbq5YdJi2KXPlWC1ANoDGzTSeMpmqHkKK/Q==
X-Received: by 2002:a63:df10:: with SMTP id u16mr195683pgg.437.1598156141144;
        Sat, 22 Aug 2020 21:15:41 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id k29sm6903335pfp.142.2020.08.22.21.15.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 22 Aug 2020 21:15:40 -0700 (PDT)
Date:   Sat, 22 Aug 2020 21:15:32 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Murali Karicheri <m-karicheri2@ti.com>
Cc:     <davem@davemloft.net>, <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-api@vger.kernel.org>,
        <nsekhar@ti.com>, <vinicius.gomes@intel.com>
Subject: Re: [PATCH iproute2 v5 0/2] iplink: hsr: add support for creating
 PRP device
Message-ID: <20200822211532.53dc3270@hermes.lan>
In-Reply-To: <20200817211737.576-1-m-karicheri2@ti.com>
References: <20200817211737.576-1-m-karicheri2@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 17 Aug 2020 17:17:35 -0400
Murali Karicheri <m-karicheri2@ti.com> wrote:

> This series enhances the iproute2 iplink module to add support
> for creating PRP device similar to HSR. The kernel part of this
> is already merged to v5.9 master
> 
> v4 - addressed comment from Stephen Hemminger
>    - Sending this with a iproute2 prefix so that this can
>      be merged to v5.9 iprout2 if possible.
> v3 of the series is rebased to iproute2-next/master at
> git://git.kernel.org/pub/scm/network/iproute2/iproute2-next
> and send as v4.
> 
> Please apply this if looks good.
> 
> 
> Murali Karicheri (2):
>   iplink: hsr: add support for creating PRP device similar to HSR
>   ip: iplink: prp: update man page for new parameter
> 
>  ip/iplink_hsr.c       | 17 +++++++++++++++--
>  man/man8/ip-link.8.in |  9 ++++++++-
>  2 files changed, 23 insertions(+), 3 deletions(-)

Applied. Than
ks for updating
