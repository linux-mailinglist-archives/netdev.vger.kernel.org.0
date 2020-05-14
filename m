Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D05A21D4062
	for <lists+netdev@lfdr.de>; Thu, 14 May 2020 23:53:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726948AbgENVwV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 May 2020 17:52:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:57882 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726216AbgENVwV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 14 May 2020 17:52:21 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 898622065C;
        Thu, 14 May 2020 21:52:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589493140;
        bh=BF2s47TmPp+dEqnQi/De6TyjgFyfyJeuGqSQJx18+dM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=akYRV8zq/yIdMjYAiTtXxJ6FvV+VqOBGHQ5+MKD2gB8yppk7wUAy7vmNhkOlCDhOQ
         Or7GhsVQN5uOqzQXhV+NfJ01N5+2PgEaxy5TMLgApgn6BdUzKEfifk9rZjnDmgE7/z
         95SvbPm8VerMyLpa6LCG2ld3lzSbqi/EQd+9smz8=
Date:   Thu, 14 May 2020 14:52:19 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Cc:     davem@davemloft.net, Vitaly Lifshits <vitaly.lifshits@intel.com>,
        netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        kbuild test robot <lkp@intel.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Aaron Brown <aaron.f.brown@intel.com>
Subject: Re: [net-next v2 3/9] igc: add support to eeprom, registers and
 link self-tests
Message-ID: <20200514145219.58484d4b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200514213117.4099065-4-jeffrey.t.kirsher@intel.com>
References: <20200514213117.4099065-1-jeffrey.t.kirsher@intel.com>
        <20200514213117.4099065-4-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 14 May 2020 14:31:11 -0700 Jeff Kirsher wrote:
> diff --git a/drivers/net/ethernet/intel/igc/igc_diag.c b/drivers/net/ethernet/intel/igc/igc_diag.c
> new file mode 100644
> index 000000000000..1c4536105e56
> --- /dev/null
> +++ b/drivers/net/ethernet/intel/igc/igc_diag.c
> @@ -0,0 +1,186 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/* Copyright (c)  2020 Intel Corporation */
> +
> +#include "igc.h"
> +#include "igc_diag.h"
> +
> +struct igc_reg_test reg_test[] = {
> +	{ IGC_FCAL,	1,	PATTERN_TEST,	0xFFFFFFFF,	0xFFFFFFFF },
> +	{ IGC_FCAH,	1,	PATTERN_TEST,	0x0000FFFF,	0xFFFFFFFF },
> +	{ IGC_FCT,	1,	PATTERN_TEST,	0x0000FFFF,	0xFFFFFFFF },
> +	{ IGC_RDBAH(0), 4,	PATTERN_TEST,	0xFFFFFFFF,	0xFFFFFFFF },

drivers/net/ethernet/intel/igc/igc_diag.c:7:21: warning: symbol 'reg_test' was not declared. Should it be static?
