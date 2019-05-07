Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B356A160F9
	for <lists+netdev@lfdr.de>; Tue,  7 May 2019 11:33:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726756AbfEGJdF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 May 2019 05:33:05 -0400
Received: from mail-lf1-f66.google.com ([209.85.167.66]:33031 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726598AbfEGJdF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 May 2019 05:33:05 -0400
Received: by mail-lf1-f66.google.com with SMTP id x132so381348lfd.0
        for <netdev@vger.kernel.org>; Tue, 07 May 2019 02:33:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hE0tGFZInJasil0DMyANrcRCEy3iRRwz1piA5wDFZiU=;
        b=e/8nTw2bpRlSP6ubmCtIPcm1M1PW2GnPsNfmAKHjju+2p/0A6tF6JCdM5aEEsBHHx0
         v4Us5VLzJ3mQtO8XHUexFuamoSb5cBkbf9i5ucX5+8ETeubGVnFt5yHtdCx6CwsAEmEt
         j+IuMHngPpj+cwOarQvkPR9Cii+phEgYViHVYTTyWq94LYxjGoGNdo5+xqdLtWPeqQr2
         3I//7cReO9Pd0R4yXNEyUmPtosulFYwDOw8UbYZZudJ3MNnTgbVh7SSRaCEJsT+Db1tu
         uyKasv/XMRqbXUq3icSPvRK35YYoG1CMfs8MtHMhuQpSFQmbz21jXIrbC3FTnqf+rUhZ
         kbuQ==
X-Gm-Message-State: APjAAAVzKQy1nHqk+bdR7VY8+jgHzFCRSHXPMO6JI8Pvp7yFf7yfkhTj
        yDeumeH3SXqcrap2gUcximGFWznVMa01cFNHQWnbg1mY
X-Google-Smtp-Source: APXvYqy1nXzRE6oSr9dQpsM0uTKmUFqWEbGu+5Jqjy9kBSUABK4uqELy/3A+cULnx/jdXYZQ/BuUlSt3U1JQyDfwXxs=
X-Received: by 2002:ac2:5621:: with SMTP id b1mr5823858lff.27.1557221583694;
 Tue, 07 May 2019 02:33:03 -0700 (PDT)
MIME-Version: 1.0
References: <20190504164853.4736-1-mcroce@redhat.com> <20190507091034.GA3561@jackdaw>
In-Reply-To: <20190507091034.GA3561@jackdaw>
From:   Matteo Croce <mcroce@redhat.com>
Date:   Tue, 7 May 2019 11:32:27 +0200
Message-ID: <CAGnkfhwVvF4qcqoU6wC8tCb6vrvNipP0UG4MxqAd1--5fLmjQg@mail.gmail.com>
Subject: Re: [PATCH pppd v4] pppoe: custom host-uniq tag
To:     Tom Parkin <tparkin@katalix.com>
Cc:     linux-ppp@vger.kernel.org, netdev <netdev@vger.kernel.org>,
        Paul Mackerras <paulus@ozlabs.org>,
        Jo-Philipp Wich <jo@mein.io>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 7, 2019 at 11:10 AM Tom Parkin <tparkin@katalix.com> wrote:
>
> Hi Matteo,
>
> On Sat, May 04, 2019 at 06:48:53PM +0200, Matteo Croce wrote:
> > Add pppoe 'host-uniq' option to set an arbitrary
> > host-uniq tag instead of the pppd pid.
> > Some ISPs use such tag to authenticate the CPE,
> > so it must be set to a proper value to connect.
> >
> > Signed-off-by: Matteo Croce <mcroce@redhat.com>
> > Signed-off-by: Jo-Philipp Wich <jo@mein.io>
> > ---
> >  pppd/plugins/rp-pppoe/common.c          | 14 +++----
> >  pppd/plugins/rp-pppoe/discovery.c       | 52 ++++++++++---------------
> >  pppd/plugins/rp-pppoe/plugin.c          | 15 ++++++-
> >  pppd/plugins/rp-pppoe/pppoe-discovery.c | 41 ++++++++++++-------
> >  pppd/plugins/rp-pppoe/pppoe.h           | 30 +++++++++++++-
> >  5 files changed, 96 insertions(+), 56 deletions(-)
> >

Hi Tom,

this was a known bug of the v3 patch, I've fixed it in the v4.

Regards,
-- 
Matteo Croce
per aspera ad upstream
