Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81DE52BB634
	for <lists+netdev@lfdr.de>; Fri, 20 Nov 2020 21:05:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729850AbgKTUCi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Nov 2020 15:02:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:50526 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729377AbgKTUCh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 20 Nov 2020 15:02:37 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DB00C2225B;
        Fri, 20 Nov 2020 20:02:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605902557;
        bh=94mAs+GjOGNIK5Bf0DlSmAyFTN1Il6KLdd2lypxQrPw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=lfexdb/88rWlhaO+GCrMpo4zwT3+rKR9ODkVd0VGKq90x0lIq1Ck//KIqMKQfVCVJ
         yn8mvQMt8YJu75E0uGO6jrFTcQ5HKzgiq+n9PLivAsClhfWz9WrDkc7FZHAn9V0Uw6
         9Fnm8rFvUSRXX0Y+W8nhmA/irGT43LusXMZ707Nc=
Date:   Fri, 20 Nov 2020 12:02:35 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Armin Wolf <W_Armin@gmx.de>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, f.fainelli@gmail.com,
        joe@perches.com
Subject: Re: [PATCH net-next v2 2/2] lib8390: Cleanup variables
Message-ID: <20201120120235.1925e713@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201118165107.12419-3-W_Armin@gmx.de>
References: <20201118165107.12419-1-W_Armin@gmx.de>
        <20201118165107.12419-3-W_Armin@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 18 Nov 2020 17:51:07 +0100 Armin Wolf wrote:
>  	unsigned long e8390_base = dev->base_addr;
>  	struct ei_device *ei_local = netdev_priv(dev);
> -	int send_length, output_page;
> +	int output_page;
>  	unsigned long flags;

The last two lines should be swapped to follow the reverse xmas tree
ordering of variables.

More importantly this driver is marked as:

S:	Orphan / Obsolete

in MAINTAINERS. Are you actually using hardware which needs this code,
or are those changes purely based on code inspection?

You should either change the state of the driver in MAINTAINERS, or find
another driver / part of the kernel to refactor.
