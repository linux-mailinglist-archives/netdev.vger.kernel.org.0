Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5653848BC5F
	for <lists+netdev@lfdr.de>; Wed, 12 Jan 2022 02:23:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347677AbiALBXV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jan 2022 20:23:21 -0500
Received: from mail-oi1-f182.google.com ([209.85.167.182]:34783 "EHLO
        mail-oi1-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345193AbiALBXV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jan 2022 20:23:21 -0500
Received: by mail-oi1-f182.google.com with SMTP id r131so1511000oig.1;
        Tue, 11 Jan 2022 17:23:21 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Oj0bIidyZ891IsLk3ct5dwWQ0l0CjSdcV42zdySFgTo=;
        b=zASwAt7opQnQBqVz9ckl328US+8+1RpQl8iuGVw7x1+4f9h2oFDdr+uIk+xma6O5yG
         MPbJhdll6Za6aVX0TKLBtMpOukVhY338zPx9SLbrpTH0V6hX36fRfrKwR6kYx/inn6nw
         QYB9/Ytos48+NkMdTORBN14hCJa2HKa8PaE2mqi8XUprAiDQwt0qM5DYh7hICjV50ln3
         jNgWJNCvNYgGLln5Q1hHMq3H72cV73D/U3smsj6T583rWE/u2jNmC77i+UvJNDDZejOE
         ZsU6lp6ouVTA2GIEiv5jrCdEt6HHidCFH75WOH2h0TDuc4/c0i7XNQVk99PvikNNLNmF
         3qgQ==
X-Gm-Message-State: AOAM530rtSDTtivK2T1nbqp9Ixa7Kfv8wISOrAaQEKd1ToPjP9jaXgnq
        UkRccX3AA/2BBf+ONx01vw==
X-Google-Smtp-Source: ABdhPJz3OGkvxE+9XqiM4meX43ZOgmHHNq1PF75N5oI15zV1jOqEICl/ICvu+8fgEYTPOB0FQ8HhxA==
X-Received: by 2002:aca:702:: with SMTP id 2mr3763222oih.44.1641950600806;
        Tue, 11 Jan 2022 17:23:20 -0800 (PST)
Received: from robh.at.kernel.org (66-90-148-213.dyn.grandenetworks.net. [66.90.148.213])
        by smtp.gmail.com with ESMTPSA id n21sm2270531oov.33.2022.01.11.17.23.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Jan 2022 17:23:19 -0800 (PST)
Received: (nullmailer pid 3858676 invoked by uid 1000);
        Wed, 12 Jan 2022 01:23:19 -0000
Date:   Tue, 11 Jan 2022 19:23:19 -0600
From:   Rob Herring <robh@kernel.org>
To:     Neil Armstrong <narmstrong@baylibre.com>
Cc:     kuba@kernel.org, netdev@vger.kernel.org, linux-oxnas@groups.io,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        davem@davemloft.net, devicetree@vger.kernel.org
Subject: Re: [PATCH net-next v2 1/3] dt-bindings: net: oxnas-dwmac: Add
 bindings for OX810SE
Message-ID: <Yd4th9QfJO62KkQC@robh.at.kernel.org>
References: <20220104145646.135877-1-narmstrong@baylibre.com>
 <20220104145646.135877-2-narmstrong@baylibre.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220104145646.135877-2-narmstrong@baylibre.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 04 Jan 2022 15:56:44 +0100, Neil Armstrong wrote:
> Add SoC specific bindings for OX810SE support.
> 
> Signed-off-by: Neil Armstrong <narmstrong@baylibre.com>
> ---
>  Documentation/devicetree/bindings/net/oxnas-dwmac.txt | 3 +++
>  1 file changed, 3 insertions(+)
> 

Acked-by: Rob Herring <robh@kernel.org>
