Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 88559194EF7
	for <lists+netdev@lfdr.de>; Fri, 27 Mar 2020 03:31:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727787AbgC0Cbm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Mar 2020 22:31:42 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:57528 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727696AbgC0Cbm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Mar 2020 22:31:42 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 4861E15CE4E19;
        Thu, 26 Mar 2020 19:31:41 -0700 (PDT)
Date:   Thu, 26 Mar 2020 19:31:40 -0700 (PDT)
Message-Id: <20200326.193140.518355155914627267.davem@davemloft.net>
To:     wsa+renesas@sang-engineering.com
Cc:     linux-i2c@vger.kernel.org, jeffrey.t.kirsher@intel.com,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] igb: convert to use i2c_new_client_device()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200326211001.13171-2-wsa+renesas@sang-engineering.com>
References: <20200326211001.13171-1-wsa+renesas@sang-engineering.com>
        <20200326211001.13171-2-wsa+renesas@sang-engineering.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 26 Mar 2020 19:31:41 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Wolfram Sang <wsa+renesas@sang-engineering.com>
Date: Thu, 26 Mar 2020 22:09:59 +0100

> Move away from the deprecated API and return the shiny new ERRPTR where
> useful.
> 
> Signed-off-by: Wolfram Sang <wsa+renesas@sang-engineering.com>

Applied.
