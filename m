Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99BCB2D37D6
	for <lists+netdev@lfdr.de>; Wed,  9 Dec 2020 01:33:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732020AbgLIAav (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Dec 2020 19:30:51 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:45980 "EHLO
        mail.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731962AbgLIAav (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Dec 2020 19:30:51 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        by mail.monkeyblade.net (Postfix) with ESMTPSA id 40C224D249B50;
        Tue,  8 Dec 2020 16:30:10 -0800 (PST)
Date:   Tue, 08 Dec 2020 16:30:09 -0800 (PST)
Message-Id: <20201208.163009.2257313101751320736.davem@davemloft.net>
To:     weiwan@google.com
Cc:     kuba@kernel.org, netdev@vger.kernel.org, alexanderduyck@fb.com,
        edumazet@google.com
Subject: Re: [PATCH net] tcp: Retain ECT bits for tos reflection
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20201208175508.1793520-1-weiwan@google.com>
References: <20201208175508.1793520-1-weiwan@google.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.6.2 (mail.monkeyblade.net [0.0.0.0]); Tue, 08 Dec 2020 16:30:10 -0800 (PST)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Wei Wang <weiwan@google.com>
Date: Tue,  8 Dec 2020 09:55:08 -0800

> For DCTCP, we have to retain the ECT bits set by the congestion control
> algorithm on the socket when reflecting syn TOS in syn-ack, in order to
> make ECN work properly.
> 
> Fixes: ac8f1710c12b ("tcp: reflect tos value received in SYN to the socket")
> Reported-by: Alexander Duyck <alexanderduyck@fb.com>
> Signed-off-by: Wei Wang <weiwan@google.com>
> Reviewed-by: Eric Dumazet <edumazet@google.com>

Applied, thanks.
