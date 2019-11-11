Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 03A69F7776
	for <lists+netdev@lfdr.de>; Mon, 11 Nov 2019 16:15:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726897AbfKKPPf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Nov 2019 10:15:35 -0500
Received: from mail-wm1-f49.google.com ([209.85.128.49]:38040 "EHLO
        mail-wm1-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726811AbfKKPPf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Nov 2019 10:15:35 -0500
Received: by mail-wm1-f49.google.com with SMTP id z19so13582097wmk.3
        for <netdev@vger.kernel.org>; Mon, 11 Nov 2019 07:15:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=7CRXAv0Q30uHbvgTQKtqRz4LZ54xLJ3KPEcsQm9BtW4=;
        b=hui7IRT5+hOUCZPi71p6VtQGw6v9WAmOfBWqq1gq6mDK+8K9ue/hutj0NyTBbm+nii
         mENQ7HtzuZFyUpfD1w8O8beYbe+cWMr29I9QmEySMAj5SJhN9WU1QXKca2CuYvuIhDJx
         KhoQOTCxX9/rhCRwZ3QDlj1VBN2xo8oJWoYbirk/JhdPZ4IVH3J7ajPL1ZQtmbIiYchH
         p9iU1wnOqbqfj916lD42amESpxTQx/V62hEUbjGQRTgMJZDmh7GlhQtVPheXlbwJKdq1
         LEMaXa2i5TrOU2S5AIA1nVZNueNUttpgkU/wtCwOH/Qfk/dvRGJceMcq4wq7DCpHHkK+
         pH3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=7CRXAv0Q30uHbvgTQKtqRz4LZ54xLJ3KPEcsQm9BtW4=;
        b=OmuluKFiDSplhCE1TKWufbnqgWKj6xj1CoUVvjUCCguKF3IVANSA2IVIU4v+JAxC2u
         wQl8XjNDQvVwLTHPzoVTd2kao6gIFW/7i/8pkGeDrSnf5hoqmzmLSvH66miQVOU6XH6b
         QUORXMXcM86UwDbi/gLB+ZGHS8ca6r56QgJxzZPGP4aG9Kw2q/V8iShCy03FmWYq4aRw
         axuOoWiIK67aZw+jAJ4oN3p6zrhCv9Yvx4A8FiWth6KgQ2nr1I8LCImyWaO4DitKXiPT
         RHSz+m+PCvUGchjV5Nx3SgUIGFKUWxruZU0WkX4zKCHn/ci8kBzCFRyW+vUronQgtcny
         UlQA==
X-Gm-Message-State: APjAAAV0FObL+6u41nMx8wxzgXj4LOECeJFjh44UF3CxcyPxVu8xxi2P
        20Kh00e4a+pMWNRSA3SPcSvhTg==
X-Google-Smtp-Source: APXvYqz8HNuuFeovrMqNJg5ArlxCqVGrxmTkxdhbFQIu2XbqFoVOf3V4ZiSeDqX1WfQH8D/EV0NGeA==
X-Received: by 2002:a1c:28d4:: with SMTP id o203mr21414634wmo.147.1573485331736;
        Mon, 11 Nov 2019 07:15:31 -0800 (PST)
Received: from apalos.home (athedsl-4484009.home.otenet.gr. [94.71.55.177])
        by smtp.gmail.com with ESMTPSA id v184sm21152276wme.31.2019.11.11.07.15.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Nov 2019 07:15:31 -0800 (PST)
Date:   Mon, 11 Nov 2019 17:15:29 +0200
From:   Ilias Apalodimas <ilias.apalodimas@linaro.org>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     brouer@redhat.com, lorenzo@kernel.org,
        netdev <netdev@vger.kernel.org>
Subject: Re: Regression in mvneta with XDP patches
Message-ID: <20191111151529.GB3614@apalos.home>
References: <20191111134615.GA8153@lunn.ch>
 <20191111143352.GA2698@apalos.home>
 <20191111150553.GC1105@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191111150553.GC1105@lunn.ch>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew,

On Mon, Nov 11, 2019 at 04:05:53PM +0100, Andrew Lunn wrote:
> On Mon, Nov 11, 2019 at 04:33:52PM +0200, Ilias Apalodimas wrote:
> > Hi Andrew,
> > 
> > On Mon, Nov 11, 2019 at 02:46:15PM +0100, Andrew Lunn wrote:
> > > Hi Lorenzo, Jesper, Ilias
> > > 
> > > I just found that the XDP patches to mvneta have caused a regression.
> > > 
> > > This one breaks networking:
> > 
> > Thaks for the report.
> > Looking at the DTS i can see 'buffer-manager' in it. The changes we made were
> > for the driver path software buffer manager. 
> > Can you confirm which one your hardware uses?
> 
> Hi Ilias
> 
> Ah, interesting.
> 
> # CONFIG_MVNETA_BM_ENABLE is not set
> 
> So in fact it is not being compiled in, so should be falling back to
> software buffer manager.
> 
> If i do enable it, then it works. So we are in a corner cases you
> probably never tested. Requested by DT, but not actually available.
> 

Correct, i don't think any of us had access to a hardware with BM
We did change some offsets of memory allocation in the swbm to make room for
skb_shared_info and the xdp headlen we need. 
Maybe we missed that on the 'fallback' scenario. I'll try to have a look on the
driver

> 	 Andrew

Thanks
/Ilias
