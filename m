Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A542634C93
	for <lists+netdev@lfdr.de>; Tue,  4 Jun 2019 17:48:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728142AbfFDPsl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jun 2019 11:48:41 -0400
Received: from mga06.intel.com ([134.134.136.31]:3087 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728041AbfFDPsl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 4 Jun 2019 11:48:41 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 04 Jun 2019 08:48:40 -0700
X-ExtLoop1: 1
Received: from unknown (HELO localhost) ([10.241.225.31])
  by fmsmga006.fm.intel.com with ESMTP; 04 Jun 2019 08:48:40 -0700
Date:   Tue, 4 Jun 2019 08:48:39 -0700
From:   Jesse Brandeburg <jesse.brandeburg@intel.com>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Realtek linux nic maintainers <nic_swsd@realtek.com>,
        David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        jesse.brandeburg@intel.com
Subject: Re: [PATCH net-next 1/2] r8169: rename r8169.c to r8169_main.c
Message-ID: <20190604084839.00004eac@intel.com>
In-Reply-To: <f2432f11-b305-656a-36d8-bdcee6a7960b@gmail.com>
References: <3e2e0491-8b0f-17e1-b163-e47fcb931eb5@gmail.com>
        <f2432f11-b305-656a-36d8-bdcee6a7960b@gmail.com>
X-Mailer: Claws Mail 3.14.0 (GTK+ 2.24.30; i686-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 4 Jun 2019 07:45:47 +0200 Heiner wrote:
> In preparation of factoring out firmware handling rename r8169.c to
> r8169_main.c.
> 
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>

Reviewed-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
