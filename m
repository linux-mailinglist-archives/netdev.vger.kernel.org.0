Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F273E20F15
	for <lists+netdev@lfdr.de>; Thu, 16 May 2019 21:13:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727821AbfEPTNA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 May 2019 15:13:00 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:60092 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726317AbfEPTNA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 May 2019 15:13:00 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d8])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 16629133E977D;
        Thu, 16 May 2019 12:13:00 -0700 (PDT)
Date:   Thu, 16 May 2019 12:12:59 -0700 (PDT)
Message-Id: <20190516.121259.2282104828063365055.davem@davemloft.net>
To:     khlebnikov@yandex-team.ru
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, ast@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: bpfilter: fallback to netfilter if failed to load
 bpfilter kernel module
From:   David Miller <davem@davemloft.net>
In-Reply-To: <155792045295.940.7526963251434168966.stgit@buzz>
References: <155792045295.940.7526963251434168966.stgit@buzz>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 16 May 2019 12:13:00 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Date: Wed, 15 May 2019 14:40:52 +0300

> If bpfilter is not available return ENOPROTOOPT to fallback to netfilter.
> 
> Function request_module() returns both errors and userspace exit codes.
> Just ignore them. Rechecking bpfilter_ops is enough.
> 
> Fixes: d2ba09c17a06 ("net: add skeleton of bpfilter kernel module")
> Signed-off-by: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>

Applied, thanks.
