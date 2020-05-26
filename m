Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F3D21E18A7
	for <lists+netdev@lfdr.de>; Tue, 26 May 2020 03:04:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388288AbgEZBEM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 May 2020 21:04:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387794AbgEZBEM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 May 2020 21:04:12 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C73CC061A0E;
        Mon, 25 May 2020 18:04:12 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 5143D127A3502;
        Mon, 25 May 2020 18:04:11 -0700 (PDT)
Date:   Mon, 25 May 2020 18:04:10 -0700 (PDT)
Message-Id: <20200525.180410.645785578182790689.davem@davemloft.net>
To:     wenhu.wang@vivo.com
Cc:     elder@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel@vivo.com
Subject: Re: [PATCH] drivers: ipa: print dev_err info accurately
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200525062951.29472-1-wenhu.wang@vivo.com>
References: <20200525062951.29472-1-wenhu.wang@vivo.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 25 May 2020 18:04:11 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Wang Wenhu <wenhu.wang@vivo.com>
Date: Sun, 24 May 2020 23:29:51 -0700

> Print certain name string instead of hard-coded "memory" for dev_err
> output, which would be more accurate and helpful for debugging.
> 
> Signed-off-by: Wang Wenhu <wenhu.wang@vivo.com>

Applied to net-next, thanks.
