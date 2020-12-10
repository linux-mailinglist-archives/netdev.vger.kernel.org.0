Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 862762D6913
	for <lists+netdev@lfdr.de>; Thu, 10 Dec 2020 21:47:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404582AbgLJUqW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Dec 2020 15:46:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732382AbgLJUqV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Dec 2020 15:46:21 -0500
Received: from mail.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 710BAC0613CF;
        Thu, 10 Dec 2020 12:45:41 -0800 (PST)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        by mail.monkeyblade.net (Postfix) with ESMTPSA id 617FD4D2ED6E3;
        Thu, 10 Dec 2020 12:45:40 -0800 (PST)
Date:   Thu, 10 Dec 2020 12:45:35 -0800 (PST)
Message-Id: <20201210.124535.572123178373912255.davem@davemloft.net>
To:     a@unstable.cc
Cc:     kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] vxlan: avoid double unlikely() notation when using
 IS_ERR()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20201210085549.22846-1-a@unstable.cc>
References: <20201210085549.22846-1-a@unstable.cc>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.6.2 (mail.monkeyblade.net [0.0.0.0]); Thu, 10 Dec 2020 12:45:40 -0800 (PST)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Antonio Quartulli <a@unstable.cc>
Date: Thu, 10 Dec 2020 09:55:49 +0100

> The definition of IS_ERR() already applies the unlikely() notation
> when checking the error status of the passed pointer. For this
> reason there is no need to have the same notation outside of
> IS_ERR() itself.
> 
> Clean up code by removing redundant notation.
> 
> Signed-off-by: Antonio Quartulli <a@unstable.cc>

Applied to net-next, thanks.
