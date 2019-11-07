Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C0916F3846
	for <lists+netdev@lfdr.de>; Thu,  7 Nov 2019 20:14:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727578AbfKGTO1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Nov 2019 14:14:27 -0500
Received: from mail-ed1-f67.google.com ([209.85.208.67]:35286 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727123AbfKGTO0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Nov 2019 14:14:26 -0500
Received: by mail-ed1-f67.google.com with SMTP id r16so2886311edq.2
        for <netdev@vger.kernel.org>; Thu, 07 Nov 2019 11:14:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=dOG7edqDFMcxMhpcrjhoUbpRxzRJr9zCrHwLExjMT10=;
        b=anix7qpP+NRxhc1Hgot2FLAdqxioqgplav02k/yiWPy3s3a2MnFtXrgtY1oNVpP90e
         0Dkha2eQSnhNupruK1Xid+DJqNH7LdeOen0gL7v3d7+WKpTqhtujU6MS1WcY5p69TJQ9
         81NLr8EWfoR0VIvmVUmnIUbvT86pMFMQyxyKr7GBr9BuU1lW7Vmt82XGYHpbyGZat6E2
         Z5RLsXO/C+KHBrHiwubb2aRFDBfALMReFSidDoRTsmZnyOtm6gF2HAK6EfzPKflqbv6X
         SdX4HMSOhSJTS1yUQ3E85JECgMGhzS3w0Q4GZnS5zc8xTqghRa/qmYSAg3ySEUUiubuv
         h40Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dOG7edqDFMcxMhpcrjhoUbpRxzRJr9zCrHwLExjMT10=;
        b=mgXEI3fO0tq/hHBfx83hjaktp/P5jlP2yjSOiVa9KC0Vp4B7LRpoY/iwQwLNt+MpG0
         j8/D/ET8JsEKvm3s89+hIxUnLd9q4C8ODBb5Fd/JEuZXPVzG+OgvBdHeN93i/9vSzqr8
         Haq0VXTi9GpVq+vT2isGi+zS4nAmTRR3co4W3pz351nQNe/C42mXXJGRY0Zq2SBtfpng
         JSd6jEArv7j/HBPrY0EWRKyw30aGLthus/sIvbGFoHlypp96PDgoz21h33TLNDCfS3E9
         Za3WcPtKu/zdJUBUK+5U/z/twid8SKIHsvgyWi4roR2BgiPMOlp6ljvcmJXluzxSuRf9
         shog==
X-Gm-Message-State: APjAAAWJHYmvpna7adUUzmyXWXbYFM6YTwjesRfwPwcKA7ZUl5ocH29H
        O938Ubemr9CHGO5IYs6jnWLwiYWyCglz5KYDZk8=
X-Google-Smtp-Source: APXvYqwXId/FNtgA/YFar5GD1pBaPYYcbMK4jRje7BcHGCo7sztIzbPM3Gw5f0z6JlwtmbB38IcIjQS8Kf/9iMRwLDk=
X-Received: by 2002:aa7:d796:: with SMTP id s22mr5253330edq.31.1573154063617;
 Thu, 07 Nov 2019 11:14:23 -0800 (PST)
MIME-Version: 1.0
References: <cover.1570455278.git.martinvarghesenokia@gmail.com>
 <5979d1bf0b5521c66f2f6fa31b7e1cbdddd8cea8.1570455278.git.martinvarghesenokia@gmail.com>
 <CA+FuTSc=uTot72dxn7VRfCv59GcfWb32ZM5XU1_GHt3Ci3PL_A@mail.gmail.com>
 <20191017132029.GA9982@martin-VirtualBox> <CA+FuTScS+fm_scnm5qkU4wtV+FAW8XkC4OfwCbLOxuPz1YipNw@mail.gmail.com>
 <20191018082029.GA11876@martin-VirtualBox> <CA+FuTSf2u2yN1KL3vDLv-j9UQGsGo1dwXNVW8w=NCrdt7n8crg@mail.gmail.com>
 <20191107133819.GA10201@martin-VirtualBox> <CAF=yD-JX=juqj2yrpZ6MjksLDqF8JVjTsruu2yVh5aXL6rou5g@mail.gmail.com>
 <20191107161238.GA10727@martin-VirtualBox> <CAF=yD-JeCV-AW2HO9inJt-yePUrBGQ9=M58fYr8f2CDHdNNpaA@mail.gmail.com>
 <20191107183136.466013d1@redhat.com> <CAF=yD-K9TjhuATs2ERNsgbnDitXTBuV3yirGnwYZ26dOvo0hFA@mail.gmail.com>
 <20191107200506.04242e5d@redhat.com>
In-Reply-To: <20191107200506.04242e5d@redhat.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Thu, 7 Nov 2019 14:13:47 -0500
Message-ID: <CAF=yD-+rPyf_yraOtB_twooZva3yDMZqb4tLGEp+HKdhE6B1-w@mail.gmail.com>
Subject: Re: [PATCH net-next 1/2] UDP tunnel encapsulation module for
 tunnelling different protocols like MPLS,IP,NSH etc.
To:     Jiri Benc <jbenc@redhat.com>
Cc:     Martin Varghese <martinvarghesenokia@gmail.com>,
        Network Development <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Jonathan Corbet <corbet@lwn.net>, scott.drennan@nokia.com,
        martin.varghese@nokia.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 7, 2019 at 2:05 PM Jiri Benc <jbenc@redhat.com> wrote:
>
> On Thu, 7 Nov 2019 13:59:23 -0500, Willem de Bruijn wrote:
> > This still needs only one socket, right? Just fall back to inet if
> > ipv6 is disabled.
>
> What would happen if IPv6 is disabled while the tunnel is operating?

How do you disable ipv6 at runtime?

rmmod is no longer allowed as of commit 8ce440610357 ("ipv6: do not
allow ipv6 module to be removed"). The commit specifically mentions a
dependency by vxlan; that sounds quite similar to this.
