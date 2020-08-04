Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF2A023C087
	for <lists+netdev@lfdr.de>; Tue,  4 Aug 2020 22:08:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727042AbgHDUIe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Aug 2020 16:08:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725981AbgHDUId (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Aug 2020 16:08:33 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80B94C06174A;
        Tue,  4 Aug 2020 13:08:33 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id AB68C12880E16;
        Tue,  4 Aug 2020 12:51:46 -0700 (PDT)
Date:   Tue, 04 Aug 2020 13:08:31 -0700 (PDT)
Message-Id: <20200804.130831.58597376499470026.davem@davemloft.net>
To:     ahabdels@gmail.com
Cc:     kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        andrea.mayer@uniroma2.it
Subject: Re: [PATCH] seg6: using DSCP of inner IPv4 packets
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200804074030.1147-1-ahabdels@gmail.com>
References: <20200804074030.1147-1-ahabdels@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 04 Aug 2020 12:51:46 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ahmed Abdelsalam <ahabdels@gmail.com>
Date: Tue,  4 Aug 2020 07:40:30 +0000

> This patch allows copying the DSCP from inner IPv4 header to the
> outer IPv6 header, when doing SRv6 Encapsulation.
> 
> This allows forwarding packet across the SRv6 fabric based on their
> original traffic class.
> 
> Signed-off-by: Ahmed Abdelsalam <ahabdels@gmail.com>

Thanks for reworking your patch this way.  I need some time to
audit the new control flow since the SKB push operation is now
in a different location.

Thanks.
