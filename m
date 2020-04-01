Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7021D19B54D
	for <lists+netdev@lfdr.de>; Wed,  1 Apr 2020 20:23:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732550AbgDASXU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Apr 2020 14:23:20 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:37556 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732285AbgDASXT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Apr 2020 14:23:19 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 3450A11E3C074;
        Wed,  1 Apr 2020 11:23:19 -0700 (PDT)
Date:   Wed, 01 Apr 2020 11:23:18 -0700 (PDT)
Message-Id: <20200401.112318.291287510384908654.davem@davemloft.net>
To:     rpalethorpe@suse.com
Cc:     linux-can@vger.kernel.org, keescook@chromium.org,
        netdev@vger.kernel.org, security@kernel.org, wg@grandegger.com,
        mkl@pengutronix.de
Subject: Re: [PATCH v2] slcan: Don't transmit uninitialized stack data in
 padding
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200401100639.20199-1-rpalethorpe@suse.com>
References: <20200401100639.20199-1-rpalethorpe@suse.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 01 Apr 2020 11:23:19 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Richard Palethorpe <rpalethorpe@suse.com>
Date: Wed,  1 Apr 2020 12:06:39 +0200

> struct can_frame contains some padding which is not explicitly zeroed in
> slc_bump. This uninitialized data will then be transmitted if the stack
> initialization hardening feature is not enabled (CONFIG_INIT_STACK_ALL).
> 
> This commit just zeroes the whole struct including the padding.
> 
> Signed-off-by: Richard Palethorpe <rpalethorpe@suse.com>
> Fixes: a1044e36e457 ("can: add slcan driver for serial/USB-serial CAN adapters")
> Reviewed-by: Kees Cook <keescook@chromium.org>

Applied and queued up for -stable, thanks.
