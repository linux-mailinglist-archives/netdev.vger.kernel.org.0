Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A77BF1499D9
	for <lists+netdev@lfdr.de>; Sun, 26 Jan 2020 10:46:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726518AbgAZJqP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Jan 2020 04:46:15 -0500
Received: from mx4.wp.pl ([212.77.101.12]:25026 "EHLO mx4.wp.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727754AbgAZJqO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 26 Jan 2020 04:46:14 -0500
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Sun, 26 Jan 2020 04:46:13 EST
Received: (wp-smtpd smtp.wp.pl 1467 invoked from network); 26 Jan 2020 10:39:33 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wp.pl; s=1024a;
          t=1580031573; bh=8l1rmL5X5Cv0Cj5XiywukSTYoIUEeUjYPldXFydWbC0=;
          h=From:To:Cc:Subject;
          b=nOuavmRoSp5RRbeyZdERhjGL6lBZfuXp1C1VmIyHyeBce9sOakGtCD5JYmxMVHj4p
           jvLiTTi+ttVtC62AHQY30tVHldAx8qkFpPY4H4fzMzBBtG7g8PBn5G/1x8ilpdGDLi
           on5uDFfGmaLAJd15pl1s+7iBsuBqrtzBsV+ikYR4=
Received: from host-178.215.207.168-internet.zabrze.debacom.pl (HELO localhost) (stf_xl@wp.pl@[178.215.207.168])
          (envelope-sender <stf_xl@wp.pl>)
          by smtp.wp.pl (WP-SMTPD) with ECDHE-RSA-AES256-GCM-SHA384 encrypted SMTP
          for <colin.king@canonical.com>; 26 Jan 2020 10:39:33 +0100
Date:   Sun, 26 Jan 2020 10:39:32 +0100
From:   Stanislaw Gruszka <stf_xl@wp.pl>
To:     Colin King <colin.king@canonical.com>
Cc:     Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        Meenakshi Venkataraman <meenakshi.venkataraman@intel.com>,
        Wey-Yi Guy <wey-yi.w.guy@intel.com>,
        Johannes Berg <johannes.berg@intel.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH][next] iwlegacy: ensure loop counter addr does not wrap
 and cause an infinite loop
Message-ID: <20200126093932.GA605118@wp.pl>
References: <20200126000954.22807-1-colin.king@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200126000954.22807-1-colin.king@canonical.com>
X-WP-MailID: 5300318e69b08c0e5e0d2f8643f46dc7
X-WP-AV: skaner antywirusowy Poczty Wirtualnej Polski
X-WP-SPAM: NO 0000000 [oROH]                               
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jan 26, 2020 at 12:09:54AM +0000, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> The loop counter addr is a u16 where as the upper limit of the loop
> is a an int. In the unlikely event that the il->cfg->eeprom_size is
> greater than 64K then we end up with an infinite loop since addr will
> wrap around an never reach upper loop limit. Fix this by making addr
> an int.
> 
> Addresses-Coverity: ("Infinite loop")
> Fixes: be663ab67077 ("iwlwifi: split the drivers for agn and legacy devices 3945/4965")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>

Acked-by: Stanislaw Gruszka <stf_xl@wp.pl>
