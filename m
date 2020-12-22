Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5959F2E0ACA
	for <lists+netdev@lfdr.de>; Tue, 22 Dec 2020 14:33:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727164AbgLVNdD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Dec 2020 08:33:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727093AbgLVNdC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Dec 2020 08:33:02 -0500
Received: from mail-il1-x12a.google.com (mail-il1-x12a.google.com [IPv6:2607:f8b0:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AE08C061793
        for <netdev@vger.kernel.org>; Tue, 22 Dec 2020 05:32:22 -0800 (PST)
Received: by mail-il1-x12a.google.com with SMTP id v3so12015872ilo.5
        for <netdev@vger.kernel.org>; Tue, 22 Dec 2020 05:32:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ieee.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=1h+XS3Jpg37m9OWU9Zgfs5kJQZ5F9azt5axjaoAFa+o=;
        b=AZpT2+SASG9nJBeXvpxrCgYcrKqMNKBOKhzbZE3iQHjPReCYhNxsX1FIcoozKiaYV+
         oeNdLumwRlra/kfdUg8dNPyqt/2WT7UP590126MBFhOxbKcmgEHCq97+3rSbF9mHWrD9
         gwwpYdZ711yTLP5cXBBBMF+bczS9F+VvUZUmA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=1h+XS3Jpg37m9OWU9Zgfs5kJQZ5F9azt5axjaoAFa+o=;
        b=BP9if4fV6hxDiwsfRLbgs57Ylbz64fGnS6OrViNufW1+s3XcXeVOZKyMyFWWHG4eNM
         Wbx/F96AHttiw7qVhD9XDkON4FtAjxnlk+U7DNaIR/ann1rYECzAR7jSQ27rn76KOgrH
         FClD8kEkoef1bjnl0cgWPd4jQHOPbra8eeJ1YOlK8oZCvG2FKK+xjuOV531+n2rdPZGg
         SK/5sw/2ZnFc7awn66eNuw/oAYAcNFmlygmzhPtLsNuT/OxTjBRlDESugyl3m2zxYIQZ
         76TmPAQnnoEO/4HP/l/+medVf0KETkvCo2UP3KDIApiZWP/X7ODPJGijkRZKD6QGpbfp
         B5OA==
X-Gm-Message-State: AOAM53269K3ZDzPnrGGJ2+Ep9WhqpPfG874HZBqRigpQNL7Xywx9Pobp
        rADYtEiP2Ng+QFUbEVIYELnjyyhX+QtU7A==
X-Google-Smtp-Source: ABdhPJyQG7N3kXgSBl8zSeDDDpQE2eNi22yYVF7ddAXWlUZNzn4bpdY2d8S070MVCt/SQB5C6Vxhlg==
X-Received: by 2002:a92:b652:: with SMTP id s79mr21318208ili.251.1608643941395;
        Tue, 22 Dec 2020 05:32:21 -0800 (PST)
Received: from [172.22.22.4] (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.googlemail.com with ESMTPSA id o7sm23739687iov.1.2020.12.22.05.32.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Dec 2020 05:32:20 -0800 (PST)
Subject: Re: [PATCH] dt-bindings: net: qcom,ipa: Drop unnecessary type ref on
 'memory-region'
To:     Rob Herring <robh@kernel.org>, devicetree@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alex Elder <elder@kernel.org>, netdev@vger.kernel.org
References: <20201222040121.1314370-1-robh@kernel.org>
From:   Alex Elder <elder@ieee.org>
Message-ID: <8d7ee97e-1730-908f-9576-88950fd59c91@ieee.org>
Date:   Tue, 22 Dec 2020 07:32:20 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <20201222040121.1314370-1-robh@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/21/20 10:01 PM, Rob Herring wrote:
> 'memory-region' is a common property, so it doesn't need a type ref here.

Acked-by: Alex Elder <elder@linaro.org>

> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: Alex Elder <elder@kernel.org>
> Cc: netdev@vger.kernel.org
> Signed-off-by: Rob Herring <robh@kernel.org>
> ---
> I'll take this via the DT tree.
> 
>   Documentation/devicetree/bindings/net/qcom,ipa.yaml | 1 -
>   1 file changed, 1 deletion(-)
> 
> diff --git a/Documentation/devicetree/bindings/net/qcom,ipa.yaml b/Documentation/devicetree/bindings/net/qcom,ipa.yaml
> index d0cbbcf1b0e5..8a2d12644675 100644
> --- a/Documentation/devicetree/bindings/net/qcom,ipa.yaml
> +++ b/Documentation/devicetree/bindings/net/qcom,ipa.yaml
> @@ -121,7 +121,6 @@ properties:
>         receive and act on notifications of modem up/down events.
>   
>     memory-region:
> -    $ref: /schemas/types.yaml#/definitions/phandle-array
>       maxItems: 1
>       description:
>         If present, a phandle for a reserved memory area that holds
> 

