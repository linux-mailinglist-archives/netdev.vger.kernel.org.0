Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D16F327395
	for <lists+netdev@lfdr.de>; Thu, 23 May 2019 02:55:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729523AbfEWAzx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 May 2019 20:55:53 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:37092 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727305AbfEWAzx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 May 2019 20:55:53 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d8])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id A6C2A1457787D;
        Wed, 22 May 2019 17:55:52 -0700 (PDT)
Date:   Wed, 22 May 2019 17:55:52 -0700 (PDT)
Message-Id: <20190522.175552.1310433348238004186.davem@davemloft.net>
To:     dsahern@kernel.org
Cc:     netdev@vger.kernel.org, dsahern@gmail.com
Subject: Re: [PATCH net-next] selftests: fib-onlink: Make quiet by default
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190522190916.15638-1-dsahern@kernel.org>
References: <20190522190916.15638-1-dsahern@kernel.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 22 May 2019 17:55:52 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Ahern <dsahern@kernel.org>
Date: Wed, 22 May 2019 12:09:16 -0700

> From: David Ahern <dsahern@gmail.com>
> 
> Add VERBOSE argument to fib-onlink-tests.sh and make output quiet by
> default. Add getopt parsing of inputs and support for -v (verbose) and
> -p (pause on fail).
> 
> Signed-off-by: David Ahern <dsahern@gmail.com>

Applied.
