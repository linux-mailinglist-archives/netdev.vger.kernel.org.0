Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1EE2A309187
	for <lists+netdev@lfdr.de>; Sat, 30 Jan 2021 03:38:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233281AbhA3C3K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jan 2021 21:29:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:58844 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233232AbhA3CWB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 29 Jan 2021 21:22:01 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8FA9364DF5;
        Sat, 30 Jan 2021 02:21:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611973269;
        bh=A7yM5wrxt1RAwhY3kIW8bR9uIzKE192CVehCTCqlOpk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=J4CIR0Ren2BifQAujWsOnf1KVrR2F+l3CBdAlCB6ydjFl6nyHaYheKsj4Tyxmuqvh
         CSgACrr2tQC8I+gSmllrBZwC+WKUnnrw1qAUB5q8/VktQrvhfnvaqyy/D+FPNmnd4n
         cAhlBHkDR3b111HtOVIEQrxwod3Xq7Yv4Kzdis9WoYfWwCw9cLxj7njq2TAs6Yt/NA
         qfPy67nCu3HXW6WPnazxZl24tkX4u51mfJk8CS0Qnk5w9mggzXDDT/SJDkVC5iqVJp
         jQRF0QilGS5JeTmkHQAD4vEBLg+nvMmd5Vs0wP4oiDnNAd9WS2jVyN/8GPMxqu6Qa5
         GsK9gRdMR//5w==
Date:   Fri, 29 Jan 2021 18:21:08 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Loic Poulain <loic.poulain@linaro.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, carl.yin@quectel.com,
        Dan Williams <dcbw@redhat.com>,
        =?UTF-8?B?QmrDuHJu?= Mork <bjorn@mork.no>
Subject: Re: [PATCH net-next 3/3] net: mhi: Add mbim proto
Message-ID: <20210129182108.771dc2fe@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1611766877-16787-3-git-send-email-loic.poulain@linaro.org>
References: <1611766877-16787-1-git-send-email-loic.poulain@linaro.org>
        <1611766877-16787-3-git-send-email-loic.poulain@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 27 Jan 2021 18:01:17 +0100 Loic Poulain wrote:
> MBIM has initially been specified by USB-IF for transporting data (IP)
> between a modem and a host over USB. However some modern modems also
> support MBIM over PCIe (via MHI). In the same way as QMAP(rmnet), it
> allows to aggregate IP packets and to perform context multiplexing.
> 
> This change adds minimal MBIM support to MHI, allowing to support MBIM
> only modems. MBIM being based on USB NCM, it reuses some helpers from
> the USB stack, but the cdc-mbim driver is too USB coupled to be reused.
> 
> At some point it would be interesting to move on a factorized solution,
> having a generic MBIM network lib or dedicated MBIM netlink virtual
> interface support.
> 
> This code has been highly inspired from the mhi_mbim downstream driver
> (Carl Yin <carl.yin@quectel.com>).
> 
> Signed-off-by: Loic Poulain <loic.poulain@linaro.org>

Does the existing MBIM over USB NCM also show up as a netdev?

Let's CC Dan and Bjorn on MBIM-related code, they may have opinions.

