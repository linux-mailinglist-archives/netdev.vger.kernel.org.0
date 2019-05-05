Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2838C13E46
	for <lists+netdev@lfdr.de>; Sun,  5 May 2019 09:51:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727572AbfEEHvc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 May 2019 03:51:32 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:46496 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725792AbfEEHvb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 May 2019 03:51:31 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d8])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 32A9814C03799;
        Sun,  5 May 2019 00:51:31 -0700 (PDT)
Date:   Sun, 05 May 2019 00:51:30 -0700 (PDT)
Message-Id: <20190505.005130.1921658214241614481.davem@davemloft.net>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: pull-request: wireless-drivers 2019-04-30
From:   David Miller <davem@davemloft.net>
In-Reply-To: <87r29jo2jy.fsf@kamboji.qca.qualcomm.com>
References: <8736lzpm0m.fsf@kamboji.qca.qualcomm.com>
        <20190430.120117.1616322040923778364.davem@davemloft.net>
        <87r29jo2jy.fsf@kamboji.qca.qualcomm.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 05 May 2019 00:51:31 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Kalle Valo <kvalo@codeaurora.org>
Date: Tue, 30 Apr 2019 19:55:45 +0300

> David Miller <davem@davemloft.net> writes:
> 
>> Thanks for the conflict resolution information, it is very helpful.
>>
>> However, can you put it into the merge commit text next time as well?
>> I cut and pasted it in there when I pulled this stuff in.
> 
> A good idea, I'll do that. Just to be sure, do you mean that I should
> add it only with conflicts between net and net-next (like in this case)?
> Or should I add it everytime I see a conflict, for example between
> wireless-drivers-next and net-next? I hope my question is not too
> confusing...

When there is a major conflict for me to resolve when I pull in your
pull reqeust, please place the conflict resolution help text into the
merge commit message.

I hope this is now clear :-)
