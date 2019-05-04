Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 87B8E13B8A
	for <lists+netdev@lfdr.de>; Sat,  4 May 2019 20:28:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727097AbfEDS14 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 May 2019 14:27:56 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:37332 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726514AbfEDS14 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 May 2019 14:27:56 -0400
Received: by mail-pg1-f193.google.com with SMTP id e6so4352935pgc.4
        for <netdev@vger.kernel.org>; Sat, 04 May 2019 11:27:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=fsSyWIIea0chWSXI1d4vmxLSlgV8eO+u1cbDHs170sg=;
        b=OCOaAB3p6ESC60cynLdbYIO0MAjoO+tpCCBoSg9+/HrZk5cd3/5XRPlTkTQ76kjicf
         tswUsiDQsyZNDPwaqAQA9izZIob1xgJCBpkW6qHOF4StE8luR4+QB1YuvpT6bCjK1olp
         MkKapvJYk8IUuHrTlr5Fi01ShOmkmwaB4akbyWLYtRFCPTScxB6BQJDpQtB5rz/a1wHd
         k696rC7Ku/MliyRlx/7YIHFF7jmsIq60W+7VW3IaqPrrwEYO7ihIVlTzDG+UyGvNF/+q
         1w3Bv6q8mzcTvJ/emsarvwRxz17aC0/iVFSg979DVK8C5HAQwIVcrSf99GjCWbPyTbZy
         qX0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=fsSyWIIea0chWSXI1d4vmxLSlgV8eO+u1cbDHs170sg=;
        b=PrDVYA30VIXoDsOkoVI9ew6NflstkKEhFZOQnXcUgcNosLIBRlAnQjSoV2icJIm51O
         go/FTIwr200VMeWi7ufXAersG3H9DUHD3D5FMDSDJ1kEzl+RBVwVP5pzsJ0pfVXX6nll
         4NePbogK2v0VZ5W7CwNSvIollwWuDAD90JeM0i/+mb1R3tO/mrweh2VLJmc5cJ0ifu0Y
         qXFUl+8O3J16JOQSfYQQDM4AfrF6uVxHZJDGPIHwgelk3cYi0sNdyfifWR5Gs0+PcMY7
         CfQEkIBU4e31/ReXWvN9dhjgX0UW9zhJE3KHE3f6SGiMDhH6TKqJ0KPEIVSEsR9Fiidz
         ijIg==
X-Gm-Message-State: APjAAAUWTC8o1Dl6HIC5x2d0pinY08Twzg/dVYkZBhBoLVua+2elWXyL
        angZy3t3EgPR8grILZGI2iya/pzkl/IrxlomGaE=
X-Google-Smtp-Source: APXvYqzOCfgUS+TuFtOARKNuByxSZuImQxE2xeRhCjtpiPVq/WlWT4mtSu25TFYGbtf0bQ5/Xfd+94aoqYILydeDri4=
X-Received: by 2002:a63:134e:: with SMTP id 14mr12834497pgt.226.1556994475019;
 Sat, 04 May 2019 11:27:55 -0700 (PDT)
MIME-Version: 1.0
References: <20190502180610.10369-1-xiyou.wangcong@gmail.com>
 <4d2d89b1-f52b-a978-75a5-39522e3eef05@gmail.com> <CAM_iQpV4CJVXP0STJs-MWREkU1uxg5HsvMpTkiRfpK7Smz-J9g@mail.gmail.com>
 <CANn89iKhyVk8AfAdKJUPho7bKiZ9Aqa3aovrgTbUBft+8gDeig@mail.gmail.com>
In-Reply-To: <CANn89iKhyVk8AfAdKJUPho7bKiZ9Aqa3aovrgTbUBft+8gDeig@mail.gmail.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Sat, 4 May 2019 11:27:43 -0700
Message-ID: <CAM_iQpX6LZ1OFXapOJpdteSSM+fOHnC0QpnJRkexq3dVZzp_bw@mail.gmail.com>
Subject: Re: [Patch net-next] sch_htb: redefine htb qdisc overlimits
To:     Eric Dumazet <edumazet@google.com>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, May 4, 2019 at 11:10 AM Eric Dumazet <edumazet@google.com> wrote:
>
> On Sat, May 4, 2019 at 1:49 PM Cong Wang <xiyou.wangcong@gmail.com> wrote:
>
> > Sure, v2 is coming. :)
>
> Another possibility would to reuse existing sch->qstats.overlimits ?

I don't find any way to retrieve qdisc pointer from struct htb_sched,
unless we add a pointer there, which will end up bigger.

Or refactor the functions on the call path of htb_change_class_mode()
to use struct Qdisc*, which will end up a bigger patch.

Therefore, I think your suggestion of folding it into 'direct_pkts' is better.

Thanks.
