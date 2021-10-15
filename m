Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37AD942E6C1
	for <lists+netdev@lfdr.de>; Fri, 15 Oct 2021 04:45:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232214AbhJOCrP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Oct 2021 22:47:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:38688 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229819AbhJOCrO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 14 Oct 2021 22:47:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 09508610D1;
        Fri, 15 Oct 2021 02:45:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634265909;
        bh=r0SCEkNfeD0gKPvU/WzZBF+R+X3+1dmYu9MVDSK/7II=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=cw8fKKxpjOkwBEjVn0oxSd8Od+9GldougJJHva7Q3POwLjZ915+8JjRdnX/x9NgiD
         AzUESG8pihJWc2QwCmQp80f2x7OPDnYu9UzjnnRZi+tzP/tPisyReDQK1MzgGlnYoX
         j3TlA40GISTn0yEVgySmLF92GJ+eeDatQxOE4PRNO8Y9hWUWDGNXblzVnuTVOofyE2
         d0RMo3JSAeLNCXrGkLc8PeL70uZBbzNzcFGOxB0HVMJziCwEeKL+nrcA/wwPkxsPcR
         SDnQujnJ+6fce+GW58CVFQsRqJAOI5cPki3+BNalDN6jPyZ3cimNJWbYvdLb4d080Z
         PGxWKxrDUWSHg==
Date:   Thu, 14 Oct 2021 19:45:07 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     <yuiko.oshino@microchip.com>
Cc:     <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <UNGLinuxDriver@microchip.com>
Subject: Re: [PATCH net-next] net: microchip: lan743x: add support for PTP
 pulse width (duty cycle)
Message-ID: <20211014194504.199c198b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1634046593-64312-1-git-send-email-yuiko.oshino@microchip.com>
References: <1634046593-64312-1-git-send-email-yuiko.oshino@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 12 Oct 2021 09:49:53 -0400 yuiko.oshino@microchip.com wrote:
> From: Yuiko Oshino <yuiko.oshino@microchip.com>
> 
> If the PTP_PEROUT_DUTY_CYCLE flag is set, then check if the
> request_on value in ptp_perout_request matches the pre-defined
> values or a toggle option.
> Return a failure if the value is not supported.
> 
> Preserve the old behaviors if the PTP_PEROUT_DUTY_CYCLE flag is not
> set.
> 
> Tested with an oscilloscope on EVB-LAN7430:
> e.g., to output PPS 1sec period 500mS on (high) to GPIO 2.
>  ./testptp -L 2,2
>  ./testptp -p 1000000000 -w 500000000
> 
> Signed-off-by: Yuiko Oshino <yuiko.oshino@microchip.com>

Applied, thanks.
