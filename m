Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 967B019467F
	for <lists+netdev@lfdr.de>; Thu, 26 Mar 2020 19:29:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728437AbgCZS33 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Mar 2020 14:29:29 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:52436 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727192AbgCZS33 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Mar 2020 14:29:29 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 9F1E315CBB87F;
        Thu, 26 Mar 2020 11:29:28 -0700 (PDT)
Date:   Thu, 26 Mar 2020 11:29:27 -0700 (PDT)
Message-Id: <20200326.112927.988175486161491472.davem@davemloft.net>
To:     kvalo@codeaurora.org
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: pull-request: wireless-drivers-2020-03-25
From:   David Miller <davem@davemloft.net>
In-Reply-To: <87sghv3af4.fsf@kamboji.qca.qualcomm.com>
References: <20200325195754.92C97C433D2@smtp.codeaurora.org>
        <20200325.131250.822565965107597577.davem@davemloft.net>
        <87sghv3af4.fsf@kamboji.qca.qualcomm.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 26 Mar 2020 11:29:28 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Kalle Valo <kvalo@codeaurora.org>
Date: Thu, 26 Mar 2020 08:19:43 +0200

> David Miller <davem@davemloft.net> writes:
> 
>> From: Kalle Valo <kvalo@codeaurora.org>
>> Date: Wed, 25 Mar 2020 19:57:54 +0000 (UTC)
>>
>>> here's a pull request to net tree, more info below. Please let me know if there
>>> are any problems.
>>
>> Pulled, thanks Kalle.
> 
> Thanks. I forgot to remind in this pull request about the iwlwifi
> conflict when you merge net to net-next. Here are the instructions how
> to handle that:
> 
>   To solve that just drop the changes from commit cf52c8a776d1 in
>   wireless-drivers and take the hunk from wireless-drivers-next as is.
>   The list of specific subsystem device IDs are not necessary after
>   commit d6f2134a3831 (in wireless-drivers-next) anymore, the detection
>   is based on other characteristics of the devices.
> 
>   https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git/commit/?id=5ef8c665416b9815113042e0edebe8ff66a45e2e

I think that's what I did basically, please go take a look and double
check my work.

Thank you!
