Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E546B1D3E78
	for <lists+netdev@lfdr.de>; Thu, 14 May 2020 22:07:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729218AbgENUHS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 May 2020 16:07:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726035AbgENUHS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 May 2020 16:07:18 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A901C061A0C;
        Thu, 14 May 2020 13:07:18 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id E1980128D496C;
        Thu, 14 May 2020 13:07:17 -0700 (PDT)
Date:   Thu, 14 May 2020 13:07:17 -0700 (PDT)
Message-Id: <20200514.130717.1848307407646007455.davem@davemloft.net>
To:     wenhu.wang@vivo.com
Cc:     elder@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel@vivo.com
Subject: Re: [PATCH] drivers: ipa: fix typos for ipa_smp2p structure doc
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200514110222.3402-1-wenhu.wang@vivo.com>
References: <20200514110222.3402-1-wenhu.wang@vivo.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 14 May 2020 13:07:18 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Wang Wenhu <wenhu.wang@vivo.com>
Date: Thu, 14 May 2020 04:02:22 -0700

> Remove the duplicate "mutex", and change "Motex" to "Mutex". Also I
> recommend it's easier for understanding to make the "ready-interrupt"
> a bundle for it is a parallel description as "shutdown" which is appended
> after the slash.
> 
> Signed-off-by: Wang Wenhu <wenhu.wang@vivo.com>
> Cc: Alex Elder <elder@kernel.org>

Applied, thanks.
