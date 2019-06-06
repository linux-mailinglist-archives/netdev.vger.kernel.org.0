Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 39E7137FEE
	for <lists+netdev@lfdr.de>; Thu,  6 Jun 2019 23:52:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728728AbfFFVwH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jun 2019 17:52:07 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:58542 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727269AbfFFVwH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jun 2019 17:52:07 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id C5CB414E272CE;
        Thu,  6 Jun 2019 14:52:06 -0700 (PDT)
Date:   Thu, 06 Jun 2019 14:52:03 -0700 (PDT)
Message-Id: <20190606.145203.79468452299179891.davem@davemloft.net>
To:     dsahern@kernel.org
Cc:     netdev@vger.kernel.org, idosch@mellanox.com, kafai@fb.com,
        weiwan@google.com, sbrivio@redhat.com, dsahern@gmail.com
Subject: Re: [PATCH net-next 01/19] nexthops: Add ipv6 helper to walk all
 fib6_nh in a nexthop struct
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190605231523.18424-2-dsahern@kernel.org>
References: <20190605231523.18424-1-dsahern@kernel.org>
        <20190605231523.18424-2-dsahern@kernel.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 06 Jun 2019 14:52:07 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Ahern <dsahern@kernel.org>
Date: Wed,  5 Jun 2019 16:15:05 -0700

> +		for (i = 0; i < nhg->num_nh; ++i) {

Please "i++" here, it's more canonical.
