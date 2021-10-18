Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28C75432849
	for <lists+netdev@lfdr.de>; Mon, 18 Oct 2021 22:16:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233832AbhJRUTF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Oct 2021 16:19:05 -0400
Received: from mail-oo1-f44.google.com ([209.85.161.44]:42541 "EHLO
        mail-oo1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233882AbhJRUTE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Oct 2021 16:19:04 -0400
Received: by mail-oo1-f44.google.com with SMTP id a17-20020a4a6851000000b002b59bfbf669so98951oof.9;
        Mon, 18 Oct 2021 13:16:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=49H7UnNXmfUIMf90hr1R2Qgsu+JmMVcrzAlO3j2sHsY=;
        b=gtnmgGvmVN5cstE/YvfAIMsQOI5HMCfgOAqNfz1uy6ozEgr10SN867gySxQTc3dzX0
         VkSblHSUWvdou62BXYzfESa+bBSWAs0YaHWIzcF/TEln3x2yxZH2VtCHAYJSkqaL01Aq
         crqNu1SHwVnVMx4tzuieteNAFRqCnSuUipH2k39pwXoyd5sSB1X7REnS7kMrNiILbfOw
         VpG5uxNZLBq3+uETWLUtBKMPpUhGSjLYmg/dFOFmkW6K2UwINfCXDkCrf6Q9fPNqN2T8
         9LtJiD+kr8Hr2taiGjp3bAXXe6ohpyNwqHhdhvr4qCW0nRiIWrnA8eJXFTAVUvttuVIj
         t2lg==
X-Gm-Message-State: AOAM531XLFCry9gScXVQ36A4mD3VoOnmaRk8X37JgG8X5kPC+/gkPuNY
        k1bNTcEe2TDzxq6aDIO2R8y91iB4Bg==
X-Google-Smtp-Source: ABdhPJxL0NPO/NISzaGi5Uq0lQuDVx+QfDBFkXMD2mX+ToREQF9p3cxjMEEuuiXO7cDS6WCTnryzJQ==
X-Received: by 2002:a4a:d0cd:: with SMTP id u13mr1468994oor.49.1634588212666;
        Mon, 18 Oct 2021 13:16:52 -0700 (PDT)
Received: from robh.at.kernel.org (66-90-148-213.dyn.grandenetworks.net. [66.90.148.213])
        by smtp.gmail.com with ESMTPSA id 3sm3246631oif.12.2021.10.18.13.16.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Oct 2021 13:16:52 -0700 (PDT)
Received: (nullmailer pid 2883365 invoked by uid 1000);
        Mon, 18 Oct 2021 20:16:51 -0000
Date:   Mon, 18 Oct 2021 15:16:51 -0500
From:   Rob Herring <robh@kernel.org>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Cc:     netdev@vger.kernel.org, Mark Greer <mgreer@animalcreek.com>,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>, linux-nfc@lists.01.org,
        "David S. Miller" <davem@davemloft.net>,
        devicetree@vger.kernel.org, None@robh.at.kernel.org,
        Charles Gorand <charles.gorand@effinnov.com>
Subject: Re: [PATCH v2 5/8] dt-bindings: nfc: st,st95hf: convert to dtschema
Message-ID: <YW3WMx9fawK1hbcC@robh.at.kernel.org>
References: <20211011073934.34340-1-krzysztof.kozlowski@canonical.com>
 <20211011073934.34340-6-krzysztof.kozlowski@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211011073934.34340-6-krzysztof.kozlowski@canonical.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 11 Oct 2021 09:39:31 +0200, Krzysztof Kozlowski wrote:
> Convert the ST ST95HF NFC controller to DT schema format.
> 
> Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
> ---
>  .../bindings/net/nfc/st,st95hf.yaml           | 57 +++++++++++++++++++
>  .../devicetree/bindings/net/nfc/st95hf.txt    | 45 ---------------
>  2 files changed, 57 insertions(+), 45 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/net/nfc/st,st95hf.yaml
>  delete mode 100644 Documentation/devicetree/bindings/net/nfc/st95hf.txt
> 

Applied, thanks!
