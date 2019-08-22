Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ED83898B16
	for <lists+netdev@lfdr.de>; Thu, 22 Aug 2019 08:01:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730899AbfHVGAC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Aug 2019 02:00:02 -0400
Received: from mail-wr1-f54.google.com ([209.85.221.54]:42202 "EHLO
        mail-wr1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729081AbfHVGAB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Aug 2019 02:00:01 -0400
Received: by mail-wr1-f54.google.com with SMTP id b16so4154578wrq.9;
        Wed, 21 Aug 2019 23:00:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=WPRFSq1neyk/J1S9hjBx5tFhwspyKWNMnMQs1q9/jA8=;
        b=tGZzA4152JJl/tIY8J7TSQjDsfyp05wKErEYL1gQ+QI3R4ZW2H/2tYEp0i0aDA7mZg
         JPbiLlEiixH9/S/CZo1gSDs7OmCU6AOw/fUySHzxhYQWo2V6rfvIE/9jGlpaxGv8v/Ed
         u9Jmq67QY7jEqo7Ldj2C5PmoNnuktsjmpMfhvJJCXvbjcZ/q/+u7SmmI6ipCmWlqsYH7
         wl2vFcZmv5rMsU+RSklvdNR3YuJDFLANZNgYA/qaVPJKNDp5BUoAYnJrDsVqbt95k3Tu
         ijmdmkIUNw8kAOjdhMBj6bBYOzaAAeHXq0DIovZfzQXmzI+e9uvDpoysnIxov2pDDocx
         /BcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=WPRFSq1neyk/J1S9hjBx5tFhwspyKWNMnMQs1q9/jA8=;
        b=b0zoh2vBEOQwzyrSmCzknI6oZATHIReshvDdmp27a3QEQN9in974Os52THeXO2+TSb
         xsd0s8RKwlLBJHBhIfnUs/JdXUEzGmrz1d1CYuWgaHbfD/aVCeTvGrIJP9o64R/fOOqa
         vKHUCdBob7K5mbT3RoGEjWMYiZYJ+eMvUQvGFU/0dk+AyLbw+5swsXwPBe1UJqhBPeQ4
         tmCel+dWv2Jn5KEDU8MlpzKDA61B653x3zBPsXFy7n4+k/zNX2vjY/XfHh4GUtlMmaUy
         O0Fb6m4zjj3AVzEt3TJ4eOSSWjt9cpaak5xNUxdBnaWDdosjitIrXDisJFEGQVSzmdEC
         c17w==
X-Gm-Message-State: APjAAAVrB99frMF5LEPyGVHz0gw7LwA9MOkpfWJH2BuPwIRACwDpd/TZ
        8JdtZZgPIrX7ebFv9i8eTvFKc9tNXBM+K7Ssj3I=
X-Google-Smtp-Source: APXvYqzsQDssV9A4LDwaI8Kmseew2Y08WytO/GRgulr2N+6D2IXcned//oLTMxni3LiIk0Mqa5dubvF9N3uO0hmMiwA=
X-Received: by 2002:a5d:4a11:: with SMTP id m17mr38371847wrq.40.1566453599721;
 Wed, 21 Aug 2019 22:59:59 -0700 (PDT)
MIME-Version: 1.0
References: <CAA5aLPhf1=wzQG0BAonhR3td-RhEmXaczug8n4hzXCzreb+52g@mail.gmail.com>
 <CAM_iQpVyEtOGd5LbyGcSNKCn5XzT8+Ouup26fvE1yp7T5aLSjg@mail.gmail.com>
 <CAA5aLPiqyhnWjY7A3xsaNJ71sDOf=Rqej8d+7=_PyJPmV9uApA@mail.gmail.com>
 <CAM_iQpUH6y8oEct3FXUhqNekQ3sn3N7LoSR0chJXAPYUzvWbxA@mail.gmail.com>
 <CAA5aLPjzX+9YFRGgCgceHjkU0=e6x8YMENfp_cC9fjfHYK3e+A@mail.gmail.com> <CAM_iQpXBhrOXtfJkibyxyq781Pjck-XJNgZ-=Ucj7=DeG865mw@mail.gmail.com>
In-Reply-To: <CAM_iQpXBhrOXtfJkibyxyq781Pjck-XJNgZ-=Ucj7=DeG865mw@mail.gmail.com>
From:   Akshat Kakkar <akshat.1984@gmail.com>
Date:   Thu, 22 Aug 2019 11:29:49 +0530
Message-ID: <CAA5aLPjO9rucCLJnmQiPBxw2pJ=6okf3C88rH9GWnh3p0R+Rmw@mail.gmail.com>
Subject: Re: Unable to create htb tc classes more than 64K
To:     Cong Wang <xiyou.wangcong@gmail.com>,
        Anton Danilov <littlesmilingcloud@gmail.com>
Cc:     NetFilter <netfilter-devel@vger.kernel.org>,
        lartc <lartc@vger.kernel.org>, netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 22, 2019 at 3:37 AM Cong Wang <xiyou.wangcong@gmail.com> wrote:
> > I am using ipset +  iptables to classify and not filters. Besides, if
> > tc is allowing me to define qdisc -> classes -> qdsic -> classes
> > (1,2,3 ...) sort of structure (ie like the one shown in ascii tree)
> > then how can those lowest child classes be actually used or consumed?
>
> Just install tc filters on the lower level too.

If I understand correctly, you are saying,
instead of :
tc filter add dev eno2 parent 100: protocol ip prio 1 handle
0x00000001 fw flowid 1:10
tc filter add dev eno2 parent 100: protocol ip prio 1 handle
0x00000002 fw flowid 1:20
tc filter add dev eno2 parent 100: protocol ip prio 1 handle
0x00000003 fw flowid 2:10
tc filter add dev eno2 parent 100: protocol ip prio 1 handle
0x00000004 fw flowid 2:20


I should do this: (i.e. changing parent to just immediate qdisc)
tc filter add dev eno2 parent 1: protocol ip prio 1 handle 0x00000001
fw flowid 1:10
tc filter add dev eno2 parent 1: protocol ip prio 1 handle 0x00000002
fw flowid 1:20
tc filter add dev eno2 parent 2: protocol ip prio 1 handle 0x00000003
fw flowid 2:10
tc filter add dev eno2 parent 2: protocol ip prio 1 handle 0x00000004
fw flowid 2:20

I tried this previously. But there is not change in the result.
Behaviour is exactly same, i.e. I am still getting 100Mbps and not
100kbps or 300kbps

Besides, as I mentioned previously I am using ipset + skbprio and not
filters stuff. Filters I used just to test.

ipset  -N foo hash:ip,mark skbinfo

ipset -A foo 10.10.10.10, 0x0x00000001 skbprio 1:10
ipset -A foo 10.10.10.20, 0x0x00000002 skbprio 1:20
ipset -A foo 10.10.10.30, 0x0x00000003 skbprio 2:10
ipset -A foo 10.10.10.40, 0x0x00000004 skbprio 2:20

iptables -A POSTROUTING -j SET --map-set foo dst,dst --map-prio

That's why I added @Anton Danilov in cc, so that he can have a look as
he designed this skbprio thing in ipset and thus would be having a
better idea.
