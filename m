Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8143C137C74
	for <lists+netdev@lfdr.de>; Sat, 11 Jan 2020 09:48:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728678AbgAKIr6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Jan 2020 03:47:58 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:38947 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728633AbgAKIr6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Jan 2020 03:47:58 -0500
Received: by mail-wm1-f67.google.com with SMTP id 20so4375519wmj.4
        for <netdev@vger.kernel.org>; Sat, 11 Jan 2020 00:47:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=mHt2ZdJ7udLdAZyl6LUxIFswN8dqEj3EPhqZ+Vrl2k0=;
        b=qJpbsz+ScyBIkKk6el36a6pgTGtMk0fMmzmMW/V5m+cmip110EWlTOATb6eut3ThJV
         oEqAg9SyfJeGMLhKuweDNm8O5DRDZ0I27B62KoNDeHqB9HxB7yE9k9KbOxSE8DioDosz
         5dkwjL3jRObElNLK9etPbibJRKR/o/sK64CJ/+HR2UKBxPwKctQlDXaD1p5amrtg2cYW
         C6FuzCsYZjA9qk1EYmSselmMriPRfjCv9kjNDNY9ius4AbPKIJytKAJ8hfSEhjOMzzVV
         RinLBo+UoScfbc7AYFQZs80fSsXkKk4ZGk3O+hkdIeySDZ+r6vFPZY3VTFMn8H+iiLFN
         +6VQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=mHt2ZdJ7udLdAZyl6LUxIFswN8dqEj3EPhqZ+Vrl2k0=;
        b=E6beDsZLKfh17RMZeysV6mZrDsl51iPN/ySuoSaeD+ROlz3DDg+mX+WhfLwof8b3N3
         FEo8Yprx2cgS16HU3WYbZoRRV9kDmLRNqf5a4GtMUUZcwVD1cUqTZapBh/C5CfsbEZ+m
         jBPV7/v+1MN+QvQLSl21lvnMAFUDtZvqPsh08OPTJ3xmOkhWt15Axv+KHr7AneCeJylf
         vpKqEfSzcf9MbYCfL9jFBWqhlpTRA1KTZ5smvIAqrN/SXnTWT9v0L+6rNVa98tjzXCWg
         4N/ZrpWhiJvfP3YZiCFz5yBjcOOv1ewt1Dmm/FLCwLgIxL1rTfv0wxoV0pY5QQfUym6K
         3INQ==
X-Gm-Message-State: APjAAAV39AZg6WQnxhTAX7RpAGkTr/Zexr+03ROYCuHdV/e3Y6348QOh
        3FO07X08wlpJWaS3F7gQTmkhmRioyIi8L6m9ByM=
X-Google-Smtp-Source: APXvYqyqmr4sHVqzPFSE4G5MjJDpMCC5jbtpmDMltS/o4BmVEQPUyO2mcxAAycRIsf374wxfJJOP8uZ5dnKwYANid98=
X-Received: by 2002:a1c:9e15:: with SMTP id h21mr8535618wme.95.1578732476315;
 Sat, 11 Jan 2020 00:47:56 -0800 (PST)
MIME-Version: 1.0
References: <1578656521-14189-1-git-send-email-sunil.kovvuri@gmail.com>
 <1578656521-14189-15-git-send-email-sunil.kovvuri@gmail.com> <20200110112808.4970c92e@cakuba.netronome.com>
In-Reply-To: <20200110112808.4970c92e@cakuba.netronome.com>
From:   Sunil Kovvuri <sunil.kovvuri@gmail.com>
Date:   Sat, 11 Jan 2020 14:17:45 +0530
Message-ID: <CA+sq2Ccr5jB1cBN62Y56C=19L-P7hgYPrD9o7EJN71Kroou9Ew@mail.gmail.com>
Subject: Re: [PATCH 14/17] octeontx2-pf: Add basic ethtool support
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     Linux Netdev List <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Christina Jacob <cjacob@marvell.com>,
        Sunil Goutham <sgoutham@marvell.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jan 11, 2020 at 12:58 AM Jakub Kicinski
<jakub.kicinski@netronome.com> wrote:
>
> On Fri, 10 Jan 2020 17:11:58 +0530, sunil.kovvuri@gmail.com wrote:
> > +static const struct otx2_stat otx2_dev_stats[] = {
> > +     OTX2_DEV_STAT(rx_bytes),
> > +     OTX2_DEV_STAT(rx_frames),
> > +     OTX2_DEV_STAT(rx_ucast_frames),
> > +     OTX2_DEV_STAT(rx_bcast_frames),
> > +     OTX2_DEV_STAT(rx_mcast_frames),
> > +     OTX2_DEV_STAT(rx_drops),
> > +
> > +     OTX2_DEV_STAT(tx_bytes),
> > +     OTX2_DEV_STAT(tx_frames),
> > +     OTX2_DEV_STAT(tx_ucast_frames),
> > +     OTX2_DEV_STAT(tx_bcast_frames),
> > +     OTX2_DEV_STAT(tx_mcast_frames),
> > +     OTX2_DEV_STAT(tx_drops),
> > +};
>
> Please don't duplicate the same exact stats which are exposed via
> ndo_get_stats64 via ethtool.

ndo_stats64 doesn't have separate stats for ucast, mcast and bcast on Rx and
Tx sides, they are combined ones. Hence added separate stats here.
The ones repeated here are bytes, frames and drops which are added to have
full set of stats at one place which could help anyone debugging pkt
drop etc issues.

Thanks,
Sunil.
