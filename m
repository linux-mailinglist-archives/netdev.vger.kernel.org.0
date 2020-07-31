Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BC98233C9B
	for <lists+netdev@lfdr.de>; Fri, 31 Jul 2020 02:39:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730940AbgGaAji (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jul 2020 20:39:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728086AbgGaAjh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jul 2020 20:39:37 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8FFAC061574;
        Thu, 30 Jul 2020 17:39:37 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477:9e51:a893:b0fe:602a])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 1D2E3126C48C8;
        Thu, 30 Jul 2020 17:22:51 -0700 (PDT)
Date:   Thu, 30 Jul 2020 17:39:35 -0700 (PDT)
Message-Id: <20200730.173935.1057438302921920842.davem@davemloft.net>
To:     gustavoars@kernel.org
Cc:     jiri@mellanox.com, idosch@mellanox.com, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH][next] mlxsw: spectrum_cnt: Use flex_array_size()
 helper in memcpy()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200729225803.GA15866@embeddedor>
References: <20200729225803.GA15866@embeddedor>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 30 Jul 2020 17:22:51 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Gustavo A. R. Silva" <gustavoars@kernel.org>
Date: Wed, 29 Jul 2020 17:58:03 -0500

> Make use of the flex_array_size() helper to calculate the size of a
> flexible array member within an enclosing structure.
> 
> This helper offers defense-in-depth against potential integer
> overflows, while at the same time makes it explicitly clear that
> we are dealing witha flexible array member.
> 
> Also, remove unnecessary pointer identifier sub_pool.
> 
> Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>

Applied.
