Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91455412E3F
	for <lists+netdev@lfdr.de>; Tue, 21 Sep 2021 07:35:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229624AbhIUFhR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Sep 2021 01:37:17 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:11175 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229590AbhIUFhQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Sep 2021 01:37:16 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1632202549; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=d/WbfYzCtCLxGjLS1Fn53umG1vTseNrfK0KHCNl2EuE=;
 b=rMPUKIqZPkd4wY/Rp0cYE/fD5P9YF0VhB9bYGAaBUquexp7WX/J+MvJa4sARHMyVTjh0243o
 yy57O8HhDkJraaxiGOptL0JE4J63KP7ELVyfkHrvgBvmFIvXWfSXysGuxm98gWCZ7cz/K2y2
 fT+Kz6k2BFQqd0gLJKXoZkHGdB8=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n04.prod.us-west-2.postgun.com with SMTP id
 61496f1de0f78151d6dd2f18 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Tue, 21 Sep 2021 05:35:25
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id D28BFC43616; Tue, 21 Sep 2021 05:35:25 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        MISSING_DATE,MISSING_MID,SPF_FAIL,URIBL_BLOCKED autolearn=no
        autolearn_force=no version=3.4.0
Received: from tykki.adurom.net (tynnyri.adurom.net [51.15.11.48])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 8E2C5C4338F;
        Tue, 21 Sep 2021 05:35:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.codeaurora.org 8E2C5C4338F
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v2] MAINTAINERS: Move Daniel Drake to credits
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20210917102834.25649-1-krzysztof.kozlowski@canonical.com>
References: <20210917102834.25649-1-krzysztof.kozlowski@canonical.com>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Cc:     Ulrich Kunitz <kune@deine-taler.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org, zd1211-devs@lists.sourceforge.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jens Frederich <jfrederich@gmail.com>,
        Jon Nettleton <jon.nettleton@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-staging@lists.linux.dev,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Daniel Drake <drake@endlessos.org>
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-Id: <20210921053525.D28BFC43616@smtp.codeaurora.org>
Date:   Tue, 21 Sep 2021 05:35:25 +0000 (UTC)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com> wrote:

> Daniel Drake's @gentoo.org email bounces (is listed as retired Gentoo
> developer) and there was no activity from him regarding zd1211rw driver.
> Also his second address @laptop.org bounces.
> 
> Cc: Daniel Drake <drake@endlessos.org>
> Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
> Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

Patch applied to wireless-drivers.git, thanks.

91dab18f0df1 MAINTAINERS: Move Daniel Drake to credits

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20210917102834.25649-1-krzysztof.kozlowski@canonical.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

