Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A87EA28C44D
	for <lists+netdev@lfdr.de>; Mon, 12 Oct 2020 23:48:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730131AbgJLVsl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Oct 2020 17:48:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:52118 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729273AbgJLVsk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Oct 2020 17:48:40 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 396E52072D;
        Mon, 12 Oct 2020 21:48:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602539320;
        bh=sJz371vhazWLmZJ/swm8tXQ1oYAgDYEkPpI821jExGE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=cPA/qJBas/GKTWP9ZvbfDRDj4UwdpOAmnKz7CltSezBhzkYBrGlt9yDBNON/T+DBv
         lbJtpsDUd3OiNjjjwoB19ftFY6ZK8hmfN9QS2q8IEtwIN/D6Y3XNRjf8hrUfKUDuLS
         qkm31sByTm0+GBYjKZWWxkulOb4MycEN042pioy8=
Date:   Mon, 12 Oct 2020 14:48:38 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Michael Chan <michael.chan@broadcom.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, gospo@broadcom.com
Subject: Re: [PATCH net-next v2 0/9] bnxt_en: Updates for net-next.
Message-ID: <20201012144838.126c2966@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1602493854-29283-1-git-send-email-michael.chan@broadcom.com>
References: <1602493854-29283-1-git-send-email-michael.chan@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 12 Oct 2020 05:10:45 -0400 Michael Chan wrote:
> This series contains these main changes:
> 
> 1. Change of default message level to enable more logging.
> 2. Some cleanups related to processing async events from firmware.
> 3. Allow online ethtool selftest on multi-function PFs.
> 4. Return stored firmware version information to devlink.
> 
> v2:
> Patch 3: Change bnxt_reset_task() to silent mode.
> Patch 8 & 9: Ensure we copy NULL terminated fw strings to devlink.
> Patch 8 & 9: Return directly after the last bnxt_dl_info_put() call.
> Patch 9: If FW call to get stored dev info fails, return success to
>          devlink without the stored versions.

Applied, thank you!
