Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 73FA817CC82
	for <lists+netdev@lfdr.de>; Sat,  7 Mar 2020 07:39:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726199AbgCGGjf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Mar 2020 01:39:35 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:41026 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726102AbgCGGje (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 Mar 2020 01:39:34 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477::f0c])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 28EE415531085;
        Fri,  6 Mar 2020 22:39:34 -0800 (PST)
Date:   Fri, 06 Mar 2020 22:39:33 -0800 (PST)
Message-Id: <20200306.223933.896880044335781056.davem@davemloft.net>
To:     mayflowerera@gmail.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] macsec: Backward compatibility bugfix of consts
 values
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200306025523.63457-1-mayflowerera@gmail.com>
References: <20200306025523.63457-1-mayflowerera@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 06 Mar 2020 22:39:34 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Era Mayflower <mayflowerera@gmail.com>
Date: Fri,  6 Mar 2020 02:55:22 +0000

> Fixed a compatibility bug, the value of the following consts changes:
>     * IFLA_MACSEC_PAD (include/uapi/linux/if_link.h)
>     * MACSEC_SECY_ATTR_PAD (include/uapi/linux/if_macsec.h)
>     * MACSEC_RXSC_ATTR_PAD (include/uapi/linux/if_macsec.h)
> 
> Depends on: macsec: Netlink support of XPN cipher suites (IEEE 802.1AEbw)
> 
> Signed-off-by: Era Mayflower <mayflowerera@gmail.com>

Fix your original patches so that they don't have these bugs, and then
resubmit that.
