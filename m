Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1B5CFE38FC
	for <lists+netdev@lfdr.de>; Thu, 24 Oct 2019 18:57:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2409981AbfJXQ5K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Oct 2019 12:57:10 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:49126 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2409957AbfJXQ5K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Oct 2019 12:57:10 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id AB340147B15F2;
        Thu, 24 Oct 2019 09:57:09 -0700 (PDT)
Date:   Thu, 24 Oct 2019 09:57:09 -0700 (PDT)
Message-Id: <20191024.095709.187911510311520475.davem@davemloft.net>
To:     kvalo@codeaurora.org
Cc:     geert+renesas@glider.be, trivial@kernel.org,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] [trivial] net: Fix misspellings of "configure" and
 "configuration"
From:   David Miller <davem@davemloft.net>
In-Reply-To: <878spaqg2k.fsf@kamboji.qca.qualcomm.com>
References: <20191024152201.29868-1-geert+renesas@glider.be>
        <878spaqg2k.fsf@kamboji.qca.qualcomm.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 24 Oct 2019 09:57:09 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Kalle Valo <kvalo@codeaurora.org>
Date: Thu, 24 Oct 2019 19:11:15 +0300

> Geert Uytterhoeven <geert+renesas@glider.be> writes:
> 
>> Fix various misspellings of "configuration" and "configure".
>>
>> Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
>> ---
>> v2:
>>   - Merge
>>     [trivial] net/mlx5e: Spelling s/configuraiton/configuration/
>>     [trivial] qed: Spelling s/configuraiton/configuration/
>>   - Fix typo in subject,
>>   - Extend with various other similar misspellings.
>> ---
>>  drivers/net/ethernet/mellanox/mlx5/core/en/port_buffer.c | 2 +-
>>  drivers/net/ethernet/qlogic/qed/qed_int.h                | 4 ++--
>>  drivers/net/ethernet/qlogic/qed/qed_sriov.h              | 2 +-
>>  drivers/net/ethernet/qlogic/qede/qede_filter.c           | 2 +-
>>  drivers/net/wireless/ath/ath9k/ar9003_hw.c               | 2 +-
>>  drivers/net/wireless/intel/iwlwifi/iwl-fh.h              | 2 +-
>>  drivers/net/wireless/ti/wlcore/spi.c                     | 2 +-
>>  include/uapi/linux/dcbnl.h                               | 2 +-
>>  8 files changed, 9 insertions(+), 9 deletions(-)
> 
> I hope this goes to net-next? Easier to handle possible conflicts that
> way.
> 
> For the wireless part:
> 
> Acked-by: Kalle Valo <kvalo@codeaurora.org>

Yeah I can take it if that's easier.
