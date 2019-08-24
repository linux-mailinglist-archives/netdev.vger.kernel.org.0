Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A055D9C06B
	for <lists+netdev@lfdr.de>; Sat, 24 Aug 2019 23:23:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727989AbfHXVXt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 24 Aug 2019 17:23:49 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:47756 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727690AbfHXVXt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 24 Aug 2019 17:23:49 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 18D0115252E15;
        Sat, 24 Aug 2019 14:23:49 -0700 (PDT)
Date:   Sat, 24 Aug 2019 14:23:48 -0700 (PDT)
Message-Id: <20190824.142348.742100834261970478.davem@davemloft.net>
To:     xiaolinkui@kylinos.cn
Cc:     ast@kernel.org, daniel@iogearbox.net, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: Re: [PATCH] net: use unlikely for dql_avail case
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190822065816.23619-1-xiaolinkui@kylinos.cn>
References: <20190822065816.23619-1-xiaolinkui@kylinos.cn>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 24 Aug 2019 14:23:49 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: xiaolinkui <xiaolinkui@kylinos.cn>
Date: Thu, 22 Aug 2019 14:58:16 +0800

> This is an unlikely case, use unlikely() on it seems logical.
> 
> Signed-off-by: xiaolinkui <xiaolinkui@kylinos.cn>

Applied to net-next.
