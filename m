Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2F66B19E14A
	for <lists+netdev@lfdr.de>; Sat,  4 Apr 2020 01:08:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728456AbgDCXIK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Apr 2020 19:08:10 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:36396 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727829AbgDCXIK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Apr 2020 19:08:10 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id BB394121938E3;
        Fri,  3 Apr 2020 16:08:09 -0700 (PDT)
Date:   Fri, 03 Apr 2020 16:08:09 -0700 (PDT)
Message-Id: <20200403.160809.1500394661848619682.davem@davemloft.net>
To:     zeil@yandex-team.ru
Cc:     netdev@vger.kernel.org, khlebnikov@yandex-team.ru,
        cgroups@vger.kernel.org, bpf@vger.kernel.org
Subject: Re: [PATCH v3 net] inet_diag: add cgroup id attribute
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200403095627.GA85072@yandex-team.ru>
References: <20200403095627.GA85072@yandex-team.ru>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 03 Apr 2020 16:08:10 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dmitry Yakunin <zeil@yandex-team.ru>
Date: Fri, 3 Apr 2020 12:56:27 +0300

> This patch adds cgroup v2 ID to common inet diag message attributes.
> Cgroup v2 ID is kernfs ID (ino or ino+gen). This attribute allows filter
> inet diag output by cgroup ID obtained by name_to_handle_at() syscall.
> When net_cls or net_prio cgroup is activated this ID is equal to 1 (root
> cgroup ID) for newly created sockets.
> 
> Some notes about this ID:
> 
> 1) gets initialized in socket() syscall
> 2) incoming socket gets ID from listening socket
>    (not during accept() syscall)
> 3) not changed when process get moved to another cgroup
> 4) can point to deleted cgroup (refcounting)
> 
> v2:
>   - use CONFIG_SOCK_CGROUP_DATA instead if CONFIG_CGROUPS
> 
> v3:
>   - fix attr size by using nla_total_size_64bit() (Eric Dumazet)
>   - more detailed commit message (Konstantin Khlebnikov)
> 
> Signed-off-by: Dmitry Yakunin <zeil@yandex-team.ru>
> Reviewed-by: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>

As a new feature, this should be resubmitted when net-next opens back
up.  Thank you.
