Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 137C510109B
	for <lists+netdev@lfdr.de>; Tue, 19 Nov 2019 02:20:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727102AbfKSBUK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Nov 2019 20:20:10 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:52158 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726996AbfKSBUK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Nov 2019 20:20:10 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 42072150FAE64;
        Mon, 18 Nov 2019 17:20:10 -0800 (PST)
Date:   Mon, 18 Nov 2019 17:20:09 -0800 (PST)
Message-Id: <20191118.172009.1629876192163031952.davem@davemloft.net>
To:     lucien.xin@gmail.com
Cc:     netdev@vger.kernel.org, simon.horman@netronome.com
Subject: Re: [PATCH net-next] lwtunnel: change to use nla_put_u8 for
 LWTUNNEL_IP_OPT_ERSPAN_VER
From:   David Miller <davem@davemloft.net>
In-Reply-To: <60ad49e50facc0d5d77120350b01e37e37d86c57.1574071812.git.lucien.xin@gmail.com>
References: <60ad49e50facc0d5d77120350b01e37e37d86c57.1574071812.git.lucien.xin@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 18 Nov 2019 17:20:10 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Xin Long <lucien.xin@gmail.com>
Date: Mon, 18 Nov 2019 18:10:12 +0800

> LWTUNNEL_IP_OPT_ERSPAN_VER is u8 type, and nla_put_u8 should have
> been used instead of nla_put_u32(). This is a copy-paste error.
> 
> Fixes: b0a21810bd5e ("lwtunnel: add options setting and dumping for erspan")
> Signed-off-by: Xin Long <lucien.xin@gmail.com>

Applied.
