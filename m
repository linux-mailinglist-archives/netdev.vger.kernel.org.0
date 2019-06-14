Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4D24446349
	for <lists+netdev@lfdr.de>; Fri, 14 Jun 2019 17:48:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726276AbfFNPsp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jun 2019 11:48:45 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:45320 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726218AbfFNPsp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jun 2019 11:48:45 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 93A67148BD7FF;
        Fri, 14 Jun 2019 08:48:44 -0700 (PDT)
Date:   Fri, 14 Jun 2019 08:48:44 -0700 (PDT)
Message-Id: <20190614.084844.694799483519239073.davem@davemloft.net>
To:     92siuyang@gmail.com
Cc:     sameo@linux.intel.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] nfc: Ensure presence of required attributes in the
 deactivate_target handler
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1560496382-32532-1-git-send-email-92siuyang@gmail.com>
References: <1560496382-32532-1-git-send-email-92siuyang@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 14 Jun 2019 08:48:44 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Young Xiao <92siuyang@gmail.com>
Date: Fri, 14 Jun 2019 15:13:02 +0800

> Check that the NFC_ATTR_TARGET_INDEX attributes (in addition to
> NFC_ATTR_DEVICE_INDEX) are provided by the netlink client prior to
> accessing them. This prevents potential unhandled NULL pointer dereference
> exceptions which can be triggered by malicious user-mode programs,
> if they omit one or both of these attributes.
> 
> Signed-off-by: Young Xiao <92siuyang@gmail.com>

Applied and queued up for -stable, thanks.
