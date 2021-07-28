Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B838E3D88A2
	for <lists+netdev@lfdr.de>; Wed, 28 Jul 2021 09:13:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234793AbhG1HNj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Jul 2021 03:13:39 -0400
Received: from so254-9.mailgun.net ([198.61.254.9]:46065 "EHLO
        so254-9.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233758AbhG1HNi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Jul 2021 03:13:38 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1627456417; h=Content-Type: MIME-Version: Message-ID:
 In-Reply-To: Date: References: Subject: Cc: To: From: Sender;
 bh=DVGGeCBbvSyqvnZxRLjfNywtSNTl0GF1xOYjiY/ySd0=; b=JYdQSHelt6DtPgjC80mlqaGKvjAEkamdoYd+rENW4rRmgGXxi4516JrCZUMDXKMRiZIJU8zz
 o/EdQ5KTYCOaloJ0Fyqbm8De9nMj1/3huBxhaqOshkwDorFp+FkZyFumRBiKNBOVutEQ1zVT
 Iy0nGdPpyEMoQ8yNh2EdL16dRZc=
X-Mailgun-Sending-Ip: 198.61.254.9
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n06.prod.us-west-2.postgun.com with SMTP id
 6101039de81205dd0ae3314a (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Wed, 28 Jul 2021 07:13:33
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 8EF93C43143; Wed, 28 Jul 2021 07:13:33 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL
        autolearn=no autolearn_force=no version=3.4.0
Received: from tykki (tynnyri.adurom.net [51.15.11.48])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 94C28C4338A;
        Wed, 28 Jul 2021 07:13:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 94C28C4338A
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Hin-Tak Leung <htl10@users.sourceforge.net>
Cc:     Herton Ronaldo Krzesinski <herton@canonical.com>,
        Larry Finger <larry.finger@lwfinger.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, gregkh@linuxfoundation.org,
        Salah Triki <salah.triki@gmail.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] wireless: rtl8187: replace udev with usb_get_dev()
References: <1490129435.403938.1627412276697.ref@mail.yahoo.com>
        <1490129435.403938.1627412276697@mail.yahoo.com>
Date:   Wed, 28 Jul 2021 10:13:25 +0300
In-Reply-To: <1490129435.403938.1627412276697@mail.yahoo.com> (Hin-Tak Leung's
        message of "Tue, 27 Jul 2021 18:57:56 +0000 (UTC)")
Message-ID: <87tukegbca.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hin-Tak Leung <htl10@users.sourceforge.net> writes:

>> BTW, please don't use HTML in emails. Our lists drop all HTML mail (and
>> for a good reason).
>
> Yes, sorry about that (I got a few bounces). Yahoo (where this is
> coming from) seems to make it quite hard to send plain non-html
> e-mails. See if this one gets through.

This one looks ok to me:

Content-Type: text/plain; charset=UTF-8

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
