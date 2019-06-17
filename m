Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D340047F0D
	for <lists+netdev@lfdr.de>; Mon, 17 Jun 2019 12:01:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728014AbfFQKBq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jun 2019 06:01:46 -0400
Received: from mx2.suse.de ([195.135.220.15]:49196 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726708AbfFQKBq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 17 Jun 2019 06:01:46 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 63B89AC11;
        Mon, 17 Jun 2019 10:01:44 +0000 (UTC)
From:   Andreas Schwab <schwab@suse.de>
To:     Paul Walmsley <paul.walmsley@sifive.com>
Cc:     Yash Shah <yash.shah@sifive.com>, davem@davemloft.net,
        devicetree@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-riscv@lists.infradead.org,
        robh+dt@kernel.org, mark.rutland@arm.com,
        nicolas.ferre@microchip.com, palmer@sifive.com,
        aou@eecs.berkeley.edu, ynezz@true.cz, sachin.ghadi@sifive.com
Subject: Re: [PATCH v2 0/2] Add macb support for SiFive FU540-C000
References: <1560745167-9866-1-git-send-email-yash.shah@sifive.com>
        <mvmtvco62k9.fsf@suse.de>
        <alpine.DEB.2.21.9999.1906170252410.19994@viisi.sifive.com>
X-Yow:  Hey, waiter!  I want a NEW SHIRT and a PONY TAIL with lemon sauce!
Date:   Mon, 17 Jun 2019 12:01:42 +0200
In-Reply-To: <alpine.DEB.2.21.9999.1906170252410.19994@viisi.sifive.com> (Paul
        Walmsley's message of "Mon, 17 Jun 2019 02:58:20 -0700 (PDT)")
Message-ID: <mvmpnnc5y49.fsf@suse.de>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.2.90 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Jun 17 2019, Paul Walmsley <paul.walmsley@sifive.com> wrote:

> Looks to me that it shouldn't have an impact unless the DT string is 
> present, and even then, the impact might simply be that the MACB driver 
> may not work?

If the macb driver doesn't work you have an unusable system, of course.

Andreas.

-- 
Andreas Schwab, SUSE Labs, schwab@suse.de
GPG Key fingerprint = 0196 BAD8 1CE9 1970 F4BE  1748 E4D4 88E3 0EEA B9D7
"And now for something completely different."
