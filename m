Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 608032ED73A
	for <lists+netdev@lfdr.de>; Thu,  7 Jan 2021 20:08:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729346AbhAGTHv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jan 2021 14:07:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:41778 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727453AbhAGTHv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 Jan 2021 14:07:51 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E7A3423441;
        Thu,  7 Jan 2021 19:07:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610046431;
        bh=34tTqDstxGrqOnfLbPZFlyGkFwjXYT2wN4M31yVbb1Y=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=bx09jY9HNxQmkkMPY7PfHlhapox4o/tC6UAEQeAmory6x8kPLG+YhWR+AEqCoeLWG
         Hng3mZMUAtGZf2bSQkDB58i0HoMME3g/ENOil22BjufCARhNLQ8Z0/1trNtTgHdd2a
         2IFp64RX0j6EO6PKyoCeNi3fmbEci+YGPw4OEImC++uTOKTtwwplGJE3+HTys/LwLy
         6VHZTSDz//Gfw7YMXTnUGk9Xdk9wZq9VFCSES6AHJaSCKQgcW3UhlgpJdlRiNFBBEF
         G2PvLfXA3kwLCpN+FnWyp4hEWo/1uSyGiFRug+m17RtuJBRrq3zBHblHdgyhuOLwq/
         IJPZB6s79qcmw==
Date:   Thu, 7 Jan 2021 11:07:10 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        linux-can@vger.kernel.org, kernel@pengutronix.de
Subject: Re: pull-request: can-next 2021-01-06
Message-ID: <20210107110710.0ea1b12b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210107094900.173046-1-mkl@pengutronix.de>
References: <20210107094900.173046-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu,  7 Jan 2021 10:48:41 +0100 Marc Kleine-Budde wrote:
> Hello Jakub, hello David,
> 
> this is a pull request of 19 patches for net-next/master.
> 
> The first 16 patches are by me and target the tcan4x5x SPI glue driver for the
> m_can CAN driver. First there are a several cleanup commits, then the SPI
> regmap part is converted to 8 bits per word, to make it possible to use that
> driver on SPI controllers that only support the 8 bit per word mode (such as
> the SPI cores on the raspberry pi).
> 
> Oliver Hartkopp contributes a patch for the CAN_RAW protocol. The getsockopt()
> for CAN_RAW_FILTER is changed to return -ERANGE if the filterset does not fit
> into the provided user space buffer.
> 
> The last two patches are by Joakim Zhang and add wakeup support to the flexcan
> driver for the i.MX8QM SoC. The dt-bindings docs are extended to describe the
> added property.

Pulled, thanks!
