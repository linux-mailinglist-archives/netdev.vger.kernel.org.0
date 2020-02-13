Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A08E715CDEB
	for <lists+netdev@lfdr.de>; Thu, 13 Feb 2020 23:13:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727794AbgBMWNk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Feb 2020 17:13:40 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:46988 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726282AbgBMWNk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Feb 2020 17:13:40 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 5D62F15B7531C;
        Thu, 13 Feb 2020 14:13:40 -0800 (PST)
Date:   Thu, 13 Feb 2020 14:13:39 -0800 (PST)
Message-Id: <20200213.141339.1857808079314187331.davem@davemloft.net>
To:     liuhangbin@gmail.com
Cc:     netdev@vger.kernel.org, tom@herbertland.com
Subject: Re: [PATCH net] net/flow_dissector: remove unexist field
 description
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200211103154.3943-1-liuhangbin@gmail.com>
References: <20200211103154.3943-1-liuhangbin@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 13 Feb 2020 14:13:40 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Hangbin Liu <liuhangbin@gmail.com>
Date: Tue, 11 Feb 2020 18:31:54 +0800

> @thoff has moved to struct flow_dissector_key_control.
> 
> Fixes: 42aecaa9bb2b ("net: Get skb hash over flow_keys structure")
> Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>

Applied.
