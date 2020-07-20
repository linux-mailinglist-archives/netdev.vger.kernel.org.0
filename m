Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3ABCD227022
	for <lists+netdev@lfdr.de>; Mon, 20 Jul 2020 23:05:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726483AbgGTVFX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jul 2020 17:05:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726012AbgGTVFW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jul 2020 17:05:22 -0400
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1D65C061794;
        Mon, 20 Jul 2020 14:05:22 -0700 (PDT)
Received: by mail-ej1-x642.google.com with SMTP id lx13so19526645ejb.4;
        Mon, 20 Jul 2020 14:05:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=oRYEtskwDDcT9Srh8wA6km/vhDAp1OdKV1cO1briNxM=;
        b=l89CH63xVSpCE7BW7N3Z4E2HKWKtj+jRw3J44YG6BJxO8sKxAvQL1iv5Tv1z0IYY3E
         JvDheh+nDmlxm85ERsxFMbveYPPS+r0YsfasDTQ79YqW1HPsRM9ae55DXu2ixfs+cs5W
         j0It4gtO7xb6/vuDEdrT93WzvY1iaPiw46ltk75QsPS42vZZBQ1z5JUJ/h+Ihlq2zPw6
         NvVJKR/bVD5rnmzbpB3rlEac3jdQOeqtHqCZqx0eYfKibizQYSDpgjJ8WGS/v+cFKd46
         EN3WTPr2cBNjKyqaf/2JHDTQA3Aq/UYsNF/C0H6YEL/craMPbEtSIlWwVxVtlDdQOKQA
         Udtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=oRYEtskwDDcT9Srh8wA6km/vhDAp1OdKV1cO1briNxM=;
        b=WhXHqvs2UArh/6PU3jxZ+yVBb+lPrBNvwadqdkIwAytdZ8C//Lb5AWfcWOrDz4ooQm
         nz2kLy+ZnPOYm/kvmJlX/swaKPb1SqpdOpkZVcwMq1IbrK9BdAynVLDEhna7dnQH1XuU
         yOsMWP34CjY3T5v4cdg3T4hfgKPmd4DR9ejN3sWCmf0/9y0u3+kX/T2NnDJ5TTr2SaWV
         SKUB9meDbG35ueWNAobJR5N7DuhnsmVXB6R47hEXvjC9k0m6062RBwtUiSvUuwuTAJhn
         tTX7NF215MnJIzkIj56kXWb4LPXlyA9EK1Qd1R3Nje+K/oyKNliUKs7WERLz9CVBjzS3
         /36A==
X-Gm-Message-State: AOAM531HBe67EJSBUU5B+22m8Vdmjvz1bKKmaF6xZ4LDlZaIg0h+1AqO
        Wg3oQM65zs2FMhl4Ewnw/h0=
X-Google-Smtp-Source: ABdhPJyDzKMCSlxkaveslDH6P9+qVOyZ9jkeMVe5aTPJ06sWxeGlUm6fjvFbYkxtynqaflNGJnPp6A==
X-Received: by 2002:a17:906:f88a:: with SMTP id lg10mr21730747ejb.317.1595279121324;
        Mon, 20 Jul 2020 14:05:21 -0700 (PDT)
Received: from skbuf ([188.25.219.134])
        by smtp.gmail.com with ESMTPSA id bt26sm15946975edb.17.2020.07.20.14.05.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jul 2020 14:05:20 -0700 (PDT)
Date:   Tue, 21 Jul 2020 00:05:18 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jacob Keller <jacob.e.keller@intel.com>
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        richardcochran@gmail.com, sorganov@gmail.com,
        linux-doc@vger.kernel.org
Subject: Re: [PATCH net-next 3/3] docs: networking: timestamping: add a set
 of frequently asked questions
Message-ID: <20200720210518.5uddqqbjuci5wxki@skbuf>
References: <20200717161027.1408240-1-olteanv@gmail.com>
 <20200717161027.1408240-4-olteanv@gmail.com>
 <e6b6f240-c2b2-b57c-7334-4762f034aae3@intel.com>
 <20200718113519.htopj6tgfvimaywn@skbuf>
 <887fcc0d-4f3d-3cb8-bdea-8144b62c5d85@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <887fcc0d-4f3d-3cb8-bdea-8144b62c5d85@intel.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 20, 2020 at 11:54:30AM -0700, Jacob Keller wrote:
> On 7/18/2020 4:35 AM, Vladimir Oltean wrote:
> > On Fri, Jul 17, 2020 at 04:12:07PM -0700, Jacob Keller wrote:
> >> On 7/17/2020 9:10 AM, Vladimir Oltean wrote:
> >>> +When the interface they represent offers both ``SOF_TIMESTAMPING_TX_HARDWARE``
> >>> +and ``SOF_TIMESTAMPING_TX_SOFTWARE``.
> >>> +Originally, the network stack could deliver either a hardware or a software
> >>> +time stamp, but not both. This flag prevents software timestamp delivery.
> >>> +This restriction was eventually lifted via the ``SOF_TIMESTAMPING_OPT_TX_SWHW``
> >>> +option, but still the original behavior is preserved as the default.
> >>> +
> >>
> >> So, this implies that we set this only if both are supported? I thought
> >> the intention was to set this flag whenever we start a HW timestamp.
> >>
> > 
> > It's only _required_ when SOF_TIMESTAMPING_TX_SOFTWARE is used, it
> > seems. I had also thought of setting 'SKBTX_IN_PROGRESS' as good
> > practice, but there are many situations where it can do more harm than
> > good.
> > 
> 
> I guess I've only ever implemented a driver with software timestamping
> enabled as an option. What sort of issues arise when you have this set?
> I'm guessing that it's some configuration of stacked devices as in the
> other cases? If the issue can't be fixed I'd at least like more
> explanation here, since the prevailing convention is that we set this
> flag, so understanding when and why it's problematic would be useful.
> 
> Thanks,
> Jake

Yes, the problematic cases have to do with stacked PHCs (DSA, PHY). The
pattern is that:
- DSA sets SKBTX_IN_PROGRESS
- calls dev_queue_xmit towards the MAC driver
- MAC driver sees SKBTX_IN_PROGRESS, thinks it's the one who set it
- MAC driver delivers TX timestamp
- DSA ends poll or receives TX interrupt, collects its timestamp, and
  delivers a second TX timestamp
In fact this is explained in a bit more detail in the current
timestamping.rst file.
Not only are there existing in-tree drivers that do that (and various
subtle variations of it), but new code also has this tendency to take
shortcuts and interpret any SKBTX_IN_PROGRESS flag set as being set
locally. Good thing it's caught during review most of the time these
days. It's an error-prone design.
On the DSA front, 1 driver sets this flag (sja1105) and 3 don't (felix,
mv88e6xxx, hellcreek). The driver who had trouble because of this flag?
sja1105.
On the PHY front, 2 drivers set this flag (mscc_phy, dp83640) and 1
doesn't (ptp_ines). The driver who had trouble? dp83640.
So it's very far from obvious that setting this flag is 'the prevailing
convention'. For a MAC driver, that might well be, but for DSA/PHY,
there seem to be risks associated with doing that, and driver writers
should know what they're signing up for.

-Vladimir
