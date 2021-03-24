Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F0B8347C74
	for <lists+netdev@lfdr.de>; Wed, 24 Mar 2021 16:22:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236664AbhCXPWV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Mar 2021 11:22:21 -0400
Received: from mail-il1-f171.google.com ([209.85.166.171]:33623 "EHLO
        mail-il1-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236457AbhCXPVs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Mar 2021 11:21:48 -0400
Received: by mail-il1-f171.google.com with SMTP id u10so21689313ilb.0;
        Wed, 24 Mar 2021 08:21:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=v9vHwBNOXaaVO3941JRMZCIaF11vJvq/t1fnNMRj5iw=;
        b=DGm6MveWi7tIYtNOjhra++M0aFrw9qGjPkNt5/cAXIN+GysO/ZAiGzaMdjF1DPmHrc
         7gJuWj3uUvZkyoMPxpCW/Esx5haSDwXzzh/vaBQCeNMDgYwYNrLqI7tKGHJxuRNBH7Qe
         6VFadq57htwI0NxHYBqaSCmFjbOr9kctJB5fcE55uDDXZ5SG3pPdH5cg2J8ouYBRAY+8
         avvPNgVN128TNSqBAb/FmmIbuepZOFjiwVoFupBQt/RQHT16SPe79sg9KHmT5TBAehfR
         WShVNDHTArp8PyMVzxrysgrrurhg3bXTbY/Z87D6IbcXb2UFlqjbXp7gOvNhWyBcsa/v
         GDAw==
X-Gm-Message-State: AOAM533d2FR2u5e82W8eEt2W3ApvTuS9FYO0N6+3simOqAXiVpGiFmcX
        Pz+WvOGtAedsjQR4x9l6fQ==
X-Google-Smtp-Source: ABdhPJwrUwOWhn6Z3qobK6pxhX275rNJ58QOwnVhjglMbWpaRA936kanfmmnZ3CRX1w5FrR3v253qQ==
X-Received: by 2002:a92:ce88:: with SMTP id r8mr2886737ilo.78.1616599307781;
        Wed, 24 Mar 2021 08:21:47 -0700 (PDT)
Received: from robh.at.kernel.org ([64.188.179.253])
        by smtp.gmail.com with ESMTPSA id z17sm1244379ilz.58.2021.03.24.08.21.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Mar 2021 08:21:46 -0700 (PDT)
Received: (nullmailer pid 3089357 invoked by uid 1000);
        Wed, 24 Mar 2021 15:21:42 -0000
Date:   Wed, 24 Mar 2021 09:21:42 -0600
From:   Rob Herring <robh@kernel.org>
To:     Bjorn Andersson <bjorn.andersson@linaro.org>
Cc:     Kalle Valo <kvalo@codeaurora.org>, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org,
        Bryan O'Donoghue <bryan.odonoghue@linaro.org>,
        wcn36xx@lists.infradead.org, linux-wireless@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, Andy Gross <agross@kernel.org>,
        netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>
Subject: Re: [PATCH 1/5] dt-bindings: soc: qcom: wcnss: Add firmware-name
 property
Message-ID: <20210324152142.GA3089198@robh.at.kernel.org>
References: <20210312003318.3273536-1-bjorn.andersson@linaro.org>
 <20210312003318.3273536-2-bjorn.andersson@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210312003318.3273536-2-bjorn.andersson@linaro.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 11 Mar 2021 16:33:14 -0800, Bjorn Andersson wrote:
> The WCNSS needs firmware which differs between platforms, and possibly
> boards. Add a new property "firmware-name" to allow the DT to specify
> the platform/board specific path to this firmware file.
> 
> Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
> ---
>  Documentation/devicetree/bindings/soc/qcom/qcom,wcnss.txt | 7 +++++++
>  1 file changed, 7 insertions(+)
> 

Acked-by: Rob Herring <robh@kernel.org>
