Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1C52D141D6
	for <lists+netdev@lfdr.de>; Sun,  5 May 2019 20:26:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727861AbfEES0D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 May 2019 14:26:03 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:53602 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727814AbfEES0C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 May 2019 14:26:02 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d8])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 3921214DA8122;
        Sun,  5 May 2019 11:26:02 -0700 (PDT)
Date:   Sun, 05 May 2019 11:26:01 -0700 (PDT)
Message-Id: <20190505.112601.2105394402398586332.davem@davemloft.net>
To:     dsahern@kernel.org
Cc:     netdev@vger.kernel.org, dsahern@gmail.com
Subject: Re: [PATCH net] ipv4: Define __ipv4_neigh_lookup_noref when
 CONFIG_INET is disabled
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190505181620.12220-1-dsahern@kernel.org>
References: <20190505181620.12220-1-dsahern@kernel.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 05 May 2019 11:26:02 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Ahern <dsahern@kernel.org>
Date: Sun,  5 May 2019 11:16:20 -0700

> From: David Ahern <dsahern@gmail.com>
> 
> Define __ipv4_neigh_lookup_noref to return NULL when CONFIG_INET is disabled.
> 
> Fixes: 4b2a2bfeb3f0 ("neighbor: Call __ipv4_neigh_lookup_noref in neigh_xmit")
> Reported-by: kbuild test robot <lkp@intel.com>
> Signed-off-by: David Ahern <dsahern@gmail.com>

Applied.
