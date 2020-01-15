Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 96E3913B97A
	for <lists+netdev@lfdr.de>; Wed, 15 Jan 2020 07:21:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729130AbgAOGVi convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 15 Jan 2020 01:21:38 -0500
Received: from mx2.suse.de ([195.135.220.15]:37556 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725962AbgAOGVi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Jan 2020 01:21:38 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 4ECD1B089;
        Wed, 15 Jan 2020 06:21:36 +0000 (UTC)
From:   Nicolai Stange <nstange@suse.de>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     Nicolai Stange <nstange@suse.de>,
        "David S. Miller" <davem@davemloft.net>,
        Wen Huang <huangwenabc@gmail.com>,
        libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Takashi Iwai <tiwai@suse.de>, Miroslav Benes <mbenes@suse.cz>
Subject: Re: [PATCH 1/2] libertas: don't exit from lbs_ibss_join_existing() with RCU read lock held
References: <87woa04t2v.fsf@suse.de> <20200114103903.2336-1-nstange@suse.de>
        <20200114103903.2336-2-nstange@suse.de>
        <87o8v6qhkh.fsf@codeaurora.org>
Date:   Wed, 15 Jan 2020 07:21:35 +0100
In-Reply-To: <87o8v6qhkh.fsf@codeaurora.org> (Kalle Valo's message of "Tue, 14
        Jan 2020 15:43:42 +0200")
Message-ID: <877e1txms0.fsf@suse.de>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/25.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Kalle Valo <kvalo@codeaurora.org> writes:

> Nicolai Stange <nstange@suse.de> writes:
>
>> Commit e5e884b42639 ("libertas: Fix two buffer overflows at parsing bss
>> descriptor") introduced a bounds check on the number of supplied rates to
>> lbs_ibss_join_existing().
>>
>> Unfortunately, it introduced a return path from within a RCU read side
>> critical section without a corresponding rcu_read_unlock(). Fix this.
>>
>> Fixes: e5e884b42639 ("libertas: Fix two buffer overflows at parsing bss
>>                       descriptor")
>
> This should be in one line, I'll fix it during commit.

Thanks!

-- 
SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 Nürnberg, Germany
(HRB 36809, AG Nürnberg), GF: Felix Imendörffer
