Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0455186F1B
	for <lists+netdev@lfdr.de>; Fri,  9 Aug 2019 03:08:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405181AbfHIBIW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Aug 2019 21:08:22 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:54030 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725785AbfHIBIW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Aug 2019 21:08:22 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 5EB4C14266517;
        Thu,  8 Aug 2019 18:08:22 -0700 (PDT)
Date:   Thu, 08 Aug 2019 18:08:21 -0700 (PDT)
Message-Id: <20190808.180821.571284161584383027.davem@davemloft.net>
To:     dsahern@kernel.org
Cc:     netdev@vger.kernel.org, dsahern@gmail.com
Subject: Re: [PATCH v2 net-next] selftests: Add l2tp tests
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190805224137.15236-1-dsahern@kernel.org>
References: <20190805224137.15236-1-dsahern@kernel.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 08 Aug 2019 18:08:22 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Ahern <dsahern@kernel.org>
Date: Mon,  5 Aug 2019 15:41:37 -0700

> From: David Ahern <dsahern@gmail.com>
> 
> Add IPv4 and IPv6 l2tp tests. Current set is over IP and with
> IPsec.
> 
> v2
> - add l2tp.sh to TEST_PROGS in Makefile
> 
> Signed-off-by: David Ahern <dsahern@gmail.com>

Applied.
