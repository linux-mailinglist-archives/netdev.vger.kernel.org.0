Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD9D01C2903
	for <lists+netdev@lfdr.de>; Sun,  3 May 2020 01:43:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726609AbgEBXnM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 2 May 2020 19:43:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726433AbgEBXnM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 2 May 2020 19:43:12 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E575C061A0C
        for <netdev@vger.kernel.org>; Sat,  2 May 2020 16:43:12 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id EE83B15166C30;
        Sat,  2 May 2020 16:43:11 -0700 (PDT)
Date:   Sat, 02 May 2020 16:43:11 -0700 (PDT)
Message-Id: <20200502.164311.320037867603910429.davem@davemloft.net>
To:     zeil@yandex-team.ru
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH net-next] inet_diag: bc: read cgroup id only for full
 sockets
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200502153442.90490-1-zeil@yandex-team.ru>
References: <20200502153442.90490-1-zeil@yandex-team.ru>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 02 May 2020 16:43:12 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dmitry Yakunin <zeil@yandex-team.ru>
Date: Sat,  2 May 2020 18:34:42 +0300

> Fix bug introduced by commit b1f3e43dbfac ("inet_diag: add support for
> cgroup filter").
> 
> Signed-off-by: Dmitry Yakunin <zeil@yandex-team.ru>
> Reported-by: syzbot+ee80f840d9bf6893223b@syzkaller.appspotmail.com
> Reported-by: syzbot+13bef047dbfffa5cd1af@syzkaller.appspotmail.com
> Fixes: b1f3e43dbfac ("inet_diag: add support for cgroup filter")

Applied, thanks.
