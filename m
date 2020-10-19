Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0F2329276C
	for <lists+netdev@lfdr.de>; Mon, 19 Oct 2020 14:38:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727107AbgJSMiJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Oct 2020 08:38:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726336AbgJSMiH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Oct 2020 08:38:07 -0400
Received: from mail-io1-xd44.google.com (mail-io1-xd44.google.com [IPv6:2607:f8b0:4864:20::d44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 462CCC0613CE
        for <netdev@vger.kernel.org>; Mon, 19 Oct 2020 05:38:07 -0700 (PDT)
Received: by mail-io1-xd44.google.com with SMTP id k21so12680850ioa.9
        for <netdev@vger.kernel.org>; Mon, 19 Oct 2020 05:38:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=suWzC+GD3r7pieoIsN/5CBQnApuR/UOsCj7nxJ1ikTM=;
        b=meF9JUfFHpSw3d3WAXFY/WZvc9IYs2hDJR73mxvTvUn//ety26lLQ2NWodRDer0sjt
         3Uw0bLqXKgX9LJiQxzR2gmCBLpxBQt/X5ptmv2sUjjybdDuEyL+vBhy//TWQDmeo0/8J
         oJhnvuetY9spmu6CklG4rA2vDVjpNY5hsakJ9pnWpgW0rtHobrh7szZTIbtDkhsx13cU
         yA8oAfIv5qTpxPHZpojROJyzjMv0X+E1wle9MFAqwbKiXaM3YwwUFAby/tq6/fEJJBRv
         VPhSw4fXu5U0zlOcc2126ywkVyyUyAhlgL7o1LVjR5ec58/wEWu0GCOcEVoHY6zKtDL5
         1/ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=suWzC+GD3r7pieoIsN/5CBQnApuR/UOsCj7nxJ1ikTM=;
        b=Y6dLvkaVWhWrVmoKr4wU0Dw6kJrhGG4I+TBXOPmoE4MZ0SrrVIPR0I0LnRX/Dg+CCh
         0AUHk71axNfYflE+5o/Y+a90JMGyGdrZf5rrpoMXmk1zeiR0mhIuQp49SIXGL5NGamZT
         X6G6o5rLMaRmb+BUaFanxOiH/bncTYHHmyKF+mXqbAigR9RuIEd6P2x6F1wMWeADeNFz
         0MZmvJEC2qRXu38hUIzxMl9LBtkrNkb4NrJXib3n8afd7okXkkELhhd7eTby96wWuQK1
         p9+bLpqSSkc8SzPu6PHj1ItIS3G7ViX0KSHmH8B63WdlISmUOVlu3ynL+OvWpyjI7N3r
         kzmA==
X-Gm-Message-State: AOAM5309ChM4HzjBA3dy+hY/Y87b2WvN99Onky3x8VKGt4l+llPWkNLr
        Ov2dIBsyoOpMzECkPMCTqg==
X-Google-Smtp-Source: ABdhPJzj/r4KFeX32K/KqeHihdv87U4ZYT/3KlfCRb4Zm7qetAqVe5NlXobBNq0tTJ7Duzn94yfiRw==
X-Received: by 2002:a5d:9842:: with SMTP id p2mr10632550ios.113.1603111086683;
        Mon, 19 Oct 2020 05:38:06 -0700 (PDT)
Received: from ICIPI.localdomain ([136.56.89.69])
        by smtp.gmail.com with ESMTPSA id x5sm3054929ilc.15.2020.10.19.05.38.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Oct 2020 05:38:06 -0700 (PDT)
Date:   Mon, 19 Oct 2020 08:38:04 -0400
From:   Stephen Suryaputra <ssuryaextr@gmail.com>
To:     Mike Manning <mmanning@vyatta.att-mail.com>
Cc:     David Ahern <dsahern@gmail.com>, netdev@vger.kernel.org,
        sashal@kernel.org
Subject: Re: Why revert commit 2271c95 ("vrf: mark skb for multicast or
 link-local as enslaved to VRF")?
Message-ID: <20201019123804.GD11729@ICIPI.localdomain>
References: <20201018132436.GA11729@ICIPI.localdomain>
 <75fda8c7-adf3-06a4-298f-b75ac6e6969b@gmail.com>
 <20201018160624.GB11729@ICIPI.localdomain>
 <33c7f9b3-aec6-6327-53b3-3b54f74ddcf6@gmail.com>
 <544357d4-1481-8563-323a-addf8b89d9e4@vyatta.att-mail.com>
 <b407b5d0-13cd-a506-24dc-1d705f55275d@vyatta.att-mail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b407b5d0-13cd-a506-24dc-1d705f55275d@vyatta.att-mail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 19, 2020 at 01:24:26PM +0100, Mike Manning wrote:
> To clarify, the regression in 4.14 only occurred when the commit was
> used in isolation, not when applied with the rest of the series.
> 
> It may be worth mentioning that we had been extensively using the series
> in our local fork with 4.14 & 4.19 kernels before proceeding with
> submitting the series and then switching to 5.x kernel, so that may be
> an approach you can take.
> 
Thanks Mike and David. Yes, I think it's best to use it in our local
4.14 fork.

Regards,
Stephen.
