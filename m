Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C60848BD13
	for <lists+netdev@lfdr.de>; Wed, 12 Jan 2022 03:21:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348398AbiALCVG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jan 2022 21:21:06 -0500
Received: from mail-ot1-f48.google.com ([209.85.210.48]:35441 "EHLO
        mail-ot1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236391AbiALCVF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jan 2022 21:21:05 -0500
Received: by mail-ot1-f48.google.com with SMTP id 60-20020a9d0142000000b0059103eb18d4so985506otu.2;
        Tue, 11 Jan 2022 18:21:05 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=qSz9nqMvLNyS6aeY5fUaSL26SyAlQ9l55+SxfRywHfw=;
        b=40fA9/TeVvFbsUjMfZcNmR/1giV9vDboxa9n3iwG4h5O89n9zrbafk2KnoKE4CwceQ
         DnWC+PY4RNLPp3cOltskDvzesh6AldCwer5qldhxAoDiapadfkpwfcsWmjRajMGriHbx
         87uwW9eTMYz9q3NRB84Zi5C6ZwdHkps0NXgm2mkwwCzo0SjmKOqxEae3g9HnFN9xP9zG
         WY/Haq4pEuSofk47AIRoSQdoYeDHObYwtFkx9ECsSknguMmQgmgfFAVDbl54p7Op9xae
         6G126hDZky4TnTsGx/LmYQ9ZEw39IoO+POPU49onkcYHlnM7s3T5yHcCY7B1C90q05EW
         b7vw==
X-Gm-Message-State: AOAM533RiyxMxNhjp7FrlX14Fd7h+dV0I11f1nvD/UtkllcI+ajwA5ZO
        fu+Rjisi93bKi8ILyzGhjKe6b7cVrw==
X-Google-Smtp-Source: ABdhPJxI82YkGfNmAqCIMJ/wSuUgCxzRZYE5VokdiLCTNQR4r9d1Ns1/A+MGaXe+wOOZUsTN0zDyfw==
X-Received: by 2002:a9d:6452:: with SMTP id m18mr1492762otl.99.1641954064626;
        Tue, 11 Jan 2022 18:21:04 -0800 (PST)
Received: from robh.at.kernel.org (66-90-148-213.dyn.grandenetworks.net. [66.90.148.213])
        by smtp.gmail.com with ESMTPSA id d21sm668955oti.5.2022.01.11.18.21.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Jan 2022 18:21:04 -0800 (PST)
Received: (nullmailer pid 3943654 invoked by uid 1000);
        Wed, 12 Jan 2022 02:21:03 -0000
Date:   Tue, 11 Jan 2022 20:21:03 -0600
From:   Rob Herring <robh@kernel.org>
To:     Abhishek Kumar <kuabhs@chromium.org>
Cc:     devicetree@vger.kernel.org, netdev@vger.kernel.org,
        pillair@codeaurora.org, Kalle Valo <kvalo@kernel.org>,
        linux-wireless@vger.kernel.org, ath10k@lists.infradead.org,
        "David S. Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>, dianders@chromium.org,
        kvalo@codeaurora.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/2] dt: bindings: add dt entry for ath10k default BDF
 name
Message-ID: <Yd47D9GjbAFaWXEo@robh.at.kernel.org>
References: <20220110231255.v2.1.Ie4dcc45b0bf365077303c596891d460d716bb4c5@changeid>
 <20220110231255.v2.2.Ia0365467994f8f9085c86b5674b57ff507c669f8@changeid>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220110231255.v2.2.Ia0365467994f8f9085c86b5674b57ff507c669f8@changeid>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 10 Jan 2022 23:14:15 +0000, Abhishek Kumar wrote:
> It is possible that BDF name with board-id+chip-id+variant
> combination is not found in the board-2.bin. Such cases can
> cause wlan probe to fail and completely break wifi. In such
> case there can be an optional property to define a default
> BDF name to search for in the board-2.bin file when none of
> the combinations (board-id,chip-id,variant) match.
> To address the above concern provide an optional proptery:
> qcom,ath10k-default-bdf
> 
> Signed-off-by: Abhishek Kumar <kuabhs@chromium.org>
> ---
> 
> Changes in v2:
>  - Changes in v2: none
> 
>  .../devicetree/bindings/net/wireless/qcom,ath10k.txt          | 4 ++++
>  1 file changed, 4 insertions(+)
> 

Acked-by: Rob Herring <robh@kernel.org>
