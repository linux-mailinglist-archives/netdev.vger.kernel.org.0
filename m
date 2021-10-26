Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3982B43B749
	for <lists+netdev@lfdr.de>; Tue, 26 Oct 2021 18:35:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237240AbhJZQh3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Oct 2021 12:37:29 -0400
Received: from ixit.cz ([94.230.151.217]:42520 "EHLO ixit.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234592AbhJZQh3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 Oct 2021 12:37:29 -0400
Received: from [192.168.1.138] (ip-89-176-96-70.net.upcbroadband.cz [89.176.96.70])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by ixit.cz (Postfix) with ESMTPSA id 954A120064;
        Tue, 26 Oct 2021 18:35:02 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ixit.cz; s=dkim;
        t=1635266103;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=8fr7ndrif8RuY1aG50GzeXeDYYcUHRvM0D960wCEk6o=;
        b=vj6Ut5G9kXhB1d4oFsybC9gAwBDV6Dq7sSdToDXZLHyu8X8bofBM9FWUbr92+9IZTSlZVH
        V4tUHES+85LGDkZyCjOYQRHOUBm/yBelTmP5uEuBFSUO32Y3AEoAZ996RPIQBY+/YPBt4U
        4/sZgiX3PnJqIy+sge/r4Mg4tV9uOa8=
Date:   Tue, 26 Oct 2021 18:34:56 +0200
From:   David Heidelberg <david@ixit.cz>
Subject: Re: [PATCH 1/2] dt-bindings: net: qcom,ipa: describe IPA v4.5
 interconnects
To:     Alex Elder <elder@ieee.org>
Cc:     Andy Gross <agross@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Alex Elder <elder@kernel.org>, ~okias/devicetree@lists.sr.ht,
        linux-arm-msm@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Message-Id: <9EFL1R.K76GY0WXZ00T2@ixit.cz>
In-Reply-To: <52362729-032b-e9e2-bbb9-663b1d566b37@ieee.org>
References: <20211020225435.274628-1-david@ixit.cz>
        <05b2cc69-d8a4-750d-d98d-db8580546a15@ieee.org>
        <C9217CCA-1A9B-40DC-9A96-13655270BA8F@ixit.cz>
        <52362729-032b-e9e2-bbb9-663b1d566b37@ieee.org>
X-Mailer: geary/40.0
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

sent fixed version "[PATCH v2] dt-bindings: net: qcom,ipa: IPA does 
support up to two iommus".

Thank you Alex

David

P.S. I have some basic structure for qcom,smp2p.yaml, but to make it 
right take some effort. If someone want to, I can send it as WIP or 
just into private email.
Best regards
David Heidelberg

On Tue, Oct 26 2021 at 09:17:43 -0500, Alex Elder <elder@ieee.org> 
wrote:
> On 10/21/21 5:11 PM, David Heidelberg wrote:
>> Hello Alex,
>> 
>> it's make dtbs_check (for me with ARCH=arm)
>> 
>> David
> 
> Thank you, I see the errors now.  I am gathering information
> so I can fix the interconnect issue for IPA v4.5 (SDX55).
> 
> Your other suggested change (increasing the allowed number of
> iommus) is the right thing to do, but it seems you need to
> specify "minItems = 1" as well to avoid the error Rob pointed
> out.  You should post version two of that patch (only), or if
> you would prefer I do that, say so.
> 
> Another error that shows up is that no "qcom,smp2p" schema
> matches.  I'm pretty sure that's simply because the binding
> "soc/qcom/qcom,smp2p.txt" has not bee converted to YAML.
> 
> 					-Alex


