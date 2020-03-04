Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B35671789CF
	for <lists+netdev@lfdr.de>; Wed,  4 Mar 2020 06:05:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725919AbgCDFFt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Mar 2020 00:05:49 -0500
Received: from mail27.static.mailgun.info ([104.130.122.27]:61549 "EHLO
        mail27.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725795AbgCDFFt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Mar 2020 00:05:49 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1583298349; h=Content-Type: MIME-Version: Message-ID:
 In-Reply-To: Date: References: Subject: Cc: To: From: Sender;
 bh=Zr+uTkCF7UjMRMUVQeIBVshpSJtBmj9w8NtCiktmS+o=; b=YorFZA6egOAc9BN5k31AsBwHRHaK5SqU+4wlYkcjauUclxovN/cCitS5YbEVTAM5c1oFh7BG
 PjXOah9uzLeinyOsJpKEF2LOHQNQQ/P7bpL2rtUeIqvoc1K9fsPGETzSDWn1bDf8UmuAFKXY
 0WZXS+hZolB5ZxUNMkbWzDwGdz4=
X-Mailgun-Sending-Ip: 104.130.122.27
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171])
 by mxa.mailgun.org with ESMTP id 5e5f372b.7f4a2ba3f458-smtp-out-n03;
 Wed, 04 Mar 2020 05:05:47 -0000 (UTC)
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 0B066C4479F; Wed,  4 Mar 2020 05:05:47 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=2.0 tests=ALL_TRUSTED,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id A0417C43383;
        Wed,  4 Mar 2020 05:05:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org A0417C43383
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Randy Dunlap <rdunlap@infradead.org>
Cc:     "Mancini\, Jason" <Jason.Mancini@amd.com>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev\@vger.kernel.org" <netdev@vger.kernel.org>,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        linux-wireless@vger.kernel.org
Subject: Re: v5.5-rc1 and beyond insta-kills some Comcast wifi routers
References: <DM6PR12MB4331FD3C4EF86E6AF2B3EBC7E5E50@DM6PR12MB4331.namprd12.prod.outlook.com>
        <4e2a1fc1-4c14-733d-74e2-750ef1f81bf6@infradead.org>
Date:   Wed, 04 Mar 2020 07:05:42 +0200
In-Reply-To: <4e2a1fc1-4c14-733d-74e2-750ef1f81bf6@infradead.org> (Randy
        Dunlap's message of "Tue, 3 Mar 2020 20:05:53 -0800")
Message-ID: <87h7z4r9p5.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Randy Dunlap <rdunlap@infradead.org> writes:

> [add netdev mailing list + 2 patch signers]

Adding also linux-wireless. It's always best to send questions about any
wireless issues to linux-wireless

> On 3/3/20 7:34 PM, Mancini, Jason wrote:
>> [I can't seem to access the linux-net ml per kernel.org faq, apology
>> in advance.]
>> 
>> This change, which I think first appeared for v5.5-rc1, basically
>> within seconds, knocks out our [apparently buggy] Comcast wifi for
>> about 2-3 minutes.  Is there a boot option (or similar) where I can
>> achieve prior kernel behavior?  Otherwise I am stuck on kernel 5.4
>> (or Win10) it seems, or forever compiling custom kernels for my
>> choice of distribution [as I don't have physical access to the router
>> in question.]
>> Thanks!
>> Jason
>> 
>> ================
>> 
>> 127eef1d46f80056fe9f18406c6eab38778d8a06 is the first bad commit
>> commit 127eef1d46f80056fe9f18406c6eab38778d8a06
>> Author: Yan-Hsuan Chuang <yhchuang@realtek.com>
>> Date:   Wed Oct 2 14:35:23 2019 +0800

Can you try if this fixes it:

https://git.kernel.org/pub/scm/linux/kernel/git/kvalo/wireless-drivers-next.git/commit/?id=74c3d72cc13401f9eb3e3c712855e9f8f2d2682b

-- 
https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
