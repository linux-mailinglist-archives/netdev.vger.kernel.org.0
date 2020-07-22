Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB148228E92
	for <lists+netdev@lfdr.de>; Wed, 22 Jul 2020 05:26:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731944AbgGVDZ4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jul 2020 23:25:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731857AbgGVDZ4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jul 2020 23:25:56 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 432C6C061794;
        Tue, 21 Jul 2020 20:25:56 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id 1so443210pfn.9;
        Tue, 21 Jul 2020 20:25:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=gQbsv3O8chCGDoP1vhf1M08fp1fq+JOY4tf84UgzKIE=;
        b=ZZLUwzLsvl3w3lFXXYaTfVNXjnoSfxIc6fVXOhPBQkqOT3koZi9LH5uRNaaYcrzuhM
         ZqyQjJM7sQs19fE/cwgFejjId8TCAiG+4fLkkNvk5N91TmTZwCGxojctQqq062k3VXc5
         SFdTJmi6xD1qBWzlyXb4my/Z1cH1SXeHyivCxLisDyrXs711CeuNe4ukDBGmPmToclVR
         ViC/pYuptA9SaP0i7e0Os2IJ5VDqzaOVHwi5azyw6WrQBhmiIwABjjAlQ6Rjao9uY3Tq
         x4jhjR8V96mSUGhw6hSRcb93LnGMg6ibmJUt7i173rIUomRbNTnsOc4SjdifyQjawErk
         zk/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=gQbsv3O8chCGDoP1vhf1M08fp1fq+JOY4tf84UgzKIE=;
        b=YqXdvI+JCJxSZjGV5qOfO/oQD2F1lAN4XP5BSyqy2TvBRx4yURWCxb3AJSDhhmido7
         vo5WYhpTQMsAbXMJwGDFbaOszBNOpVa2fZuvqzFF5KFtpCfxhBLElJkb0BYBGLazvrW/
         0Di8QlPA81OrbUCPCh8TBYvM2AvFrKEZTLPHhY61XNBAM1kJXP3ZFVgP5C64I7uuPWmP
         t4rLbH8bUFjzZEy1LJI2Tv8UAePolp++HCFJgRNp0Sj2YkcA2q+eVht7f/uZwCPWWBJC
         pyrPsACGFSv/MZdhyaj3tn9HdNWfVqsdgQmqcP3pSvKOX8XuM0fuFu7/8IdVdo1rx+Ke
         sg6A==
X-Gm-Message-State: AOAM533tjzg76GZalC9IXj7xpO7i7OD0S/eMt7juM68zHGpC4tmfrz04
        nlLA44nDOTvITGTTIt2eNOM=
X-Google-Smtp-Source: ABdhPJyQ91A1Gpx6Hy/EXbqAdrl6AwIyIhgcRcCVnJVRU+ZA1Fw/WWIA9Feo0wnMV/dhGH0I66EC7w==
X-Received: by 2002:a62:195:: with SMTP id 143mr26238206pfb.226.1595388355837;
        Tue, 21 Jul 2020 20:25:55 -0700 (PDT)
Received: from hoboy (c-73-241-114-122.hsd1.ca.comcast.net. [73.241.114.122])
        by smtp.gmail.com with ESMTPSA id j16sm19271224pgb.33.2020.07.21.20.25.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Jul 2020 20:25:55 -0700 (PDT)
Date:   Tue, 21 Jul 2020 20:25:53 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Jacob Keller <jacob.e.keller@intel.com>, kuba@kernel.org,
        davem@davemloft.net, netdev@vger.kernel.org, sorganov@gmail.com,
        linux-doc@vger.kernel.org
Subject: Re: [PATCH net-next 3/3] docs: networking: timestamping: add a set
 of frequently asked questions
Message-ID: <20200722032553.GB12524@hoboy>
References: <20200717161027.1408240-1-olteanv@gmail.com>
 <20200717161027.1408240-4-olteanv@gmail.com>
 <e6b6f240-c2b2-b57c-7334-4762f034aae3@intel.com>
 <20200718113519.htopj6tgfvimaywn@skbuf>
 <887fcc0d-4f3d-3cb8-bdea-8144b62c5d85@intel.com>
 <20200720210518.5uddqqbjuci5wxki@skbuf>
 <0fb4754b-6545-f8dc-484f-56aee25796f6@intel.com>
 <20200720221314.xkdbw25nsjsyvgbv@skbuf>
 <20200721002150.GB21585@hoboy>
 <20200721195127.nxuxg6ef2h6cs3wj@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200721195127.nxuxg6ef2h6cs3wj@skbuf>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 21, 2020 at 10:51:27PM +0300, Vladimir Oltean wrote:
> So I think the position of "just don't have software timestamping code
> in DSA and you'll be fine" won't be getting us anywhere. Either you can
> or you can't, and there isn't anything absurd about it, so sooner or
> later somebody will want to do it. The rules surrounding it, however,
> are far from being ready, or clear.
> 
> Am I missing something?

I'm just trying to make things easy for you, as the author of DSA
drivers.  There is no need to set skb flags that have no purpose
within the stack.

Nobody is demanding software time stamps from any DSA devices yet, and
so I don't see the point in solving a problem that doesn't exist.

I'm sorry if the "rules" are not clear, but if you look around the
kernel internals, you will be hard pressed to find perfectly
documented rules anywhere!

Thanks,
Richard
