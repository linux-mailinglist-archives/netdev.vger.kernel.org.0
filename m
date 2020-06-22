Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00DFA204453
	for <lists+netdev@lfdr.de>; Tue, 23 Jun 2020 01:16:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731186AbgFVXQN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jun 2020 19:16:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730985AbgFVXQL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Jun 2020 19:16:11 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF824C061573
        for <netdev@vger.kernel.org>; Mon, 22 Jun 2020 16:16:11 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 2377A12970F46;
        Mon, 22 Jun 2020 16:16:11 -0700 (PDT)
Date:   Mon, 22 Jun 2020 16:16:10 -0700 (PDT)
Message-Id: <20200622.161610.1973683057638627952.davem@davemloft.net>
To:     kuba@kernel.org
Cc:     vasundhara-v.volam@broadcom.com, netdev@vger.kernel.org,
        michael.chan@broadcom.com, jiri@mellanox.com,
        jacob.e.keller@intel.com
Subject: Re: [PATCH v2 net-next 0/2] devlink: Add board.serial_number field
 to info_get cb.
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200622145324.79906b88@kicinski-fedora-PC1C0HJN>
References: <1592670717-28851-1-git-send-email-vasundhara-v.volam@broadcom.com>
        <20200622145324.79906b88@kicinski-fedora-PC1C0HJN>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 22 Jun 2020 16:16:11 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jakub Kicinski <kuba@kernel.org>
Date: Mon, 22 Jun 2020 14:53:24 -0700

> On Sat, 20 Jun 2020 22:01:55 +0530 Vasundhara Volam wrote:
>> This patchset adds support for board.serial_number to devlink info_get
>> cb and also use it in bnxt_en driver.
 ...
> Reviewed-by: Jakub Kicinski <kuba@kernel.org>

Series applied, thanks.
