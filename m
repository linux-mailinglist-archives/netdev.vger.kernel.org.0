Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16E3F29A23E
	for <lists+netdev@lfdr.de>; Tue, 27 Oct 2020 02:37:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2411668AbgJ0Bgm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Oct 2020 21:36:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:53866 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2410507AbgJ0Bgm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 26 Oct 2020 21:36:42 -0400
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5C6E12080A;
        Tue, 27 Oct 2020 01:36:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603762601;
        bh=NqaFC7cHs4ctFqfKjom4H7KMXR9H1z5b7cdB6n0/f2o=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=faXlDvCtR+37rhqlGr7Fb7wO9xXLBOfI27MWI3iVMu+/owo7D8TStHnNjWzlOdREc
         Pp3/xcR+vHiLGT9zkznb5yiRLsCrZHPsFL04KQ1Lw/UiROTsVuwoqPQ4M/IkfOO88v
         N5hcK0oW1mkzKfaiYb1cBHDLKg0Ni2bYiMOM4d6U=
Date:   Mon, 26 Oct 2020 18:36:40 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Michael Chan <michael.chan@broadcom.com>
Cc:     netdev@vger.kernel.org, gospo@broadcom.com
Subject: Re: [PATCH net 0/5] bnxt_en: Bug fixes.
Message-ID: <20201026183640.5f0dac28@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <1603685901-17917-1-git-send-email-michael.chan@broadcom.com>
References: <1603685901-17917-1-git-send-email-michael.chan@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 26 Oct 2020 00:18:16 -0400 Michael Chan wrote:
> These 5 bug fixes are all related to the firmware reset or AER recovery.
> 2 patches fix the cleanup logic for the workqueue used to handle firmware
> reset and recovery. 1 patch ensures that the chip will have the proper
> BAR addresses latched after fatal AER recovery.  1 patch fixes the
> open path to check for firmware reset abort error.  The last one
> sends the fw reset command unconditionally to fix the AER reset logic.
> 
> Please queue these for -stable as well.  Thanks.

Applied, thanks!
