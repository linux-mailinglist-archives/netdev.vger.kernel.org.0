Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42D244681D6
	for <lists+netdev@lfdr.de>; Sat,  4 Dec 2021 02:37:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1384018AbhLDBkh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Dec 2021 20:40:37 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:34062 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383963AbhLDBkg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Dec 2021 20:40:36 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 009E9B80DD7;
        Sat,  4 Dec 2021 01:37:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85908C341C0;
        Sat,  4 Dec 2021 01:37:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638581829;
        bh=V0YJGTiKuStUo8QL0j7QQLTPjfAZmi+KAdffmnVsFGU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ZPdfrIApgMrXUqbkfWnHmIST78D9yIPx4Vbp5TaCU/DmbHukP0RaLd+3KejgSfjn7
         SKuaUVG+rC2R6y2q8ALYubwkXMdi7upubn2YffF8pD0xp7y1TmJNy0O9NsWDUzB2Np
         hm0jklRFE0baY8zlIIlIoWasLXTfuvmqq/o7mm2eVymRLpm8CGM64P5zV6L5un0Rx4
         8p7pA0EWOuuunPrc8nKHCFjX9Td27KbILoZBucQf0uM5wJbix+MgZeYSt9eNfWZMDI
         +szTRhMATJ2Mcp3s4ncRCF8t7ZL+LEwfLqd9s7sBuOTRkV5ptleAvXWmpCAfTfPGWr
         A1icEHinrqFyQ==
Date:   Fri, 3 Dec 2021 17:37:08 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Ameer Hamza <amhamza.mgc@gmail.com>
Cc:     davem@davemloft.net, mcoquelin.stm32@gmail.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: stmmac: Fix possible division by zero
Message-ID: <20211203173708.7fdbed06@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211202223729.134238-1-amhamza.mgc@gmail.com>
References: <20211202223729.134238-1-amhamza.mgc@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri,  3 Dec 2021 03:37:29 +0500 Ameer Hamza wrote:
> Fix for divide by zero error reported by Coverity.
> 
> Addresses-Coverity: 1494557 ("Division or modulo by zero")
> 
> Signed-off-by: Ameer Hamza <amhamza.mgc@gmail.com>

Please include justification that this issue can actually happen, Fixes
tag pointing to the commit which introduced the problem, and CC the
author and reviewers of that commit.
