Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DFB71E6BE7
	for <lists+netdev@lfdr.de>; Thu, 28 May 2020 22:04:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406921AbgE1UES (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 May 2020 16:04:18 -0400
Received: from mail-io1-f65.google.com ([209.85.166.65]:36843 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2406907AbgE1UEN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 May 2020 16:04:13 -0400
Received: by mail-io1-f65.google.com with SMTP id y18so11101079iow.3;
        Thu, 28 May 2020 13:04:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=VRpntUdWv8AKtZ+a5Y9VWiuC0YFnDQkWfaKNcQDj9bg=;
        b=qfxqTsy0jJ+7HJISTZKm+nxV37YbZrtVTwaxr1bN5THfrKYYPer9eR1YQaiJusx2lq
         2ze6wn9vM7bW4jwtMdcGfsq4ofFfueUt1wBUciRCFQYGLBH9d00Q93Jnni9WV9lNCG3w
         qEtbaxufE+4R/lban9kAfpakMXeqKPOubrQvuuQ8VzbVovNexstv5pm6N5bLnxODlcU+
         XfOLyVBn06VWJwJkx+rmUOOLmUcxENtRTpsYcGUcwdi1Nalz/qseV+RgZZmAHfdK7mUj
         jI02PsbppnkA9WXmyDH+pqTMTh4vczRvfTrQX5ZGi2Usm3/MSxFOhSP7SUMBm18wb65t
         aI3w==
X-Gm-Message-State: AOAM531HtcPJxwK0HvD7pUR6eC/BHlo9f2X5DRM9SY70H0wgTM1H4vWN
        EN3vTz+ZAPbgn3EMwnGnMQ==
X-Google-Smtp-Source: ABdhPJxZO4C3hMEVs6HYSS9ViI+m49BTCVXhrMEy/RENUDfC5bOoPifwoF5TffYNDNXuWDDJrBhMew==
X-Received: by 2002:a6b:ab03:: with SMTP id u3mr3738640ioe.148.1590696248371;
        Thu, 28 May 2020 13:04:08 -0700 (PDT)
Received: from xps15 ([64.188.179.252])
        by smtp.gmail.com with ESMTPSA id h28sm3835922ild.53.2020.05.28.13.04.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 May 2020 13:04:07 -0700 (PDT)
Received: (nullmailer pid 590102 invoked by uid 1000);
        Thu, 28 May 2020 20:04:06 -0000
Date:   Thu, 28 May 2020 14:04:06 -0600
From:   Rob Herring <robh@kernel.org>
To:     Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
Cc:     linux-renesas-soc@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Prabhakar <prabhakar.csengg@gmail.com>, netdev@vger.kernel.org,
        Jens Axboe <axboe@kernel.dk>, devicetree@vger.kernel.org,
        linux-watchdog@vger.kernel.org, linux-i2c@vger.kernel.org,
        Wim Van Sebroeck <wim@linux-watchdog.org>,
        linux-mmc@vger.kernel.org
Subject: Re: [PATCH 08/17] dt-bindings: ata: renesas,rcar-sata: Add r8a7742
 support
Message-ID: <20200528200406.GA590056@bogus>
References: <1589555337-5498-1-git-send-email-prabhakar.mahadev-lad.rj@bp.renesas.com>
 <1589555337-5498-9-git-send-email-prabhakar.mahadev-lad.rj@bp.renesas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1589555337-5498-9-git-send-email-prabhakar.mahadev-lad.rj@bp.renesas.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 15 May 2020 16:08:48 +0100, Lad Prabhakar wrote:
> Document SATA support for the RZ/G1H, which is compatible with
> R-Car Gen2 SoC family.
> 
> Signed-off-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
> Reviewed-by: Marian-Cristian Rotariu <marian-cristian.rotariu.rb@bp.renesas.com>
> ---
>  Documentation/devicetree/bindings/ata/renesas,rcar-sata.yaml | 1 +
>  1 file changed, 1 insertion(+)
> 

Applied, thanks!
