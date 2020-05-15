Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 214501D4212
	for <lists+netdev@lfdr.de>; Fri, 15 May 2020 02:29:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728131AbgEOA3I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 May 2020 20:29:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727805AbgEOA3H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 May 2020 20:29:07 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9F13C061A0C
        for <netdev@vger.kernel.org>; Thu, 14 May 2020 17:29:07 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id n11so152539pgl.9
        for <netdev@vger.kernel.org>; Thu, 14 May 2020 17:29:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=9xz3JlEUYuYK9yBRHaMo5e7YTxCpaTGsNRLa7Dd3D9Y=;
        b=angKGpVIPbuAUqOFXNFPulb5qc0NQWGywMPHQksIXu4rbVVrwSopUvsbHG8oZy2Deh
         gRlWMjqJkj/G9zSmLbWlunMYA76S533N6LW42jlwZRlZTbQBAgHqaBddlNRpsd7f5VbZ
         8o/wEjTzDoGkbftDS8tjZstszzR2FB3WE+R1NPM0nX9N+t2gtN+5ubWXlV1szoJtsk2u
         tcZvmr/O8hk+iaWxcdTdT6ZqT61Yz1oUIUst3vjHIF8SVhuBrqLy2rc/jtODfaq1uqqI
         hYRWdeyZxPX4yjzV5ZDSv9tJIMZVl+a1MzwIM2fVFofWe8PHIZWmaVv26MIOCYsk2Q5x
         PxQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=9xz3JlEUYuYK9yBRHaMo5e7YTxCpaTGsNRLa7Dd3D9Y=;
        b=cV1vygDjTagUgbfaintn1x5kEY2yLySaIUR/CLAKfPjyZeu2iP6WtbyQfAmTEWEXqp
         CNWBKNq+Awua3Nyv735oNRYVHCASeNY8HIXNsBirKUXlymR76lv4lHlL0L4v1iZ/qbUY
         yKzokfIg1F1CkrekYtGN5Gjk3s5rOtjt5F2lNXCAQPkxamd7bdN2+kgN6ms1g0+M2BZ7
         iwKHf+wQA5DIwpyDDdVU+sxjaQaZqIhdSUTDdR2ZNivEJIkKL/U/x5EVDbwHQVl84Dhz
         q0i+JQ6ScYlNxGu04XtohUY6VMtaQEWkHOlUBDCWuzqLVLfvliSZ+0zp+ShjtuXRlodO
         VCHw==
X-Gm-Message-State: AOAM530L9ASmuJ8Kpctdz2ORjdgbh4EVm46QWrLGKWB1lE7T7bx2phFX
        2EuU5FlvWuYW1HvY2dtNE3A=
X-Google-Smtp-Source: ABdhPJzxh8oTc+eMQuQdwy5V8iYceM+OZ+SAEYkKLtbNfAH9JGMpTXqhtivQ+oe7hdH9VZO3QxBk/w==
X-Received: by 2002:a62:8888:: with SMTP id l130mr1176308pfd.140.1589502547143;
        Thu, 14 May 2020 17:29:07 -0700 (PDT)
Received: from localhost (c-73-241-114-122.hsd1.ca.comcast.net. [73.241.114.122])
        by smtp.gmail.com with ESMTPSA id w19sm317345pfq.43.2020.05.14.17.29.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 May 2020 17:29:06 -0700 (PDT)
Date:   Thu, 14 May 2020 17:29:04 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Olivier Dautricourt <olivier.dautricourt@orolia.com>
Cc:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [PATCH 2/3] net: uapi: Add HWTSTAMP_FLAGS_ADJ_FINE/ADJ_COARSE
Message-ID: <20200515002904.GA18192@localhost>
References: <20200514102808.31163-1-olivier.dautricourt@orolia.com>
 <20200514102808.31163-3-olivier.dautricourt@orolia.com>
 <20200514133809.GA18838@localhost>
 <20200514152041.GB12924@orolia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200514152041.GB12924@orolia.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 14, 2020 at 05:20:41PM +0200, Olivier Dautricourt wrote:
> Can't we consider this as a time stamp settings ?

No.  It really is not a time stamp setting at all.

> I don't see where we could put those driver-specific flags.
> That flag field was reserved for futher improvements so i found
> it acceptable to specify that here.

This field is for possible future changes in time stamps, not clock
inputs or servo modes.

Thanks,
Richard
