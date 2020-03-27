Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4E791194F19
	for <lists+netdev@lfdr.de>; Fri, 27 Mar 2020 03:35:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727696AbgC0Cf1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Mar 2020 22:35:27 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:57554 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726496AbgC0Cf1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Mar 2020 22:35:27 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id A0C7715CE62E0;
        Thu, 26 Mar 2020 19:35:26 -0700 (PDT)
Date:   Thu, 26 Mar 2020 19:35:25 -0700 (PDT)
Message-Id: <20200326.193525.1798104373725390140.davem@davemloft.net>
To:     lorenzo@kernel.org
Cc:     netdev@vger.kernel.org, toshiaki.makita1@gmail.com,
        brouer@redhat.com, dsahern@gmail.com, lorenzo.bianconi@redhat.com,
        toke@redhat.com
Subject: Re: [PATCH v2 net-next 0/2] move ndo_xdp_xmit stats to peer veth_rq
From:   David Miller <davem@davemloft.net>
In-Reply-To: <cover.1585260407.git.lorenzo@kernel.org>
References: <cover.1585260407.git.lorenzo@kernel.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 26 Mar 2020 19:35:27 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Lorenzo Bianconi <lorenzo@kernel.org>
Date: Thu, 26 Mar 2020 23:10:18 +0100

> Move ndo_xdp_xmit ethtool stats accounting to peer veth_rq.
> Move XDP_TX accounting to veth_xdp_flush_bq routine.
> 
> Changes since v1:
> - rename xdp_xmit[_err] counters to peer_tq_xdp_xmit[_err]

Series applied, thanks.
