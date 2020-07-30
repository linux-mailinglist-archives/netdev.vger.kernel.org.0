Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A62A233C38
	for <lists+netdev@lfdr.de>; Fri, 31 Jul 2020 01:39:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730695AbgG3Xjc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jul 2020 19:39:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728588AbgG3Xjc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jul 2020 19:39:32 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 954B6C061574
        for <netdev@vger.kernel.org>; Thu, 30 Jul 2020 16:39:32 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 07E90126BFE2A;
        Thu, 30 Jul 2020 16:22:46 -0700 (PDT)
Date:   Thu, 30 Jul 2020 16:39:31 -0700 (PDT)
Message-Id: <20200730.163931.718165003662361803.davem@davemloft.net>
To:     jianyang.kernel@gmail.com
Cc:     netdev@vger.kernel.org, willemb@google.com, jianyang@google.com
Subject: Re: [PATCH net-next] selftests: txtimestamp: add flag for
 timestamp validation tolerance.
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200727211438.2071822-1-jianyang.kernel@gmail.com>
References: <20200727211438.2071822-1-jianyang.kernel@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 30 Jul 2020 16:22:47 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jian Yang <jianyang.kernel@gmail.com>
Date: Mon, 27 Jul 2020 14:14:38 -0700

> From: Jian Yang <jianyang@google.com>
> 
> The txtimestamp selftest sets a fixed 500us tolerance. This value was
> arrived at experimentally. Some platforms have higher variances. Make
> this adjustable by adding the following flag:
> 
> -t N: tolerance (usec) for timestamp validation.
> 
> Signed-off-by: Jian Yang <jianyang@google.com>
> Acked-by: Willem de Bruijn <willemb@google.com>

Applied, thanks.
