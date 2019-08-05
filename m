Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 397008264B
	for <lists+netdev@lfdr.de>; Mon,  5 Aug 2019 22:49:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730099AbfHEUta (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Aug 2019 16:49:30 -0400
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:51457 "EHLO
        relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727460AbfHEUta (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Aug 2019 16:49:30 -0400
X-Originating-IP: 209.85.222.41
Received: from mail-ua1-f41.google.com (mail-ua1-f41.google.com [209.85.222.41])
        (Authenticated sender: pshelar@ovn.org)
        by relay3-d.mail.gandi.net (Postfix) with ESMTPSA id 5C73060004
        for <netdev@vger.kernel.org>; Mon,  5 Aug 2019 20:49:28 +0000 (UTC)
Received: by mail-ua1-f41.google.com with SMTP id s4so32787403uad.7
        for <netdev@vger.kernel.org>; Mon, 05 Aug 2019 13:49:28 -0700 (PDT)
X-Gm-Message-State: APjAAAWr2XYLURF14c0b8vbx0iG9QyuvoOQ3p9XlxHqRzCyl/nsALfPB
        dyGxZf28ThINN5ysYRMtYPrBnGjkrP1R2FBE29k=
X-Google-Smtp-Source: APXvYqxqBygBVMd/bkLwQh2Jt9ejcNQyIRBSw/br3OGXwpEMExy/7aSvs+K+dZ4txanXIxjOhOhngyze+F7vdI65gIY=
X-Received: by 2002:ab0:699a:: with SMTP id t26mr75719uaq.70.1565038167079;
 Mon, 05 Aug 2019 13:49:27 -0700 (PDT)
MIME-Version: 1.0
References: <1564973771-22542-1-git-send-email-pkusunyifeng@gmail.com>
In-Reply-To: <1564973771-22542-1-git-send-email-pkusunyifeng@gmail.com>
From:   Pravin Shelar <pshelar@ovn.org>
Date:   Mon, 5 Aug 2019 13:50:32 -0700
X-Gmail-Original-Message-ID: <CAOrHB_C758HjLJxb3jzAn0Wy1a_m4G2o4gsqMDdhJ9PRdT4GUg@mail.gmail.com>
Message-ID: <CAOrHB_C758HjLJxb3jzAn0Wy1a_m4G2o4gsqMDdhJ9PRdT4GUg@mail.gmail.com>
Subject: Re: [PATCH net-next v2] openvswitch: Print error when
 ovs_execute_actions() fails
To:     Yifeng Sun <pkusunyifeng@gmail.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Greg Rose <gvrose8192@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Aug 4, 2019 at 7:56 PM Yifeng Sun <pkusunyifeng@gmail.com> wrote:
>
> Currently in function ovs_dp_process_packet(), return values of
> ovs_execute_actions() are silently discarded. This patch prints out
> an debug message when error happens so as to provide helpful hints
> for debugging.
> ---
> v1->v2: Fixed according to Pravin's review.
>

Looks good.
Acked-by: Pravin B Shelar <pshelar@ovn.org>

Thanks,
Pravin.
