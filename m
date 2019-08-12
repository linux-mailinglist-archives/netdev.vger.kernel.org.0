Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B73468AAFE
	for <lists+netdev@lfdr.de>; Tue, 13 Aug 2019 01:12:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726692AbfHLXMI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Aug 2019 19:12:08 -0400
Received: from mail-ot1-f65.google.com ([209.85.210.65]:44332 "EHLO
        mail-ot1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726316AbfHLXMH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Aug 2019 19:12:07 -0400
Received: by mail-ot1-f65.google.com with SMTP id b7so115212824otl.11;
        Mon, 12 Aug 2019 16:12:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=KfF7VWfZTJ8nGpf3jajOCOsnqhBAHUORyOlgjXXkKVg=;
        b=J6Nml9ydsIdvLd74F8bR4C9jizIRZ54dzr6nYwMegVdi/MRDSHKtta6VeVlhydnRRj
         +GOKbZcKXTRAdxdWmFHzUv2khHev16u1SrfjjQuXBqiRjATE3Bp65D63CfAHhX9hHYiD
         MrUUwsJOIJdAz+la5aUp5ztSNYsvVCJT9vRakzCV/JTl3FyUAU61PLeT3k662ZlOVRny
         z1/pg9TT55Qvj4MkXlt1RZdqi4OdqeDsf/TywbG80vJ9ucyDY/7HSdRWH734LnaIT6Zm
         0EWZQPgvnTvA680K6vYEb8GMO34w0Wh8HnLsHEgBiZzB+uJRl1ZzG5UvBAmkG1EQ+T4w
         nrcg==
X-Gm-Message-State: APjAAAUxJNvkQjrybWW/KjMTfHR1P7Mc8e7Qfp24Ejqy9PMdEUuv4qqW
        YZqtB8/aIt6PAAaiieVYAw==
X-Google-Smtp-Source: APXvYqxoS2lxIdSYiBK0gxgw0WLhtXgGowt96+sZ3N2NAojXd96Z7ce9cMq+jHNui6d+54BW04Evag==
X-Received: by 2002:a02:5246:: with SMTP id d67mr33482382jab.58.1565651526703;
        Mon, 12 Aug 2019 16:12:06 -0700 (PDT)
Received: from localhost ([64.188.179.254])
        by smtp.gmail.com with ESMTPSA id n17sm82548086iog.63.2019.08.12.16.12.05
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 12 Aug 2019 16:12:05 -0700 (PDT)
Date:   Mon, 12 Aug 2019 17:12:05 -0600
From:   Rob Herring <robh@kernel.org>
To:     Sven Van Asbroeck <thesven73@gmail.com>
Cc:     Fugang Duan <fugang.duan@nxp.com>,
        Mark Rutland <mark.rutland@arm.com>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Fabio Estevam <festevam@gmail.com>,
        Lucas Stach <l.stach@pengutronix.de>
Subject: Re: [PATCH v1] dt-bindings: fec: explicitly mark deprecated
 properties
Message-ID: <20190812231205.GA21028@bogus>
References: <20190718201453.13062-1-TheSven73@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190718201453.13062-1-TheSven73@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 18 Jul 2019 16:14:53 -0400, Sven Van Asbroeck wrote:
> fec's gpio phy reset properties have been deprecated.
> Update the dt-bindings documentation to explicitly mark
> them as such, and provide a short description of the
> recommended alternative.
> 
> Signed-off-by: Sven Van Asbroeck <TheSven73@gmail.com>
> ---
>  .../devicetree/bindings/net/fsl-fec.txt       | 30 +++++++++++--------
>  1 file changed, 17 insertions(+), 13 deletions(-)
> 

Applied, thanks.

Rob
