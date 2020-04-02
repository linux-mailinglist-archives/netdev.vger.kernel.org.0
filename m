Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 18DD719BAEB
	for <lists+netdev@lfdr.de>; Thu,  2 Apr 2020 06:17:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726653AbgDBERd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Apr 2020 00:17:33 -0400
Received: from mail-lf1-f51.google.com ([209.85.167.51]:41915 "EHLO
        mail-lf1-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725890AbgDBERd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Apr 2020 00:17:33 -0400
Received: by mail-lf1-f51.google.com with SMTP id z23so1562479lfh.8
        for <netdev@vger.kernel.org>; Wed, 01 Apr 2020 21:17:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=QtYdDcdShOL8G9Lbr8afeC0kB0JEVURYvDX3qsqwMXA=;
        b=jHnnBeekTejDEnd0wYykaVJLWASd6CmAiwwbjYt1mL4gdh1l2264UchNWtOJ6A7SXS
         V6T9RTI8cgYTFZ/HfHF7XVcNSo1M500rA01qT0VAKFlkr5NRCr0UuJw0vTZYTD1p3Aa4
         Tp52/cJdWuOaDZIgJqSrqiYmWFjGduRpalRSe2iJRkBFFtiMc1HR11kguhsGqQjhY6BR
         ADgC2IulIhpB8z+2eGKKV+vwNoWLc5b/HlbrXXNt1BJkZ8JXqdS2ojliF64coJSuky1K
         zKnCaV3NhvFt2tWPzBkK6A187qob/HRrWKYshuiDG4N1LUjqyNpy84rkJDgH5tjUTmMZ
         IYzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=QtYdDcdShOL8G9Lbr8afeC0kB0JEVURYvDX3qsqwMXA=;
        b=l4jCkAcYRf2SApLVlAqcuRmLxahLEGgkzJ4wVEG8JRF7pJVyzJ5cQ74ZcVlSirxO4O
         ItaWmDz5+yV/KUmQka1JTPhq8loKoWCormi5F0oSw321LuUcORy8TWxxT6CckNhN6el1
         u/5RXamDX9uVgYB/9cq03t83ZlqETFev9dDgp7EyH9NTZjza2JHF0buAXr7zdaUL5pmj
         MnUIwrpUQw/ARpqdquX3vto14RgsjgSwsCnSFh8UL/tnWVngzUwUxqH3ZMVPTYwfvQMW
         nQynmZm3U4JRkQVBVmGjrKU3W1O14HIqTa1UT2QOQ+zwnI4OAuM8CZlv5s1Pj5gNGTBe
         uEQw==
X-Gm-Message-State: AGi0Pub0mv+Xz2DGzqgkcmqx75U6nBGEcx8vJvCEC5HaS/TBnsNQVhpP
        oV6aHVgkM+h9yI3ODj5huGi0aIAJAg9pPpA9kLs=
X-Google-Smtp-Source: APiQypJYzje1jcqL2XiLKJnGEI65QWHeXHEbmd99N3+8vZa5U1bcOVH2Fr0gJmW/siYfMDfQb3WTfXToWJSWULP0s1M=
X-Received: by 2002:a19:2d1d:: with SMTP id k29mr835771lfj.46.1585801050997;
 Wed, 01 Apr 2020 21:17:30 -0700 (PDT)
MIME-Version: 1.0
References: <CABDVJk9Btt8bpXr40EL_O9bqY-wAd7N5P9ghp0kTpDQkc8n4=w@mail.gmail.com>
 <CAEzD07Jsbt=FBAPWwU-Fyzm58DAMaz45vWot3DgdKRRKNGPMWQ@mail.gmail.com>
In-Reply-To: <CAEzD07Jsbt=FBAPWwU-Fyzm58DAMaz45vWot3DgdKRRKNGPMWQ@mail.gmail.com>
From:   Nagaprabhanjan Bellari <nagp.lists@gmail.com>
Date:   Thu, 2 Apr 2020 09:47:19 +0530
Message-ID: <CABDVJk-ce6ifDCTkzgS0R7ZzeZnC0vjfo1D82wYw4gCtCQO-Kw@mail.gmail.com>
Subject: Re: Proxy ARP is getting reset on a VLAN interface
To:     Anton Danilov <littlesmilingcloud@gmail.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Many thanks! Setting /proc/sys/net/ipv4/conf/default/proxy_arp to 1
has resolved the issue.

-nagp

On Thu, Apr 2, 2020 at 12:45 AM Anton Danilov
<littlesmilingcloud@gmail.com> wrote:
>
> The ifdown of vlan interface removes the interface completely.
> After ifup (recreating) of vlan interface, this interface inherits the
> proxy_arp value from /proc/sys/net/conf/ipv4/default/proxy_arp.
>
>
> On Wed, 1 Apr 2020 at 21:52, Nagaprabhanjan Bellari
> <nagp.lists@gmail.com> wrote:
> >
> > Hi,
> >
> > I need a small help w.r.t proxy_arp setting on an interface - even if
> > I set /sys/net/conf/ipv4/all/proxy_arp to 1, doing a ifdown and an
> > ifup on a vlan interface resets the proxy_arp setting.
> >
> > This does not happen, for example on a physical interface. ifdown/ifup
> > "remembers" the setting and applies it properly. I am talking about a
> > 3.x kernel.
> >
> > Can something be done to keep this from happening?
> >
> > Thanks,
> > -nagp
>
>
>
> --
> Anton Danilov.
