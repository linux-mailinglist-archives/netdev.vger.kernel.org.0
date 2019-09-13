Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1BC3DB216C
	for <lists+netdev@lfdr.de>; Fri, 13 Sep 2019 15:55:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391717AbfIMNvH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Sep 2019 09:51:07 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:44132 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388813AbfIMNvH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Sep 2019 09:51:07 -0400
Received: from localhost (93-63-141-166.ip28.fastwebnet.it [93.63.141.166])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 1D7F314C64018;
        Fri, 13 Sep 2019 06:51:04 -0700 (PDT)
Date:   Fri, 13 Sep 2019 14:51:03 +0100 (WEST)
Message-Id: <20190913.145103.1810916177357272729.davem@davemloft.net>
To:     jeffrey.t.kirsher@intel.com
Cc:     netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com
Subject: Re: [net-next 0/6][pull request] 100GbE Intel Wired LAN Driver
 Updates 2019-09-12
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190912205002.12159-1-jeffrey.t.kirsher@intel.com>
References: <20190912205002.12159-1-jeffrey.t.kirsher@intel.com>
X-Mailer: Mew version 6.8 on Emacs 26.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 13 Sep 2019 06:51:06 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Date: Thu, 12 Sep 2019 13:49:56 -0700

> This series contains updates to ice driver to implement and support
> loading a Dynamic Device Personalization (DDP) package from lib/firmware
> onto the device.
> 
> Paul updates the way the driver version is stored in the driver so that
> we can pass the driver version to the firmware.  Passing of the driver
> version to the firmware is needed for the DDP package to ensure we have
> the appropriate support in the driver for the features in the package.
> 
> Lukasz fixes how the firmware version is stored to align with how the
> firmware stores its own version.  Also extended the log message to
> display additional useful information such as NVM version, API patch
> information and firmware build hash.
> 
> Tony adds the needed driver support to check, load and store the DDP
> package.  Also add support for the ability to load DDP packages intended
> for specific hardware devices, as well as what to do when loading of the
> DDP package fails to load.
> 
> The following are changes since commit 172ca8308b0517ca2522a8c885755fd5c20294e7:
>   cxgb4: Fix spelling typos
> and are available in the git repository at:
>   git://git.kernel.org/pub/scm/linux/kernel/git/jkirsher/next-queue 100GbE

Pulled, thanks Jeff.
