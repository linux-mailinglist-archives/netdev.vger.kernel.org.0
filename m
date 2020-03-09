Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D44F417D8AC
	for <lists+netdev@lfdr.de>; Mon,  9 Mar 2020 05:58:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726027AbgCIE6W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Mar 2020 00:58:22 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:54156 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725796AbgCIE6W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Mar 2020 00:58:22 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id A282E158B730E;
        Sun,  8 Mar 2020 21:58:21 -0700 (PDT)
Date:   Sun, 08 Mar 2020 21:58:21 -0700 (PDT)
Message-Id: <20200308.215821.1029255577399058866.davem@davemloft.net>
To:     zeil@yandex-team.ru
Cc:     netdev@vger.kernel.org, khlebnikov@yandex-team.ru
Subject: Re: [PATCH net] inet_diag: return classid for all socket types
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200305123312.GA77699@yandex-team.ru>
References: <20200305123312.GA77699@yandex-team.ru>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 08 Mar 2020 21:58:21 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dmitry Yakunin <zeil@yandex-team.ru>
Date: Thu, 5 Mar 2020 15:33:12 +0300

> In commit 1ec17dbd90f8 ("inet_diag: fix reporting cgroup classid and
> fallback to priority") croup classid reporting was fixed. But this works
> only for TCP sockets because for other socket types icsk parameter can
> be NULL and classid code path is skipped. This change moves classid
> handling to inet_diag_msg_attrs_fill() function.
> 
> Also inet_diag_msg_attrs_size() helper was added and addends in
> nlmsg_new() were reordered to save order from inet_sk_diag_fill().
> 
> Fixes: 1ec17dbd90f8 ("inet_diag: fix reporting cgroup classid and fallback to priority")
> Signed-off-by: Dmitry Yakunin <zeil@yandex-team.ru>
> Reviewed-by: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>

Applied and queued up for -stable, thanks.
