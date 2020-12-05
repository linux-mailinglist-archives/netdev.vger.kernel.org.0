Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09EC42CF936
	for <lists+netdev@lfdr.de>; Sat,  5 Dec 2020 04:45:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726880AbgLEDpR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Dec 2020 22:45:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:40652 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725300AbgLEDpR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 4 Dec 2020 22:45:17 -0500
Date:   Fri, 4 Dec 2020 19:44:35 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607139877;
        bh=DedLMCvUUNoNA8KM948vSidKtSEDZGqQQyINU7/n3WQ=;
        h=From:To:Cc:Subject:In-Reply-To:References:From;
        b=n1d/CegJidq7wdRVGjJRC2XNBkXnKdUlaOA/iDk1G03ARpQorizmjttSeKU74MPMj
         DKnSaqnOo3tlDkMIVW3kCIGhIVaM0k1oOanCUEYPRemIYmRJR0D0fdnkZPGwm4996v
         4Erz00v1IuJKt92PYNzU61FCui72ZdYEZtKbv99e0LI1dtSKkhkvwprbzDjCtXMaBm
         mMu3WN+hAEKbLDyJxnWDg5CkigObHulBzFQTjhd//SLBeOEgjHp9oi0uGhkIal20mH
         2ASy/8lEmnmH7fTzwJ3lD2wf01O6DdZTJWGemem78OQ8zrQRPFPifFiGbZkD0KX4+F
         tgCxyq9c4HF9g==
From:   Jakub Kicinski <kuba@kernel.org>
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        linux-can@vger.kernel.org, kernel@pengutronix.de,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Thomas Wagner <thwa1@web.de>
Subject: Re: [net 3/3] can: isotp: add SF_BROADCAST support for functional
 addressing
Message-ID: <20201204194435.0d4ab3fd@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
In-Reply-To: <20201204133508.742120-4-mkl@pengutronix.de>
References: <20201204133508.742120-1-mkl@pengutronix.de>
        <20201204133508.742120-4-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri,  4 Dec 2020 14:35:08 +0100 Marc Kleine-Budde wrote:
> From: Oliver Hartkopp <socketcan@hartkopp.net>
> 
> When CAN_ISOTP_SF_BROADCAST is set in the CAN_ISOTP_OPTS flags the CAN_ISOTP
> socket is switched into functional addressing mode, where only single frame
> (SF) protocol data units can be send on the specified CAN interface and the
> given tp.tx_id after bind().
> 
> In opposite to normal and extended addressing this socket does not register a
> CAN-ID for reception which would be needed for a 1-to-1 ISOTP connection with a
> segmented bi-directional data transfer.
> 
> Sending SFs on this socket is therefore a TX-only 'broadcast' operation.

Unclear from this patch what is getting fixed. Looks a little bit like
a feature which could be added in a backward compatible way, no?
Is it only added for completeness of the ISOTP implementation?
