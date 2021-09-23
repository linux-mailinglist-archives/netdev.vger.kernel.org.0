Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2DF54163EC
	for <lists+netdev@lfdr.de>; Thu, 23 Sep 2021 19:10:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242476AbhIWRLb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Sep 2021 13:11:31 -0400
Received: from mail-oo1-f49.google.com ([209.85.161.49]:42722 "EHLO
        mail-oo1-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242239AbhIWRLa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Sep 2021 13:11:30 -0400
Received: by mail-oo1-f49.google.com with SMTP id u15-20020a4a970f000000b0029aed4b0e4eso2352158ooi.9;
        Thu, 23 Sep 2021 10:09:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=aRKOgb/IptW6U1Mvub3XjCFxU2/8lUJIfk6QZum3jmM=;
        b=4xCLeJ6u/hLAL6mGgnQMNNJpk6UEZQLEISjlJIButE+VmzNpVaH9OVId7sz1weaeo4
         rWD5crJ0kL7tERIu0GxyERejOnkD/T6+AnOXz76ufqdUv5JCHCIP38UAME9lxwgj3D9X
         Jnihg3t40LB+acQq1j/mMPRjxWRmEuv/2+0DwsXkXHGvmE5aVL5/fOVJX4vKmM5LY0gZ
         byf4ykttEuY2f4TvSlMgBTqAgcikekw3yMJjIvXL48XsoLIGt3dI7N1hTjVAYtQ4fRdC
         Gi08CBKtcl++6wQQt7GaWu2RQu4T1QZoeowT0hUEB4e9MOvN/WFEIjsJp8Q97dnD8eCh
         +6kA==
X-Gm-Message-State: AOAM532ho7mnee1TxBDl5gBeZF/tZBTyFqG/cRzifOvcrt1kAJWPQ45a
        Z5XiVXL88BEAJL+8oM16Z//3ztFioQ==
X-Google-Smtp-Source: ABdhPJw676lPJ7r9WEiBbldf9ALqBQhp0Wdivqz9FvDU+aldnL2DEOFeYcGq580EGuIyBGC7VXj2ZA==
X-Received: by 2002:a4a:ba90:: with SMTP id d16mr2406809oop.31.1632416998498;
        Thu, 23 Sep 2021 10:09:58 -0700 (PDT)
Received: from robh.at.kernel.org (66-90-148-213.dyn.grandenetworks.net. [66.90.148.213])
        by smtp.gmail.com with ESMTPSA id v16sm1453551oiv.23.2021.09.23.10.09.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Sep 2021 10:09:57 -0700 (PDT)
Received: (nullmailer pid 3183978 invoked by uid 1000);
        Thu, 23 Sep 2021 17:09:56 -0000
Date:   Thu, 23 Sep 2021 12:09:56 -0500
From:   Rob Herring <robh@kernel.org>
To:     Jerome Pouiller <Jerome.Pouiller@silabs.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Kalle Valo <kvalo@codeaurora.org>, netdev@vger.kernel.org,
        =?iso-8859-1?B?Suly9G1l?= Pouiller <jerome.pouiller@silabs.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Pali =?iso-8859-1?Q?Roh=E1r?= <pali@kernel.org>,
        devel@driverdev.osuosl.org, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ulf Hansson <ulf.hansson@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        linux-wireless@vger.kernel.org, devicetree@vger.kernel.org
Subject: Re: [PATCH v7 02/24] dt-bindings: introduce silabs,wfx.yaml
Message-ID: <YUy05Kn2iCCBC6AF@robh.at.kernel.org>
References: <20210920161136.2398632-1-Jerome.Pouiller@silabs.com>
 <20210920161136.2398632-3-Jerome.Pouiller@silabs.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210920161136.2398632-3-Jerome.Pouiller@silabs.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 20 Sep 2021 18:11:14 +0200, Jerome Pouiller wrote:
> From: Jérôme Pouiller <jerome.pouiller@silabs.com>
> 
> Prepare the inclusion of the wfx driver in the kernel.
> 
> Signed-off-by: Jérôme Pouiller <jerome.pouiller@silabs.com>
> ---
>  .../bindings/net/wireless/silabs,wfx.yaml     | 133 ++++++++++++++++++
>  1 file changed, 133 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/net/wireless/silabs,wfx.yaml
> 

Reviewed-by: Rob Herring <robh@kernel.org>
