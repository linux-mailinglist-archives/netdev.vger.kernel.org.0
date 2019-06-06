Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9949E37FEF
	for <lists+netdev@lfdr.de>; Thu,  6 Jun 2019 23:52:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728740AbfFFVwZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jun 2019 17:52:25 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:58564 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728735AbfFFVwZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jun 2019 17:52:25 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 11CE814E272D1;
        Thu,  6 Jun 2019 14:52:25 -0700 (PDT)
Date:   Thu, 06 Jun 2019 14:52:24 -0700 (PDT)
Message-Id: <20190606.145224.1883563982799597413.davem@davemloft.net>
To:     dsahern@kernel.org
Cc:     netdev@vger.kernel.org, idosch@mellanox.com, kafai@fb.com,
        weiwan@google.com, sbrivio@redhat.com, dsahern@gmail.com
Subject: Re: [PATCH net-next 14/19] nexthops: add support for replace
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190605231523.18424-15-dsahern@kernel.org>
References: <20190605231523.18424-1-dsahern@kernel.org>
        <20190605231523.18424-15-dsahern@kernel.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 06 Jun 2019 14:52:25 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Ahern <dsahern@kernel.org>
Date: Wed,  5 Jun 2019 16:15:18 -0700

> +	for (i = 0; i < newg->num_nh; ++i)
> +		newg->nh_entries[i].nh_parent = old;

i++ please.

> +	for (i = 0; i < oldg->num_nh; ++i)
> +		oldg->nh_entries[i].nh_parent = new;

Likewise.
