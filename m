Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 578E92AD1D9
	for <lists+netdev@lfdr.de>; Tue, 10 Nov 2020 09:53:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727658AbgKJIxW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Nov 2020 03:53:22 -0500
Received: from z5.mailgun.us ([104.130.96.5]:20227 "EHLO z5.mailgun.us"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726690AbgKJIxV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Nov 2020 03:53:21 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1604998401; h=Content-Transfer-Encoding: Content-Type:
 MIME-Version: Message-ID: In-Reply-To: Date: References: Subject: Cc:
 To: From: Sender; bh=HqmvUu7PFG5dpHnRXtX9zBQ5lc3G1AT+/blm4ih6cto=; b=gK9irwMI5yGMVl7IcYgAFY/wkceDvzGQrEuUtdpN1xYOVLLs5WvaX6joL0srAyAEJVH/EVFP
 6JSR4W35hAq3eF6o9IB0oVx9PSJfAM9hnlvBAjt6Ie1LPhNBGLDxya4gBNtRmK+0ZeUZS5pa
 bQGDFWbINQxVGcDIS9JBgSzojvk=
X-Mailgun-Sending-Ip: 104.130.96.5
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n02.prod.us-west-2.postgun.com with SMTP id
 5faa54fd18b2aa4b1ff025d3 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Tue, 10 Nov 2020 08:53:17
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 14F61C433FE; Tue, 10 Nov 2020 08:53:17 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL
        autolearn=no autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id C5B3FC433C8;
        Tue, 10 Nov 2020 08:53:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org C5B3FC433C8
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Yejune Deng <yejune.deng@gmail.com>
Cc:     pizza@shaftnet.org, davem@davemloft.net, kuba@kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Replace a set of atomic_add()
References: <1604991491-27908-1-git-send-email-yejune.deng@gmail.com>
        <87mtzpeieb.fsf@codeaurora.org>
        <CABWKuGXdCffiDYqr_TZpkfkMoKRdCMUZ=fDUqkoU=658miQ3AQ@mail.gmail.com>
Date:   Tue, 10 Nov 2020 10:53:12 +0200
In-Reply-To: <CABWKuGXdCffiDYqr_TZpkfkMoKRdCMUZ=fDUqkoU=658miQ3AQ@mail.gmail.com>
        (Yejune Deng's message of "Tue, 10 Nov 2020 16:44:05 +0800")
Message-ID: <877dqtegp3.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Yejune Deng <yejune.deng@gmail.com> writes:

> Oh=EF=BC=8CI was forgetting. thanks.=20

And you should also disable HTML in your emails :) See the wiki link
below for more.

--=20
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatc=
hes
