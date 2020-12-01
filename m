Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D81582CAD41
	for <lists+netdev@lfdr.de>; Tue,  1 Dec 2020 21:26:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731215AbgLAUZ3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Dec 2020 15:25:29 -0500
Received: from mail-ed1-f68.google.com ([209.85.208.68]:44136 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727165AbgLAUZ3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Dec 2020 15:25:29 -0500
Received: by mail-ed1-f68.google.com with SMTP id l5so5292521edq.11;
        Tue, 01 Dec 2020 12:25:12 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ZeQhgtJymCHCi7xcHFwnekowg0dZ1ylay8OPyOYHius=;
        b=qmVKsV2FT9xQze06YSbIRlU9y86vMHFZspH7s8oREuI/BHL8eaWFRii3lMaOjb3gKe
         9qJMHDH83P6Uy+cCZTAEMpMRlS9rLrwisYncIDbF3RWAOKxxzg77Qi9/TQp3Qf3Q2ApE
         KV0S8RijG5OwTym6lcCeGM5dIjvFMUEjrf8AC+nA7wLLVY/lbQ8czq119Ok96X+MncIs
         8/LzJqbU4OYAxEN1iYsGcEoLS8gDbtMQv2xdfGg972ApXyUlUMm4jOIuMkdFyDeRDqn+
         1/CqH3QEXyJRRAWV9FqJFm1jqToL+fiQL0Um+eMSwcosTvL5jGi2LLhIdPP6Ueq9h1o+
         9f6g==
X-Gm-Message-State: AOAM531yPa1Wx5G4iF4xLwRL3Q4NEE1QyU3oX2EJfv8Nuu4ZE/nntYQa
        ezxzllB8z9ETSck0dnWAhwU=
X-Google-Smtp-Source: ABdhPJzQqqaHsg2yWf3EuAlhpDz+JHiuWbYCBZowD4C6Nrak+YQb7+xuF0eHcD3V2hn6nxyq+25Bgw==
X-Received: by 2002:a50:e00b:: with SMTP id e11mr1883546edl.303.1606854285637;
        Tue, 01 Dec 2020 12:24:45 -0800 (PST)
Received: from kozik-lap (adsl-84-226-167-205.adslplus.ch. [84.226.167.205])
        by smtp.googlemail.com with ESMTPSA id n15sm351278eje.112.2020.12.01.12.24.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Dec 2020 12:24:44 -0800 (PST)
Date:   Tue, 1 Dec 2020 22:24:43 +0200
From:   Krzysztof Kozlowski <krzk@kernel.org>
To:     Bongsu Jeon <bongsu.jeon2@gmail.com>
Cc:     linux-nfc@lists.01.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bongsu Jeon <bongsu.jeon@samsung.com>
Subject: Re: [PATCH v4 net-next 4/4] nfc: s3fwrn5: Support a UART interface
Message-ID: <20201201202443.GD2435@kozik-lap>
References: <1606830628-10236-1-git-send-email-bongsu.jeon@samsung.com>
 <1606830628-10236-5-git-send-email-bongsu.jeon@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1606830628-10236-5-git-send-email-bongsu.jeon@samsung.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 01, 2020 at 10:50:28PM +0900, Bongsu Jeon wrote:
> From: Bongsu Jeon <bongsu.jeon@samsung.com>
> 
> Since S3FWRN82 NFC Chip, The UART interface can be used.
> S3FWRN82 uses NCI protocol and supports I2C and UART interface.
> 
> Signed-off-by: Bongsu Jeon <bongsu.jeon@samsung.com>
> ---
>  drivers/nfc/s3fwrn5/Kconfig      |  12 +++
>  drivers/nfc/s3fwrn5/Makefile     |   2 +
>  drivers/nfc/s3fwrn5/phy_common.c |  12 +++
>  drivers/nfc/s3fwrn5/phy_common.h |   1 +
>  drivers/nfc/s3fwrn5/uart.c       | 196 +++++++++++++++++++++++++++++++++++++++
>  5 files changed, 223 insertions(+)
>  create mode 100644 drivers/nfc/s3fwrn5/uart.c
> 

Reviewed-by: Krzysztof Kozlowski <krzk@kernel.org>

Best regards,
Krzysztof
