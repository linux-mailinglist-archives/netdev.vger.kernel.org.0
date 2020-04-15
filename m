Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2D671AADAB
	for <lists+netdev@lfdr.de>; Wed, 15 Apr 2020 18:32:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1415510AbgDOQR2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Apr 2020 12:17:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S2410350AbgDOQRV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Apr 2020 12:17:21 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8E00C061A0F
        for <netdev@vger.kernel.org>; Wed, 15 Apr 2020 09:17:20 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id g2so182954plo.3
        for <netdev@vger.kernel.org>; Wed, 15 Apr 2020 09:17:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=8qF0LUXdpindc5vOiwqFLokJsFdLR0vgnOBjxtQzWbs=;
        b=Mve6xxIT004adgNzucM9jYaZUdUKPTbB4pwhTsIrjJyXfWIjwyitHsnToKZ2/j7tXo
         VmFkPLz3yqdaiwSASSLGOvK7JOu8Kl0d2dIICLPS6AGnBQif9AGJeXnHs9V8by/mtclL
         qAsawvXA5/aCflai5s1gmEy5wct8dOm+XAOZg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=8qF0LUXdpindc5vOiwqFLokJsFdLR0vgnOBjxtQzWbs=;
        b=nPBgWu6jkCNuC1G8FN58npkaBsmZPUdOamBlKcsZxbuy8fk8siqG52mmmjGOctAwaA
         u4h+O8ZpF/p5HG6+luKHSSdvdT5lnVTI/GGF6UBXG4nCrbhRMa/ANL7acgFYqO2KV60D
         YtIJvd+w66nJ2jwJVRj3GCEtZQ63Gp2Zwx0Z9X0tyFcfkFAPbqHssePMz+5dAOklZcnM
         ZrbVmSOXT09wd/W87gSHnJdfFyR+Xae9LvBXNDKmQH5AhKg3c3KAgl6mKwFW2LWpn+VM
         /7RJXXoDOd1AoMNrr4Nq+UM0sResdlPBIO1YmwoZAHW60bLmaaCscYLK8ejpLF9XZ7/h
         OTTQ==
X-Gm-Message-State: AGi0PuZkWaBc3D+SSB0uisudVjXCe7E7dsinfxvBv3nF9qCFvTtyNa0p
        JkFQC7No8UTatuFNifwPvaYStw==
X-Google-Smtp-Source: APiQypLZs4xoFWXwCC6ACEShStmRbLORywovCATnaoYdHfDs8I1rBSwFVXIOkj5TOo8wqWByixut/Q==
X-Received: by 2002:a17:902:a40b:: with SMTP id p11mr5828336plq.304.1586967440145;
        Wed, 15 Apr 2020 09:17:20 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id u15sm13106471pgj.34.2020.04.15.09.17.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Apr 2020 09:17:19 -0700 (PDT)
Date:   Wed, 15 Apr 2020 09:17:18 -0700
From:   Kees Cook <keescook@chromium.org>
To:     shuah@kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        luto@amacapital.net, wad@chromium.org,
        linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-team@fb.com, Tim.Bird@sony.com
Subject: Re: [PATCH v5 0/5] kselftest: add fixture parameters
Message-ID: <202004150916.3A452C9@keescook>
References: <20200318010153.40797-1-kuba@kernel.org>
 <20200410172326.3ad05290@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200410172326.3ad05290@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 10, 2020 at 05:23:26PM -0700, Jakub Kicinski wrote:
> On Tue, 17 Mar 2020 18:01:48 -0700 Jakub Kicinski wrote:
> > Hi!
> > 
> > Shuah please consider applying to the kselftest tree.
> > 
> > This set is an attempt to make running tests for different
> > sets of data easier. The direct motivation is the tls
> > test which we'd like to run for TLS 1.2 and TLS 1.3,
> > but currently there is no easy way to invoke the same
> > tests with different parameters.
> > 
> > Tested all users of kselftest_harness.h.
> 
> Hi Shuah!
> 
> Were these applied anywhere? I'm happy to take them via 
> the networking tree if that's easier.

Shuah, with -rc1 out the door, would now be a good time to take this
series?

Thanks!

-Kees

-- 
Kees Cook
