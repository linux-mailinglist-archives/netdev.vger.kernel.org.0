Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82AB12E1A3F
	for <lists+netdev@lfdr.de>; Wed, 23 Dec 2020 10:01:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728169AbgLWJAW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Dec 2020 04:00:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727050AbgLWJAV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Dec 2020 04:00:21 -0500
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CDA3C0613D3;
        Wed, 23 Dec 2020 00:59:41 -0800 (PST)
Received: by mail-ej1-x634.google.com with SMTP id b9so21900399ejy.0;
        Wed, 23 Dec 2020 00:59:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ES/8ieI8Kxtel9JlAtC3s+3/PUrp/OzcZLFZoDxjKqA=;
        b=UEgPNhyUF5K0K5Vluw21w7F/F+PiR6V0PvyX0LR/kqwJFtEZ07Np/8GaGkf6SGP69p
         WQXYZ/f/6aWTTl8X3Cc3cf9FF3sAGnp9OzwnFWH/GpQm2fBmAxPvjZbazvjxFCcOr8PP
         ENqF5X7spWt4IKytN8sv4cXmTNazBVox1hQa/nZokeByRAi+RvwND43NMyD+NvXOiDYc
         ikYwybT2Wsr7aEzO/qBGt+2ivuPab/Et9sHbYC4P6sMD3ijFyWNNKwUbTv/zfvSA/GID
         V/hM1EWoh1hX0iztJ0kz5X1BdaD4EEnBg+2kMIAoimucpKP+fja//SMUNtbsLakkEXvD
         gsVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ES/8ieI8Kxtel9JlAtC3s+3/PUrp/OzcZLFZoDxjKqA=;
        b=VAHgWKgvRoXOQE47++aGLmzrEuMT5SoNpJjfW/ltjR1rDe4hec0t0KJRU0p6QbUV6x
         +YJWhJh3x6xvWvvoV/MnUZ1H++6AIMsW+g+vvBHRYdytJnPH9reVwv+MSBft9sZsSWWq
         E+ScKTok7kGqcT/07pMLI0Put3nIzJypZ/wsz8cKhcxipQUIHKbarHOijWbzFh9Gamgu
         HwR8Yuec5MWsjXWeQU5N6AbcgG+k08HejDTv6HsB3i0TNOQqS2ft1Sb5om3oMab+RNWC
         c8+zWjfaNEuhtwWw2qOhgJ4iiHCEDBl1ALHINfHZ9jGzX5caNpRDX4yJcQ1cIc1TgY16
         6U1A==
X-Gm-Message-State: AOAM531ymATFTF+xm69xQMsHxT0mGo0mknPBI2oURJXEA3AyO5o+V2hv
        rhhsdBtjc62aSab/53icK2Q=
X-Google-Smtp-Source: ABdhPJxJa7VIjYxxaH3afq1nZmDskCd4o4RjZYDvXMckqFCAULCCx1rexAClald7Csj5LrMJ3Bdhtw==
X-Received: by 2002:a17:906:cb86:: with SMTP id mf6mr22786625ejb.57.1608713979695;
        Wed, 23 Dec 2020 00:59:39 -0800 (PST)
Received: from andrea (host-95-239-64-30.retail.telecomitalia.it. [95.239.64.30])
        by smtp.gmail.com with ESMTPSA id n2sm11289270ejj.24.2020.12.23.00.59.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Dec 2020 00:59:39 -0800 (PST)
Date:   Wed, 23 Dec 2020 09:59:31 +0100
From:   Andrea Parri <parri.andrea@gmail.com>
To:     Michael Kelley <mikelley@microsoft.com>
Cc:     Sasha Levin <sashal@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Saruhan Karademir <skarade@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Wei Liu <wei.liu@kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>
Subject: Re: [PATCH AUTOSEL 4.14 40/66] hv_netvsc: Validate number of
 allocated sub-channels
Message-ID: <20201223085931.GA2683@andrea>
References: <20201223022253.2793452-1-sashal@kernel.org>
 <20201223022253.2793452-40-sashal@kernel.org>
 <MW2PR2101MB1052FDCC72FE8D5735553E3CD7DE9@MW2PR2101MB1052.namprd21.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <MW2PR2101MB1052FDCC72FE8D5735553E3CD7DE9@MW2PR2101MB1052.namprd21.prod.outlook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 23, 2020 at 02:47:56AM +0000, Michael Kelley wrote:
> From: Sasha Levin <sashal@kernel.org> Sent: Tuesday, December 22, 2020 6:22 PM
> > 
> > From: "Andrea Parri (Microsoft)" <parri.andrea@gmail.com>
> > 
> > [ Upstream commit 206ad34d52a2f1205c84d08c12fc116aad0eb407 ]
> > 
> > Lack of validation could lead to out-of-bound reads and information
> > leaks (cf. usage of nvdev->chan_table[]).  Check that the number of
> > allocated sub-channels fits into the expected range.
> > 
> > Suggested-by: Saruhan Karademir <skarade@microsoft.com>
> > Signed-off-by: Andrea Parri (Microsoft) <parri.andrea@gmail.com>
> > Reviewed-by: Haiyang Zhang <haiyangz@microsoft.com>
> > Acked-by: Jakub Kicinski <kuba@kernel.org>
> > Cc: "David S. Miller" <davem@davemloft.net>
> > Cc: Jakub Kicinski <kuba@kernel.org>
> > Cc: netdev@vger.kernel.org
> > Link:
> > https://lore.kernel.org/linux-hyperv/20201118153310.112404-1-parri.andrea@gmail.com/
> > Signed-off-by: Wei Liu <wei.liu@kernel.org>
> > Signed-off-by: Sasha Levin <sashal@kernel.org>
> > ---
> >  drivers/net/hyperv/rndis_filter.c | 5 +++++
> >  1 file changed, 5 insertions(+)
> > 
> 
> Sasha -- This patch is one of an ongoing group of patches where a Linux
> guest running on Hyper-V will start assuming that hypervisor behavior might
> be malicious, and guards against such behavior.  Because this is a new
> assumption,  these patches are more properly treated as new functionality
> rather than as bug fixes.  So I would propose that we *not* bring such patches
> back to stable branches.

Thank you, Michael.  Just to confirm, I agree with Michael's assessment
above and I join his proposal to *not* backport such patches to stable.

Thanks,
  Andrea
