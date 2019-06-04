Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CDED234CA9
	for <lists+netdev@lfdr.de>; Tue,  4 Jun 2019 17:54:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728189AbfFDPyU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jun 2019 11:54:20 -0400
Received: from mga04.intel.com ([192.55.52.120]:45980 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727422AbfFDPyT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 4 Jun 2019 11:54:19 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 04 Jun 2019 08:54:19 -0700
X-ExtLoop1: 1
Received: from unknown (HELO localhost) ([10.241.225.31])
  by fmsmga006.fm.intel.com with ESMTP; 04 Jun 2019 08:54:18 -0700
Date:   Tue, 4 Jun 2019 08:54:18 -0700
From:   Jesse Brandeburg <jesse.brandeburg@intel.com>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Realtek linux nic maintainers <nic_swsd@realtek.com>,
        David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        jesse.brandeburg@intel.com
Subject: Re: [PATCH net-next 2/2] r8169: factor out firmware handling
Message-ID: <20190604085418.00002ee2@intel.com>
In-Reply-To: <80bdf40e-bfa9-dae4-2d30-29451e5b8e51@gmail.com>
References: <3e2e0491-8b0f-17e1-b163-e47fcb931eb5@gmail.com>
        <80bdf40e-bfa9-dae4-2d30-29451e5b8e51@gmail.com>
X-Mailer: Claws Mail 3.14.0 (GTK+ 2.24.30; i686-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 4 Jun 2019 07:46:44 +0200 Heiner wrote:
> Let's factor out firmware handling into a separate source code file.
> This simplifies reading the code and makes clearer what the interface
> between driver and firmware handling is.
> 
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>

Reviewed-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
