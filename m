Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DA06254243
	for <lists+netdev@lfdr.de>; Thu, 27 Aug 2020 11:27:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728516AbgH0J1m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Aug 2020 05:27:42 -0400
Received: from mail29.static.mailgun.info ([104.130.122.29]:35805 "EHLO
        mail29.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727030AbgH0J1l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Aug 2020 05:27:41 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1598520460; h=Content-Type: MIME-Version: Message-ID:
 In-Reply-To: Date: References: Subject: Cc: To: From: Sender;
 bh=QWdQHQuPvLrCO8rowzZZm4QHVqIRVrvYDpdAOb7yDRk=; b=SVSXyx9k7s75YHn1e+USJoMulzzcp3I9bwG7XYhzBg/pZxM8v9g55QgAPeO/mUDMDHAaJS98
 /cFtCfCIhNGepAAyX+YwkOauWqooHC3oloxsKzxSJDznQ1VO972JlYtC4dMu2Wn5qHs1nPaA
 HeMtASp1Z0YLWuzvZ5UtzxIJ61w=
X-Mailgun-Sending-Ip: 104.130.122.29
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n05.prod.us-west-2.postgun.com with SMTP id
 5f477c89c598aced542063f4 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Thu, 27 Aug 2020 09:27:37
 GMT
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 41AC8C433C6; Thu, 27 Aug 2020 09:27:37 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=2.0 tests=ALL_TRUSTED,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id B735FC433A0;
        Thu, 27 Aug 2020 09:27:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org B735FC433A0
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Larry Finger <Larry.Finger@lwfinger.net>
Cc:     Joe Perches <joe@perches.com>, Pkshih <pkshih@realtek.com>,
        "linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "davem\@davemloft.net" <davem@davemloft.net>,
        "netdev\@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kuba\@kernel.org" <kuba@kernel.org>
Subject: Re: [PATCH 2/6] rtlwifi: Remove unnecessary parenthese in rtl_dbg uses
References: <cover.1595706419.git.joe@perches.com>
        <9b2eaedb7ea123ea766a379459b20a9486d1cd41.1595706420.git.joe@perches.com>
        <1595830034.12227.7.camel@realtek.com>
        <ae9d562ec9ef765dddd1491d4cfb5f6d18f7025f.camel@perches.com>
        <1595840670.17671.4.camel@realtek.com>
        <6e0c07bc3d2f48d4a62a9e270366c536cfe56783.camel@perches.com>
        <374359f9-8199-f4b9-0596-adc41c8c664f@lwfinger.net>
Date:   Thu, 27 Aug 2020 12:27:32 +0300
In-Reply-To: <374359f9-8199-f4b9-0596-adc41c8c664f@lwfinger.net> (Larry
        Finger's message of "Mon, 27 Jul 2020 11:25:21 -0500")
Message-ID: <87v9h4bfqz.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Larry Finger <Larry.Finger@lwfinger.net> writes:

> On 7/27/20 9:52 AM, Joe Perches wrote:
>> On Mon, 2020-07-27 at 09:04 +0000, Pkshih wrote:
>>> So, I think you would like to have parenthesis intentionally.
>>> If so,
>>> test1 ? : (test2 ? :)
>>> would be better.
>>>
>>>
>>> If not,
>>> test1 ? : test2 ? :
>>> may be what you want (without any parenthesis).
>>
>> Use whatever style you like, it's unimportant to me
>> and it's not worth spending any real time on it.
>
> If you are so busy, why did you jump in with patches that you knew I
> was already working on? You knew because you critiqued my first
> submission.

Yeah, I don't understand this either. First stepping on Larry's work and
when after getting review comments claiming being busy and not caring is
contradicting.

> @Kalle: Please drop my contributions in the sequence "PATCH v2 00/15]
> rtlwifi: Change RT_TRACE into rtl_dbg for all drivers".

Is there a technical reason for that? I prefer that patchset more,
nicely split in smaller patches and it's fully available from patchwork.

Patch 15 had a build problem but I can drop that for now, it can be
resent separately:

https://patchwork.kernel.org/patch/11681621/

-- 
https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
