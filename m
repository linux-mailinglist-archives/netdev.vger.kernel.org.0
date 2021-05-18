Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7AB073882D5
	for <lists+netdev@lfdr.de>; Wed, 19 May 2021 00:42:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352806AbhERWne (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 May 2021 18:43:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:40268 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230251AbhERWne (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 18 May 2021 18:43:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 654C260C40;
        Tue, 18 May 2021 22:42:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621377735;
        bh=ch/rHWKCAfnljtKNgoRHxZs91S6GLayxOZEk0dYuSlE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=thx75XmCtFX5jiZlvnB1CPwhWZyrhKB7g+jYtvvr0NkKTJ+enVGNU1Tfl/9zYSLiW
         T3EHr9/yURITtWzPCcKoJdo7GU6TYLFXho1hwX7UIwbbDrFwRBYQ+EfMI2cHm0xnXu
         cwXU3FJn2jnNqSo2Dkcen4dB9TTfhoRNVL4yZ+86fuWfFZxeXGKsOVMK/llcZX6vdP
         a37nwSwKgWMmAriQMzabwDpWUtldOVTojOgFLfLmFSEetBYTMbJCpRnjHKEDC2aBSI
         rucWkwk3iy8MGIovINfTMSYo/3+7yDEYGEYxsrvsNt5nUuzKMwLnrrbUlQ52WDWmPq
         8h5fqN8D2Nc2w==
Date:   Tue, 18 May 2021 15:42:14 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     mkubecek@suse.cz
Cc:     netdev@vger.kernel.org, idosch@idosch.org
Subject: Re: [PACTH ethtool-next v3 0/7] ethtool: support FEC and standard
 stats
Message-ID: <20210518154214.22060227@kicinski-fedora-PC1C0HJN>
In-Reply-To: <20210503160830.555241-1-kuba@kernel.org>
References: <20210503160830.555241-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon,  3 May 2021 09:08:23 -0700 Jakub Kicinski wrote:
> This series adds support for FEC requests via netlink
> and new "standard" stats.

Anything I can do to help with those? They disappeared from 
patchwork due to auto archiving being set to 2 weeks.
