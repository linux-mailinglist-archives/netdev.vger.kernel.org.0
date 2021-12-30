Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5CCE482034
	for <lists+netdev@lfdr.de>; Thu, 30 Dec 2021 21:13:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240814AbhL3UNR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Dec 2021 15:13:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240844AbhL3UNR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Dec 2021 15:13:17 -0500
Received: from mail-lf1-x12c.google.com (mail-lf1-x12c.google.com [IPv6:2a00:1450:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CF25C061574
        for <netdev@vger.kernel.org>; Thu, 30 Dec 2021 12:13:16 -0800 (PST)
Received: by mail-lf1-x12c.google.com with SMTP id h2so45974669lfv.9
        for <netdev@vger.kernel.org>; Thu, 30 Dec 2021 12:13:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fungible.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=IqMMs1xAEe2ALQC+fLOaECPYS4mJAp5tXwsQP5pU0Mk=;
        b=VfvCz9sF5imrE9tcJFPX7DfajWvxAmQ3GmiufhSmhfTIewz0vkZvsS8W63pxJtUVI3
         1HQdKEg/Gxmjpl6mQAc/wr8jc35b0kJVfleyTBPCAkvWnIpJTMDxOkO9rLQ54591OB1a
         dBVEcsVw9y70U7vNQpJw0jC+eHxs/uyyMz4SU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=IqMMs1xAEe2ALQC+fLOaECPYS4mJAp5tXwsQP5pU0Mk=;
        b=RWL8CQOy7MOOrC8JRWfbV5szMmXaBPuKWJD37UF4BNpgWsK5NwS+aCV/aJHIdeyXN9
         JI5jibZwRESKpp+iOj3DzAvuii1Vmw5GCzx8k49I3MQpusEf/h70oUMBCQkCSDIZx5kR
         E2sBLps35S5HWuL9vqjEf6oJnaX5CDV7DaUBIGXkp/+Fpmz7Nc4Tbe+i2J2z+ROlU24Y
         Ym1rPkMILOQo9Vg2p+hO7zxr8ESt1XZTvIv9yLhy5xjXOxwQC6XewqgQ9C8CYsb7tbe7
         I0bVqcf8s7Bch/OFf5i9oQmZR5GCgLd5uKkogcI7EgFaKlgR7IsbTAhiCBgkgJkJUWhF
         l4Ng==
X-Gm-Message-State: AOAM533W00nxcfCCJdbKH6+LJT0mDvKsWotlfwIfMEEeiQcLSQ4x95Y8
        qlIt8ca4u3hWqTefMHqpxwG0qCf6Z2Y1dzTXwlNviXSqMoQ=
X-Google-Smtp-Source: ABdhPJxH5yxAnTsGikYU98KJEpXoL8fsSTmcD3DZqinvsSNXmsd1NM1BaQo7/fE3SdPah/ONQw9+bhtfVpDvZ+saXDY=
X-Received: by 2002:a05:6512:1599:: with SMTP id bp25mr27061141lfb.689.1640895194752;
 Thu, 30 Dec 2021 12:13:14 -0800 (PST)
MIME-Version: 1.0
References: <20211230163909.160269-1-dmichail@fungible.com>
 <20211230163909.160269-3-dmichail@fungible.com> <Yc3sLEjF6O1CaMZZ@lunn.ch>
 <CAOkoqZnoOgGDGcnDeOQxjZ_eYh8eyFHK_E+w7E6QHWAvaembKw@mail.gmail.com> <Yc4Bxu8f9S5w3VsM@lunn.ch>
In-Reply-To: <Yc4Bxu8f9S5w3VsM@lunn.ch>
From:   Dimitris Michailidis <d.michailidis@fungible.com>
Date:   Thu, 30 Dec 2021 12:13:02 -0800
Message-ID: <CAOkoqZk=mu0zEv52-u8_0yg0SoY92hsmu_9FiZfWzTu9XjVtbg@mail.gmail.com>
Subject: Re: [PATCH net-next 2/8] net/fungible: Add service module for
 Fungible drivers
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 30, 2021 at 11:00 AM Andrew Lunn <andrew@lunn.ch> wrote:
>
> On Thu, Dec 30, 2021 at 10:24:10AM -0800, Dimitris Michailidis wrote:
> > On Thu, Dec 30, 2021 at 9:28 AM Andrew Lunn <andrew@lunn.ch> wrote:
> > >
> > > > +/* Wait for the CSTS.RDY bit to match @enabled. */
> > > > +static int fun_wait_ready(struct fun_dev *fdev, bool enabled)
> > > > +{
> > > > +     unsigned int cap_to = NVME_CAP_TIMEOUT(fdev->cap_reg);
> > > > +     unsigned long timeout = ((cap_to + 1) * HZ / 2) + jiffies;
> > > > +     u32 bit = enabled ? NVME_CSTS_RDY : 0;
> > >
> > > Reverse Christmas tree, since this is a network driver.
> >
> > The longer line in the middle depends on the previous line, I'd need to
> > remove the initializers to sort these by length.
>
> Yes.
>
>
> > > Please also consider using include/linux/iopoll.h. The signal handling
> > > might make that not possible, but signal handling in driver code is in
> > > itself very unusual.
> >
> > This initialization is based on NVMe, hence the use of NVMe registers,
> > and this function is based on nvme_wait_ready(). The check sequence
> > including signal handling comes from there.
> >
> > iopoll is possible with the signal check removed, though I see I'd need a
> > shorter delay than the 100ms used here and it doesn't check for reads of
> > all 1s, which happen occasionally. My preference though would be to keep
> > this close to the NVMe version. Let me know.
>
> I knew it would be hard to directly use iopoll, which is why i only
> said 'consider'. The problem is, this implementation has the same bug
> nearly everybody makes when writing their own implementation of what
> iopoll does, which is why i always point people at iopoll.
>
> msleep(100) guarantees that it will not return within 100ms. That is
> all. Consider what happens when msleep(100) actually sleeps for
> 1000.

Thanks, I see your point. Let me see which fix is easier.

>
>         Andrew
