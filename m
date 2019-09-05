Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 489D4AA5A4
	for <lists+netdev@lfdr.de>; Thu,  5 Sep 2019 16:20:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387813AbfIEOUC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Sep 2019 10:20:02 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:51618 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728666AbfIEOUC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Sep 2019 10:20:02 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 2ED086058E; Thu,  5 Sep 2019 14:20:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1567693201;
        bh=CQnx7U4IU5RtD4vXyAeIpL8Vvix5Ftn8Uv26HEnCIsA=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=fQoZr3RkWCfjlw/x4UfChN5WDe2PxJP2QKncrLHKIY6wub1FqPqGF8/R3+QoPPvE3
         XmsCi1dgc3vH9aTuo63DciZKL5fb4UglLZs+12gpxqW5fZ5tHEyu+ZZkfy/fILi9Ea
         +4uJC1M3yYTFqUkwpqWtvgjqBrG9Lqd0iLdM4Tg4=
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        pdx-caf-mail.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        DKIM_INVALID,DKIM_SIGNED,SPF_NONE autolearn=no autolearn_force=no
        version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 35191602DC;
        Thu,  5 Sep 2019 14:19:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1567693200;
        bh=CQnx7U4IU5RtD4vXyAeIpL8Vvix5Ftn8Uv26HEnCIsA=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=PEpyC/egL0Epv7HLTDxUShyjV/W0Jp/ycJYdiDHqAKXnz/I+2/B9KBnRHfUsGJOB9
         IAKjLYDBTaHJV0w8Jczf8mkad3ccggtcjV2OC/8K0acmv86mRVnFr9fE5P3+4KMRo9
         REVzXYHJL50gccbjZPYv1X2w2HGSap9ORwYYZL5A=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 35191602DC
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     zhong jiang <zhongjiang@huawei.com>
Cc:     <davem@davemloft.net>, <linux-wireless@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] hostap: remove set but not used variable 'copied' in prism2_io_debug_proc_read
References: <1567497430-22539-1-git-send-email-zhongjiang@huawei.com>
        <5D6E1DF2.1000109@huawei.com> <87zhjij1q6.fsf@tynnyri.adurom.net>
        <5D711760.20903@huawei.com>
Date:   Thu, 05 Sep 2019 17:19:56 +0300
In-Reply-To: <5D711760.20903@huawei.com> (zhong jiang's message of "Thu, 5 Sep
        2019 22:10:40 +0800")
Message-ID: <87ftlalt9v.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

zhong jiang <zhongjiang@huawei.com> writes:

> On 2019/9/5 21:45, Kalle Valo wrote:
>> zhong jiang <zhongjiang@huawei.com> writes:
>>
>>> Please ignore the patch.  Because  the hostap_proc.c is marked as 'obsolete'.
>> You mean marked in the MAINTAINERS file? I don't see that as a problem,
>> I can (and should) still apply any patches submitted to hostap driver.
>>
> I  hit the following issue when checking the patch by checkpatch.pl
>
> WARNING: drivers/net/wireless/intersil/hostap/hostap_proc.c is marked
> as 'obsolete' in the MAINTAINERS hierarchy.
> No unnecessary modifications please.
>
> I certainly hope it can be appiled to upstream if the above check doesn't matter.

I have no idea why checkpatch says like that and I'm going to just
ignore that warning. As long as the driver is in the tree I think it
should be improved.

-- 
https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
