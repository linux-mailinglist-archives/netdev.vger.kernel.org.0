Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B30D2CE4B4
	for <lists+netdev@lfdr.de>; Fri,  4 Dec 2020 02:07:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728441AbgLDBHK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Dec 2020 20:07:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:52564 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728005AbgLDBHK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Dec 2020 20:07:10 -0500
Date:   Thu, 3 Dec 2020 17:06:28 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607043989;
        bh=+SyN7x2DNaQbOsGqnbSUpwi8VIsKLoeEg6noIVJhwLw=;
        h=From:To:Cc:Subject:In-Reply-To:References:From;
        b=UlPZxkX0YrVNrSNVZR34GeVPYSZH58pb2Aq51ehunuuDSTbZpF3Y9TVrnlXhcPB0P
         ICgaMeaVuEfgCSNaq5T0TuNpJLuMrbsPUGtMesrHfmRfrZWklfOHPuUV4SFDlNX79c
         mmCHtTKGQDhutdAWmdrw4u+N5LPlMe1Y2Qzk64wVBxULdTloZatww5bdxq9DxQgEs3
         AF1zW4/Rk9IctbICk/6WrSYiip8BMRMb0UeoA6siitr9iRcDo+Xcm2qNwSvIw5swZJ
         0P7lob2u8QdCZbbdQvH2cqnEkFxR3JwcNGUUhr0rVktT4o2VdmQwk7QcNO6FIOjWI0
         kl8A373fbyqYQ==
From:   Jakub Kicinski <kuba@kernel.org>
To:     <min.li.xe@renesas.com>
Cc:     <richardcochran@gmail.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next 1/4] ptp: clockmatrix: reset device and check
 BOOT_STATUS
Message-ID: <20201203170628.003d92e2@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
In-Reply-To: <1607008819-29158-1-git-send-email-min.li.xe@renesas.com>
References: <1607008819-29158-1-git-send-email-min.li.xe@renesas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 3 Dec 2020 10:20:16 -0500 min.li.xe@renesas.com wrote:
> From: Min Li <min.li.xe@renesas.com>
> 
> SM_RESET device only when loading full configuration and check
> for BOOT_STATUS. Also remove polling for write trigger done in
> _idtcm_settime().
> 
> Signed-off-by: Min Li <min.li.xe@renesas.com>

Please fix the checkpatch warnings:

CHECK: Unnecessary parentheses around 'regaddr < GPIO_USER_CONTROL'
#62: FILE: drivers/ptp/ptp_clockmatrix.c:60:
+		if ((regaddr < GPIO_USER_CONTROL)
+		    || (regaddr >= SCRATCH))

CHECK: Unnecessary parentheses around 'regaddr >= SCRATCH'
#62: FILE: drivers/ptp/ptp_clockmatrix.c:60:
+		if ((regaddr < GPIO_USER_CONTROL)
+		    || (regaddr >= SCRATCH))

CHECK: Logical continuations should be on the previous line
#63: FILE: drivers/ptp/ptp_clockmatrix.c:61:
+		if ((regaddr < GPIO_USER_CONTROL)
+		    || (regaddr >= SCRATCH))

CHECK: Unnecessary parentheses around 'loaddr > 0x7b'
#67: FILE: drivers/ptp/ptp_clockmatrix.c:65:
+		if (((loaddr > 0x7b) && (loaddr <= 0x7f))
+		     || loaddr > 0xfb)

CHECK: Unnecessary parentheses around 'loaddr <= 0x7f'
#67: FILE: drivers/ptp/ptp_clockmatrix.c:65:
+		if (((loaddr > 0x7b) && (loaddr <= 0x7f))
+		     || loaddr > 0xfb)

CHECK: Logical continuations should be on the previous line
#68: FILE: drivers/ptp/ptp_clockmatrix.c:66:
+		if (((loaddr > 0x7b) && (loaddr <= 0x7f))
+		     || loaddr > 0xfb)
