Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E84421C3573
	for <lists+netdev@lfdr.de>; Mon,  4 May 2020 11:20:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728347AbgEDJUv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 May 2020 05:20:51 -0400
Received: from mail26.static.mailgun.info ([104.130.122.26]:37831 "EHLO
        mail26.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727824AbgEDJUu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 May 2020 05:20:50 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1588584049; h=Content-Type: MIME-Version: Message-ID:
 In-Reply-To: Date: References: Subject: Cc: To: From: Sender;
 bh=z3mUepLM3WsniLD5TRfWqfHrgRQVjA/uOj1ZMRdcoTI=; b=rSaKLR3UzmlldXGKkVTC9viz3w2KbfS6bwr5v37qisJ6RJh1pwBaYNYr222a+adnI6CrSvwG
 ibjm7nIgGm6LQcrF2UEtL+XRh/zE37dc8Y9ipKUbT3cyT0mk+AnS4upbQAZvag3u4M9lNyJg
 HdKKdU8AW2agC8uzurB6gmeiA6Y=
X-Mailgun-Sending-Ip: 104.130.122.26
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171])
 by mxa.mailgun.org with ESMTP id 5eafde71.7f63f130a0a0-smtp-out-n03;
 Mon, 04 May 2020 09:20:49 -0000 (UTC)
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id CF21FC433BA; Mon,  4 May 2020 09:20:47 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=2.0 tests=ALL_TRUSTED,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 7A56BC433D2;
        Mon,  4 May 2020 09:20:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 7A56BC433D2
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Cc:     Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Stanislav Yakovlev <stas.yakovlev@gmail.com>,
        netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 24/37] docs: networking: device drivers: convert intel/ipw2100.txt to ReST
References: <cover.1588344146.git.mchehab+huawei@kernel.org>
        <9f8e6ca792b65b691fadafc5a1f20de20b4f7c6f.1588344146.git.mchehab+huawei@kernel.org>
Date:   Mon, 04 May 2020 12:20:42 +0300
In-Reply-To: <9f8e6ca792b65b691fadafc5a1f20de20b4f7c6f.1588344146.git.mchehab+huawei@kernel.org>
        (Mauro Carvalho Chehab's message of "Fri, 1 May 2020 16:44:46 +0200")
Message-ID: <87lfm8dpjp.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Mauro Carvalho Chehab <mchehab+huawei@kernel.org> writes:

> - add SPDX header;
> - adjust titles and chapters, adding proper markups;
> - comment out text-only TOC from html/pdf output;
> - use copyright symbol;
> - use :field: markup;
> - mark code blocks and literals as such;
> - mark tables as such;
> - adjust identation, whitespaces and blank lines where needed;
> - add to networking/index.rst.
>
> Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>

Acked-by: Kalle Valo <kvalo@codeaurora.org>

-- 
https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
