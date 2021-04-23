Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09457368BCE
	for <lists+netdev@lfdr.de>; Fri, 23 Apr 2021 06:04:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232740AbhDWEFP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Apr 2021 00:05:15 -0400
Received: from so254-9.mailgun.net ([198.61.254.9]:52549 "EHLO
        so254-9.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232098AbhDWEFP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Apr 2021 00:05:15 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1619150679; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=1G7DPv+dUKAyqtSBeEFPxTQF0zmDWYdFqoKBXFZqScw=;
 b=b2kVwz4jk72qHel2iRxWnADWLSft4FRXWS5HzJagwRYTKaD/lDgiO5TtUaY55TRUzu8ZoB+9
 iOufXHZw2THcZNOillSewpeMd3LzbolvLI4l1vGwtTLx+ZK0nn2/YmIBWhyLWKHSF7HRbQyW
 /Q1sTeZmis5wfIqhASYNBAMaBW0=
X-Mailgun-Sending-Ip: 198.61.254.9
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n05.prod.us-east-1.postgun.com with SMTP id
 6082473f03cfff3452186585 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Fri, 23 Apr 2021 04:04:15
 GMT
Sender: subashab=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 92A37C4338A; Fri, 23 Apr 2021 04:04:14 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00
        autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: subashab)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id F0901C433F1;
        Fri, 23 Apr 2021 04:04:13 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Thu, 22 Apr 2021 22:04:13 -0600
From:   subashab@codeaurora.org
To:     Bjorn Andersson <bjorn.andersson@linaro.org>
Cc:     Alex Elder <elder@linaro.org>,
        Sean Tranchetti <stranche@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Daniele Palmas <dnlplm@gmail.com>,
        Aleksander Morgado <aleksander@aleksander.es>,
        Loic Poulain <loic.poulain@linaro.org>
Subject: Re: [PATCH] net: qualcomm: rmnet: Allow partial updates of IFLA_FLAGS
In-Reply-To: <20210423023026.GD1908499@yoga>
References: <20210422182045.1040966-1-bjorn.andersson@linaro.org>
 <76db0c51-15be-2d27-00a7-c9f8dc234816@linaro.org>
 <89526b9845cc86143da2221fc2445557@codeaurora.org>
 <20210423023026.GD1908499@yoga>
Message-ID: <7291b240853fbf1fc6dbdc30fe4f6743@codeaurora.org>
X-Sender: subashab@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> I recently posted a patch to iproute2 extending the rmnet link handling
> to handle IFLA_RMNET_FLAGS, in the discussion that followed this 
> subject
> came up. So nothing is broken, it's just that the current logic doesn't
> make sense and I wanted to attempt to fix it before we start to use it
> commonly distributed userspace software (iproute2, libqmi etc)

With this patch, passing IFLA_RMNET_FLAGS in newlink vs changelink will 
have
different behavior. Is that inline with your expectations.

I checked VLAN and it seems to be using the same behavior for both the 
operations.
While the patch itself is fine, I don't think its right to have 
different
behavior for the operations.

> Okay, please let me know what hoops you want me to jump through. I just
> want the subject concluded so that I can respin my iproute2 patch
> according to what we decide here.

My suggestion is to have the subject prefix as [PATCH net-next] since 
this
is an enhancement rather than fixing something which is broken.
