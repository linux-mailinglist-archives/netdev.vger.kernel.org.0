Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E862432857
	for <lists+netdev@lfdr.de>; Mon, 18 Oct 2021 22:17:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233978AbhJRUTh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Oct 2021 16:19:37 -0400
Received: from mail-ot1-f51.google.com ([209.85.210.51]:44576 "EHLO
        mail-ot1-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234014AbhJRUTb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Oct 2021 16:19:31 -0400
Received: by mail-ot1-f51.google.com with SMTP id d21-20020a9d4f15000000b0054e677e0ac5so1275662otl.11;
        Mon, 18 Oct 2021 13:17:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=tXoif9oLGDuH3R1sbFjMjztHtwSA21PTGPYZHCDpZg4=;
        b=ktEK0op17xX/Q7SttlnBKMcpmAWOgdRRcUxrFiakiMtZ5hcwHxJiV1gSmfnEk00SYf
         YmEyNz2/VAVgNAMG5hD5vbCeo+2nxm1ZciO//ZsAVgnggewwUAK8aQKCOIFOKSJDZigr
         T7tD0U1dq3AoDMC92zFVDzfn+justEhHmBjXsMkLSTcB3dPltYF706SaE0cvLDZfkDl5
         d4iM5nj1RHHmSz6dRDzYnPyxBjqLYp8udFw3KHKtJsXc/4YWeg+zIaV2SXyiDCtY1HQM
         YfEvhF+fjZWFFMXHCjtVZaEil7TpSfn6Sen/6NlFKbkm99FFQDqzkO3Nw6iDbIOCKgpN
         b7mw==
X-Gm-Message-State: AOAM533hDUrt8XVPd2aGcgxSCjsmPMr3gc+NIuLGDhba3nSWVlZ5k52Z
        YqwwwizGGpDTBS38dnGcqA==
X-Google-Smtp-Source: ABdhPJxSpH/ahGz47ZvSaDlc4OQyZOq4JN4U4Ips3ix1p1vrOvwOH/2k5MdpShjDYTwBH+JSE4OKWg==
X-Received: by 2002:a9d:60cf:: with SMTP id b15mr1650017otk.282.1634588239667;
        Mon, 18 Oct 2021 13:17:19 -0700 (PDT)
Received: from robh.at.kernel.org (66-90-148-213.dyn.grandenetworks.net. [66.90.148.213])
        by smtp.gmail.com with ESMTPSA id k2sm2704550oot.37.2021.10.18.13.17.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Oct 2021 13:17:19 -0700 (PDT)
Received: (nullmailer pid 2884561 invoked by uid 1000);
        Mon, 18 Oct 2021 20:17:18 -0000
Date:   Mon, 18 Oct 2021 15:17:18 -0500
From:   Rob Herring <robh@kernel.org>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        None@robh.at.kernel.org, Mark Greer <mgreer@animalcreek.com>,
        Charles Gorand <charles.gorand@effinnov.com>,
        netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        linux-nfc@lists.01.org, Rob Herring <robh+dt@kernel.org>,
        devicetree@vger.kernel.org
Subject: Re: [PATCH v2 8/8] dt-bindings: nfc: marvell,nci: convert to dtschema
Message-ID: <YW3WTmEN1GA228ng@robh.at.kernel.org>
References: <20211011073934.34340-1-krzysztof.kozlowski@canonical.com>
 <20211011073934.34340-9-krzysztof.kozlowski@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211011073934.34340-9-krzysztof.kozlowski@canonical.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 11 Oct 2021 09:39:34 +0200, Krzysztof Kozlowski wrote:
> Convert the Marvell NCI NFC controller to DT schema format.
> 
> Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
> ---
>  .../bindings/net/nfc/marvell,nci.yaml         | 170 ++++++++++++++++++
>  .../devicetree/bindings/net/nfc/nfcmrvl.txt   |  84 ---------
>  2 files changed, 170 insertions(+), 84 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/net/nfc/marvell,nci.yaml
>  delete mode 100644 Documentation/devicetree/bindings/net/nfc/nfcmrvl.txt
> 

Applied, thanks!
