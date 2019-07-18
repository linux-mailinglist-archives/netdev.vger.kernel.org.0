Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 48F206D74D
	for <lists+netdev@lfdr.de>; Fri, 19 Jul 2019 01:34:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726138AbfGRXeG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jul 2019 19:34:06 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:57244 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725992AbfGRXeF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Jul 2019 19:34:05 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 624471528C8CF;
        Thu, 18 Jul 2019 16:34:05 -0700 (PDT)
Date:   Thu, 18 Jul 2019 16:34:04 -0700 (PDT)
Message-Id: <20190718.163404.1067881023225282536.davem@davemloft.net>
To:     michael.chan@broadcom.com
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH net] bnxt_en: Fix VNIC accounting when enabling aRFS on
 57500 chips.
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1563347243-8100-1-git-send-email-michael.chan@broadcom.com>
References: <1563347243-8100-1-git-send-email-michael.chan@broadcom.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 18 Jul 2019 16:34:05 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Michael Chan <michael.chan@broadcom.com>
Date: Wed, 17 Jul 2019 03:07:23 -0400

> Unlike legacy chips, 57500 chips don't need additional VNIC resources
> for aRFS/ntuple.  Fix the code accordingly so that we don't reserve
> and allocate additional VNICs on 57500 chips.  Without this patch,
> the driver is failing to initialize when it tries to allocate extra
> VNICs.
> 
> Fixes: ac33906c67e2 ("bnxt_en: Add support for aRFS on 57500 chips.")
> Signed-off-by: Michael Chan <michael.chan@broadcom.com>

Applied.

> Please queue this for 5.2 -stable also.  Thanks.

Queued up.
