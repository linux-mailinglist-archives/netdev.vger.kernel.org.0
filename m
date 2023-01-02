Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D650A65B358
	for <lists+netdev@lfdr.de>; Mon,  2 Jan 2023 15:32:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236129AbjABOcL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Jan 2023 09:32:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232572AbjABOcJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Jan 2023 09:32:09 -0500
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35157627B
        for <netdev@vger.kernel.org>; Mon,  2 Jan 2023 06:32:07 -0800 (PST)
Received: by mail-wm1-x32f.google.com with SMTP id k26-20020a05600c1c9a00b003d972646a7dso17641933wms.5
        for <netdev@vger.kernel.org>; Mon, 02 Jan 2023 06:32:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=lu/k05f1NEWZMOG5XEo4PoIdXKh0FG01idXkAFuGwis=;
        b=xaivG2C1NOOItU3tPWPJXQQOSNF0rnox5+v7eTiXuUEu/WlaalxjxYf7nVnRbddsn7
         62FmAXkuv6s+JtWPVHIOHWLT3BopT/HEmSwhRbgh8Cwr0tlEAdiqRYoc9db9jFHxhdEL
         y0l/UDpXiT357+eUdn71rSujJnMgXUXsZRnByYeqgY2Yn9yTGuojd0dllQdNO1TqFZiJ
         vdkp69pkoRNZBjXKpmzEPHiPrtm4jb+tR5fF03WnZnnfiyS65NQOOMdT8FVUWmLJ6vvu
         cFh3S/OtkqFeLDObSS5P84nh2q3+tI4YlMmOAH17PfzdL5uASFZYfihpadxpvM8u9Wzz
         qY+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lu/k05f1NEWZMOG5XEo4PoIdXKh0FG01idXkAFuGwis=;
        b=yiGkNXc0p9qu8ur+lxPMnjeFNxw7cG9Zgz4rdkyUQMZ4tH1u+Dy907IEfxCgngthTP
         9d64/O1jIG7rZuWDFzWBb7LdtnkrNHWzKrIRGpCLs8baOubcE2PtsnMNtz47GTHIb515
         u237P7w6aGPm926RDXxftcHT3ScmItrOK1Wa1eAtI7i5ApOkfYVj34i2xEDDG2CBeuDI
         zw6781ww0Gzp+1vChdTErqLo5LLQtSBJXKJSzzlAGyWTMynAW9AwD/D/HR/I7WFY2vfE
         ai/DL3DA4RbElpoHTY6bvbBRBbioLxFuSKFS5A9Q4N1hAseErRnN9KUw89KYGFAqN2rJ
         6Zjw==
X-Gm-Message-State: AFqh2kpFkam3teODNztTMbr1GteFnVo6feSaMlZJxLfgOCg01nqrSyyC
        iOxaA4FMejajtC/iAacXbGLJut2Us/5Hfx5O6r3Cqw==
X-Google-Smtp-Source: AMrXdXvbz8anMYZEDvz8v9X+CNzV66llvF+soeufBE0UIADFHoVd9cUPe2UyUVlyzImZjta+U3zbiA==
X-Received: by 2002:a05:600c:b90:b0:3d9:76fd:ee06 with SMTP id fl16-20020a05600c0b9000b003d976fdee06mr20120494wmb.32.1672669925799;
        Mon, 02 Jan 2023 06:32:05 -0800 (PST)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id e10-20020a5d594a000000b0028663fc8f4csm15803992wri.30.2023.01.02.06.32.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Jan 2023 06:32:05 -0800 (PST)
Date:   Mon, 2 Jan 2023 15:32:04 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     jacob.e.keller@intel.com, leon@kernel.org, netdev@vger.kernel.org
Subject: Re: [RFC net-next 05/10] devlink: remove the registration guarantee
 of references
Message-ID: <Y7Lq5KbFWjTDGmz0@nanopsycho>
References: <20221217011953.152487-1-kuba@kernel.org>
 <20221217011953.152487-6-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221217011953.152487-6-kuba@kernel.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sat, Dec 17, 2022 at 02:19:48AM CET, kuba@kernel.org wrote:
>

[...]


>Holding a reference will now only guarantee that the memory
>of the object is around. Another way of looking at it is that
>the reference now protects the object not its "registered" status.

This would help to understand what you are doing in patch 3. Perphaps it
would be fine to describe the goal in the cover letter?

