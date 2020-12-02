Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 128592CC750
	for <lists+netdev@lfdr.de>; Wed,  2 Dec 2020 21:01:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731178AbgLBUAS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Dec 2020 15:00:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:57708 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726082AbgLBUAS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 2 Dec 2020 15:00:18 -0500
Date:   Wed, 2 Dec 2020 11:59:35 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1606939177;
        bh=hKKHmmiGqm9ELuo9236p13tJm7Or7hfnIr2YHNhBD0A=;
        h=From:To:Cc:Subject:In-Reply-To:References:From;
        b=pWPqLZvh+bIGIDSyauDMpL0mEviesjG+si6GOzyYJ5OYLr/kexYUSWyTYmMHUflQN
         C7vqy/43p9OC450AQNNkj6DrJTd5vnFq25xBlfeSWAUzHjZVkwewT3mN7epQQqCX7N
         nqPaWVFJXmVxhE90w9hnhgTLYiv4GHHVXrsHmxV6VuZDWPRCb3GcmAcfb3SYCbHMFj
         Q0DSHWQKjmVbYKEK2P1hhk+mb8kd1lyrw1/i0aKUo14v5O8YPGpnixs0d0I6iRRbXI
         Ar233axVm+9epxtaPDTUwGMGRdwAYgGTQ/8zGXz4g0qx0j2oi3t1mSSVu5Gx0DNAEw
         e/oHUfZlhlibw==
From:   Jakub Kicinski <kuba@kernel.org>
To:     Schrempf Frieder <frieder.schrempf@kontron.de>
Cc:     Andy Shevchenko <andy.shevchenko@gmail.com>,
        Charles Gorand <charles.gorand@effinnov.com>,
        "David S. Miller" <davem@davemloft.net>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-nfc@lists.01.org, netdev@vger.kernel.org,
        Stephan Gerhold <stephan@gerhold.net>
Subject: Re: [PATCH v3] NFC: nxp-nci: Make firmware GPIO pin optional
Message-ID: <20201202115935.335788bc@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
In-Reply-To: <20201201113921.6572-1-frieder.schrempf@kontron.de>
References: <20201201113921.6572-1-frieder.schrempf@kontron.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue,  1 Dec 2020 12:39:09 +0100 Schrempf Frieder wrote:
> From: Frieder Schrempf <frieder.schrempf@kontron.de>
> 
> There are other NXP NCI compatible NFC controllers such as the PN7150
> that use an integrated firmware and therefore do not have a GPIO to
> select firmware downloading mode. To support this kind of controller,
> let's make the firmware GPIO optional.
> 
> Signed-off-by: Frieder Schrempf <frieder.schrempf@kontron.de>
> Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>

Applied, thanks!
