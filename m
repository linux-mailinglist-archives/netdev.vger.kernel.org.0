Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 82ED0F9A4C
	for <lists+netdev@lfdr.de>; Tue, 12 Nov 2019 21:12:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727063AbfKLUML (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Nov 2019 15:12:11 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:48938 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727022AbfKLUMJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Nov 2019 15:12:09 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 0CB73154D2508;
        Tue, 12 Nov 2019 12:12:08 -0800 (PST)
Date:   Mon, 11 Nov 2019 14:43:57 -0800 (PST)
Message-Id: <20191111.144357.792497174551610263.davem@davemloft.net>
To:     lucien.xin@gmail.com
Cc:     netdev@vger.kernel.org, dsahern@gmail.com
Subject: Re: [PATCH net-next] lwtunnel: change to use nla_parse_nested on
 new options
From:   David Miller <davem@davemloft.net>
In-Reply-To: <78f1826a019e62b19a435a1498114274fb34223c.1573359382.git.lucien.xin@gmail.com>
References: <78f1826a019e62b19a435a1498114274fb34223c.1573359382.git.lucien.xin@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 12 Nov 2019 12:12:08 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Xin Long <lucien.xin@gmail.com>
Date: Sun, 10 Nov 2019 12:16:22 +0800

> As the new options added in kernel, all should always use strict
> parsing from the beginning with nla_parse_nested(), instead of
> nla_parse_nested_deprecated().
> 
> Fixes: b0a21810bd5e ("lwtunnel: add options setting and dumping for erspan")
> Fixes: edf31cbb1502 ("lwtunnel: add options setting and dumping for vxlan")
> Fixes: 4ece47787077 ("lwtunnel: add options setting and dumping for geneve")
> Signed-off-by: Xin Long <lucien.xin@gmail.com>

Applied.
