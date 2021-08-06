Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 449583E2655
	for <lists+netdev@lfdr.de>; Fri,  6 Aug 2021 10:47:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243487AbhHFIra (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Aug 2021 04:47:30 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:10087 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231572AbhHFIr3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 6 Aug 2021 04:47:29 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1628239634; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=Ana7UmuqR+Bk0VGuXemplEABFtFk/iLk/wuJCyedqS0=;
 b=VsvFjM0gcU8tBsrCI8BnZIjNz/a7lqnjkEdMgceLUm5hh1wWqVYSzk6vOMyvF0PiQ5IUeVJ0
 FtovypUezSy9EnxqkO8dd6e1tB6BbddToxC5LqMq4iWAOF0M4ng+JVkKip8sbByXXaQWXlh3
 grRLSVVVXKAnYRNf4e8AIvK5xaA=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n03.prod.us-east-1.postgun.com with SMTP id
 610cf711ad1af63949ce7b33 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Fri, 06 Aug 2021 08:47:13
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 5A1C1C43460; Fri,  6 Aug 2021 08:47:12 +0000 (UTC)
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
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 0A9CAC433F1;
        Fri,  6 Aug 2021 08:47:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 0A9CAC433F1
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 27/54] dt-bindings: net: wireless: Convert ESP ESP8089
 binding
 to a schema
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20210721140424.725744-28-maxime@cerno.tech>
References: <20210721140424.725744-28-maxime@cerno.tech>
To:     Maxime Ripard <maxime@cerno.tech>
Cc:     Chen-Yu Tsai <wens@csie.org>, Maxime Ripard <maxime@cerno.tech>,
        Jernej Skrabec <jernej.skrabec@siol.net>,
        devicetree@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        Frank Rowand <frowand.list@gmail.com>,
        linux-arm-kernel@lists.infradead.org, linux-sunxi@googlegroups.com,
        "David S. Miller" <davem@davemloft.net>,
        de Goede <hdegoede@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-Id: <20210806084712.5A1C1C43460@smtp.codeaurora.org>
Date:   Fri,  6 Aug 2021 08:47:12 +0000 (UTC)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Maxime Ripard <maxime@cerno.tech> wrote:

> The ESP8089 Wireless Chip is supported by Linux (through an out-of-tree
> driver) thanks to its device tree binding.
> 
> Now that we have the DT validation in place, let's convert the device
> tree bindings for that driver over to a YAML schema.
> 
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: de Goede <hdegoede@redhat.com>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: Kalle Valo <kvalo@codeaurora.org>
> Cc: linux-wireless@vger.kernel.org
> Cc: netdev@vger.kernel.org
> Signed-off-by: Maxime Ripard <maxime@cerno.tech>
> Reviewed-by: Rob Herring <robh@kernel.org>

We support out-of-tree drivers in DT?  Via which tree is this supposed to go? I
guess not via wireless-drivers-next as this is an out-of-tree driver.

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20210721140424.725744-28-maxime@cerno.tech/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

