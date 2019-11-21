Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3DA11105A8F
	for <lists+netdev@lfdr.de>; Thu, 21 Nov 2019 20:46:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726912AbfKUTqc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Nov 2019 14:46:32 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:52398 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726887AbfKUTqc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Nov 2019 14:46:32 -0500
Received: from localhost (unknown [IPv6:2001:558:600a:cc:f9f3:9371:b0b8:cb13])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 3A37F15043D31;
        Thu, 21 Nov 2019 11:46:32 -0800 (PST)
Date:   Thu, 21 Nov 2019 11:46:31 -0800 (PST)
Message-Id: <20191121.114631.995877327927284264.davem@davemloft.net>
To:     lucien.xin@gmail.com
Cc:     netdev@vger.kernel.org, simon.horman@netronome.com,
        jakub.kicinski@netronome.com
Subject: Re: [PATCH net-next] net: remove the unnecessary strict_start_type
 in some policies
From:   David Miller <davem@davemloft.net>
In-Reply-To: <bcd455a3339a42f32dd2970d5495740ea1ee142d.1574330918.git.lucien.xin@gmail.com>
References: <bcd455a3339a42f32dd2970d5495740ea1ee142d.1574330918.git.lucien.xin@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 21 Nov 2019 11:46:32 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Xin Long <lucien.xin@gmail.com>
Date: Thu, 21 Nov 2019 18:08:38 +0800

> ct_policy and mpls_policy are parsed with nla_parse_nested(), which
> does NL_VALIDATE_STRICT validation, strict_start_type is not needed
> to set as it is actually trying to make some attributes parsed with
> NL_VALIDATE_STRICT.
> 
> This patch is to remove it, and do the same on rtm_nh_policy which
> is parsed by nlmsg_parse().
> 
> Suggested-by: Jakub Kicinski <jakub.kicinski@netronome.com>
> Signed-off-by: Xin Long <lucien.xin@gmail.com>

Applied.
