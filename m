Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 52A0F33BEB
	for <lists+netdev@lfdr.de>; Tue,  4 Jun 2019 01:27:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726538AbfFCX1r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jun 2019 19:27:47 -0400
Received: from mga04.intel.com ([192.55.52.120]:11876 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726179AbfFCX1q (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 3 Jun 2019 19:27:46 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 03 Jun 2019 16:27:46 -0700
X-ExtLoop1: 1
Received: from jbrandeb-mobl2.amr.corp.intel.com (HELO localhost) ([10.254.84.131])
  by fmsmga007.fm.intel.com with ESMTP; 03 Jun 2019 16:27:46 -0700
Date:   Mon, 3 Jun 2019 16:27:45 -0700
From:   Jesse Brandeburg <jesse.brandeburg@intel.com>
To:     Robert Hancock <hancock@sedsystems.ca>
Cc:     <netdev@vger.kernel.org>, jesse.brandeburg@intel.com
Subject: Re: [PATCH net-next v2] net: phy: xilinx: add Xilinx PHY driver
Message-ID: <20190603162745.00007313@intel.com>
In-Reply-To: <1559603524-18288-1-git-send-email-hancock@sedsystems.ca>
References: <1559603524-18288-1-git-send-email-hancock@sedsystems.ca>
X-Mailer: Claws Mail 3.12.0 (GTK+ 2.24.28; i686-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 3 Jun 2019 17:12:04 -0600
Robert Hancock <hancock@sedsystems.ca> wrote:

> This adds a driver for the PHY device implemented in the Xilinx PCS/PMA
> Core logic. This is mostly a generic gigabit PHY, except that the
> features are explicitly set because the PHY wrongly indicates it has no
> extended status register when it actually does.
> 
> This version is a simplified version of the GPL 2+ version from the
> Xilinx kernel tree.
> 
> Signed-off-by: Robert Hancock <hancock@sedsystems.ca>
> ---
> 
> Differences from v1:
> -Removed unnecessary config_init method
> -Added comment to explain why features are explicitly set
> 
>  drivers/net/phy/Kconfig  |  6 ++++++
>  drivers/net/phy/Makefile |  1 +
>  drivers/net/phy/xilinx.c | 51 ++++++++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 58 insertions(+)
>  create mode 100644 drivers/net/phy/xilinx.c
> 

Seems fine.

Reviewed-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
