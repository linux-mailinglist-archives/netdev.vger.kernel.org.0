Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 203FA49E21B
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 13:11:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236528AbiA0MLX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jan 2022 07:11:23 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:43750 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234481AbiA0MLW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jan 2022 07:11:22 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3F1F2B82227;
        Thu, 27 Jan 2022 12:11:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40EA1C340E4;
        Thu, 27 Jan 2022 12:11:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643285480;
        bh=l6TRy4jFk0Trxh8+yK9kI1v0jsEYunfLcp1/XiEleh8=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=kda1foNqREMz9pKhLX9F6Jrq8C1fgqA/P2pVwJzWbJ3rXX1MHuzhq7EJ9q99Hbw+C
         u0UEB9YScQdiQCy7e3OEya4I2PtqJjc/SlGo2b2waVmgiWikvqtNhzHhcs80GmiwLi
         ebxiH0PbRkD7Hbudc3X3p9J8y9nsWElkTjn9o6DTAD0XoJQI6fluSqukZV3BWjWrU8
         d+XK8lyWxKDxtMXRTbjZS/aKVQvTGPDIVMT8qHW581O/fImoxhv18Q4kBvPQfAFhkS
         xC6ByS0UQmJf4MdxkNM1HZXnRQgjhYr+GVa6wASYHeU9XlizjPUUZzumAZpLjSXt8z
         ohCI2MilfYfLw==
From:   Kalle Valo <kvalo@kernel.org>
To:     Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Cc:     Pkshih <pkshih@realtek.com>,
        "linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "tony0620emma\@gmail.com" <tony0620emma@gmail.com>,
        "netdev\@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Neo Jou <neojou@gmail.com>,
        Jernej Skrabec <jernej.skrabec@gmail.com>
Subject: Re: [PATCH 3/4] rtw88: Move enum rtw_tx_queue_type mapping code to tx.{c,h}
References: <20220114234825.110502-1-martin.blumenstingl@googlemail.com>
        <20220114234825.110502-4-martin.blumenstingl@googlemail.com>
        <b2bf2bc5f04b488487797aa21c50a130@realtek.com>
        <87czkogsc4.fsf@kernel.org>
        <CAFBinCCeCoRmqApeeAD534dKrhgbnh4wSBF88oLLXqL-TYv5+w@mail.gmail.com>
Date:   Thu, 27 Jan 2022 14:11:14 +0200
In-Reply-To: <CAFBinCCeCoRmqApeeAD534dKrhgbnh4wSBF88oLLXqL-TYv5+w@mail.gmail.com>
        (Martin Blumenstingl's message of "Sun, 23 Jan 2022 19:34:18 +0100")
Message-ID: <87mtjhjs4d.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Martin Blumenstingl <martin.blumenstingl@googlemail.com> writes:

> Hi Kalle,
>
> On Wed, Jan 19, 2022 at 7:20 AM Kalle Valo <kvalo@kernel.org> wrote:
> [...]
>> I was about to answer that with a helper function it's easier to catch
>> out of bands access, but then noticed the helper doesn't have a check
>> for that. Should it have one?
>
> you mean something like:
>     if (ac >= IEEE80211_NUM_ACS)
>         return RTW_TX_QUEUE_BE;
>
> Possibly also with a WARN_ON/WARN_ON_ONCE

Yeah, something like that would be good.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
