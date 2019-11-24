Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3F4E7108296
	for <lists+netdev@lfdr.de>; Sun, 24 Nov 2019 10:24:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726752AbfKXJYx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Nov 2019 04:24:53 -0500
Received: from mail-vs1-f67.google.com ([209.85.217.67]:37629 "EHLO
        mail-vs1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725980AbfKXJYx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Nov 2019 04:24:53 -0500
Received: by mail-vs1-f67.google.com with SMTP id u6so7953094vsp.4
        for <netdev@vger.kernel.org>; Sun, 24 Nov 2019 01:24:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=uOi9/3Q0X3w1OfxUDmTCL10mVYvW+MBUir/d9YeA3Ys=;
        b=D3KYhhYbXDNvMBQYB8korikYRelHiV3c5RvDJ55I722uPWddQkMB08m6s0Q9yWhAcA
         HTHgCJ2InBeaIdANNUIGAGL1xermd60im86ZpIQqhMgaTbHKMz+Ig2nyvygJhSzbuDfo
         TbgpUi9OcyMmtEuXiUTX/86Qsj42ri+AQvJdL/vndLSOM2Z8Z9Rx8HYYgCzgg3YjtD2r
         WjGXzT/LI6Y+lV+u/QOuW2ntdFBec9TLNh7cMIC+V3931XI/mJRD3WSw/sGNmAzVQc3C
         EikpI4/Qq18wzAO9In3Gg1liHNv0/1N+XSa66Txn8Z5IVEcDnXdaMKi4reqVJzC715HU
         dMPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=uOi9/3Q0X3w1OfxUDmTCL10mVYvW+MBUir/d9YeA3Ys=;
        b=I/kychZzO/shFFX+kZz+Mc82yRTezF78Gf2MW4/vYCzOrWdSQ9Bp3KPkwaau71UlNa
         Hvu26rNUtY8uuQVAH5jb4a/3T9mJGd/dZaDvAk9z149D9kdBtVfcQFGHRDABnHMfWk6j
         icSsTh4Fa6u0dK76R7gMvhA6y+DxAT5e4R1TbZEaR2KNQTqRIDCJPJcezWQyhMxbqrgu
         /QLAec7lNwTFOWKzBU3aqtlPXwm5EtnudQUpMy5iVn3NX8Q7wQjxdMYHV4CBwzKYyW70
         4qzyC1Wuq1m5GHLXlF3Gl6QDATeMISxVOxpndBshx+45bcYGTjA5quFbrHr8ysKASfcW
         IPkg==
X-Gm-Message-State: APjAAAUIcUkrzwLXlupy+YFwb5HUEslvkiaOTsxf2qBmmzLNjwssmOGe
        xvMwA0oQ3G6OkP7ArN1KEjHlfaN1RZ3/d46CDyo8xg==
X-Google-Smtp-Source: APXvYqxOiLdDlrzeIaj0JChHNL/Fc7oei5e2a4sKo5TF6Wl20KMUsnG/8pY6WuPMaa6Scn1lJIE7suZjWAQ+WCpt5e4=
X-Received: by 2002:a67:e9d6:: with SMTP id q22mr16159896vso.231.1574587491566;
 Sun, 24 Nov 2019 01:24:51 -0800 (PST)
MIME-Version: 1.0
References: <20191122072102.248636-1-zenczykowski@gmail.com>
 <20191122.100657.2043691592550032738.davem@davemloft.net> <CANP3RGfF9GZ-quN-ijM4A_A+cP3-tzhA174hFjsYbXPRiTMSLA@mail.gmail.com>
In-Reply-To: <CANP3RGfF9GZ-quN-ijM4A_A+cP3-tzhA174hFjsYbXPRiTMSLA@mail.gmail.com>
From:   =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <zenczykowski@gmail.com>
Date:   Sun, 24 Nov 2019 01:24:39 -0800
Message-ID: <CANP3RGfi3vwAjYu45xRG7HqMw-CGEr4uxES8Cd7vHs+q4W4wLQ@mail.gmail.com>
Subject: Re: [PATCH 1/3] net: inet_is_local_reserved_port() should return bool
 not int
To:     David Miller <davem@davemloft.net>
Cc:     Linux NetDev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > Maciej, please repost this series with a proper introduction "[PATCH 0/3]" posting
> > so that I know what this series does at a high level, how it is doing it, and why
> > it is doing it that way.
>
> That's because the first two patches were standalone refactors,
> and only the third - one line - patch had a dependency on the 2nd.

So I've been thinking about this, and I've come to the conclusion
you'd probably not be willing to accept the final one line patch (and
either way it should also be updating the sysctl docs) because it is
after all a change of behaviour for userspace (even if I imagine very
rarely utilized).

I'm still not sure what exactly to do about it.  Perhaps the easiest
thing is to carry it around as an Android common kernel only patch.
I'm not sure.
I'm kind of loathe to add another sysctl... but perhaps?

So for now I'll go with resubmitting just the refactor, which I *hope*
won't be controversial??
