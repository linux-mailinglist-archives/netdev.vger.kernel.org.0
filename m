Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 968A8123888
	for <lists+netdev@lfdr.de>; Tue, 17 Dec 2019 22:16:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728032AbfLQVQf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Dec 2019 16:16:35 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:43032 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727490AbfLQVQe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Dec 2019 16:16:34 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id DC21014325EFA;
        Tue, 17 Dec 2019 13:16:33 -0800 (PST)
Date:   Tue, 17 Dec 2019 13:16:31 -0800 (PST)
Message-Id: <20191217.131631.2246524906428878009.davem@davemloft.net>
To:     opendmb@gmail.com
Cc:     f.fainelli@gmail.com, bcm-kernel-feedback-list@broadcom.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 3/8] net: bcmgenet: use CHECKSUM_COMPLETE for
 NETIF_F_RXCSUM
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1576616549-39097-4-git-send-email-opendmb@gmail.com>
References: <1576616549-39097-1-git-send-email-opendmb@gmail.com>
        <1576616549-39097-4-git-send-email-opendmb@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 17 Dec 2019 13:16:34 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Doug Berger <opendmb@gmail.com>
Date: Tue, 17 Dec 2019 13:02:24 -0800

> This commit updates the Rx checksum offload behavior of the driver
> to use the more generic CHECKSUM_COMPLETE method that supports all
> protocols over the CHECKSUM_UNNECESSARY method that only applies
> to some protocols known by the hardware.
> 
> This behavior is perceived to be superior.
> 
> Signed-off-by: Doug Berger <opendmb@gmail.com>

This has to be done in the same patch that you change to use
the NETIF_F_HW_CSUM feature flag.
