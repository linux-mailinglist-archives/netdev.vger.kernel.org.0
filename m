Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9EEC72B123E
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 23:55:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726348AbgKLWzX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 17:55:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:50410 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725971AbgKLWzX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 12 Nov 2020 17:55:23 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 52C422085B;
        Thu, 12 Nov 2020 22:55:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605221722;
        bh=TuNbC2A6rWFosN//6t+OI+I4OjlX5wmpO0dQUYP7a/0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=JagG0SyT8xyfIfF8/vgIygjzKmW9u2GdtqdwtKmfHjsTbBL+myuwMBWEDkQEfsiuw
         4eoGWVDCTvy59LjfguCs4DBSRGGSd/8+wCm5tylPsJmd77CylAiQHnJjq2XfgqJsDz
         TNBAHCUIxVMqOJSw3PLkq0jvMwTgxcsit7kDXFRc=
Date:   Thu, 12 Nov 2020 14:55:20 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Thierry Reding <thierry.reding@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jon Hunter <jonathanh@nvidia.com>
Subject: Re: [PATCH net/next] net: ipconfig: Avoid spurious blank lines in
 boot log
Message-ID: <20201112145520.45f13da3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201110073757.1284594-1-thierry.reding@gmail.com>
References: <20201110073757.1284594-1-thierry.reding@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 10 Nov 2020 08:37:57 +0100 Thierry Reding wrote:
> From: Thierry Reding <treding@nvidia.com>
> 
> When dumping the name and NTP servers advertised by DHCP, a blank line
> is emitted if either of the lists is empty. This can lead to confusing
> issues such as the blank line getting flagged as warning. This happens
> because the blank line is the result of pr_cont("\n") and that may see
> its level corrupted by some other driver concurrently writing to the
> console.
> 
> Fix this by making sure that the terminating newline is only emitted
> if at least one entry in the lists was printed before.
> 
> Reported-by: Jon Hunter <jonathanh@nvidia.com>
> Signed-off-by: Thierry Reding <treding@nvidia.com>

Applied, thanks!
