Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 018793D9152
	for <lists+netdev@lfdr.de>; Wed, 28 Jul 2021 16:55:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237436AbhG1OzU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Jul 2021 10:55:20 -0400
Received: from so254-9.mailgun.net ([198.61.254.9]:29271 "EHLO
        so254-9.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237347AbhG1Oy4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Jul 2021 10:54:56 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1627484094; h=Content-Type: MIME-Version: Message-ID:
 In-Reply-To: Date: References: Subject: Cc: To: From: Sender;
 bh=Ep08OHNA6cPjguVx+7EyjN81zK8S0EpKX+rpXN2XyL4=; b=VQdDBzNAflkXweuUyUUQjcblOYfgVNUQUOi5YFh787ijOcSi3tU/D3Mf7nefkJ3CrK5uDr75
 f28jWWkpP/mKbR0qxGQyY4VxGEFcxbxDMh4a75X7KMFJ3HnwqqHtZX/rs934DAFxdXrd00Sd
 NbG+CEI9F1PXbQ8OmGtiHeE/B44=
X-Mailgun-Sending-Ip: 198.61.254.9
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n04.prod.us-east-1.postgun.com with SMTP id
 61016fb9b653fbdadd3e24d7 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Wed, 28 Jul 2021 14:54:49
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id D33CAC43148; Wed, 28 Jul 2021 14:54:48 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL
        autolearn=no autolearn_force=no version=3.4.0
Received: from tykki (tynnyri.adurom.net [51.15.11.48])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 9DD15C43144;
        Wed, 28 Jul 2021 14:54:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 9DD15C43144
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Luis Chamberlain <mcgrof@kernel.org>
Cc:     Christian Lamparter <chunkeey@gmail.com>,
        Lukas Bulwahn <lukas.bulwahn@gmail.com>,
        linux-wireless@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Dwaipayan Ray <dwaipayanray1@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] intersil: remove obsolete prism54 wireless driver
References: <20210713054025.32006-1-lukas.bulwahn@gmail.com>
        <20210715220644.2d2xfututdoimszm@garbanzo>
        <6f490ee6-4879-cac5-d351-112f21c6b23f@gmail.com>
        <87mtq8guh7.fsf@codeaurora.org>
        <YP//NPZbVXZ5efZJ@bombadil.infradead.org>
Date:   Wed, 28 Jul 2021 17:54:40 +0300
In-Reply-To: <YP//NPZbVXZ5efZJ@bombadil.infradead.org> (Luis Chamberlain's
        message of "Tue, 27 Jul 2021 05:42:28 -0700")
Message-ID: <87pmv2fpzj.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Luis Chamberlain <mcgrof@kernel.org> writes:

> On Tue, Jul 27, 2021 at 09:07:48AM +0300, Kalle Valo wrote:
>> Christian Lamparter <chunkeey@gmail.com> writes:
>> 
>> > On 16/07/2021 00:06, Luis Chamberlain wrote:
>> >> On Tue, Jul 13, 2021 at 07:40:25AM +0200, Lukas Bulwahn wrote:
>> >>> Commit 1d89cae1b47d ("MAINTAINERS: mark prism54 obsolete") indicated the
>> >>> prism54 driver as obsolete in July 2010.
>> >>>
>> >>> Now, after being exposed for ten years to refactoring, general tree-wide
>> >>> changes and various janitor clean-up, it is really time to delete the
>> >>> driver for good.
>> >>>
>> >>> This was discovered as part of a checkpatch evaluation, investigating all
>> >>> reports of checkpatch's WARNING:OBSOLETE check.
>> >>>
>> >>> Signed-off-by: Lukas Bulwahn <lukas.bulwahn@gmail.com>
>> >>> ---
>> >
>> > noted. Farewell.
>> 
>> How do we know that there are no users left? It's surprising how ancient
>> hardware some people use. Is the driver broken or what?
>> 
>> (Reads commit 1d89cae1b47d)
>> 
>> Ah, p54 is supposed to replace prism54. Does that include all the
>> hardware supported by prism54?
>
> There was a one off chipset someone told me about long ago that p54
> didn't work for. But that persond disappeared from the face of the
> earth. Additionally, distributions have been blacklisting prism54
> for years now.
>
>> If yes, that should be clearly documented
>> in the commit log and I can add that.
>
> Agreed. Feel free to quote the above.

Thanks, will do.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
