Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0672FED258
	for <lists+netdev@lfdr.de>; Sun,  3 Nov 2019 07:48:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727533AbfKCGr5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 Nov 2019 01:47:57 -0500
Received: from relay8-d.mail.gandi.net ([217.70.183.201]:43445 "EHLO
        relay8-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726379AbfKCGr5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 3 Nov 2019 01:47:57 -0500
X-Originating-IP: 209.85.221.179
Received: from mail-vk1-f179.google.com (mail-vk1-f179.google.com [209.85.221.179])
        (Authenticated sender: pshelar@ovn.org)
        by relay8-d.mail.gandi.net (Postfix) with ESMTPSA id EA6DE1BF203
        for <netdev@vger.kernel.org>; Sun,  3 Nov 2019 06:47:55 +0000 (UTC)
Received: by mail-vk1-f179.google.com with SMTP id j84so3102936vkj.6
        for <netdev@vger.kernel.org>; Sat, 02 Nov 2019 23:47:55 -0700 (PDT)
X-Gm-Message-State: APjAAAX2Fg5u1b4/Fa1flPuRvv0oxqWlp1zHQhxGgc0keyNIq1clxYx5
        HKX979JiFm2ZNM38sLJIOvmNfgVoYUC/v54harc=
X-Google-Smtp-Source: APXvYqzcD0yTHnI8IhZhH7HReC4FN+y68qDLJ/D90iIOf/xK8WrCsUnH9a63w/ZRFV7Kedp/quC/wBs4hTOMyVKe40U=
X-Received: by 2002:a1f:d401:: with SMTP id l1mr8880444vkg.27.1572763674724;
 Sat, 02 Nov 2019 23:47:54 -0700 (PDT)
MIME-Version: 1.0
References: <1572618234-6904-1-git-send-email-xiangxia.m.yue@gmail.com> <1572618234-6904-9-git-send-email-xiangxia.m.yue@gmail.com>
In-Reply-To: <1572618234-6904-9-git-send-email-xiangxia.m.yue@gmail.com>
From:   Pravin Shelar <pshelar@ovn.org>
Date:   Sat, 2 Nov 2019 23:47:43 -0700
X-Gmail-Original-Message-ID: <CAOrHB_AkMjpJ_Oc79uXtVnE-4qiEZpsaNO5mkg_im+PqFO81FQ@mail.gmail.com>
Message-ID: <CAOrHB_AkMjpJ_Oc79uXtVnE-4qiEZpsaNO5mkg_im+PqFO81FQ@mail.gmail.com>
Subject: Re: [PATCH net-next v6 08/10] net: openvswitch: fix possible memleak
 on destroy flow-table
To:     Tonghao Zhang <xiangxia.m.yue@gmail.com>
Cc:     Greg Rose <gvrose8192@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        ovs dev <dev@openvswitch.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 1, 2019 at 7:24 AM <xiangxia.m.yue@gmail.com> wrote:
>
> From: Tonghao Zhang <xiangxia.m.yue@gmail.com>
>
> When we destroy the flow tables which may contain the flow_mask,
> so release the flow mask struct.
>
> Signed-off-by: Tonghao Zhang <xiangxia.m.yue@gmail.com>
> Tested-by: Greg Rose <gvrose8192@gmail.com>
> ---
Acked-by: Pravin B Shelar <pshelar@ovn.org>
