Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 72D94128540
	for <lists+netdev@lfdr.de>; Fri, 20 Dec 2019 23:54:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726717AbfLTWyE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Dec 2019 17:54:04 -0500
Received: from mail-io1-f65.google.com ([209.85.166.65]:46184 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726030AbfLTWyE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Dec 2019 17:54:04 -0500
Received: by mail-io1-f65.google.com with SMTP id t26so10966093ioi.13;
        Fri, 20 Dec 2019 14:54:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=2UN8sBzxbyN8aug/3vc+iOIWvC/qcpLh7CDuZsTPA48=;
        b=ooQwAssq7Yw4IstteUqAmZGSBz7iyxWDxAwOlrhEzUYV6XDUC+6ADB0mzwemDksk6E
         iDl83NUyq83qwbZubYq+vUzyKN129w1lYMPJ8ov+Pj74bpB4/NhwRoLsxtzjm6E/Gizj
         UkNao8aKp6eb5b0lwAMCSScnhQ4h9tT6evltpvizPc6UVVpjyx3VkbRLJ2bV4qBVIceV
         EcXazGPEHNjN4u6kWRzph23dtkD4bsT7fLTlmNHDOGs7srkPmlwFflp+s+E9l5yVtJpL
         ByjhT4La4LhoRWgcu5Et1z6II7zHp5/F5AXjCIJoqhZpDRBQYPKe8socbGhze2zBZQzg
         DCvg==
X-Gm-Message-State: APjAAAVZMFPwxhxTsgSrLgCTiBc6mswFJIEebthFxLT1bVqFB0l7xrzY
        d5MpTrxxxhpPQFJjIG0G1w==
X-Google-Smtp-Source: APXvYqz4DDqXIhZ6wJ1YCFldM/1b2d3Wtt5n0HPOSGpAeXTa7cl9VfKgzTmteFMXEEqaN9C6/kFEqw==
X-Received: by 2002:a5d:8901:: with SMTP id b1mr11201405ion.246.1576882443540;
        Fri, 20 Dec 2019 14:54:03 -0800 (PST)
Received: from localhost ([64.188.179.251])
        by smtp.gmail.com with ESMTPSA id e85sm5486916ilk.78.2019.12.20.14.54.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Dec 2019 14:54:03 -0800 (PST)
Date:   Fri, 20 Dec 2019 15:54:01 -0700
From:   Rob Herring <robh@kernel.org>
To:     Benjamin Gaignard <benjamin.gaignard@st.com>
Cc:     davem@davemloft.net, mark.rutland@arm.com, mripard@kernel.org,
        martin.blumenstingl@googlemail.com, andrew@lunn.ch,
        narmstrong@baylibre.com, alexandru.ardelean@analog.com,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] dt-bindings: net: stmmac: add missing properties keyword
Message-ID: <20191220225401.GA3172@bogus>
References: <20191219140226.16820-1-benjamin.gaignard@st.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191219140226.16820-1-benjamin.gaignard@st.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 19, 2019 at 03:02:26PM +0100, Benjamin Gaignard wrote:
> Add missing 'properties' keyword to be compliant with syntax requirements
> 
> Fixes: 7db3545aef5fa ("dt-bindings: net: stmmac: Convert the binding to a schemas")
> Signed-off-by: Benjamin Gaignard <benjamin.gaignard@st.com>
> ---
>  Documentation/devicetree/bindings/net/snps,dwmac.yaml | 1 +
>  1 file changed, 1 insertion(+)

Thanks, but I already sent and applied a fix.

Rob
