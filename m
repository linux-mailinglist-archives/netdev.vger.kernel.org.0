Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DC49091235
	for <lists+netdev@lfdr.de>; Sat, 17 Aug 2019 20:24:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726298AbfHQSYZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Aug 2019 14:24:25 -0400
Received: from mail-pl1-f172.google.com ([209.85.214.172]:40864 "EHLO
        mail-pl1-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726046AbfHQSYZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 17 Aug 2019 14:24:25 -0400
Received: by mail-pl1-f172.google.com with SMTP id h3so440123pls.7;
        Sat, 17 Aug 2019 11:24:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ChyHBGIA+t8HHZ8fjN+eZZX89DxnxMH1aUXinF6wiX8=;
        b=CWGpTz2+Kce16DRmUO/jFzSJe3WGQ96RREy4aTkTsTuVqHqQ87tvxcxU4KOiMDYdFt
         XriNb+8VEE4C0sObeH36vyFboMPwZnl7k1/KsZtBmJuQVclQcm91hnpT3X554q4XYmYU
         lGiZ0+gegS6xUNmS27Sor+eyACUmAJkmwTc2nLNPmqaNhHB/hCZMR6YMHsEGW2VbnQJ6
         hhttkt0vv7FUz5+a0Nyu9bwdQ+k4kESZ8TYKQkPEN0LQnqp+m9xk1/M017UmR6jtDMS3
         GPfm/trqEYTQS6SLn/z4OuZ1X9s8do2BIEGJkWPufQmH6fKVmtbiIzhLi4yNRGCdAeAG
         3UoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ChyHBGIA+t8HHZ8fjN+eZZX89DxnxMH1aUXinF6wiX8=;
        b=MdtErWUVYq/g0iXIM0aZYzw1C2KUD53Pwa3OUfM1XsTQE0w2fhAJmgMi05eBW9ZhFN
         IiHdcyW7ce/4Nfpp8Tec/aJ/uhY7Yz/pJmHedSgtvDhItW3uS67uxbGJm6INH+2aJfJ2
         Y/ZqZ0FWBF+s+5ri1vtm8ThODOkABHMy1HWtue02mP/0KOW7M/d1HhvJFThCVgHTdfdz
         u0BFoW+eNc113hPeVEY3Tw7Na2dN2G22Yim+1b7skufui8yMb+HQ5Pdnd4UeFvMxLbnn
         r0B4KNUeImc3jQwA6lysHMmayUv/HUbmQE9LqgWbJQMiMgvfqupG24kbEJZeS2fSGhbt
         zU1A==
X-Gm-Message-State: APjAAAWzK9ISvG+/hJzU4LvISo+QynUXijn6iOOeeTl4JFairPiZ+qXA
        peXBIlBy8j146JwJ8hPg9wr5TDZ+zuEF/orbH7bPQg==
X-Google-Smtp-Source: APXvYqzgr7bPKeOp+oPpw+bieCQE/gQng0l173PxZmamuwodfUO57xHUDUAl0sCyN2qsf9k5Fdt9dWM8wn4yaMG4ZJw=
X-Received: by 2002:a17:902:7286:: with SMTP id d6mr15082675pll.61.1566066264315;
 Sat, 17 Aug 2019 11:24:24 -0700 (PDT)
MIME-Version: 1.0
References: <CAA5aLPhf1=wzQG0BAonhR3td-RhEmXaczug8n4hzXCzreb+52g@mail.gmail.com>
 <CAM_iQpVyEtOGd5LbyGcSNKCn5XzT8+Ouup26fvE1yp7T5aLSjg@mail.gmail.com> <CAA5aLPiqyhnWjY7A3xsaNJ71sDOf=Rqej8d+7=_PyJPmV9uApA@mail.gmail.com>
In-Reply-To: <CAA5aLPiqyhnWjY7A3xsaNJ71sDOf=Rqej8d+7=_PyJPmV9uApA@mail.gmail.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Sat, 17 Aug 2019 11:24:13 -0700
Message-ID: <CAM_iQpUH6y8oEct3FXUhqNekQ3sn3N7LoSR0chJXAPYUzvWbxA@mail.gmail.com>
Subject: Re: Unable to create htb tc classes more than 64K
To:     Akshat Kakkar <akshat.1984@gmail.com>
Cc:     NetFilter <netfilter-devel@vger.kernel.org>,
        lartc <lartc@vger.kernel.org>, netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Aug 17, 2019 at 5:46 AM Akshat Kakkar <akshat.1984@gmail.com> wrote:
>
> I agree that it is because of 16bit of minor I'd of class which
> restricts it to 64K.
> Point is, can we use multilevel qdisc and classes to extend it to more
> no. of classes i.e. to more than 64K classes

If your goal is merely having as many classes as you can, then yes.


>
> One scheme can be like
>                                       100: root qdisc
>                                          |
>                                        / | \
>                                      /   |   \
>                                    /     |     \
>                                  /       |       \
>                           100:1   100:2   100:3        child classes
>                             |              |           |
>                             |              |           |
>                             |              |           |
>                            1:            2:          3:     qdisc
>                            / \           / \           / \
>                          /     \                     /     \
>                       1:1    1:2             3:1      3:2 leaf classes
>
> with all qdisc and classes defined as htb.
>
> Is this correct approach? Any alternative??

Again, depends on what your goal is.


>
> Besides, in order to direct traffic to leaf classes 1:1, 1:2, 2:1,
> 2:2, 3:1, 3:2 .... , instead of using filters I am using ipset with
> skbprio and iptables map-set match rule.
> But even after all this it don't work. Why?

Again, the filters you use to classify the packets could only
work for the classes on the same level, no the next level.


Thanks.
