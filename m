Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 815C324E97C
	for <lists+netdev@lfdr.de>; Sat, 22 Aug 2020 21:49:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728671AbgHVTtE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Aug 2020 15:49:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728654AbgHVTtE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 Aug 2020 15:49:04 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEC94C061573
        for <netdev@vger.kernel.org>; Sat, 22 Aug 2020 12:49:03 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 5C15215D2BE6F;
        Sat, 22 Aug 2020 12:32:17 -0700 (PDT)
Date:   Sat, 22 Aug 2020 12:49:02 -0700 (PDT)
Message-Id: <20200822.124902.1531691234014991272.davem@davemloft.net>
To:     herbert@gondor.apana.org.au, kuba@kernel.org,
        netdev@vger.kernel.org, nhorman@tuxdriver.com
Subject: Re: [PATCH] net: Get rid of consume_skb when tracing is off
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200822175419.GA293438@localhost.localdomain>
References: <20200821222329.GA2633@gondor.apana.org.au>
        <20200822175419.GA293438@localhost.localdomain>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 22 Aug 2020 12:32:17 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


From: Neil Horman <nhorman@localhost.localdomain>

Neil, you might want to fix this so people can reply to you :-)
