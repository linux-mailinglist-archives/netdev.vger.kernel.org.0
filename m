Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2788A3ABCED
	for <lists+netdev@lfdr.de>; Thu, 17 Jun 2021 21:35:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233666AbhFQTh0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Jun 2021 15:37:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233599AbhFQThX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Jun 2021 15:37:23 -0400
Received: from ms.lwn.net (ms.lwn.net [IPv6:2600:3c01:e000:3a1::42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13F2FC061574;
        Thu, 17 Jun 2021 12:35:15 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:281:8300:104d:444a:d152:279d:1dbb])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ms.lwn.net (Postfix) with ESMTPSA id A93469A9;
        Thu, 17 Jun 2021 19:35:14 +0000 (UTC)
DKIM-Filter: OpenDKIM Filter v2.11.0 ms.lwn.net A93469A9
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=lwn.net; s=20201203;
        t=1623958514; bh=Ob76x7fxQDpyGJnHa31xoDRYOIjUeb2UTOSmumypFGM=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=Wl987n+7qTGE/KOM2prVX9YDpbSt8wwuxgz0twwMYYpUJfEgudq12x+JUN63FHKBC
         CtHRaIFZiFgQfgOh2IGa26RFx/+yx5WFl1FJ3X9RmhWnPhOTok8vOP8kjPHWKONWZZ
         J9uKe8iXDnLzd3wYdgPwEZITwVLlffEj9pCjBHFFV8FbAIBnjAl54FTCMJdEVGZLRi
         8qrb9j/kiT9YV85XXtje09nGoQZCBZ+HlYUIYKCAsrnZj5XL4gk0A0zDK8yV1vdlAU
         y7uxQWkMhnNl/RQMgdBd0wpzPDnRSWUieK0ts+R755yHXeeIfQfoRF3d5zda2F/niH
         07rNDop6MQbfA==
From:   Jonathan Corbet <corbet@lwn.net>
To:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Theodore Ts'o <tytso@mit.edu>,
        Alan Stern <stern@rowland.harvard.edu>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        Jakub Kicinski <kuba@kernel.org>, Leo Yan <leo.yan@linaro.org>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Mike Leach <mike.leach@linaro.org>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Thorsten Leemhuis <linux@leemhuis.info>,
        coresight@lists.linaro.org, intel-wired-lan@lists.osuosl.org,
        linux-arm-kernel@lists.infradead.org, linux-ext4@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH 0/8] Replace some bad characters on documents
In-Reply-To: <cover.1623826294.git.mchehab+huawei@kernel.org>
References: <cover.1623826294.git.mchehab+huawei@kernel.org>
Date:   Thu, 17 Jun 2021 13:35:14 -0600
Message-ID: <87lf78thcd.fsf@meer.lwn.net>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Mauro Carvalho Chehab <mchehab+huawei@kernel.org> writes:

> Hi Jon,
>
> This series contain the remaining 8 patches I submitted at v3 that
> weren't merged yet at -next.
>
> This series is rebased on the top of your docs-next branch.
>
> No changes here, except by some Reviewed/ack lines, and at the
> name of the final patch (per PCI maintainer's request).

Applied, thanks.

jon
