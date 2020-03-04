Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 66CF7179C86
	for <lists+netdev@lfdr.de>; Thu,  5 Mar 2020 00:44:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388513AbgCDXoB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Mar 2020 18:44:01 -0500
Received: from mail26.static.mailgun.info ([104.130.122.26]:27563 "EHLO
        mail26.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388389AbgCDXoA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Mar 2020 18:44:00 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1583365440; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=7eUUFwVHuI/U/XukJuffOaTXNP+eD9Qwzgt9BBFqIqI=;
 b=aBTcmqHs0rt13eQFLioz7CHCIcectXATc0/7L7VGEu1LxL5ufp3J9iwByM30tlb9wh1j9MNt
 HCApQwxxxvqj6utKGt2VQZFvixvSUnt7xJ1RBI0WyCUWCc0KBQ5YkFcX1ywV3GxJBnbHx8E7
 CAE3a2gBx9yyCMw1RD5hqRLI0bY=
X-Mailgun-Sending-Ip: 104.130.122.26
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171])
 by mxa.mailgun.org with ESMTP id 5e603d3f.7fcd36a07570-smtp-out-n04;
 Wed, 04 Mar 2020 23:43:59 -0000 (UTC)
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id C786BC4479F; Wed,  4 Mar 2020 23:43:58 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=2.0 tests=ALL_TRUSTED
        autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: subashab)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 49212C43383;
        Wed,  4 Mar 2020 23:43:58 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Wed, 04 Mar 2020 16:43:58 -0700
From:   subashab@codeaurora.org
To:     Taehee Yoo <ap420073@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, stranche@codeaurora.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next v2 0/3] net: rmnet: several code cleanup for
 rmnet module
In-Reply-To: <20200304232415.12205-1-ap420073@gmail.com>
References: <20200304232415.12205-1-ap420073@gmail.com>
Message-ID: <eb4fa65d10a8b1f81be44bcb4e3b6a43@codeaurora.org>
X-Sender: subashab@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-03-04 16:24, Taehee Yoo wrote:
> This patchset is to cleanup rmnet module code.
> 
> 1. The first patch is to add module alias
> rmnet module can not be loaded automatically because there is no
> alias name.
> 
> 2. The second patch is to add extack error message code.
> When rmnet netlink command fails, it doesn't print any error message.
> So, users couldn't know the exact reason.
> In order to tell the exact reason to the user, the extack error message
> is used in this patch.
> 
> 3. The third patch is to use GFP_KERNEL instead of GFP_ATOMIC.
> In the sleepable context, GFP_KERNEL can be used.
> So, in this patch, GFP_KERNEL is used instead of GFP_ATOMIC.
> 
> Change log:
>  - v1->v2: change error message in the second patch.
> 
> Taehee Yoo (3):
>   net: rmnet: add missing module alias
>   net: rmnet: print error message when command fails
>   net: rmnet: use GFP_KERNEL instead of GFP_ATOMIC
> 
>  .../ethernet/qualcomm/rmnet/rmnet_config.c    | 36 ++++++++++++-------
>  .../net/ethernet/qualcomm/rmnet/rmnet_vnd.c   | 11 +++---
>  .../net/ethernet/qualcomm/rmnet/rmnet_vnd.h   |  3 +-
>  3 files changed, 32 insertions(+), 18 deletions(-)

For the series:

Acked-by: Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>
