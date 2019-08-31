Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9C84AA4161
	for <lists+netdev@lfdr.de>; Sat, 31 Aug 2019 02:38:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728477AbfHaAio (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Aug 2019 20:38:44 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:44492 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728122AbfHaAio (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Aug 2019 20:38:44 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id CBAA61550659B;
        Fri, 30 Aug 2019 17:38:43 -0700 (PDT)
Date:   Fri, 30 Aug 2019 17:38:43 -0700 (PDT)
Message-Id: <20190830.173843.403900662104064621.davem@davemloft.net>
To:     michael.chan@broadcom.com
Cc:     netdev@vger.kernel.org, ray.jui@broadcom.com
Subject: Re: [PATCH net-next] bnxt_en: Fix compile error regression with
 CONFIG_BNXT_SRIOV not set.
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1567206638-22674-1-git-send-email-michael.chan@broadcom.com>
References: <1567206638-22674-1-git-send-email-michael.chan@broadcom.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 30 Aug 2019 17:38:43 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Michael Chan <michael.chan@broadcom.com>
Date: Fri, 30 Aug 2019 19:10:38 -0400

> Add a new function bnxt_get_registered_vfs() to handle the work
> of getting the number of registered VFs under #ifdef CONFIG_BNXT_SRIOV.
> The main code will call this function and will always work correctly
> whether CONFIG_BNXT_SRIOV is set or not.
> 
> Fixes: 230d1f0de754 ("bnxt_en: Handle firmware reset.")
> Reported-by: kbuild test robot <lkp@intel.com>
> Signed-off-by: Michael Chan <michael.chan@broadcom.com>

Applied, thanks.
