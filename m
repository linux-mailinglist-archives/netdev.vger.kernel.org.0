Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1F04233C4A
	for <lists+netdev@lfdr.de>; Fri, 31 Jul 2020 01:52:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730751AbgG3Xwr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jul 2020 19:52:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730643AbgG3Xwq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jul 2020 19:52:46 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEB53C061574
        for <netdev@vger.kernel.org>; Thu, 30 Jul 2020 16:52:46 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 2CBFD126C2AAD;
        Thu, 30 Jul 2020 16:36:01 -0700 (PDT)
Date:   Thu, 30 Jul 2020 16:52:45 -0700 (PDT)
Message-Id: <20200730.165245.498996927458633882.davem@davemloft.net>
To:     kuba@kernel.org
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, jiri@mellanox.com,
        kernel-team@fb.com
Subject: Re: [PATCH net] devlink: ignore -EOPNOTSUPP errors on dumpit
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200728231507.426387-1-kuba@kernel.org>
References: <20200728231507.426387-1-kuba@kernel.org>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 30 Jul 2020 16:36:01 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jakub Kicinski <kuba@kernel.org>
Date: Tue, 28 Jul 2020 16:15:07 -0700

> Number of .dumpit functions try to ignore -EOPNOTSUPP errors.
> Recent change missed that, and started reporting all errors
> but -EMSGSIZE back from dumps. This leads to situation like
> this:
> 
> $ devlink dev info
> devlink answers: Operation not supported
> 
> Dump should not report an error just because the last device
> to be queried could not provide an answer.
> 
> To fix this and avoid similar confusion make sure we clear
> err properly, and not leave it set to an error if we don't
> terminate the iteration.
> 
> Fixes: c62c2cfb801b ("net: devlink: don't ignore errors during dumpit")
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>

Applied and queued up for -stable, thanks.
