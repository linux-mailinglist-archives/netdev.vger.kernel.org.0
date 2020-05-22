Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BB4C1DF267
	for <lists+netdev@lfdr.de>; Sat, 23 May 2020 00:49:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731212AbgEVWtu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 May 2020 18:49:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731166AbgEVWtu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 May 2020 18:49:50 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CBA5C061A0E
        for <netdev@vger.kernel.org>; Fri, 22 May 2020 15:49:50 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id AEB7C12744688;
        Fri, 22 May 2020 15:49:49 -0700 (PDT)
Date:   Fri, 22 May 2020 15:49:49 -0700 (PDT)
Message-Id: <20200522.154949.1270260346517105547.davem@davemloft.net>
To:     vfedorenko@novek.ru
Cc:     kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org, kuba@kernel.org,
        netdev@vger.kernel.org
Subject: Re: [net-next v2 0/5] ip6_tunnel: add MPLS support
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1589988099-13095-1-git-send-email-vfedorenko@novek.ru>
References: <1589988099-13095-1-git-send-email-vfedorenko@novek.ru>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 22 May 2020 15:49:49 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vadim Fedorenko <vfedorenko@novek.ru>
Date: Wed, 20 May 2020 18:21:34 +0300

> The support for MPLS-in-IPv4 was added earlier. This patchset adds
> support for MPLS-in-IPv6.
> 
> Changes in v2:
> - Eliminate ifdefs IS_ENABLE(CONFIG_MPLS)

Series applied, thank you.
