Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8481922D31E
	for <lists+netdev@lfdr.de>; Sat, 25 Jul 2020 02:12:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726726AbgGYAM6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jul 2020 20:12:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726576AbgGYAM6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jul 2020 20:12:58 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4A3EC0619D3
        for <netdev@vger.kernel.org>; Fri, 24 Jul 2020 17:12:57 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 468951275D4A1;
        Fri, 24 Jul 2020 16:56:12 -0700 (PDT)
Date:   Fri, 24 Jul 2020 17:12:56 -0700 (PDT)
Message-Id: <20200724.171256.2067344077228386021.davem@davemloft.net>
To:     willemdebruijn.kernel@gmail.com
Cc:     netdev@vger.kernel.org, willemb@google.com
Subject: Re: [PATCH net-next v2 0/3] icmp6: support rfc 4884
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200724130310.788305-1-willemdebruijn.kernel@gmail.com>
References: <20200724130310.788305-1-willemdebruijn.kernel@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 24 Jul 2020 16:56:12 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date: Fri, 24 Jul 2020 09:03:07 -0400

> From: Willem de Bruijn <willemb@google.com>
> 
> Extend the feature merged earlier this week for IPv4 to IPv6.
> 
> I expected this to be a single patch, but patch 1 seemed better to be
> stand-alone
> 
> patch 1: small fix in length calculation
> patch 2: factor out ipv4-specific
> patch 3: add ipv6
> 
> changes v1->v2: add missing static keyword in patch 3

Series applied, thanks Willem.
