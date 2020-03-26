Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 973AA19387B
	for <lists+netdev@lfdr.de>; Thu, 26 Mar 2020 07:19:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726270AbgCZGTv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Mar 2020 02:19:51 -0400
Received: from mail26.static.mailgun.info ([104.130.122.26]:17752 "EHLO
        mail26.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726138AbgCZGTv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Mar 2020 02:19:51 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1585203591; h=Content-Type: MIME-Version: Message-ID:
 In-Reply-To: Date: References: Subject: Cc: To: From: Sender;
 bh=8fHBnabYixGwE4XAz5kPWWZx2CunwgyaNZeFS6vGEXM=; b=qFyDC7WTVqdqJtqGwDLTo3ASJsTNLFdDVJEbp/BEoMy8zFIgmWAAYHd6eRF7nc/01vBB4ixS
 siV+f2AuuhhCK+5bxps4K6LO2EeUyTPmfcK5udRjQkOXsbXhHhiMwJ4gt80Yt9zIInr+gf73
 Lm8xMf0xCo5LNnCIW1k1mnkEPKI=
X-Mailgun-Sending-Ip: 104.130.122.26
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171])
 by mxa.mailgun.org with ESMTP id 5e7c4983.7fd93f8b33e8-smtp-out-n01;
 Thu, 26 Mar 2020 06:19:47 -0000 (UTC)
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id AD05DC433BA; Thu, 26 Mar 2020 06:19:47 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=2.0 tests=ALL_TRUSTED,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 3B4E8C433F2;
        Thu, 26 Mar 2020 06:19:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 3B4E8C433F2
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: pull-request: wireless-drivers-2020-03-25
References: <20200325195754.92C97C433D2@smtp.codeaurora.org>
        <20200325.131250.822565965107597577.davem@davemloft.net>
Date:   Thu, 26 Mar 2020 08:19:43 +0200
In-Reply-To: <20200325.131250.822565965107597577.davem@davemloft.net> (David
        Miller's message of "Wed, 25 Mar 2020 13:12:50 -0700 (PDT)")
Message-ID: <87sghv3af4.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

David Miller <davem@davemloft.net> writes:

> From: Kalle Valo <kvalo@codeaurora.org>
> Date: Wed, 25 Mar 2020 19:57:54 +0000 (UTC)
>
>> here's a pull request to net tree, more info below. Please let me know if there
>> are any problems.
>
> Pulled, thanks Kalle.

Thanks. I forgot to remind in this pull request about the iwlwifi
conflict when you merge net to net-next. Here are the instructions how
to handle that:

  To solve that just drop the changes from commit cf52c8a776d1 in
  wireless-drivers and take the hunk from wireless-drivers-next as is.
  The list of specific subsystem device IDs are not necessary after
  commit d6f2134a3831 (in wireless-drivers-next) anymore, the detection
  is based on other characteristics of the devices.

  https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git/commit/?id=5ef8c665416b9815113042e0edebe8ff66a45e2e

-- 
https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
