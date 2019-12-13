Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 041FE11DEB9
	for <lists+netdev@lfdr.de>; Fri, 13 Dec 2019 08:37:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725924AbfLMHhU convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 13 Dec 2019 02:37:20 -0500
Received: from coyote.holtmann.net ([212.227.132.17]:59816 "EHLO
        mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725468AbfLMHhU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Dec 2019 02:37:20 -0500
Received: from marcel-macbook.fritz.box (p4FF9F0D1.dip0.t-ipconnect.de [79.249.240.209])
        by mail.holtmann.org (Postfix) with ESMTPSA id F13FBCECF0;
        Fri, 13 Dec 2019 08:46:28 +0100 (CET)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 13.0 \(3608.40.2.2.4\))
Subject: Re: [PATCH v1 2/2] dt-bindings: net: bluetooth: Add device tree
 bindings for QCA6390
From:   Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <ab0557bcacdae61027b775f440145b05@codeaurora.org>
Date:   Fri, 13 Dec 2019 08:37:17 +0100
Cc:     Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, bgodavar@codeaurora.org,
        linux-bluetooth-owner@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <5F24A10B-D0DB-4FE7-8EB1-1028671599FB@holtmann.org>
References: <0101016ef8b923bc-5760b40c-1968-4992-9186-8e3965207236-000000@us-west-2.amazonses.com>
 <24B540FF-C627-4DF9-9077-247A4A6A3605@holtmann.org>
 <ab0557bcacdae61027b775f440145b05@codeaurora.org>
To:     Rocky Liao <rjliao@codeaurora.org>
X-Mailer: Apple Mail (2.3608.40.2.2.4)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Rocky,

>>> Add compatible string for the Qualcomm QCA6390 Bluetooth controller
>>> Signed-off-by: Rocky Liao <rjliao@codeaurora.org>
>>> ---
>>> Documentation/devicetree/bindings/net/qualcomm-bluetooth.txt | 1 +
>>> 1 file changed, 1 insertion(+)
>>> diff --git a/Documentation/devicetree/bindings/net/qualcomm-bluetooth.txt b/Documentation/devicetree/bindings/net/qualcomm-bluetooth.txt
>>> index 68b67d9db63a..87b7f9d22414 100644
>>> --- a/Documentation/devicetree/bindings/net/qualcomm-bluetooth.txt
>>> +++ b/Documentation/devicetree/bindings/net/qualcomm-bluetooth.txt
>>> @@ -10,6 +10,7 @@ device the slave device is attached to.
>>> Required properties:
>>> - compatible: should contain one of the following:
>>>   * "qcom,qca6174-bt"
>>> +   * "qcom,qca6390-bt"
>>>   * "qcom,wcn3990-bt"
>>>   * "qcom,wcn3998-bt"
>> now I am confused. Is this a DT platform or ACPI or both?
> We need to support both, should I update ACPI part in this doc as well?

this patch is fine the, but the other one would be better if you split it in DT and ACPI support.

Regards

Marcel

