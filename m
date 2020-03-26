Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 760C319478E
	for <lists+netdev@lfdr.de>; Thu, 26 Mar 2020 20:39:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728632AbgCZTix (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Mar 2020 15:38:53 -0400
Received: from mail26.static.mailgun.info ([104.130.122.26]:50713 "EHLO
        mail26.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728630AbgCZTiv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Mar 2020 15:38:51 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1585251530; h=Content-Type: MIME-Version: Message-ID:
 In-Reply-To: Date: References: Subject: Cc: To: From: Sender;
 bh=HGer0yxP7sLj3QyFrIf54CwysnJOZjYM50OWoKj9vg0=; b=teAIoXITSrdIAMLY/bNVLjY7iUoupjco8Vj6CwyjJzxQDqkg878cYyx51cdDmJWF/hVTn5Xq
 RAVt4nravQR1aP0dkinU/5QKcrSIo371FPuVTqWPlouB4I2I1nUnHXcz5lG6JmnWfTB7aNCh
 SOLiCVKefjDgfbYTey1EE5JprQU=
X-Mailgun-Sending-Ip: 104.130.122.26
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171])
 by mxa.mailgun.org with ESMTP id 5e7d04c6.7f611eadf928-smtp-out-n03;
 Thu, 26 Mar 2020 19:38:46 -0000 (UTC)
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id A0EE1C433BA; Thu, 26 Mar 2020 19:38:45 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=2.0 tests=ALL_TRUSTED,SPF_NONE,
        URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id A1268C433F2;
        Thu, 26 Mar 2020 19:38:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org A1268C433F2
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: pull-request: wireless-drivers-2020-03-25
References: <20200325195754.92C97C433D2@smtp.codeaurora.org>
        <20200325.131250.822565965107597577.davem@davemloft.net>
        <87sghv3af4.fsf@kamboji.qca.qualcomm.com>
        <20200326.112927.988175486161491472.davem@davemloft.net>
Date:   Thu, 26 Mar 2020 21:38:41 +0200
In-Reply-To: <20200326.112927.988175486161491472.davem@davemloft.net> (David
        Miller's message of "Thu, 26 Mar 2020 11:29:27 -0700 (PDT)")
Message-ID: <87k1363nzy.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

David Miller <davem@davemloft.net> writes:

> From: Kalle Valo <kvalo@codeaurora.org>
> Date: Thu, 26 Mar 2020 08:19:43 +0200
>
>> David Miller <davem@davemloft.net> writes:
>> 
>>> From: Kalle Valo <kvalo@codeaurora.org>
>>> Date: Wed, 25 Mar 2020 19:57:54 +0000 (UTC)
>>>
>>>> here's a pull request to net tree, more info below. Please let me know if there
>>>> are any problems.
>>>
>>> Pulled, thanks Kalle.
>> 
>> Thanks. I forgot to remind in this pull request about the iwlwifi
>> conflict when you merge net to net-next. Here are the instructions how
>> to handle that:
>> 
>>   To solve that just drop the changes from commit cf52c8a776d1 in
>>   wireless-drivers and take the hunk from wireless-drivers-next as is.
>>   The list of specific subsystem device IDs are not necessary after
>>   commit d6f2134a3831 (in wireless-drivers-next) anymore, the detection
>>   is based on other characteristics of the devices.
>> 
>>   https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git/commit/?id=5ef8c665416b9815113042e0edebe8ff66a45e2e
>
> I think that's what I did basically, please go take a look and double
> check my work.

Looks good to me, thanks for taking care of it.

-- 
https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
