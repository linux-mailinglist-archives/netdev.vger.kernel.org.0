Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 419F742CB8
	for <lists+netdev@lfdr.de>; Wed, 12 Jun 2019 18:52:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2440335AbfFLQwm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jun 2019 12:52:42 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:38052 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2409477AbfFLQwm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jun 2019 12:52:42 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 6EB87152788A0;
        Wed, 12 Jun 2019 09:52:41 -0700 (PDT)
Date:   Wed, 12 Jun 2019 09:52:40 -0700 (PDT)
Message-Id: <20190612.095240.868638680123053774.davem@davemloft.net>
To:     nsaenzjulienne@suse.de
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH v2 1/2] net: ethernet: wiznet: w5X00 add device tree
 support
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190612122526.14332-1-nsaenzjulienne@suse.de>
References: <20190612122526.14332-1-nsaenzjulienne@suse.de>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 12 Jun 2019 09:52:41 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nicolas Saenz Julienne <nsaenzjulienne@suse.de>
Date: Wed, 12 Jun 2019 14:25:25 +0200

> The w5X00 chip provides an SPI to Ethernet inteface. This patch allows
> platform devices to be defined through the device tree.
> 
> Signed-off-by: Nicolas Saenz Julienne <nsaenzjulienne@suse.de>

Applied to net-next.
