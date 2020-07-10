Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E382021BED7
	for <lists+netdev@lfdr.de>; Fri, 10 Jul 2020 22:58:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727952AbgGJU6q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jul 2020 16:58:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:58896 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726832AbgGJU6q (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 10 Jul 2020 16:58:46 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C9EE72068F;
        Fri, 10 Jul 2020 20:58:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594414726;
        bh=DkEEYZd7x1DcGSpdD+Xf3QuaQibE3kKCCy2A4ydlWow=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=rejKsv4Nvwk9+NBkBAPS+Y6AIrBecUvHBSMnBroAzP4DsG8vL6RuAC1tnK62W86/A
         0lSaFllPnc9Fc0HqGiib4V8Qji4KC/r+VSXyfuM6JmG8TgD5aKiFxEYTpAzFxuIm1t
         uW9Q94WE1iquh5xkk5g4lZs4aZs1gpnxJNNJ7qXE=
Date:   Fri, 10 Jul 2020 13:58:44 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     <min.li.xe@renesas.com>
Cc:     <richardcochran@gmail.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next] ptp: add debugfs support for IDT family of
 timing devices
Message-ID: <20200710135844.58d76d44@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1594395685-25199-1-git-send-email-min.li.xe@renesas.com>
References: <1594395685-25199-1-git-send-email-min.li.xe@renesas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 10 Jul 2020 11:41:25 -0400 min.li.xe@renesas.com wrote:
> From: Min Li <min.li.xe@renesas.com>
> 
> This patch is to add debugfs support for ptp_clockmatrix and ptp_idt82p33.
> It will create a debugfs directory called idtptp{x} and x is the ptp index.
> Three inerfaces are present, which are cmd, help and regs. help is read
> only and will display a brief help message. regs is read only amd will show
> all register values. cmd is write only and will accept certain commands.
> Currently, the accepted commands are combomode to set comobo mode and write
> to write up to 4 registers.
> 
> Signed-off-by: Min Li <min.li.xe@renesas.com>

No private configuration interfaces in debugfs, please.

If what you're exposing is a useful feature it deserves a proper 
uAPI interface.
