Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CD6F4131DC1
	for <lists+netdev@lfdr.de>; Tue,  7 Jan 2020 03:45:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727405AbgAGCpD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jan 2020 21:45:03 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:57368 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727295AbgAGCpD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jan 2020 21:45:03 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 3CABC159ECA33;
        Mon,  6 Jan 2020 18:45:02 -0800 (PST)
Date:   Mon, 06 Jan 2020 18:45:01 -0800 (PST)
Message-Id: <20200106.184501.381242538052232318.davem@davemloft.net>
To:     jeffrey.t.kirsher@intel.com
Cc:     netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com
Subject: Re: [net-next 0/5][pull request] 1GbE Intel Wired LAN Driver
 Updates 2020-01-06
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200106231956.549255-1-jeffrey.t.kirsher@intel.com>
References: <20200106231956.549255-1-jeffrey.t.kirsher@intel.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 06 Jan 2020 18:45:02 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Date: Mon,  6 Jan 2020 15:19:51 -0800

> This series contains updates to igc to add basic support for
> timestamping.
> 
> Vinicius adds basic support for timestamping and enables ptp4l/phc2sys
> to work with i225 devices.  Initially, adds the ability to read and
> adjust the PHC clock.  Patches 2 & 3 enable and retrieve hardware
> timestamps.  Patch 4 implements the ethtool ioctl that ptp4l uses to
> check what timestamping methods are supported.  Lastly, added support to
> do timestamping using the "Start of Packet" signal from the PHY, which
> is now supported in i225 devices.
> 
> While i225 does support multiple PTP domains, with multiple timestamping
> registers, we currently only support one PTP domain and use only one of
> the timestamping registers for implementation purposes.
> 
> The following are changes since commit df2c2ba831a04083ad7485684896eeb090ca3c7d:
>   Merge branch 'Convert-Felix-DSA-switch-to-PHYLINK'
> and are available in the git repository at:
>   git://git.kernel.org/pub/scm/linux/kernel/git/jkirsher/next-queue 1GbE

Pulled, thanks Jeff.
