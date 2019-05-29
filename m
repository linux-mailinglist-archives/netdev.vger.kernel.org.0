Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5565F2D2C8
	for <lists+netdev@lfdr.de>; Wed, 29 May 2019 02:19:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727463AbfE2ATR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 May 2019 20:19:17 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:54358 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726515AbfE2ATR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 May 2019 20:19:17 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d8])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 9A7D213FDEDA5;
        Tue, 28 May 2019 17:19:16 -0700 (PDT)
Date:   Tue, 28 May 2019 17:19:16 -0700 (PDT)
Message-Id: <20190528.171916.1463233624014674136.davem@davemloft.net>
To:     willemdebruijn.kernel@gmail.com
Cc:     netdev@vger.kernel.org, willemb@google.com
Subject: Re: [PATCH net-next] selftests/net: ipv6 flowlabel
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190527204751.47643-1-willemdebruijn.kernel@gmail.com>
References: <20190527204751.47643-1-willemdebruijn.kernel@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 28 May 2019 17:19:16 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date: Mon, 27 May 2019 16:47:51 -0400

> From: Willem de Bruijn <willemb@google.com>
> 
> Test the IPv6 flowlabel control and datapath interfaces:
> 
> Acquire and release the right to use flowlabels with socket option
> IPV6_FLOWLABEL_MGR.
> 
> Then configure flowlabels on send and read them on recv with cmsg
> IPV6_FLOWINFO. Also verify auto-flowlabel if not explicitly set.
> 
> This helped identify the issue fixed in commit 95c169251bf73 ("ipv6:
> invert flowlabel sharing check in process and user mode")
> 
> Signed-off-by: Willem de Bruijn <willemb@google.com>

Applied.
