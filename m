Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9D4C711DCA4
	for <lists+netdev@lfdr.de>; Fri, 13 Dec 2019 04:40:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726897AbfLMDki (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Dec 2019 22:40:38 -0500
Received: from m228-5.mailgun.net ([159.135.228.5]:47730 "EHLO
        m228-5.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731353AbfLMDki (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Dec 2019 22:40:38 -0500
X-Greylist: delayed 305 seconds by postgrey-1.27 at vger.kernel.org; Thu, 12 Dec 2019 22:40:36 EST
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1576208437; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=yW+1ND7ANM8ah4AyDYZWbcub633HYWOPfgaR0fg0IeY=;
 b=t5ReM5fca6JVbLkKge6XG+paWi7K4kN2hSSCLXoUnDUxa9VhqFE7TBnpI5o81rehWhEBVUUn
 NlMhKGoDvJa8wt9eQWdWdfzVYsb901KupKl5/QXQg/XYmyJAAIibbvKxXfADyZbuRwiLiFJP
 b+P6KESGvSCz8AbYjtJMGcZVGNo=
X-Mailgun-Sending-Ip: 159.135.228.5
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171])
 by mxa.mailgun.org with ESMTP id 5df30702.7fc7ab7a9180-smtp-out-n01;
 Fri, 13 Dec 2019 03:35:30 -0000 (UTC)
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id ECB08C4479C; Fri, 13 Dec 2019 03:35:28 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=2.0 tests=ALL_TRUSTED,URIBL_BLOCKED
        autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: rjliao)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 67C04C43383;
        Fri, 13 Dec 2019 03:35:28 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
Date:   Fri, 13 Dec 2019 11:35:28 +0800
From:   rjliao@codeaurora.org
To:     Marcel Holtmann <marcel@holtmann.org>
Cc:     Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, bgodavar@codeaurora.org,
        linux-bluetooth-owner@vger.kernel.org
Subject: Re: [PATCH v1 2/2] dt-bindings: net: bluetooth: Add device tree
 bindings for QCA6390
In-Reply-To: <24B540FF-C627-4DF9-9077-247A4A6A3605@holtmann.org>
References: <0101016ef8b923bc-5760b40c-1968-4992-9186-8e3965207236-000000@us-west-2.amazonses.com>
 <24B540FF-C627-4DF9-9077-247A4A6A3605@holtmann.org>
Message-ID: <ab0557bcacdae61027b775f440145b05@codeaurora.org>
X-Sender: rjliao@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

在 2019-12-12 18:33，Marcel Holtmann 写道：
> Hi Rocky,
> 
>> Add compatible string for the Qualcomm QCA6390 Bluetooth controller
>> 
>> Signed-off-by: Rocky Liao <rjliao@codeaurora.org>
>> ---
>> Documentation/devicetree/bindings/net/qualcomm-bluetooth.txt | 1 +
>> 1 file changed, 1 insertion(+)
>> 
>> diff --git 
>> a/Documentation/devicetree/bindings/net/qualcomm-bluetooth.txt 
>> b/Documentation/devicetree/bindings/net/qualcomm-bluetooth.txt
>> index 68b67d9db63a..87b7f9d22414 100644
>> --- a/Documentation/devicetree/bindings/net/qualcomm-bluetooth.txt
>> +++ b/Documentation/devicetree/bindings/net/qualcomm-bluetooth.txt
>> @@ -10,6 +10,7 @@ device the slave device is attached to.
>> Required properties:
>>  - compatible: should contain one of the following:
>>    * "qcom,qca6174-bt"
>> +   * "qcom,qca6390-bt"
>>    * "qcom,wcn3990-bt"
>>    * "qcom,wcn3998-bt"
> 
> now I am confused. Is this a DT platform or ACPI or both?
> 
We need to support both, should I update ACPI part in this doc as well?
> Regards
> 
> Marcel
