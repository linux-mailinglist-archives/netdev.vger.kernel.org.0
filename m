Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5775DAF003
	for <lists+netdev@lfdr.de>; Tue, 10 Sep 2019 18:56:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436921AbfIJQ4Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Sep 2019 12:56:24 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:46916 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2436879AbfIJQ4Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Sep 2019 12:56:24 -0400
Received: by mail-pl1-f193.google.com with SMTP id t1so8863654plq.13
        for <netdev@vger.kernel.org>; Tue, 10 Sep 2019 09:56:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=crbtybzYZlTYA6/rxzBHXjAM1cEztt5jKJFibRqHvJ8=;
        b=g8T0x4sRZ/UYMEEzK330XrlOKu90k7s4nfKoIytet0tr4wDxtk0UE+jxAL4+laqIqi
         4Oy5bBRrIa3DROkT5a836dp9M0mVnWB/A6m2zDiedLdobIeXuBuYCnywV1rC/oZljwZw
         GBzRLnOIBvFOZsfjJ5E5KG1Uw+db7bARCWIr9riU+cnzMRyb5TKXtCH2Ey0TXfc7uaPC
         bsIPJ11k+/zHmSw+JXl/vVAAixs4qSPO09DgsqvWjYO9qYAYhRVAzhAlXhQbQM8tEEVj
         ENNIZf7rsKMEl3OMlYfnarRKv5MWQ5IBKF443TvjrmMU9oPa3A44v5JrB0c6jxS5KEQM
         mSqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=crbtybzYZlTYA6/rxzBHXjAM1cEztt5jKJFibRqHvJ8=;
        b=LIKWCUbye2cptLyXtb8enB9ofevIv9iZUP4KpJmMZrg7KvzE9+5R8SL/BJ614mpDp6
         aVCdGb3UUFgFoVyvWr/YI9yaAM5bPv/47XIpOajH4Rf0qIlj3xkERe8zVmhaSyfQ4xR0
         fA7I7xw/V5sr3R7H/QgwwEEILQkQMVFBz67zjWOaB7mYd1zSEKfqWu+4s8HIy31PBlWr
         muqv87fuSXFD25zmhavYYZpv8WeFQohIkjowBDV0mSeIAwysY3x2MQHv27xeoEUAgBKD
         EgGn4NxadiNAabsEk0yJG7PaClJsq3GRBL2O3caffu6lOw3rVvZWmQiADDgGTNdc3eg8
         O3EA==
X-Gm-Message-State: APjAAAVZD8Sy6JhA39CqqoyQjjQz8znd4b5p8qX3F9Y4ZkSqgnhygQZT
        A5qRjfWHtiS8xBm/0Tqxj1CujJqLmJnyPg90tUnNwhD2
X-Google-Smtp-Source: APXvYqzZ/Lxw5ffNxk0FrcyRnzyiA9va9Pv1mVKuyVG3hxwchIrsDfHvWph3MEHqwbwVAXbqMfh7loqko6/cM4aYvJw=
X-Received: by 2002:a17:902:36a:: with SMTP id 97mr32332869pld.61.1568134583829;
 Tue, 10 Sep 2019 09:56:23 -0700 (PDT)
MIME-Version: 1.0
References: <211c7151-7500-f895-7fd7-2c868dd48579@applied-asynchrony.com>
 <CAM_iQpWKsSWDZ55kMO6mzDe5C7tHW-ub_eH91hRzZMdUtKJtfA@mail.gmail.com> <dbc359d3-5cac-9b2e-6520-df4a25964bd3@applied-asynchrony.com>
In-Reply-To: <dbc359d3-5cac-9b2e-6520-df4a25964bd3@applied-asynchrony.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Tue, 10 Sep 2019 09:56:12 -0700
Message-ID: <CAM_iQpUO3vedg+XOcMb8s6hE=+hdvjPJp9DitjHZE6oNtDVkVQ@mail.gmail.com>
Subject: Re: Default qdisc not correctly initialized with custom MTU
To:     =?UTF-8?Q?Holger_Hoffst=C3=A4tte?= <holger@applied-asynchrony.com>
Cc:     Netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 10, 2019 at 2:14 AM Holger Hoffst=C3=A4tte
<holger@applied-asynchrony.com> wrote:
>
> On 9/10/19 12:52 AM, Cong Wang wrote:
> > On Mon, Sep 9, 2019 at 5:44 AM Holger Hoffst=C3=A4tte
> > <holger@applied-asynchrony.com> wrote:
> >> I can't help but feel this is a slight bug in terms of initialization =
order,
> >> and that the default qdisc should only be created when it's first bein=
g
> >> used/attached to a link, not when the sysctls are configured.
> >
> > Yeah, this is because the fq_codel qdisc is initialized once and
> > doesn't get any notification when the netdev's MTU get changed.
>
> My point was that it shouldn't be created or initialized at all when
> the sysctl is configured, only the name should be validated/stored and
> queried when needed. If any interface is brought up before that point,
> no value (yet) would just mean "trod along with the defaults" to whoever
> is doing the work.

It is _not_ created when sysctl is configured, it is either created via tc
command, or implicitly created by kernel when you bring up eth0.
sysctl only tells kernel what to create by default, but never commits it.

>
> > We can "fix" this by adding a NETDEV_CHANGEMTU notifier to
> > qdisc's, but I don't know if it is really worth the effort.
>
> This is essentially the opposite of what I had in mind. The problem is
> that the entity was created, not that it needs to be notified.

Hmm? You did change MTU after adding fq_codel to eth0, right?
So how do you fix this without notification or recreation of fq_codel
in your mind?

I am happy to hear more details.

> Also I don't think that would work for scenarios with multiple links
> using different MTUs.

The fq_codel you created is apparently attached to a netdev,
I don't think this is even a problem. I _guess_ you somehow
believe you create a standalone fq_codel during sysctl setting,
this is just impossible. It must be attached to an interface, no
matter who creates it.

>
> > Is there any reason you can't change that order?
>
> Yes, because that wouldn't solve anything?

Really? You already said it works for you like below, I am confused.


> Like i said I can just kick the root qdisc to update itself in
> a post interface-setup script, and that works fine. Since I need
> that script anyway for setting several other parameters for
> the device it's no big deal - just another workaround.
>
> A brief look at the initialization in sch_mq/sch_generic unfortunately
> didn't really help clear things up for me, hence I guess my real
> question is whether a qdisc *must* be created early for some reason
> (assuming sysctls come before link setup), or whether this is something
> that could be delayed and done on-demand.

The default qdisc is created by kernel when you don't create any.
Again, you can create your own after changing the MTU, this should
solve the problem you see. It is all about ordering.

Thanks.
