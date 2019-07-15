Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B4C8769AA1
	for <lists+netdev@lfdr.de>; Mon, 15 Jul 2019 20:15:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731822AbfGOSPJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Jul 2019 14:15:09 -0400
Received: from relay10.mail.gandi.net ([217.70.178.230]:40229 "EHLO
        relay10.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729535AbfGOSPJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Jul 2019 14:15:09 -0400
Received: from mail-vs1-f41.google.com (mail-vs1-f41.google.com [209.85.217.41])
        (Authenticated sender: pshelar@ovn.org)
        by relay10.mail.gandi.net (Postfix) with ESMTPSA id 14313240009
        for <netdev@vger.kernel.org>; Mon, 15 Jul 2019 18:14:59 +0000 (UTC)
Received: by mail-vs1-f41.google.com with SMTP id 2so12023049vso.8
        for <netdev@vger.kernel.org>; Mon, 15 Jul 2019 11:14:59 -0700 (PDT)
X-Gm-Message-State: APjAAAWQ3NTSx1/TATc0i/dBmgH3JbbzfLgdXRKXsXtOLmqCA1wTzZgJ
        SDGHb/AclzLuWlqOKfBJyx2gtUFmun1nbK9sr+s=
X-Google-Smtp-Source: APXvYqwVJYUbU67qqeU0dhnPfJ1EO8ly9l/SYnHA7ycalSFTBS/vADr3MFA4cDjOPyG58fWtwIZMP6N+2ffqFbT3BYg=
X-Received: by 2002:a67:8d8a:: with SMTP id p132mr16802504vsd.103.1563214498122;
 Mon, 15 Jul 2019 11:14:58 -0700 (PDT)
MIME-Version: 1.0
References: <20190705160809.5202-1-ap420073@gmail.com>
In-Reply-To: <20190705160809.5202-1-ap420073@gmail.com>
From:   Pravin Shelar <pshelar@ovn.org>
Date:   Mon, 15 Jul 2019 11:15:01 -0700
X-Gmail-Original-Message-ID: <CAOrHB_DXSo37ZttVcW3fEuvB9_-2VtzZgf0JNq1ZhSfJJHSa7Q@mail.gmail.com>
Message-ID: <CAOrHB_DXSo37ZttVcW3fEuvB9_-2VtzZgf0JNq1ZhSfJJHSa7Q@mail.gmail.com>
Subject: Re: [PATCH net-next] net: openvswitch: do not update max_headroom if
 new headroom is equal to old headroom
To:     Taehee Yoo <ap420073@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        ovs dev <dev@openvswitch.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 5, 2019 at 9:08 AM Taehee Yoo <ap420073@gmail.com> wrote:
>
> When a vport is deleted, the maximum headroom size would be changed.
> If the vport which has the largest headroom is deleted,
> the new max_headroom would be set.
> But, if the new headroom size is equal to the old headroom size,
> updating routine is unnecessary.
>
> Signed-off-by: Taehee Yoo <ap420073@gmail.com>

Sorry for late reply. This patch looks good to me too.

I am curious about reason to avoid adjustment to headroom. why are you
trying to avoid unnecessary changes to headroom.

Thanks,
Pravin.
