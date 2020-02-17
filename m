Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5F36A161D3A
	for <lists+netdev@lfdr.de>; Mon, 17 Feb 2020 23:18:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726240AbgBQWSw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Feb 2020 17:18:52 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:56070 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726047AbgBQWSv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Feb 2020 17:18:51 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 3523015AA6301;
        Mon, 17 Feb 2020 14:18:51 -0800 (PST)
Date:   Mon, 17 Feb 2020 14:18:50 -0800 (PST)
Message-Id: <20200217.141850.2134390863127670308.davem@davemloft.net>
To:     lorenzo.bianconi@redhat.com
Cc:     brouer@redhat.com, lorenzo@kernel.org, netdev@vger.kernel.org,
        ilias.apalodimas@linaro.org, dsahern@kernel.org,
        bpf@vger.kernel.org
Subject: Re: [PATCH net-next 4/5] net: mvneta: introduce xdp counters to
 ethtool
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200217102550.GB3080@localhost.localdomain>
References: <882d9f03a8542cceec7c7b8e6d083419d84eaf7a.1581886691.git.lorenzo@kernel.org>
        <20200217111718.2c9ab08a@carbon>
        <20200217102550.GB3080@localhost.localdomain>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 17 Feb 2020 14:18:51 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Date: Mon, 17 Feb 2020 11:25:50 +0100

> yes, I think it is definitely better. So to follow up:
> - rename current "xdp_tx" counter in "xdp_xmit" and increment it for
>   XDP_TX verdict and for ndo_xdp_xmit
> - introduce a new "xdp_tx" counter only for XDP_TX verdict.
> 
> If we agree I can post a follow-up patch.

What names do other drivers use?  Consistency is important.  I noticed
while reviewing these patches that mellanox drivers export similar
statistics in the exact same way.
