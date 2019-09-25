Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4AB12BE6C1
	for <lists+netdev@lfdr.de>; Wed, 25 Sep 2019 22:59:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393466AbfIYU7J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Sep 2019 16:59:09 -0400
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:37865 "EHLO
        relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391186AbfIYU7I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Sep 2019 16:59:08 -0400
X-Originating-IP: 209.85.217.45
Received: from mail-vs1-f45.google.com (mail-vs1-f45.google.com [209.85.217.45])
        (Authenticated sender: pshelar@ovn.org)
        by relay3-d.mail.gandi.net (Postfix) with ESMTPSA id 2160F60007
        for <netdev@vger.kernel.org>; Wed, 25 Sep 2019 20:59:05 +0000 (UTC)
Received: by mail-vs1-f45.google.com with SMTP id w195so69618vsw.11
        for <netdev@vger.kernel.org>; Wed, 25 Sep 2019 13:59:05 -0700 (PDT)
X-Gm-Message-State: APjAAAXWG5IA/hSv59xPyF7hKztg7m9y1k679yc16AwHK/iYr/MPzelw
        pD/BN+aR3ZEo5coadifw/a9CZ++1epyWyfuAYyI=
X-Google-Smtp-Source: APXvYqxa44JSUAgX39P0w9V7xmnRRJ5XQ8ptdg8Wa+cJ8HgMTONh+3xGHRLnwKo4DxITwk2zqeChVQlnNNiAcBhWRs4=
X-Received: by 2002:a67:f314:: with SMTP id p20mr249034vsf.66.1569445143162;
 Wed, 25 Sep 2019 13:59:03 -0700 (PDT)
MIME-Version: 1.0
References: <1569323512-19195-1-git-send-email-lirongqing@baidu.com>
In-Reply-To: <1569323512-19195-1-git-send-email-lirongqing@baidu.com>
From:   Pravin Shelar <pshelar@ovn.org>
Date:   Wed, 25 Sep 2019 14:02:34 -0700
X-Gmail-Original-Message-ID: <CAOrHB_Drgcyxa_2yR4QyyUTkADxT=mdRwPSKOgTrefpnQq5-=g@mail.gmail.com>
Message-ID: <CAOrHB_Drgcyxa_2yR4QyyUTkADxT=mdRwPSKOgTrefpnQq5-=g@mail.gmail.com>
Subject: Re: [PATCH] openvswitch: change type of UPCALL_PID attribute to NLA_UNSPEC
To:     Li RongQing <lirongqing@baidu.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 24, 2019 at 4:11 AM Li RongQing <lirongqing@baidu.com> wrote:
>
> userspace openvswitch patch "(dpif-linux: Implement the API
> functions to allow multiple handler threads read upcall)"
> changes its type from U32 to UNSPEC, but leave the kernel
> unchanged
>
> and after kernel 6e237d099fac "(netlink: Relax attr validation
> for fixed length types)", this bug is exposed by the below
> warning
>
>         [   57.215841] netlink: 'ovs-vswitchd': attribute type 5 has an invalid length.
>
> Signed-off-by: Li RongQing <lirongqing@baidu.com>

Acked-by: Pravin B Shelar <pshelar@ovn.org>

Thanks,
Pravin.
