Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6FF7626A89
	for <lists+netdev@lfdr.de>; Wed, 22 May 2019 21:07:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729748AbfEVTHv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 May 2019 15:07:51 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:60458 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728761AbfEVTHv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 May 2019 15:07:51 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d8])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 095CF1500A85B;
        Wed, 22 May 2019 12:07:51 -0700 (PDT)
Date:   Wed, 22 May 2019 12:07:48 -0700 (PDT)
Message-Id: <20190522.120748.42244348495685617.davem@davemloft.net>
To:     maximmi@mellanox.com
Cc:     jakub.kicinski@netronome.com, kuznet@ms2.inr.ac.ru,
        yoshfuji@linux-ipv6.org, netdev@vger.kernel.org,
        leonro@mellanox.com
Subject: Re: [PATCH net v2] Validate required parameters in
 inet6_validate_link_af
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190521063941.7451-1-maximmi@mellanox.com>
References: <20190521063941.7451-1-maximmi@mellanox.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 22 May 2019 12:07:51 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maxim Mikityanskiy <maximmi@mellanox.com>
Date: Tue, 21 May 2019 06:40:04 +0000

> inet6_set_link_af requires that at least one of IFLA_INET6_TOKEN or
> IFLA_INET6_ADDR_GET_MODE is passed. If none of them is passed, it
> returns -EINVAL, which may cause do_setlink() to fail in the middle of
> processing other commands and give the following warning message:
> 
>   A link change request failed with some changes committed already.
>   Interface eth0 may have been left with an inconsistent configuration,
>   please check.
> 
> Check the presence of at least one of them in inet6_validate_link_af to
> detect invalid parameters at an early stage, before do_setlink does
> anything. Also validate the address generation mode at an early stage.
> 
> Signed-off-by: Maxim Mikityanskiy <maximmi@mellanox.com>

Applied, thank you.
