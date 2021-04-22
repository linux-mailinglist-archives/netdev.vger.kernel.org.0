Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D619B368279
	for <lists+netdev@lfdr.de>; Thu, 22 Apr 2021 16:30:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236663AbhDVObS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Apr 2021 10:31:18 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:13203 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236341AbhDVObS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Apr 2021 10:31:18 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1619101843; h=Content-Type: MIME-Version: Message-ID:
 In-Reply-To: Date: References: Subject: Cc: To: From: Sender;
 bh=chL4BkCvm+bquexbpqzupJJrJnve98d4abqXXixbou8=; b=MJJsPuUPKLQI/SBL7WiWbOM9XMqD6ykz4R4Fp+q0eEhOgINZY2UOYZ38A3WfoGuZV/Aw7ZAt
 9XfFVSmiA+HgzmsZy/wav92ciSQfaN3KJPYvLQMPgCO/10Fu/4lzJxDGpjk7XoG2+kmHn3Pl
 odOr8btJr8uhV5AGRs6TcPSIEF0=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n04.prod.us-west-2.postgun.com with SMTP id
 6081887b2cc44d3aea9ea917 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Thu, 22 Apr 2021 14:30:19
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id A86C0C43460; Thu, 22 Apr 2021 14:30:19 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL
        autolearn=no autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id A78B3C433F1;
        Thu, 22 Apr 2021 14:30:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org A78B3C433F1
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Sedat Dilek <sedat.dilek@gmail.com>
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        Joe Perches <joe@perches.com>
Subject: Re: pull-request: wireless-drivers-2021-04-21
References: <20210421090335.7A50CC4338A@smtp.codeaurora.org>
        <CA+icZUV079dCCKJTU6e40bJYcaVT+ofK5S=9xFwxB3Sc+QPrXw@mail.gmail.com>
Date:   Thu, 22 Apr 2021 17:30:15 +0300
In-Reply-To: <CA+icZUV079dCCKJTU6e40bJYcaVT+ofK5S=9xFwxB3Sc+QPrXw@mail.gmail.com>
        (Sedat Dilek's message of "Thu, 22 Apr 2021 10:47:41 +0200")
Message-ID: <87a6pqjsso.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sedat Dilek <sedat.dilek@gmail.com> writes:

> On Wed, Apr 21, 2021 at 11:04 AM Kalle Valo <kvalo@codeaurora.org> wrote:
>>
>> Hi,
>>
>> here's a pull request to net tree, more info below. Please let me know if there
>> are any problems.
>>
>> Kalle
>>
>> The following changes since commit d434405aaab7d0ebc516b68a8fc4100922d7f5ef:
>>
>>   Linux 5.12-rc7 (2021-04-11 15:16:13 -0700)
>>
>> are available in the git repository at:
>>
>>   git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/wireless-drivers.git
>> tags/wireless-drivers-2021-04-21
>>
>> for you to fetch changes up to e7020bb068d8be50a92f48e36b236a1a1ef9282e:
>>
>>   iwlwifi: Fix softirq/hardirq disabling in
>> iwl_pcie_gen2_enqueue_hcmd() (2021-04-19 20:35:10 +0300)
>>
>
> [ CC Joe Perches ]
>
> That patch misses the closing ">" in the Reported-by of Heiner.
> My Tested-by seems also to be ignored.
> See [1] and [2].

You commented on v1, I missed those as I only check the latest version
(v2 in this case). I recommend giving comments to the latest version to
make sure I see them.

Also patchwork automatically picks up Tested-by if you provide it to the
latest version.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
