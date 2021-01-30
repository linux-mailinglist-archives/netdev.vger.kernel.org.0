Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98784309322
	for <lists+netdev@lfdr.de>; Sat, 30 Jan 2021 10:19:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231363AbhA3JSF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 Jan 2021 04:18:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:37480 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233602AbhA3EOd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 29 Jan 2021 23:14:33 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C576864E10;
        Sat, 30 Jan 2021 03:50:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611978610;
        bh=gyBYZCIQ6GpWAMI5dfXJpRmMlyhJfGJ/U9LQuJPledU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=LUoFtNYNkj0wuXz1YBnHl0llu6UxthCzqqiYEH99Fhl0AUG3nRtkY9SJuEzZyY25c
         inshsnxXHQZFiZHWHeHPHpwrTAeOvzCserJU/ty/OaTvlFtEQxz7KIbKDWLhCqTU0j
         MO4lCummdILrxS3WHETlC0m/j0tYvPsfjPF0vIEhStXJajvzDaMLIxXBrjMlsNigpi
         VSDO7DiKIJTfd96xSIybpdMZhXNu1gVfxuj5XAU75Pl7bycOpx2z+vFBUPYKNak0rY
         0XFek2aktgWu5iEms+MuxZ30x8FIDK3jSY4F817QwNgOxcSeUdGhH49DzjBVSSIJ7s
         UyHfSdhUpOdKA==
Date:   Fri, 29 Jan 2021 19:50:08 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        linux-can@vger.kernel.org, kernel@pengutronix.de
Subject: Re: pull-request: can-next 2021-01-29
Message-ID: <20210129195008.66f980f7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210129084302.3040284-1-mkl@pengutronix.de>
References: <20210129084302.3040284-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 29 Jan 2021 09:42:54 +0100 Marc Kleine-Budde wrote:
> Hello Jakub, hello David,
> 
> this is a pull request of 8 patches for net-next/master.
> 
> All patches are by me and target the mcp251xfd driver. The first 4
> patches update the information regarding the "85% of (FSYSCLK/2)"
> errata. The other 4 are misc cleanups, unitfy error messages, add
> missing postfix to a macro, simplify the return of a function, and
> make use of dev_err_probe() in the mcp251xfd_probe() function.

Pulled, thanks!
