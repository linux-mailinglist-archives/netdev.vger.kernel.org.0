Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1156F37F1E
	for <lists+netdev@lfdr.de>; Thu,  6 Jun 2019 22:56:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727366AbfFFU4D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jun 2019 16:56:03 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:57644 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726668AbfFFU4D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jun 2019 16:56:03 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id BF07514E0EB75;
        Thu,  6 Jun 2019 13:56:01 -0700 (PDT)
Date:   Thu, 06 Jun 2019 13:56:01 -0700 (PDT)
Message-Id: <20190606.135601.1164776763745750423.davem@davemloft.net>
To:     brouer@redhat.com
Cc:     ivan.khoronzhuk@linaro.org, grygorii.strashko@ti.com,
        hawk@kernel.org, ast@kernel.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, xdp-newbies@vger.kernel.org,
        ilias.apalodimas@linaro.org, netdev@vger.kernel.org,
        daniel@iogearbox.net, jakub.kicinski@netronome.com,
        john.fastabend@gmail.com
Subject: Re: [PATCH v3 net-next 0/7] net: ethernet: ti: cpsw: Add XDP
 support
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190606100850.72a48a43@carbon>
References: <20190605132009.10734-1-ivan.khoronzhuk@linaro.org>
        <20190605.121450.2198491088032558315.davem@davemloft.net>
        <20190606100850.72a48a43@carbon>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 06 Jun 2019 13:56:02 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jesper Dangaard Brouer <brouer@redhat.com>
Date: Thu, 6 Jun 2019 10:08:50 +0200

> I do have a working prototype, that fixes these two bugs.  I guess, I'm
> under pressure to send this to the list soon...

So I'm going to mark this CPSW patchset as "deferred" while these bugs are
worked out.
