Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E03C1D5CCE
	for <lists+netdev@lfdr.de>; Sat, 16 May 2020 01:31:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727854AbgEOXam (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 May 2020 19:30:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726183AbgEOXam (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 May 2020 19:30:42 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A8F0C061A0C
        for <netdev@vger.kernel.org>; Fri, 15 May 2020 16:30:42 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id k19so1526365pll.9
        for <netdev@vger.kernel.org>; Fri, 15 May 2020 16:30:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=3/dvplDpbgVp9tPdbPh39Gyxm2F/qe5inqFsLRkTHiY=;
        b=ceiWf9qdEj6BFmK2QGCahtmOIkRubg981BQO6RWQ3ozmpoP2GrTTzRBlutrfREn+Ds
         PpweiLGyfZAdE0KhR5fxDrKgtWwmC4wcHEpLRBXYdJakvv+v11hsQGpubgnCoac8ajUj
         CBRVqkWG0ZGs7zLXUkP9YjOeG/BX2LJ3l9IH+Ls5fNxsmsSavPLY/3ntN9jBxW/cxw4z
         8SreBhLFKVxZAxod0PiEZxK+4idVAD9ZgjcgXphWtMC1JL7F47//2SiYfrKJW8rx4wGB
         0QN+QC/rKb9GWpCjIHKEiGPXIGBzFTuukGCUprn8GZkY3q1K2vheHtxPbiao2IMVCLDH
         rHYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=3/dvplDpbgVp9tPdbPh39Gyxm2F/qe5inqFsLRkTHiY=;
        b=tiL5nwJDMHI7qHKMW3e2koxrxarrX5hoQ1kEBe/jP8TOKVr3KY3MLTEtSpfcZlH1Y+
         VGAOIuyli0gT7rs5kUG9sg2asGncK45E9WJlOmjechbZr6AiZGUeguzGe7wL+agm5cJi
         eonVd2KopZA7Ltszfg48gYgPJlkV0WNfgH1JEShULwi+/bEAIIEYliu0raqBgGcLgGfb
         OUu2aVZXQ8WySn0xVXbleRgI81ytv6QH1XJyEKqqjTnZ3E+/NWvhX4gFVZUmgTF4g/a5
         yIHzSBwrJ2WUTs02kLXz7lHED9qTspu73cwDuXhnC7gH4ak97Q29vJ4mjYJYnO4TvXIY
         gMSA==
X-Gm-Message-State: AOAM5301VLQ3eYzoMDVL/DD5M3RFG3y3g1xowWSfDbVz6Z/Zq1t2iRD9
        TppIIf2neTOgSQn0SsV66bQ=
X-Google-Smtp-Source: ABdhPJyRllG971HZyVCKnL+MWKR3zT1v8uVeIw4cETSVyWespbcrU2b5GMyRYXmfBk52FuWMiJUB9Q==
X-Received: by 2002:a17:90a:ad49:: with SMTP id w9mr6076424pjv.20.1589585441974;
        Fri, 15 May 2020 16:30:41 -0700 (PDT)
Received: from localhost (c-73-241-114-122.hsd1.ca.comcast.net. [73.241.114.122])
        by smtp.gmail.com with ESMTPSA id d18sm2835013pfo.15.2020.05.15.16.30.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 May 2020 16:30:41 -0700 (PDT)
Date:   Fri, 15 May 2020 16:30:39 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Julien Beraud <julien.beraud@orolia.com>
Cc:     Olivier Dautricourt <olivier.dautricourt@orolia.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [PATCH 0/3] Patch series for a PTP Grandmaster use case using
 stmmac/gmac3 ptp clock
Message-ID: <20200515233039.GA12152@localhost>
References: <20200514102808.31163-1-olivier.dautricourt@orolia.com>
 <20200514135325.GB18838@localhost>
 <20200514150900.GA12924@orolia.com>
 <20200515003706.GB18192@localhost>
 <3a14f417-1ae1-9434-5532-4b3387f25d18@orolia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3a14f417-1ae1-9434-5532-4b3387f25d18@orolia.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 15, 2020 at 03:26:47PM +0200, Julien Beraud wrote:
> So the question is what interface could we use to configure a timestamping
> clock that has more than one functioning mode and which mode can be changed at
> runtime, but not while timestamping is running ?

Thanks for your detailed response.  Let me digest that and see what I
can come up with...

Thanks,
Richard
