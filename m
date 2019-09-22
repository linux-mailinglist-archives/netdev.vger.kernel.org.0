Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2B860BA12F
	for <lists+netdev@lfdr.de>; Sun, 22 Sep 2019 07:47:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727499AbfIVFrl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Sep 2019 01:47:41 -0400
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:48823 "EHLO
        relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727453AbfIVFrl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 Sep 2019 01:47:41 -0400
X-Originating-IP: 209.85.221.182
Received: from mail-vk1-f182.google.com (mail-vk1-f182.google.com [209.85.221.182])
        (Authenticated sender: pshelar@ovn.org)
        by relay4-d.mail.gandi.net (Postfix) with ESMTPSA id 22A8EE0002
        for <netdev@vger.kernel.org>; Sun, 22 Sep 2019 05:47:38 +0000 (UTC)
Received: by mail-vk1-f182.google.com with SMTP id j21so2348846vki.11
        for <netdev@vger.kernel.org>; Sat, 21 Sep 2019 22:47:38 -0700 (PDT)
X-Gm-Message-State: APjAAAVrjekvhpEylpqhpV+jkl/0ooHh6A20YwtKlVtpDIfIX7duQ4Sd
        tQIsLqXYQ/TW20vHXrYSCrrvcwfRufEXtvotq4o=
X-Google-Smtp-Source: APXvYqxvA6pLgeJ19mo8C9CpUmKWpq7h1UaQosIL/p1MzqkkQguDe2iONL+b/wrAsCBemaiIcb0zTCI0iyYSJtB0DE4=
X-Received: by 2002:ac5:c7bb:: with SMTP id d27mr12521494vkn.19.1569131257787;
 Sat, 21 Sep 2019 22:47:37 -0700 (PDT)
MIME-Version: 1.0
References: <1568734808-42628-1-git-send-email-xiangxia.m.yue@gmail.com>
 <CAOrHB_DONiJ7Z41xAm5DhkjcrXDrgu6XNpscw1qf592wdMH5bg@mail.gmail.com> <5d86ef21.1c69fb81.d4519.2861SMTPIN_ADDED_MISSING@mx.google.com>
In-Reply-To: <5d86ef21.1c69fb81.d4519.2861SMTPIN_ADDED_MISSING@mx.google.com>
From:   Pravin Shelar <pshelar@ovn.org>
Date:   Sat, 21 Sep 2019 22:50:58 -0700
X-Gmail-Original-Message-ID: <CAOrHB_CeDqYw4WR2AmUS5TN93mGptgZN-KNjtNNnHxQa7DqZ-Q@mail.gmail.com>
Message-ID: <CAOrHB_CeDqYw4WR2AmUS5TN93mGptgZN-KNjtNNnHxQa7DqZ-Q@mail.gmail.com>
Subject: Re: [PATCH net] net: openvswitch: fix possible memleak on createvport fails
To:     Hillf Danton <hdanton@sina.com>
Cc:     Tonghao Zhang <xiangxia.m.yue@gmail.com>,
        Greg Rose <gvrose8192@gmail.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Taehee Yoo <ap420073@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Sep 21, 2019 at 8:48 PM Hillf Danton <hdanton@sina.com> wrote:
>
> On Sun, 9 Sep 2019 11:14 from Pravin Shelar <pshelar@ovn.org>
>
> >
>
> > There is already patch a patch to fix this memory leak.
>
> > https://patchwork.ozlabs.org/patch/1144316/
>
> > Can you or Hillf post it on netdev list?
>
>
>
> Was that posted without netdev Cced?

I do not see your patch on netdev patchwork, repost of the patch would
put it on netdev patchwork.
