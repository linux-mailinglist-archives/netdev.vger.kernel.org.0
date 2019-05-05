Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 87470141AA
	for <lists+netdev@lfdr.de>; Sun,  5 May 2019 19:53:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727673AbfEERxn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 May 2019 13:53:43 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:53310 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726081AbfEERxn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 May 2019 13:53:43 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d8])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id A576A14DA7E88;
        Sun,  5 May 2019 10:53:42 -0700 (PDT)
Date:   Sun, 05 May 2019 10:53:42 -0700 (PDT)
Message-Id: <20190505.105342.1942212955421682000.davem@davemloft.net>
To:     dsahern@gmail.com
Cc:     dsahern@kernel.org, netdev@vger.kernel.org,
        alan.maguire@oracle.com, jwestfall@surrealistic.net
Subject: Re: [PATCH v2 net] neighbor: Call __ipv4_neigh_lookup_noref in
 neigh_xmit
From:   David Miller <davem@davemloft.net>
In-Reply-To: <77633c9c-7f44-fc0f-47e2-7f7f9df6872b@gmail.com>
References: <20190503155501.28182-1-dsahern@kernel.org>
        <20190505.104248.1454328009154159060.davem@davemloft.net>
        <77633c9c-7f44-fc0f-47e2-7f7f9df6872b@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 05 May 2019 10:53:42 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Ahern <dsahern@gmail.com>
Date: Sun, 5 May 2019 11:43:39 -0600

> oops on the double signoff; you actually took v1 so I need to send a delta.

Aha, I see, thanks for catching that.
