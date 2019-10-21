Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A77C4DF325
	for <lists+netdev@lfdr.de>; Mon, 21 Oct 2019 18:32:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728570AbfJUQb5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Oct 2019 12:31:57 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:52364 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727889AbfJUQbz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Oct 2019 12:31:55 -0400
Received: by mail-wm1-f68.google.com with SMTP id r19so14083990wmh.2
        for <netdev@vger.kernel.org>; Mon, 21 Oct 2019 09:31:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=3IkhyqN1C3DeqmpvyeKao62eu0Id9wyxWa4NyKMwjSY=;
        b=ecUT7YuSAH7EqAHwjxoJ7bXyebXggXNBwTBOODxudm9W3L4rkeeF2Tup1Rjgq9+0nX
         1ig00rspZrWlFuh9g6eK7Iu3wfnnlYbTq5Ri8hsPUTViIT9wIE6HafPFwHR/TllGcxDR
         /9VvDHFweGt+uOWhUbn9oGA4OsW6S59AVRWtMrVsp2JVl6obVs2Z+ocmObYsTyrsJFVq
         HXrxI67X+xn7XSZiGSVIxnN9jAi3rsKEqKhd4FTequn80r2arymkCrxSqoB1GN+QqgJp
         iAqbQbKupwGVXNS8Z0tNTPAej0KM6EndGKI+mdUmCApAZb6zvxHZ5V2QC4OygoowVtSt
         9kGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=3IkhyqN1C3DeqmpvyeKao62eu0Id9wyxWa4NyKMwjSY=;
        b=hn5blgYRosHPkEsRg7fvgABc2wqYrkIsy8jvf6LeLaxWQtLj/6yXA0hJmPNfWrkFvk
         lN5UYhi2j8XsYVC5MqS8mMWZugRC8DnUMFGREw6WcARBpyew3RDHGHebELAYj879hO5l
         R+t6KAuuCz44lnrRWEwOjhfxOPP4v2Wa8zwi7RBdaEV8IqRi62vY4AHhi5G+SxorwZ28
         sZ83sYBn/uFxtRF7Ir/qh6eFLEUL57JFDHQxaFDxdjHwEswXoa2WTikCt60CJlHH/DUA
         +xlx7fMeufhETtB0jZq1ARmJxcjOHCQS6TcXvDFYjUXebjn1divQC5HOGfIGa+k2MyjP
         8jCA==
X-Gm-Message-State: APjAAAXfr9dDDh4rporBz1/yJmgtfyQIBE2gWUktxA57NA/6XJ6ufHo9
        8yvIwa+tWM6Vp883OYg4RGQmUQ==
X-Google-Smtp-Source: APXvYqzPOa4k0MGzDnxIlfae62AIVxgrRFLh8OdQdSIsPDPBjcYwh/TC0W5XSEVF4sDYB4ISkgFdIQ==
X-Received: by 2002:a7b:cf28:: with SMTP id m8mr20552680wmg.63.1571675512031;
        Mon, 21 Oct 2019 09:31:52 -0700 (PDT)
Received: from netronome.com ([83.137.2.245])
        by smtp.gmail.com with ESMTPSA id z9sm16104645wrl.35.2019.10.21.09.31.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Oct 2019 09:31:51 -0700 (PDT)
Date:   Mon, 21 Oct 2019 18:31:40 +0200
From:   Simon Horman <simon.horman@netronome.com>
To:     "Zhu, Lingshan" <lingshan.zhu@intel.com>
Cc:     mst@redhat.com, jasowang@redhat.com, alex.williamson@redhat.com,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        netdev@vger.kernel.org, dan.daly@intel.com,
        cunming.liang@intel.com, tiwei.bie@intel.com, jason.zeng@intel.com,
        zhiyuan.lv@intel.com
Subject: Re: [RFC 1/2] vhost: IFC VF hardware operation layer
Message-ID: <20191021163139.GC4486@netronome.com>
References: <20191016011041.3441-1-lingshan.zhu@intel.com>
 <20191016011041.3441-2-lingshan.zhu@intel.com>
 <20191016095347.5sb43knc7eq44ivo@netronome.com>
 <075be045-3a02-e7d8-672f-4a207c410ee8@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <075be045-3a02-e7d8-672f-4a207c410ee8@intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 21, 2019 at 05:55:33PM +0800, Zhu, Lingshan wrote:
> 
> On 10/16/2019 5:53 PM, Simon Horman wrote:
> > Hi Zhu,
> > 
> > thanks for your patch.
> > 
> > On Wed, Oct 16, 2019 at 09:10:40AM +0800, Zhu Lingshan wrote:

...

> > > +static void ifcvf_read_dev_config(struct ifcvf_hw *hw, u64 offset,
> > > +		       void *dst, int length)
> > > +{
> > > +	int i;
> > > +	u8 *p;
> > > +	u8 old_gen, new_gen;
> > > +
> > > +	do {
> > > +		old_gen = ioread8(&hw->common_cfg->config_generation);
> > > +
> > > +		p = dst;
> > > +		for (i = 0; i < length; i++)
> > > +			*p++ = ioread8((u8 *)hw->dev_cfg + offset + i);
> > > +
> > > +		new_gen = ioread8(&hw->common_cfg->config_generation);
> > > +	} while (old_gen != new_gen);
> > Would it be wise to limit the number of iterations of the loop above?
> Thanks but I don't quite get it. This is used to make sure the function
> would get the latest config.

I am worried about the possibility that it will loop forever.
Could that happen?

...

> > > +static void io_write64_twopart(u64 val, u32 *lo, u32 *hi)
> > > +{
> > > +	iowrite32(val & ((1ULL << 32) - 1), lo);
> > > +	iowrite32(val >> 32, hi);
> > > +}
> > I see this macro is also in virtio_pci_modern.c
> > 
> > Assuming lo and hi aren't guaranteed to be sequential
> > and thus iowrite64_hi_lo() cannot be used perhaps
> > it would be good to add a common helper somewhere.
> Thanks, I will try after this IFC patchwork, I will cc you.

Thanks.

...
