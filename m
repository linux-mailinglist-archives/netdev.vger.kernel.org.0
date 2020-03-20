Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 772E718C66D
	for <lists+netdev@lfdr.de>; Fri, 20 Mar 2020 05:25:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727133AbgCTEZQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Mar 2020 00:25:16 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:46794 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725996AbgCTEZQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Mar 2020 00:25:16 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 44AD615909F0D;
        Thu, 19 Mar 2020 21:25:15 -0700 (PDT)
Date:   Thu, 19 Mar 2020 21:25:14 -0700 (PDT)
Message-Id: <20200319.212514.1483327895338104843.davem@davemloft.net>
To:     lorenzo@kernel.org
Cc:     netdev@vger.kernel.org, toshiaki.makita1@gmail.com,
        brouer@redhat.com, dsahern@gmail.com, lorenzo.bianconi@redhat.com,
        toke@redhat.com
Subject: Re: [PATCH net-next 0/5] add more xdp stats to veth driver
From:   David Miller <davem@davemloft.net>
In-Reply-To: <cover.1584635611.git.lorenzo@kernel.org>
References: <cover.1584635611.git.lorenzo@kernel.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 19 Mar 2020 21:25:15 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Lorenzo Bianconi <lorenzo@kernel.org>
Date: Thu, 19 Mar 2020 17:41:24 +0100

> Align veth xdp stats accounting to mellanox, intel and marvell
> implementation. Introduce the following xdp counters:
> - rx_xdp_tx
> - rx_xdp_tx_errors
> - tx_xdp_xmit
> - tx_xdp_xmit_errors
> - rx_xdp_redirect

Series applied, thanks.
