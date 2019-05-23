Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EDFDF27D23
	for <lists+netdev@lfdr.de>; Thu, 23 May 2019 14:49:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730571AbfEWMtT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 May 2019 08:49:19 -0400
Received: from mx2.suse.de ([195.135.220.15]:38954 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728309AbfEWMtT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 May 2019 08:49:19 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 0EDE5AEBB;
        Thu, 23 May 2019 12:49:18 +0000 (UTC)
From:   Andreas Schwab <schwab@suse.de>
To:     Yash Shah <yash.shah@sifive.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-riscv@lists.infradead.org,
        devicetree@vger.kernel.org, robh+dt@kernel.org,
        mark.rutland@arm.com, nicolas.ferre@microchip.com,
        palmer@sifive.com, aou@eecs.berkeley.edu, ynezz@true.cz,
        paul.walmsley@sifive.com, sachin.ghadi@sifive.com
Subject: Re: [PATCH 0/2] net: macb: Add support for SiFive FU540-C000
References: <1558611952-13295-1-git-send-email-yash.shah@sifive.com>
X-Yow:  Don't worry, nobody really LISTENS to lectures in MOSCOW, either!
 ..  FRENCH, HISTORY, ADVANCED CALCULUS, COMPUTER PROGRAMMING,
 BLACK STUDIES, SOCIOBIOLOGY!..  Are there any QUESTIONS??
Date:   Thu, 23 May 2019 14:49:16 +0200
In-Reply-To: <1558611952-13295-1-git-send-email-yash.shah@sifive.com> (Yash
        Shah's message of "Thu, 23 May 2019 17:15:50 +0530")
Message-ID: <mvmwoihfi9f.fsf@suse.de>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mai 23 2019, Yash Shah <yash.shah@sifive.com> wrote:

> On FU540, the management IP block is tightly coupled with the Cadence
> MACB IP block. It manages many of the boundary signals from the MACB IP
> This patchset controls the tx_clk input signal to the MACB IP. It
> switches between the local TX clock (125MHz) and PHY TX clocks. This
> is necessary to toggle between 1Gb and 100/10Mb speeds.

Doesn't work for me:

[  365.842801] macb: probe of 10090000.ethernet failed with error -17

Andreas.

-- 
Andreas Schwab, SUSE Labs, schwab@suse.de
GPG Key fingerprint = 0196 BAD8 1CE9 1970 F4BE  1748 E4D4 88E3 0EEA B9D7
"And now for something completely different."
