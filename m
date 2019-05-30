Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CF4462F4F9
	for <lists+netdev@lfdr.de>; Thu, 30 May 2019 06:44:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388722AbfE3EnL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 May 2019 00:43:11 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:46808 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388611AbfE3EnJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 May 2019 00:43:09 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 554EA136E16A9;
        Wed, 29 May 2019 21:43:09 -0700 (PDT)
Date:   Wed, 29 May 2019 21:43:08 -0700 (PDT)
Message-Id: <20190529.214308.861063011385687296.davem@davemloft.net>
To:     hkallweit1@gmail.com
Cc:     nic_swsd@realtek.com, netdev@vger.kernel.org
Subject: Re: [PATCH net-next] r8169: remove 1000/Half from supported modes
From:   David Miller <davem@davemloft.net>
In-Reply-To: <ac29e5b9-2d8a-f68d-db1b-cdb3d3110922@gmail.com>
References: <ac29e5b9-2d8a-f68d-db1b-cdb3d3110922@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 29 May 2019 21:43:09 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Heiner Kallweit <hkallweit1@gmail.com>
Date: Tue, 28 May 2019 18:43:46 +0200

> MAC on the GBit versions supports 1000/Full only, however the PHY
> partially claims to support 1000/Half. So let's explicitly remove
> this mode.
> 
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>

Applied.
