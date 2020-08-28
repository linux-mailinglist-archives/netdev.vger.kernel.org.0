Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CEEBD255857
	for <lists+netdev@lfdr.de>; Fri, 28 Aug 2020 12:09:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729059AbgH1KIx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Aug 2020 06:08:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729019AbgH1KIi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Aug 2020 06:08:38 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68CFFC061232
        for <netdev@vger.kernel.org>; Fri, 28 Aug 2020 03:08:38 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id e16so761084wrm.2
        for <netdev@vger.kernel.org>; Fri, 28 Aug 2020 03:08:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=v5lZnMhxQ5xHaQDAvMt8o84hghDQ+psCSSy2/pA49/0=;
        b=kPoIVAiqq1QaZS578tG1TWbJT7hIKgNMnnpooLDBh97H/EMbG3iVtH5wj0bfTE86mG
         IxXT/saTC8D5kEgad8cU4Da0I0IcTci98+zeua0tD2+nPSoAu4MY8DYUUNzrUWHhnJqo
         cwh0iew9zJrJXF6YjIoLjrkxqZjmJfC7qx+L4uwzEc/PjO5dyMAhggI2KizmbfB87ZLE
         joIKezV6zFJq68p20wCYE08ZD2sgYJrh+r0jNVFcaSrnA7TedxHa4OtJXzI4Qhy2tQ1X
         DofqiSnbhcVP6SSruYC6CrHKgHDgFZBVacJcX189OpjMzoBgFKLysZoY2HdKE+vI3qy6
         R1zg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=v5lZnMhxQ5xHaQDAvMt8o84hghDQ+psCSSy2/pA49/0=;
        b=nAE0odzx0pGWZnb4m7vIgMLduCQxIG7+MXLziCO+5xmw46yM0j3Pc9K8/dedjejW1T
         fv62JlxsbqaSfoPX78gy4ANwrtVWx6xE5jw4AyGhYxua6JdBEMWVTzfaB6qQ5peGs4Zb
         VGxn/HZGLAGkGk0JzQI1nAcUtvvSDqiu3nvTbuNv8iGtqkMykwM+J3AUs4XIudAnCxiI
         c9zICzmDVMon5cz/N0mji/WDggJFMTmIojs9H7PLx815apWiUoRIGPiqCCwcuQ9TubMG
         G46AVILTXAgkAFrl/b0nrLznhpLJkLet4pIPM0f+v9L/jMFpDpWnkovEOh9TVx5kbubr
         z5DA==
X-Gm-Message-State: AOAM530T6UFHO6houCSERRLsGUQWHsliW+20JaBh1aX9i1o2oBvmGQC9
        1K5b8uN9SrkoAx67XUmD+kkpWw==
X-Google-Smtp-Source: ABdhPJwVvQEqQCgPU0h1cMou7BBaQ5dj2m3YsYRGYfBolRb7b1B/iW+2QQKgMONqUDvLgdIxn3DsDQ==
X-Received: by 2002:a5d:5446:: with SMTP id w6mr770934wrv.349.1598609317023;
        Fri, 28 Aug 2020 03:08:37 -0700 (PDT)
Received: from dell ([91.110.221.141])
        by smtp.gmail.com with ESMTPSA id g3sm1242071wrb.59.2020.08.28.03.08.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Aug 2020 03:08:36 -0700 (PDT)
Date:   Fri, 28 Aug 2020 11:08:34 +0100
From:   Lee Jones <lee.jones@linaro.org>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     Ondrej Zary <linux@zary.sk>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        davem@davemloft.net, kuba@kernel.org, linux-kernel@vger.kernel.org,
        Benjamin Reed <breed@users.sourceforge.net>,
        Javier Achirica <achirica@users.sourceforge.net>,
        Jean Tourrilhes <jt@hpl.hp.com>,
        Fabrice Bellet <fabrice@bellet.info>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 12/30] net: wireless: cisco: airo: Fix a myriad of coding
 style issues
Message-ID: <20200828100834.GG1826686@dell>
References: <20200814113933.1903438-1-lee.jones@linaro.org>
 <202008172335.02988.linux@zary.sk>
 <87v9h4le9z.fsf@codeaurora.org>
 <202008272223.57461.linux@zary.sk>
 <87lfhz9mdi.fsf@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87lfhz9mdi.fsf@codeaurora.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 28 Aug 2020, Kalle Valo wrote:

> Ondrej Zary <linux@zary.sk> writes:
> 
> > On Thursday 27 August 2020 09:49:12 Kalle Valo wrote:
> >> Ondrej Zary <linux@zary.sk> writes:
> >> 
> >> > On Monday 17 August 2020 20:27:06 Jesse Brandeburg wrote:
> >> >> On Mon, 17 Aug 2020 16:27:01 +0300
> >> >> Kalle Valo <kvalo@codeaurora.org> wrote:
> >> >> 
> >> >> > I was surprised to see that someone was using this driver in 2015, so
> >> >> > I'm not sure anymore what to do. Of course we could still just remove
> >> >> > it and later revert if someone steps up and claims the driver is still
> >> >> > usable. Hmm. Does anyone any users of this driver?
> >> >> 
> >> >> What about moving the driver over into staging, which is generally the
> >> >> way I understood to move a driver slowly out of the kernel?
> >> >
> >> > Please don't remove random drivers.
> >> 
> >> We don't want to waste time on obsolete drivers and instead prefer to
> >> use our time on more productive tasks. For us wireless maintainers it's
> >> really hard to know if old drivers are still in use or if they are just
> >> broken.
> >> 
> >> > I still have the Aironet PCMCIA card and can test the driver.
> >> 
> >> Great. Do you know if the airo driver still works with recent kernels?
> >
> > Yes, it does.
> 
> Nice, I'm very surprised that so old and unmaintained driver still
> works. Thanks for testing.

That's awesome.  Go Linux!

So where does this leave us from a Maintainership perspective?  Are
you still treating the driver as obsolete?  After this revelation, I
suggest not.  So let's make it better. :)

-- 
Lee Jones [李琼斯]
Senior Technical Lead - Developer Services
Linaro.org │ Open source software for Arm SoCs
Follow Linaro: Facebook | Twitter | Blog
