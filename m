Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D58F2C7345
	for <lists+netdev@lfdr.de>; Sat, 28 Nov 2020 23:14:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389699AbgK1VuE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Nov 2020 16:50:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:52832 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387807AbgK1VdG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 28 Nov 2020 16:33:06 -0500
Received: from kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com (c-67-180-217-166.hsd1.ca.comcast.net [67.180.217.166])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2BF91207CD;
        Sat, 28 Nov 2020 21:32:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606599146;
        bh=BkLSihrZLEUXgtQYzSMm1VBUPSC8VraPuQNRfnbFyR4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=NGIwED6IV+SflyfKuFohf0tft/Mae58erzftgWLKtwJEt89cSNaxOfXhdmM4qlVYC
         mP6IPIC8V8z8z7gArWsu+yA9O4vtSNq6EzP1C3F4yzxknQpMx2DahRNvBsFgn+INjq
         7DQK6NFchFI44Rkz0MLSwF3Dui628du9w1Rpas+8=
Date:   Sat, 28 Nov 2020 13:32:25 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Dany Madden <drt@linux.ibm.com>
Cc:     netdev@vger.kernel.org, ljp@linux.ibm.com, sukadev@linux.ibm.com,
        linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH net v3 0/9] ibmvnic: assorted bug fixes
Message-ID: <20201128133225.6dff854f@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
In-Reply-To: <20201126000432.29897-1-drt@linux.ibm.com>
References: <20201126000432.29897-1-drt@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 25 Nov 2020 18:04:23 -0600 Dany Madden wrote:
> Assorted fixes for ibmvnic originated from "[PATCH net 00/15] ibmvnic:
> assorted bug fixes" sent by Lijun Pan.

Applied, thanks!
