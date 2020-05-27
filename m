Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E78E1E34C5
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 03:33:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726222AbgE0Bbl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 May 2020 21:31:41 -0400
Received: from mail-il1-f195.google.com ([209.85.166.195]:45314 "EHLO
        mail-il1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725287AbgE0Bbl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 May 2020 21:31:41 -0400
Received: by mail-il1-f195.google.com with SMTP id 9so3988807ilg.12;
        Tue, 26 May 2020 18:31:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=k9Tih4XnsvyNY6esAFQ63eiV+bEtuajcRZUBRdAyvvc=;
        b=ZrOYu8wV++Ea9KqNlQN7fknl4Pd81KfHqWRahHTkU+uZtDiN5F2qgGxWieHX/v1gLR
         z/ydCWUG1XOnVF2yMEnD8Z41L0Lxn7WRP1UwsTo8lJP4v+vHQ21kNc8MWiP/sDwPqD1q
         xozhOw0wFrlyhELIx0cw0cbzwQ+TgX2Dr9l4rjpZVcfJEGsRdCW/qkAUJ2W1SezquEPc
         IIrjsWfcYpBCqjkdwN6Bd8VlgnulxCcfr4zJzrgTlLAS4mutxIyrsVPk5kVhO5bNXMOQ
         cZ07Od+zN4Z5GWFO8gNDn8xymkbSCPAp0PaWMJpCi6rq0Rb0mICYXn4gqPGyzp+zHZq6
         PaJQ==
X-Gm-Message-State: AOAM5310M/pQEkV3OHnltFX4iS7RMtRj2NzDHP5sX3gY6Oi2s334PffO
        1gUMpF476+X9A6jcV+dkOQ==
X-Google-Smtp-Source: ABdhPJwJOyjslkUwLMUCa6L98wpsiVwI3A8D8vv1EsWHGsWdVRUWm3/bwvdmfxReZz4y9VPBwudgAA==
X-Received: by 2002:a92:7e90:: with SMTP id q16mr13816ill.199.1590543098611;
        Tue, 26 May 2020 18:31:38 -0700 (PDT)
Received: from xps15 ([64.188.179.252])
        by smtp.gmail.com with ESMTPSA id j2sm615491ioo.8.2020.05.26.18.31.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 May 2020 18:31:37 -0700 (PDT)
Received: (nullmailer pid 843489 invoked by uid 1000);
        Wed, 27 May 2020 01:31:36 -0000
Date:   Tue, 26 May 2020 19:31:36 -0600
From:   Rob Herring <robh@kernel.org>
To:     Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
Cc:     Geert Uytterhoeven <geert+renesas@glider.be>,
        Jens Axboe <axboe@kernel.dk>,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        "David S. Miller" <davem@davemloft.net>,
        Wim Van Sebroeck <wim@linux-watchdog.org>,
        Guenter Roeck <linux@roeck-us.net>, linux-ide@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-i2c@vger.kernel.org, linux-mmc@vger.kernel.org,
        netdev@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        linux-watchdog@vger.kernel.org,
        Prabhakar <prabhakar.csengg@gmail.com>
Subject: Re: [PATCH 16/17] dt-bindings: watchdog: renesas,wdt: Document
 r8a7742 support
Message-ID: <20200527013136.GA838011@bogus>
References: <1589555337-5498-1-git-send-email-prabhakar.mahadev-lad.rj@bp.renesas.com>
 <1589555337-5498-17-git-send-email-prabhakar.mahadev-lad.rj@bp.renesas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1589555337-5498-17-git-send-email-prabhakar.mahadev-lad.rj@bp.renesas.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 15, 2020 at 04:08:56PM +0100, Lad Prabhakar wrote:
> RZ/G1H (R8A7742) watchdog implementation is compatible with R-Car Gen2,
> therefore add relevant documentation.
> 
> Signed-off-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
> Reviewed-by: Marian-Cristian Rotariu <marian-cristian.rotariu.rb@bp.renesas.com>
> ---
>  Documentation/devicetree/bindings/watchdog/renesas,wdt.txt | 1 +
>  1 file changed, 1 insertion(+)

Meanwhile in the DT tree, converting this schema landed. Can you prepare 
a version based on the schema.

Rob
