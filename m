Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 175EB426D53
	for <lists+netdev@lfdr.de>; Fri,  8 Oct 2021 17:14:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242933AbhJHPQj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Oct 2021 11:16:39 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:52438 "EHLO
        mail.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242715AbhJHPQi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Oct 2021 11:16:38 -0400
Received: from localhost (unknown [149.11.102.75])
        by mail.monkeyblade.net (Postfix) with ESMTPSA id A196B4FEE3F1E;
        Fri,  8 Oct 2021 08:14:40 -0700 (PDT)
Date:   Fri, 08 Oct 2021 16:14:35 +0100 (BST)
Message-Id: <20211008.161435.1734009617183253791.davem@davemloft.net>
To:     kvalo@codeaurora.org
Cc:     geert@linux-m68k.org, sfr@canb.auug.org.au, netdev@vger.kernel.org,
        jouni@codeaurora.org, pradeepc@codeaurora.org,
        linux-kernel@vger.kernel.org, linux-next@vger.kernel.org,
        ath11k@lists.infradead.org, linux-wireless@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the net-next tree
From:   David Miller <davem@davemloft.net>
In-Reply-To: <87pmsf60h0.fsf@codeaurora.org>
References: <87tuhs5ah8.fsf@codeaurora.org>
        <CAMuHMdUZa9o15_fGJ7Si_-bOQVcFOxtWgo_MOiKsV0FjoPeX6Q@mail.gmail.com>
        <87pmsf60h0.fsf@codeaurora.org>
X-Mailer: Mew version 6.8 on Emacs 27.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.6.2 (mail.monkeyblade.net [0.0.0.0]); Fri, 08 Oct 2021 08:14:42 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Kalle Valo <kvalo@codeaurora.org>
Date: Fri, 08 Oct 2021 17:43:39 +0300

> Thanks Geert, you helped a lot! I now submitted a patch to netdev:
> 
> https://patchwork.kernel.org/project/netdevbpf/patch/20211008143932.23884-1-kvalo@codeaurora.org/
> 
> Dave & Jakub, if you can please take the patch directly to net-next.
Done.


