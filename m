Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4DC532F3F5
	for <lists+netdev@lfdr.de>; Fri,  5 Mar 2021 20:33:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230175AbhCETdN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Mar 2021 14:33:13 -0500
Received: from mail-oi1-f171.google.com ([209.85.167.171]:34861 "EHLO
        mail-oi1-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229793AbhCETdG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Mar 2021 14:33:06 -0500
Received: by mail-oi1-f171.google.com with SMTP id i21so3745544oii.2;
        Fri, 05 Mar 2021 11:33:06 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=mTwHPyjWfhl1XqUMpjwfPssmNWFoEwKK7SmIVDkyUDE=;
        b=S25odXOvO03OJGt17ffnIea42AmL81oL96EnxF5H57GdgA6uCEQqWSv4mB8ketXwVy
         4y1ljwjJWlxT0R2QEvzMyFWYxkB1FdCHj1wgJRiwEenFe9rUaKx89F0c/0DJobHZQdlZ
         wPpAqLTp2y0DDjKyMTDQblqoNDX0cCK0gYRCExw4n/Onw7yDlVLsns3geluLw3jczIyu
         tdiwBYLbWst3BppxgI56jh8/oik+SZcj67Ium/palz7QZ64no1gVCGcw0OL6QQT9HyuY
         Jyw7w3ufEevmjsyXd1hWQz+02A+6IKLD2IJQPaC4lMw/hFakF6Nyu40CgSTN3WLawvAo
         lUNA==
X-Gm-Message-State: AOAM531s+I1nDrtGGlxz5Q/BxzyJaU+Ys+Kcy6eBZkwnuS0z4vWhP/2u
        d3fzBEQsZ0EaFSXAEwHU3w==
X-Google-Smtp-Source: ABdhPJxqq+Z2SkmbLluH0oPPw9cQNWOmLNg4SefNbcdQUbbXjrwjEkisf0R2JPjz2iiTk2iVJprTVg==
X-Received: by 2002:a54:4590:: with SMTP id z16mr4377479oib.110.1614972786174;
        Fri, 05 Mar 2021 11:33:06 -0800 (PST)
Received: from robh.at.kernel.org (24-155-109-49.dyn.grandenetworks.net. [24.155.109.49])
        by smtp.gmail.com with ESMTPSA id i3sm812358otk.56.2021.03.05.11.33.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Mar 2021 11:33:05 -0800 (PST)
Received: (nullmailer pid 520060 invoked by uid 1000);
        Fri, 05 Mar 2021 19:33:04 -0000
Date:   Fri, 5 Mar 2021 13:33:04 -0600
From:   Rob Herring <robh@kernel.org>
To:     AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@somainline.org>
Cc:     elder@kernel.org, bjorn.andersson@linaro.org, agross@kernel.org,
        davem@davemloft.net, kuba@kernel.org,
        linux-arm-msm@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        konrad.dybcio@somainline.org, marijn.suijten@somainline.org,
        phone-devel@vger.kernel.org
Subject: Re: [PATCH v1 7/7] dt-bindings: net: qcom-ipa: Document
 qcom,msm8998-ipa compatible
Message-ID: <20210305193304.GA519324@robh.at.kernel.org>
References: <20210211175015.200772-1-angelogioacchino.delregno@somainline.org>
 <20210211175015.200772-8-angelogioacchino.delregno@somainline.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210211175015.200772-8-angelogioacchino.delregno@somainline.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 11, 2021 at 06:50:15PM +0100, AngeloGioacchino Del Regno wrote:
> MSM8998 support has been added: document the new compatible.
> 
> Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@somainline.org>
> ---
>  Documentation/devicetree/bindings/net/qcom,ipa.yaml | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/Documentation/devicetree/bindings/net/qcom,ipa.yaml b/Documentation/devicetree/bindings/net/qcom,ipa.yaml
> index b063c6c1077a..9dacd224b606 100644
> --- a/Documentation/devicetree/bindings/net/qcom,ipa.yaml
> +++ b/Documentation/devicetree/bindings/net/qcom,ipa.yaml
> @@ -46,6 +46,7 @@ properties:
>      oneOf:
>        - items:
>            - enum:
> +              - "qcom,msm8998-ipa"

Also, don't need quotes on these.

>                - "qcom,sdm845-ipa"
>                - "qcom,sc7180-ipa"
>  
> -- 
> 2.30.0
> 
