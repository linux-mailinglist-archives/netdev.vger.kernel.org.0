Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46B691BAC23
	for <lists+netdev@lfdr.de>; Mon, 27 Apr 2020 20:15:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726344AbgD0SPs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Apr 2020 14:15:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725963AbgD0SPs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Apr 2020 14:15:48 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A049C0610D5;
        Mon, 27 Apr 2020 11:15:48 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id BCCFC104D0E41;
        Mon, 27 Apr 2020 11:15:47 -0700 (PDT)
Date:   Mon, 27 Apr 2020 11:15:47 -0700 (PDT)
Message-Id: <20200427.111547.346558310845161759.davem@davemloft.net>
To:     zhengdejin5@gmail.com
Cc:     tglx@linutronix.de, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v1] ethernet: ks8842: delete unnecessary goto
 label
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200425115612.17171-1-zhengdejin5@gmail.com>
References: <20200425115612.17171-1-zhengdejin5@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 27 Apr 2020 11:15:47 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dejin Zheng <zhengdejin5@gmail.com>
Date: Sat, 25 Apr 2020 19:56:12 +0800

> the label of err_register is not necessary, so delete it to
> simplify code.
> 
> Signed-off-by: Dejin Zheng <zhengdejin5@gmail.com>

It's not unnecessary, it's documenting the state of the probe.
