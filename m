Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5CEC7A3F46
	for <lists+netdev@lfdr.de>; Fri, 30 Aug 2019 23:02:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728148AbfH3VCr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Aug 2019 17:02:47 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:41796 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727991AbfH3VCr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Aug 2019 17:02:47 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id BBA30154FD930;
        Fri, 30 Aug 2019 14:02:46 -0700 (PDT)
Date:   Fri, 30 Aug 2019 14:02:46 -0700 (PDT)
Message-Id: <20190830.140246.425280810721271380.davem@davemloft.net>
To:     michael.chan@broadcom.com
Cc:     netdev@vger.kernel.org, vasundhara-v.volam@broadcom.com,
        ray.jui@broadcom.com
Subject: Re: [PATCH net-next v2 00/22] bnxt_en: health and error recovery.
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1567137305-5853-1-git-send-email-michael.chan@broadcom.com>
References: <1567137305-5853-1-git-send-email-michael.chan@broadcom.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 30 Aug 2019 14:02:46 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Michael Chan <michael.chan@broadcom.com>
Date: Thu, 29 Aug 2019 23:54:43 -0400

> This patchset implements adapter health and error recovery.  The status
> is reported through several devlink reporters and the driver will
> initiate and complete the recovery process using the devlink infrastructure.
> 
> v2: Added 4 patches at the beginning of the patchset to clean up error code
>     handling related to firmware messages and to convert to use standard
>     error codes.
> 
>     Removed the dropping of rtnl_lock in bnxt_close().
> 
>     Broke up the patches some more for better patch organization and
>     future bisection.

The return value handling looks a lot better now, thanks for cleaning that
up.

Series applied, thanks Michael.
