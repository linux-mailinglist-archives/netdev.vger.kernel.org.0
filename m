Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AE590125776
	for <lists+netdev@lfdr.de>; Thu, 19 Dec 2019 00:12:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726622AbfLRXMJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Dec 2019 18:12:09 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:57574 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726591AbfLRXMI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Dec 2019 18:12:08 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 40722153FF241;
        Wed, 18 Dec 2019 15:12:08 -0800 (PST)
Date:   Wed, 18 Dec 2019 15:12:05 -0800 (PST)
Message-Id: <20191218.151205.1522776052236085821.davem@davemloft.net>
To:     andre.guedes@intel.com
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH 1/2] ether: Add ETH_P_OPCUA macro
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191218224448.8066-1-andre.guedes@intel.com>
References: <20191218224448.8066-1-andre.guedes@intel.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 18 Dec 2019 15:12:08 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Andre Guedes <andre.guedes@intel.com>
Date: Wed, 18 Dec 2019 14:44:47 -0800

> This patch adds the ETH_P_OPCUA macro which defines the 'OPC UA over
> TSN' ethertype assigned to 0xB62C, according to:
> 
> http://standards-oui.ieee.org/ethertype/eth.txt
> 
> Signed-off-by: Andre Guedes <andre.guedes@intel.com>

Add then when there is also an in-kernel user as well.
