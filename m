Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 35C0747C39
	for <lists+netdev@lfdr.de>; Mon, 17 Jun 2019 10:25:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727323AbfFQIZp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jun 2019 04:25:45 -0400
Received: from mx2.suse.de ([195.135.220.15]:53646 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725791AbfFQIZp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 17 Jun 2019 04:25:45 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 6F77DABCD;
        Mon, 17 Jun 2019 08:25:43 +0000 (UTC)
From:   Andreas Schwab <schwab@suse.de>
To:     Yash Shah <yash.shah@sifive.com>
Cc:     davem@davemloft.net, devicetree@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-riscv@lists.infradead.org, robh+dt@kernel.org,
        mark.rutland@arm.com, nicolas.ferre@microchip.com,
        palmer@sifive.com, aou@eecs.berkeley.edu, paul.walmsley@sifive.com,
        ynezz@true.cz, sachin.ghadi@sifive.com
Subject: Re: [PATCH v2 0/2] Add macb support for SiFive FU540-C000
References: <1560745167-9866-1-git-send-email-yash.shah@sifive.com>
X-Yow:  RELAX!! ... This is gonna be a HEALING EXPERIENCE!!  Besides,
 I work for DING DONGS!
Date:   Mon, 17 Jun 2019 10:25:42 +0200
In-Reply-To: <1560745167-9866-1-git-send-email-yash.shah@sifive.com> (Yash
        Shah's message of "Mon, 17 Jun 2019 09:49:25 +0530")
Message-ID: <mvmtvco62k9.fsf@suse.de>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.2.90 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Jun 17 2019, Yash Shah <yash.shah@sifive.com> wrote:

> - Add "MACB_SIFIVE_FU540" in Kconfig to support SiFive FU540 in macb
>   driver. This is needed because on FU540, the macb driver depends on
>   SiFive GPIO driver.

This of course requires that the GPIO driver is upstreamed first.

Andreas.

-- 
Andreas Schwab, SUSE Labs, schwab@suse.de
GPG Key fingerprint = 0196 BAD8 1CE9 1970 F4BE  1748 E4D4 88E3 0EEA B9D7
"And now for something completely different."
