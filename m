Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 901D028CE84
	for <lists+netdev@lfdr.de>; Tue, 13 Oct 2020 14:40:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727924AbgJMMkL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Oct 2020 08:40:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726636AbgJMMkJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Oct 2020 08:40:09 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD804C0613D0;
        Tue, 13 Oct 2020 05:40:09 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id n9so17457174pgf.9;
        Tue, 13 Oct 2020 05:40:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=IAvUP/SNXLFWxPseN2fkYDuXWsWTQevluoDNd3o/wiE=;
        b=a+Je3JWpw3FL7os4ZqiD3XA9NL0oSpxM0YnjdnfgkgtJQLYJjWrN7QT1u9FfXXU8HE
         ggrhutr+bnD3phA9Wd1Rqb8sOjd64N9OZrcKL8u0MI+W9ewmyNCmYKa6FbFOenT/IXjI
         FIQtbvANvAMrmPUgeoeimxg0EF5D+PW79hLdGr1BP9/Quh8k4dlLZfNEFUXJREggJcHX
         +L+uZR9LkgeItna44i0RCBqeyg1cVO10yNcZgeTwJq+RUWceVfkbwdo9EFYlSPSYwbu4
         LVFwtpmRe/GP1BSylfjMC9GBoZkvD3wJkR1fAjjaUenF2g5yEoxSNT8qDPw35HfnKkEy
         qsGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=IAvUP/SNXLFWxPseN2fkYDuXWsWTQevluoDNd3o/wiE=;
        b=PX5ltDAb43/xwFgL/Qgq0ZWkQ+u0k3rM1c/VMjYfWTPG0a++VehG/4u61/y7wdVDFw
         RC/cX1ZWuntbgXKp6JiP/fWqXgqXAz1IWk1niK4x3HWzgt3AKavS3HKLNCzJu6rupDuL
         6efzCvtKkgHV6jDZ/AflQ7ZasgkdjCfp4RL2EhuJsz5Okw5jIJKzYbR5I+Q7tghgX71w
         VsmsxHDg8hbP4v+3MJtpfuL7j5NoPM+1nzqK7EEhYNRFNBeF3yK0uY1Zig9I2vPTmxuE
         6OXAiCKBG6VpP9oGq/EzkS11GhO+z+AAPCFAs1nCMhy1HEeJywZTVo/9gbOkhxdXWXw/
         qabQ==
X-Gm-Message-State: AOAM53143FINPxEUxIFwsHcZEPQbmU8tHa3m6PJERBBGyWUpqMCdzyX/
        ZPYOD8b4cMslv3VVQfeks1+i7BEIYNc=
X-Google-Smtp-Source: ABdhPJxTBI8AyiLXFUzbUiJSkyZ9P2ttFTS6jansX6Tfmf13/pt+pyUqxOdHLiKIMveW1lByAO5sOg==
X-Received: by 2002:a62:6082:0:b029:156:5cab:1bfc with SMTP id u124-20020a6260820000b02901565cab1bfcmr5081745pfb.69.1602592809338;
        Tue, 13 Oct 2020 05:40:09 -0700 (PDT)
Received: from hoboy (c-73-241-114-122.hsd1.ca.comcast.net. [73.241.114.122])
        by smtp.gmail.com with ESMTPSA id i7sm22277297pfo.208.2020.10.13.05.40.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Oct 2020 05:40:08 -0700 (PDT)
Date:   Tue, 13 Oct 2020 05:40:06 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Tom Rix <trix@redhat.com>
Cc:     natechancellor@gmail.com, ndesaulniers@google.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        clang-built-linux@googlegroups.com
Subject: Re: [PATCH] ptp: ptp_clockmatrix: initialize variables
Message-ID: <20201013124006.GA10454@hoboy>
References: <20201011200955.29992-1-trix@redhat.com>
 <20201012220126.GB1310@hoboy>
 <05da63b8-f1f5-9195-d156-0f2e7f3ea116@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <05da63b8-f1f5-9195-d156-0f2e7f3ea116@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 12, 2020 at 09:07:30PM -0700, Tom Rix wrote:
> calling function is a print information only function that returns void.

That is fine.

> I do think not adding error handling is worth it.
> 
> I could change the return and then the calls if if you like.

How about printing the version string when readable, and otherwise
print an appropriate informative error message?

Thanks,
Richard
