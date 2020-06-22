Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6ADC220438D
	for <lists+netdev@lfdr.de>; Tue, 23 Jun 2020 00:27:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730945AbgFVW1H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jun 2020 18:27:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:56378 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730888AbgFVW1H (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Jun 2020 18:27:07 -0400
Received: from kicinski-fedora-PC1C0HJN (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A2E682075A;
        Mon, 22 Jun 2020 22:27:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592864826;
        bh=Obm8tCLN/BRC3BiBZneez/w3ATzBSHs7uPmVcz50cp4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=CdqJJFlE83sNM2GZlBPsQ/2ckTVhCEu8hRBYTHi8sYGRgfb2JqpUySFyB3UB8NuTM
         VxPTlN7zUYFsetqWnpcEPRq9nAKM6NegHhJ/KnsySjj0GkiVEeWujg38v5mAVDe8T0
         ulAyCe4AiAQ6knPzhJGh6pOYo0M+pCichFBrcrcA=
Date:   Mon, 22 Jun 2020 15:27:04 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next 0/7] r8169: mark device as detached in PCI D3
 and improve locking
Message-ID: <20200622152704.429c5d19@kicinski-fedora-PC1C0HJN>
In-Reply-To: <2e68df85-4f64-d45b-3c4c-bb8cb9a4411d@gmail.com>
References: <2e68df85-4f64-d45b-3c4c-bb8cb9a4411d@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 20 Jun 2020 22:33:39 +0200 Heiner Kallweit wrote:
> Mark the netdevice as detached whenever parent is in PCI D3hot and not
> accessible. This mainly applies to runtime-suspend state.
> In addition take RTNL lock in suspend calls, this allows to remove
> the driver-specific mutex and improve PM callbacks in general.

Not an expert on PM but looks like a nice improvement to me:

Reviewed-by: Jakub Kicinski <kuba@kernel.org>
