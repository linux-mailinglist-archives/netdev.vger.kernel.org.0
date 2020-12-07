Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6BA32D0E31
	for <lists+netdev@lfdr.de>; Mon,  7 Dec 2020 11:41:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726327AbgLGKlN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Dec 2020 05:41:13 -0500
Received: from so254-31.mailgun.net ([198.61.254.31]:43549 "EHLO
        so254-31.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725794AbgLGKlN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Dec 2020 05:41:13 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1607337648; h=Content-Type: MIME-Version: Message-ID:
 In-Reply-To: Date: References: Subject: Cc: To: From: Sender;
 bh=SJSbCik9Tek06j7dEaYsZTY3s+Lwk19Ci7mR6nO9gjk=; b=MTmgEmhbaSeZCkjyJg+yMKVFT3MzBgNCGgSV7j23pW2qQlxQ/NfjpF2C5xxyQaIBoEHKL/3p
 wCOCboi6GB/TZnx0Bn7JtTUzTvwOiDda4wJkf/QWR0DFLF17q9mha+PmSkqmff4Pk5hYihMq
 jHq2vVYfe6X44zWJvdMmwIIE7ck=
X-Mailgun-Sending-Ip: 198.61.254.31
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n04.prod.us-east-1.postgun.com with SMTP id
 5fce0692ae7b105766e29498 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Mon, 07 Dec 2020 10:40:18
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 24AF6C433C6; Mon,  7 Dec 2020 10:40:18 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL
        autolearn=no autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id B24E1C433CA;
        Mon,  7 Dec 2020 10:40:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org B24E1C433CA
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: pull-request: wireless-drivers-next-2020-12-03
References: <20201203185732.9CFA5C433ED@smtp.codeaurora.org>
        <20201204111715.04d5b198@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
Date:   Mon, 07 Dec 2020 12:40:14 +0200
In-Reply-To: <20201204111715.04d5b198@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
        (Jakub Kicinski's message of "Fri, 4 Dec 2020 11:17:15 -0800")
Message-ID: <87tusxgar5.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub Kicinski <kuba@kernel.org> writes:

> On Thu,  3 Dec 2020 18:57:32 +0000 (UTC) Kalle Valo wrote:
>> wireless-drivers-next patches for v5.11
>> 
>> First set of patches for v5.11. rtw88 getting improvements to work
>> better with Bluetooth and other driver also getting some new features.
>> mhi-ath11k-immutable branch was pulled from mhi tree to avoid
>> conflicts with mhi tree.
>
> Pulled, but there are a lot of fixes in here which look like they
> should have been part of the other PR, if you ask me.

Yeah, I'm actually on purpose keeping the bar high for patches going to
wireless-drivers (ie. the fixes going to -rc releases). This is just to
keep things simple for me and avoiding the number of conflicts between
the trees.

> There's also a patch which looks like it renames a module parameter.
> Module parameters are considered uAPI.

Ah, I have been actually wondering that if they are part of user space
API or not, good to know that they are. I'll keep an eye of this in the
future so that we are not breaking the uAPI with module parameter
changes.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
