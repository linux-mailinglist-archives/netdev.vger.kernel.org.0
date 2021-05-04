Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27022373066
	for <lists+netdev@lfdr.de>; Tue,  4 May 2021 21:09:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231926AbhEDTJ4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 May 2021 15:09:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231849AbhEDTJy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 May 2021 15:09:54 -0400
Received: from mail.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB9A8C061574
        for <netdev@vger.kernel.org>; Tue,  4 May 2021 12:08:59 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        by mail.monkeyblade.net (Postfix) with ESMTPSA id 521484D0B172D;
        Tue,  4 May 2021 12:08:57 -0700 (PDT)
Date:   Tue, 04 May 2021 12:08:52 -0700 (PDT)
Message-Id: <20210504.120852.2074680927730840237.davem@davemloft.net>
To:     snelson@pensando.io
Cc:     netdev@vger.kernel.org, kuba@kernel.org, drivers@pensando.io
Subject: Re: [PATCH net] ionic: fix ptp support config breakage
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20210504182809.71312-1-snelson@pensando.io>
References: <20210504182809.71312-1-snelson@pensando.io>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.6.2 (mail.monkeyblade.net [0.0.0.0]); Tue, 04 May 2021 12:08:57 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Shannon Nelson <snelson@pensando.io>
Date: Tue,  4 May 2021 11:28:09 -0700

> Driver link failed with undefined references in some
> kernel config variations.
> 
> Reported-by: kernel test robot <lkp@intel.com>
> Signed-off-by: Shannon Nelson <snelson@pensando.io>

Please resend with an appropriate Fixes: tag.

Thank you.
