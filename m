Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8232B2C1972
	for <lists+netdev@lfdr.de>; Tue, 24 Nov 2020 00:34:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727033AbgKWXaE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Nov 2020 18:30:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:59616 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727017AbgKWXaE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 23 Nov 2020 18:30:04 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3BBB020719;
        Mon, 23 Nov 2020 23:30:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606174203;
        bh=rYUtxSEvA/l/tlosAjsOsm3sjR2Z381mgJ+SO0KslHc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=FEVwaM+8YSECZkoPGkZL5ra6ZmiqJWRlOslAoathS3ZtwWsrx2DbSMIyIzW96zGVG
         rMTlr/GXzR+2DyhXTtn+Q06KTWguIy3zRfr3ldC3jQqr/S43qv2ICzkPVdvuVD+91l
         WKnNIEH255C197B0bQ3tn/zMxz1mADlahagujhQw=
Date:   Mon, 23 Nov 2020 15:30:02 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: pull-request: wireless-drivers-2020-11-23
Message-ID: <20201123153002.2200d6be@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201123161037.C11D1C43460@smtp.codeaurora.org>
References: <20201123161037.C11D1C43460@smtp.codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 23 Nov 2020 16:10:37 +0000 (UTC) Kalle Valo wrote:
> wireless-drivers fixes for v5.10
> 
> First set of fixes for v5.10. One fix for iwlwifi kernel panic, others
> less notable.
> 
> rtw88
> 
> * fix a bogus test found by clang
> 
> iwlwifi
> 
> * fix long memory reads causing soft lockup warnings
> 
> * fix kernel panic during Channel Switch Announcement (CSA)
> 
> * other smaller fixes
> 
> MAINTAINERS
> 
> * email address updates

Pulled, thanks!

Please watch out for missing sign-offs.
