Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 91D4336A12
	for <lists+netdev@lfdr.de>; Thu,  6 Jun 2019 04:37:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726589AbfFFChr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jun 2019 22:37:47 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:38556 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725783AbfFFChr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jun 2019 22:37:47 -0400
Received: by mail-pf1-f193.google.com with SMTP id a186so520160pfa.5
        for <netdev@vger.kernel.org>; Wed, 05 Jun 2019 19:37:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=J6m54nz2yHoMtFBhFZ+6x0rfqKLIN6sXm7hx7e5TIvs=;
        b=ZKvwUdaxX6Tj7J+LnHofjCaRZjhz/ExVmooLwAmtNY7hid5zcru4gmgtvj7F7xv+ty
         N976+DmGCq45sK993DOCXYaAUZ5xfZu+vwVNr3fG6+6PQB6v5SfBR+X7Nc8e/dndBwuf
         Ecxtt++bxPzh0QB+8670mFhYgm8aJCNO/+XtQ7oYeIlpdmj9lVgSaqCjkY0nPbIWvMZJ
         f0MIPVi2qDjAB5o70Kjjbnnd+yT4gx/pjbjgWnX2BAk59W/IsFOCFivHcTkQsuc2hIkH
         vCEj/er1BBWJcg2b+YGbPsWceYWu9Hkdb+iu64uPeB9njWvMr84+JAKPE1e3j3kvJcug
         wnFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=J6m54nz2yHoMtFBhFZ+6x0rfqKLIN6sXm7hx7e5TIvs=;
        b=AmbMwPVcR1QMxVpVjhtQksDZO7nl8vzc/1qay0gjJjWvnwzvURjbovjf1SmPP8hSRA
         BH3rkV+6XE7vlJDvdUNy7ApRFdsLMm078W+vUDJxqTrkx1/WbJyLNcIDTU5xHBWoBSwg
         jgvWRcLWY9H/e5ouk/9o4s92CxdnC2Wb94OrUddO0wVL+GhNmRlJ9kE1dL2VJbUc8mOU
         XzZVqIP+mK+yGU5G+SzfS4xGYlnB+AKASPw4IhDmlMDQ8PgZAcGuawdPlsUKg6JLZaTj
         5mhGQ4qPtptZ7xY3/W0xcUp8k6w7E0AUxLgmH7paVEsxcf7qyX1n5xPjTCchLypxh+i8
         rouA==
X-Gm-Message-State: APjAAAX5IwKmEbWToha+rplqadtFiUQ2i7nmJinX7Xn70SNJY4/FALPs
        73QBecuCAIh2OWcuA+TO1Wg=
X-Google-Smtp-Source: APXvYqx5ecZ7ZCz4va+bZGMbMMCcqKi5Homi25smtEhAfis4ufpo7VN7SG4zdrbcVp5NEkcCOgfk5A==
X-Received: by 2002:a63:5d45:: with SMTP id o5mr1069381pgm.40.1559788666922;
        Wed, 05 Jun 2019 19:37:46 -0700 (PDT)
Received: from localhost (c-73-222-71-142.hsd1.ca.comcast.net. [73.222.71.142])
        by smtp.gmail.com with ESMTPSA id c25sm170898pfi.75.2019.06.05.19.37.45
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 05 Jun 2019 19:37:46 -0700 (PDT)
Date:   Wed, 5 Jun 2019 19:37:43 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Shalom Toledo <shalomt@mellanox.com>
Cc:     Ido Schimmel <idosch@idosch.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Jiri Pirko <jiri@mellanox.com>,
        Petr Machata <petrm@mellanox.com>, mlxsw <mlxsw@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>
Subject: Re: [PATCH net-next 4/9] mlxsw: reg: Add Management UTC Register
Message-ID: <20190606023743.s7im2d3zwgyd7xbp@localhost>
References: <20190603121244.3398-1-idosch@idosch.org>
 <20190603121244.3398-5-idosch@idosch.org>
 <20190604141724.rwzthxdrcnvjboen@localhost>
 <05498adb-364e-18c9-f1d1-bb32462e4036@mellanox.com>
 <20190605172354.gixuid7t72yoxjks@localhost>
 <78632a57-3dc7-f290-329b-b0ead767c750@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <78632a57-3dc7-f290-329b-b0ead767c750@mellanox.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 05, 2019 at 06:55:18PM +0000, Shalom Toledo wrote:
> On 05/06/2019 20:23, Richard Cochran wrote:
> > On Wed, Jun 05, 2019 at 11:30:06AM +0000, Shalom Toledo wrote:
> >> On 04/06/2019 17:17, Richard Cochran wrote:
> >>> On Mon, Jun 03, 2019 at 03:12:39PM +0300, Ido Schimmel wrote:
> >>>> From: Shalom Toledo <shalomt@mellanox.com>
> >>>>
> >>>> The MTUTC register configures the HW UTC counter.
> >>>
> >>> Why is this called the "UTC" counter?
> >>>
> >>> The PTP time scale is TAI.  Is this counter intended to reflect the
> >>> Linux CLOCK_REALTIME system time?
> >>
> >> Exactly. The hardware doesn't have the ability to convert the FRC to UTC, so
> >> we, as a driver, need to do it and align the hardware with this value.
> > 
> > What does "FRC" mean?
> 
> Free Running Counter

Okay, so then you want to convert it into TAI (for PTP) rather than UTC.

Thanks,
Richard
