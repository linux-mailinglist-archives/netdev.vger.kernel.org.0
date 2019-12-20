Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 582C2127667
	for <lists+netdev@lfdr.de>; Fri, 20 Dec 2019 08:19:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726327AbfLTHTm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Dec 2019 02:19:42 -0500
Received: from mail26.static.mailgun.info ([104.130.122.26]:13887 "EHLO
        mail26.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725920AbfLTHTl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Dec 2019 02:19:41 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1576826381; h=Content-Type: MIME-Version: Message-ID:
 In-Reply-To: Date: References: Subject: Cc: To: From: Sender;
 bh=qQnAOBnm851gvtQP9RARiafEiullQAdZpKpw996rOSk=; b=LK+J1zGwcyMsY9map+ofgfL+RI6uZaFvetVaCYLvEDOLJWxeXKpS78fk6PUlYuv7t2Jg/vnI
 UEVQvDOJDTLdtRObq/UJ8oEjmHp9FwDJlqI3u8W3HNXMvU+7XcLcuV817Y6WrJjFnz5RHnTJ
 4SyBsAWj1O3P9t1Tkphn9HJ1caY=
X-Mailgun-Sending-Ip: 104.130.122.26
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171])
 by mxa.mailgun.org with ESMTP id 5dfc7608.7fdada0a99d0-smtp-out-n02;
 Fri, 20 Dec 2019 07:19:36 -0000 (UTC)
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 76001C4479C; Fri, 20 Dec 2019 07:19:35 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=2.0 tests=ALL_TRUSTED,SPF_NONE,
        URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 04C50C433CB;
        Fri, 20 Dec 2019 07:19:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 04C50C433CB
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Nick Desaulniers <ndesaulniers@google.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        linux-wireless@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        clang-built-linux <clang-built-linux@googlegroups.com>,
        Nathan Chancellor <natechancellor@gmail.com>,
        ath11k@lists.infradead.org
Subject: Re: [PATCH] ath11k: Remove unnecessary enum scan_priority
References: <20191211192252.35024-1-natechancellor@gmail.com>
        <CAKwvOdmQp+Rjgh49kbTp1ocLCjv4SUACEO4+tX5vz4stX-pPpg@mail.gmail.com>
        <87a77o786o.fsf@kamboji.qca.qualcomm.com>
        <CAKwvOdk3EPurHLMf81VHowauRYZ4FZXxNg98hJvp8CLgu=SSPw@mail.gmail.com>
Date:   Fri, 20 Dec 2019 09:19:30 +0200
In-Reply-To: <CAKwvOdk3EPurHLMf81VHowauRYZ4FZXxNg98hJvp8CLgu=SSPw@mail.gmail.com>
        (Nick Desaulniers's message of "Thu, 19 Dec 2019 09:06:37 -0800")
Message-ID: <877e2r4g71.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Nick Desaulniers <ndesaulniers@google.com> writes:

> On Thu, Dec 19, 2019 at 5:32 AM Kalle Valo <kvalo@codeaurora.org> wrote:
>>
>> Nick Desaulniers <ndesaulniers@google.com> writes:
>>
>> > On Wed, Dec 11, 2019 at 11:23 AM Nathan Chancellor
>> > <natechancellor@gmail.com> wrote:
>> >> wmi_scan_priority and scan_priority have the same values but the wmi one
>> >> has WMI prefixed to the names. Since that enum is already being used,
>> >> get rid of scan_priority and switch its one use to wmi_scan_priority to
>> >> fix this warning.
>> >>
>> > Also, I don't know if the more concisely named enum is preferable?
>>
>> I didn't get this comment.
>
> Given two enums with the same values:
> enum scan_priority
> enum wmi_scan_priority
> wouldn't you prefer to type wmi_ a few times less?  Doesn't really
> matter, but that was the point I was making.

Ah, now I got it :) This enum is part of firmware interface (WMI) so
yes, I prefer to use the wmi_ prefix to make that obvious.

-- 
https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
