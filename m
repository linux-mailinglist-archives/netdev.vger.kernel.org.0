Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 666051E50EF
	for <lists+netdev@lfdr.de>; Thu, 28 May 2020 00:08:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726393AbgE0WIP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 May 2020 18:08:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725385AbgE0WIP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 May 2020 18:08:15 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66634C05BD1E;
        Wed, 27 May 2020 15:08:15 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id CA152128CEF78;
        Wed, 27 May 2020 15:08:14 -0700 (PDT)
Date:   Wed, 27 May 2020 15:08:14 -0700 (PDT)
Message-Id: <20200527.150814.495554320366388162.davem@davemloft.net>
To:     jonas.falkevik@gmail.com
Cc:     marcelo.leitner@gmail.com, lucien.xin@gmail.com,
        nhorman@tuxdriver.com, vyasevich@gmail.com, kuba@kernel.org,
        linux-sctp@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sctp: fix typo sctp_ulpevent_nofity_peer_addr_change
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200527095943.271140-1-jonas.falkevik@gmail.com>
References: <20200527095943.271140-1-jonas.falkevik@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 27 May 2020 15:08:15 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jonas Falkevik <jonas.falkevik@gmail.com>
Date: Wed, 27 May 2020 11:59:43 +0200

> change typo in function name "nofity" to "notify"
> sctp_ulpevent_nofity_peer_addr_change ->
> sctp_ulpevent_notify_peer_addr_change
> 
> Signed-off-by: Jonas Falkevik <jonas.falkevik@gmail.com>

Applied to net-next, thanks.
