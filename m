Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3EC948B464
	for <lists+netdev@lfdr.de>; Tue, 11 Jan 2022 18:50:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344572AbiAKRuF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jan 2022 12:50:05 -0500
Received: from mail-ot1-f47.google.com ([209.85.210.47]:35592 "EHLO
        mail-ot1-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242729AbiAKRuD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jan 2022 12:50:03 -0500
Received: by mail-ot1-f47.google.com with SMTP id 60-20020a9d0142000000b0059103eb18d4so2287075otu.2;
        Tue, 11 Jan 2022 09:50:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=SjRe+CkmRLZrog3sEydSnGtCTplRZpNfb1EM1oGQgQ4=;
        b=VpDhPbtmTsDpSO8RJ/T769GIGq0qx9KiU8g2sfKVPyK3Fw8SIH6eaNPqxYq6ohbRW2
         WR8ZknulM1wwDttDFiXuudfvPgM1URMfYh8UfwIViOQj5QMJzcGn59elrSyiOsZmn9hR
         tolZrZFLllk3ycshjpKZv78XTKAPRt6242NfyOif+sPZzgTTWRE/nTYFI7WZrsvvN3Kz
         PFerOIpdH+irJDNFzWIOpoRsymPV5zBu1USrlMNKCJznltsTRmt1Yogf64A6WQ8Wn5zf
         0aj2/9NEnRzFlsFUkzEg+HMxirG7eA0KY7vMoAEFYffI1bkNhJk//PMAkidKaQt6XjfJ
         2roQ==
X-Gm-Message-State: AOAM532fCblmJ5jmwQPNkmBjqo1Yj2TwaChvePeJncolhKNs+HTN/s21
        9cqqmcKQsZfCG2dVzv14r14U5MwoEA==
X-Google-Smtp-Source: ABdhPJyvAbTpnK0keT5SZM33hy+udbBcmUmItmHAKcPEBi3qTSizv2gbfjVZO6wX/A1GeVzkHYMZJg==
X-Received: by 2002:a05:6830:4127:: with SMTP id w39mr4058250ott.98.1641923402686;
        Tue, 11 Jan 2022 09:50:02 -0800 (PST)
Received: from robh.at.kernel.org (66-90-148-213.dyn.grandenetworks.net. [66.90.148.213])
        by smtp.gmail.com with ESMTPSA id z30sm2156546otj.1.2022.01.11.09.50.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Jan 2022 09:50:02 -0800 (PST)
Received: (nullmailer pid 3225637 invoked by uid 1000);
        Tue, 11 Jan 2022 17:50:01 -0000
Date:   Tue, 11 Jan 2022 11:50:01 -0600
From:   Rob Herring <robh@kernel.org>
To:     Rob Herring <robh@kernel.org>
Cc:     linux-kernel@vger.kernel.org,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        linux-stm32@st-md-mailman.stormreply.com,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Christophe Roullier <christophe.roullier@foss.st.com>,
        linux-arm-kernel@lists.infradead.org,
        Jakub Kicinski <kuba@kernel.org>, devicetree@vger.kernel.org
Subject: Re: [PATCH] dt-bindings: net: stm32-dwmac: Make each example a
 separate entry
Message-ID: <Yd3DSb6gJLgIcjxG@robh.at.kernel.org>
References: <20220106182518.1435497-8-robh@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220106182518.1435497-8-robh@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 06 Jan 2022 12:25:16 -0600, Rob Herring wrote:
> Each independent example should be a separate entry. This allows for
> 'interrupts' to have different cell sizes.
> 
> The first example also has a phandle in 'interrupts', so drop the phandle.
> 
> Signed-off-by: Rob Herring <robh@kernel.org>
> ---
>  Documentation/devicetree/bindings/net/stm32-dwmac.yaml | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 

Applied, thanks!
