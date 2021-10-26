Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F380E43B7CC
	for <lists+netdev@lfdr.de>; Tue, 26 Oct 2021 19:02:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237670AbhJZREm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Oct 2021 13:04:42 -0400
Received: from ixit.cz ([94.230.151.217]:43048 "EHLO ixit.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237663AbhJZREl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 Oct 2021 13:04:41 -0400
Received: from [192.168.1.138] (ip-89-176-96-70.net.upcbroadband.cz [89.176.96.70])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by ixit.cz (Postfix) with ESMTPSA id 7153320064;
        Tue, 26 Oct 2021 19:02:13 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ixit.cz; s=dkim;
        t=1635267734;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Yr9uhClX24/LPzr3j28xMSkldVyzrS/jPB9TXwItW/Q=;
        b=Yh5h1/PdyDWYWMmGnNH2FK2FhyIlEnkwGw/C5a4HremTpgkN5mF+shIUq80pTLKyljAKVi
        0rbvXGc7e4SnG0rbRzaZlDW1ksWR91fy6mltEPxmWSeL0mi77v4wuRJgqzz9y47YhsqY74
        FYU1fCsxFsOBNdo6eg+N3BR5FASsJJs=
Date:   Tue, 26 Oct 2021 19:02:07 +0200
From:   David Heidelberg <david@ixit.cz>
Subject: Re: [PATCH v2] dt-bindings: net: qcom,ipa: IPA does support up to two
 iommus
To:     Alex Elder <elder@ieee.org>
Cc:     Andy Gross <agross@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Alex Elder <elder@kernel.org>, ~okias/devicetree@lists.sr.ht,
        linux-arm-msm@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Message-Id: <JNGL1R.U8OWUCOV58262@ixit.cz>
In-Reply-To: <2de53575-af6e-5bb9-e7ad-5d924656867d@ieee.org>
References: <20211026163240.131052-1-david@ixit.cz>
        <2de53575-af6e-5bb9-e7ad-5d924656867d@ieee.org>
X-Mailer: geary/40.0
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

thanks, I'll try to work on my commit messages :)

David


On Tue, Oct 26 2021 at 11:47:46 -0500, Alex Elder <elder@ieee.org> 
wrote:
> On 10/26/21 11:32 AM, David Heidelberg wrote:
>> Fix warnings as:
>> arch/arm/boot/dts/qcom-sdx55-mtp.dt.yaml: ipa@1e40000: iommus: [[21, 
>> 1504, 0], [21, 1506, 0]] is too long
>> 	From schema: Documentation/devicetree/bindings/net/qcom,ipa.yaml
>> 
>> Signed-off-by: David Heidelberg <david@ixit.cz>
> 
> Looks good to me.  I'm not sure why the minItems is required,
> unless it's to indicate that it must be at least 1 and can't
> be missing.  But iommus is also stated to be required elsewhere
> in the binding.
> 
> In the future, it's helpful to indicate the command you
> used to produce the warning in your commit message.  And
> furthermore, describing the problem (and not just including
> the error message) is even more helpful.
> 
> Reviewed-by: Alex Elder <elder@linaro.org>
> 
>> ---
>>   Documentation/devicetree/bindings/net/qcom,ipa.yaml | 3 ++-
>>   1 file changed, 2 insertions(+), 1 deletion(-)
>> 
>> diff --git a/Documentation/devicetree/bindings/net/qcom,ipa.yaml 
>> b/Documentation/devicetree/bindings/net/qcom,ipa.yaml
>> index b8a0b392b24e..b86edf67ce62 100644
>> --- a/Documentation/devicetree/bindings/net/qcom,ipa.yaml
>> +++ b/Documentation/devicetree/bindings/net/qcom,ipa.yaml
>> @@ -64,7 +64,8 @@ properties:
>>         - const: gsi
>>       iommus:
>> -    maxItems: 1
>> +    minItems: 1
>> +    maxItems: 2
>>       clocks:
>>       maxItems: 1
>> 
> 


