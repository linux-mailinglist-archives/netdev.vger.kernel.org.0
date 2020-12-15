Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D537D2DA4E9
	for <lists+netdev@lfdr.de>; Tue, 15 Dec 2020 01:30:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729093AbgLOAa2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Dec 2020 19:30:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:58870 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726615AbgLOAaS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 14 Dec 2020 19:30:18 -0500
Date:   Mon, 14 Dec 2020 16:29:37 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607992178;
        bh=5rs2vLQHAVbGiDjp1Kwfo5SBAOeqHd8dGmV+3y/sPOs=;
        h=From:To:Cc:Subject:In-Reply-To:References:From;
        b=dOHHXRfaA8CTgDWvtEQ2amw/A23i/myIWO14mUn301E9pvypZ/KDuPUYWssuXeUOR
         MySn1FDl4r6gF3YTufwqUVbuY8G2NPE7uOtjbYl7a5n8WJpUoRjBmLv1FMqE412bjX
         Bji9jOIxN6HiL3iWch3zpzuSvsCIPmRmx99qByFb7dfoQTGU5NYSnGeFHndMBSradk
         tvd6M98q4fTijSCsJ18HoUUAjpIaD35Is4ZEycH+RdsXQl/UrsTeqV2Bb2I8Ma9Uj0
         LRVRa2QjwgJw6c+hroJNMJiRdBc996MXOkxLq6wE4kQv20+y12xHsUuf8zAQxnAAJY
         Tn6UQ8lmvtANA==
From:   Jakub Kicinski <kuba@kernel.org>
To:     Tobias Klauser <tklauser@distanz.ch>
Cc:     Jiri Pirko <jiri@nvidia.com>, Moshe Shemesh <moshe@mellanox.com>,
        netdev@vger.kernel.org
Subject: Re: [PATCH] devlink: use _BITUL() macro instead of BIT() in the
 UAPI header
Message-ID: <20201214162937.0106e2ee@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201214112157.4841-1-tklauser@distanz.ch>
References: <20201214112157.4841-1-tklauser@distanz.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 14 Dec 2020 12:21:57 +0100 Tobias Klauser wrote:
> The BIT() macro is not available for the UAPI headers. Moreover, it can
> be defined differently in user space headers. Thus, replace its usage
> with the _BITUL() macro which is already used in other macro definitions
> in <linux/devlink.h>.
> 
> Fixes: dc64cc7c6310 ("devlink: Add devlink reload limit option")
> Signed-off-by: Tobias Klauser <tklauser@distanz.ch>

Thanks for the patch. It doesn't apply any longer, please respin on top
of:

https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git/

Thanks!
