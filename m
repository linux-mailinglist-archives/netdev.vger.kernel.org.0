Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3DFBE8BEE4
	for <lists+netdev@lfdr.de>; Tue, 13 Aug 2019 18:47:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727351AbfHMQrx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Aug 2019 12:47:53 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:39815 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726769AbfHMQrx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Aug 2019 12:47:53 -0400
Received: by mail-pg1-f194.google.com with SMTP id u17so51547026pgi.6
        for <netdev@vger.kernel.org>; Tue, 13 Aug 2019 09:47:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=lwUTEOGkM8sxlOAtWcejs41m6Ts0cX1I7Ao3u3wRNJI=;
        b=uo02fIr5cVpOxVTQ6I7g9Ok7UYjJgtMhaA5D3leZ+hiQ3eQUT41tmzbQYDnNMwpJH5
         ol42b2XlbmxqPjbpN/hNmKYHVFVKR4o6iC/YUHQdZyNBPXtdij0FpHIheAYs3VK7pjYJ
         yXJGQfCR8BWwlKuKj2VnrRL5THITkk3V4bi6eUH330gwsM6x37JwTWOJXYa+W5xD8AlC
         mn9pkwDzNnqpuCv298N9z/GgsznVpW9lBGoqQcSMDVA6cTsyPhOcgMbRW5s1sW52YIs5
         DlARe39zMVtZnDkqpfvd1AwWUi9TlctYxPAct0eHTYZbMaxOPtwVl6WXjiEkhnsbOvKj
         57cQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=lwUTEOGkM8sxlOAtWcejs41m6Ts0cX1I7Ao3u3wRNJI=;
        b=YzW2eq1l7TZIL9gN+ZwBTMKw9xsmFKMwThUyKKEHCyyreAPaKFL7k1F5y/AB6F1cCf
         8+p312Axw6wd8v/I7cVoWHjt83EWp8sTpzaLZ+d1RFa8cRKHFNSg1qL0SMt6/YhKG4eW
         6W/ceI0i5iqKv7ubScnBUA9llvT2dodegiisOUFUyARZor9VGg5aDyZvnwr6/74x1823
         XnYir4k/pRjONjB/Wm/Uzu5yXGzbh09y6O470f+18I22Y2lJ3yl9BZPWV2c0jByWHpej
         0+EYJSrjO2vJZQMBgmGgG2XQN9gktG8SvxoKJ4lN+D7HzZyaK8c2LHdj6IN1eproURsr
         pvHg==
X-Gm-Message-State: APjAAAWMfmtTkQ07w4P56QPuhXCu4adDsTQbTYoH5zWWvasTKE4ddamt
        jR5jxtAJXyIYwQNZbIx+LsyPN2AavkIpkQF8Xqq8JbTS
X-Google-Smtp-Source: APXvYqyjFF9J/+DUk9Uam//jKjuK8bo9k2jMox/ZiJUXjqFUGA7PJTrQLHgsAbSQuh40b9keW6o1KhWCLJhqNrITdUs=
X-Received: by 2002:a63:8a43:: with SMTP id y64mr35263648pgd.104.1565714872656;
 Tue, 13 Aug 2019 09:47:52 -0700 (PDT)
MIME-Version: 1.0
References: <CAAT+qEa6Yw-tf3L_R-phzSvLiGOdW9uLhFGNTz+i9eWhBT_+DA@mail.gmail.com>
 <CAAT+qEbOx8Jh3aFS-e7U6FyHo03sdcY6UoeGzwYQbO6WRjc3PQ@mail.gmail.com>
In-Reply-To: <CAAT+qEbOx8Jh3aFS-e7U6FyHo03sdcY6UoeGzwYQbO6WRjc3PQ@mail.gmail.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Tue, 13 Aug 2019 09:47:41 -0700
Message-ID: <CAM_iQpW-kTV1ZL-OnS2TNVcso1NbiiPn0eUz=7f5uTpFucz7sw@mail.gmail.com>
Subject: Re: tc - mirred ingress not supported at the moment
To:     Martin Olsson <martin.olsson+netdev@sentorsecurity.com>
Cc:     netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 13, 2019 at 4:05 AM Martin Olsson
<martin.olsson+netdev@sentorsecurity.com> wrote:
> Q1: Why was 'ingress' not implemented at the same time as 'egress'?

Because you are using an old iproute2.

ingress support is added by:
https://git.kernel.org/pub/scm/network/iproute2/iproute2.git/commit/?id=5eca0a3701223619a513c7209f7d9335ca1b4cfa


> 2)
> Ok, so I have to use 'egress':
> # tc filter add dev eno2 parent ffff: prio 999  protocol all matchall
> action mirred egress redirect dev mon0


So you redirect packets from eno2's ingress to mon0's egress.


>
> Since the mirred action forces me to use 'egress' as the direction on
> the dest interface, all kinds of network statistics tools show
> incorrect counters. :-(
> eno2 is a pure sniffer interface (it is connected to the SPAN dest
> port of a switch).
> All packets (matchall) on eno2 are mirrored to mon0.
>
> # ip -s link show dev eno2
>     ...
>     ...
>     RX: bytes  packets  errors  dropped overrun mcast
>     13660757   16329    0       0       0       0
>     TX: bytes  packets  errors  dropped carrier collsns
>     0          0        0       0       0       0
> # ip -s link show dev mon0
>     ...
>     ...
>     RX: bytes  packets  errors  dropped overrun mcast
>     0          0        0       0       0       0
>     TX: bytes  packets  errors  dropped carrier collsns
>     13660757   16329    0       0       0       0
>
> eno2 and mon0 should be identical, but they are inverted.

Yes, this behavior is correct. The keyword "egress" in your cmdline
already says so.

>
> Q2: So... Can the 'ingress' option please be implemented? (I'm no
> programmer, so unfortunetly I can't do it myself).

It is completed, you need to update your iproute2 and kernel.

Thanks.
