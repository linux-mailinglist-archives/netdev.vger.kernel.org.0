Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E05C7346D73
	for <lists+netdev@lfdr.de>; Tue, 23 Mar 2021 23:43:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234007AbhCWWnN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Mar 2021 18:43:13 -0400
Received: from mail-il1-f182.google.com ([209.85.166.182]:46007 "EHLO
        mail-il1-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233781AbhCWWmy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Mar 2021 18:42:54 -0400
Received: by mail-il1-f182.google.com with SMTP id v3so19673152ilj.12;
        Tue, 23 Mar 2021 15:42:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=KVmKCSdOdE0heS6y/Cbbfc/TApG4WjUWKfbAhWrSGbs=;
        b=KGcOVs114XCQYsJZpd2UiCd4AurFCr2q63UHwgj7cUsm+YFzYXqSE+9esjcR8njHsm
         GSWtKmUnVacNjhkM05W/uRjZ9t6hX2uscomDoRSfSUMd8dRke5KIzKMyRKoYfThOTrtZ
         /KRQ76jbykRmR2U06FFeDhyiZ6N18tpjc4B6EysGWOMT16ME2Ooqfl9IdmjsxHdXCgeo
         gZ7/X5zfvJYtVWupIPnRtQUg2WQPmNOdA4HJWsh3iVvPd39xdLpPmnlGKfbz01dvoEMx
         Uhb5JfXx4CsfnICd4vsy9y0YKgt9jWw9t2L+06S4E/KZJ3uvh7987mrs/UCNSvqKOBPB
         KuDg==
X-Gm-Message-State: AOAM533+T9vqNAycDV9xx18VZI+AUZxvM0VpenZodXzEcq4zVNIkI4eT
        +1juWOkYvxm6PsI3w8Tb6Q==
X-Google-Smtp-Source: ABdhPJwBk7tZXg9j0xfN8xEAYZDHN4Zew5Ma8PpLvYQTNKrWQj5/xQRmwUlUtQCNdhtaFJhzACwpBw==
X-Received: by 2002:a92:b00d:: with SMTP id x13mr391816ilh.128.1616539373579;
        Tue, 23 Mar 2021 15:42:53 -0700 (PDT)
Received: from robh.at.kernel.org ([64.188.179.253])
        by smtp.gmail.com with ESMTPSA id s9sm110713iob.33.2021.03.23.15.42.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Mar 2021 15:42:52 -0700 (PDT)
Received: (nullmailer pid 1483403 invoked by uid 1000);
        Tue, 23 Mar 2021 22:42:49 -0000
Date:   Tue, 23 Mar 2021 16:42:49 -0600
From:   Rob Herring <robh@kernel.org>
To:     Jerome Pouiller <Jerome.Pouiller@silabs.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        linux-mmc@vger.kernel.org,
        Pali =?iso-8859-1?Q?Roh=E1r?= <pali@kernel.org>,
        linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org,
        devel@driverdev.osuosl.org, netdev@vger.kernel.org,
        Ulf Hansson <ulf.hansson@linaro.org>,
        linux-wireless@vger.kernel.org, Kalle Valo <kvalo@codeaurora.org>
Subject: Re: [PATCH v5 02/24] dt-bindings: introduce silabs,wfx.yaml
Message-ID: <20210323224249.GA1483296@robh.at.kernel.org>
References: <20210315132501.441681-1-Jerome.Pouiller@silabs.com>
 <20210315132501.441681-3-Jerome.Pouiller@silabs.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210315132501.441681-3-Jerome.Pouiller@silabs.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 15 Mar 2021 14:24:39 +0100, Jerome Pouiller wrote:
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
