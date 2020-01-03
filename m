Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7036E12FF53
	for <lists+netdev@lfdr.de>; Sat,  4 Jan 2020 00:54:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726926AbgACXyE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jan 2020 18:54:04 -0500
Received: from mail-il1-f193.google.com ([209.85.166.193]:38971 "EHLO
        mail-il1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726820AbgACXyD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Jan 2020 18:54:03 -0500
Received: by mail-il1-f193.google.com with SMTP id x5so37968324ila.6
        for <netdev@vger.kernel.org>; Fri, 03 Jan 2020 15:54:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=DLv6sevWK4SOmkrjtAjyOZj+Qda5b1Jn7x8aH9qo+K8=;
        b=rzNwP0s9oUjt+RwmKcJ65kO2A+SE/cReR8D278KAqmbKZk15Mp2ZzNWqMjmCL+47Hj
         i28yeNYx2B3C7ayoKNwZyWE5g6ZMQD+pOA+Mi63te0FvicjlnFQuWiju+1ICbRU5ASyi
         TBCHcppmo0x6zX0UG5h3xKKX0lqZtzGFUZOo8zJrQNiV5sWr76UYhWkIq4HhUgDt8iT3
         ogyXYUTx7QB7RicE2pi8KW1zjwehjS4V0w9gJGWLQECfqdjH9JhtOGrbXov+U4QKi5Ok
         Dxj4zxmpL/i85DvtAvBpNUIwTSBpD3nf4SPGaqi/YS6h3om7yUi0GsQ0p5fiL3w4QX/2
         /P+g==
X-Gm-Message-State: APjAAAX61jKgh/XZoG61KnjRTLOPnPizUbWEUS7WJH0RmmOHNJ8ucJID
        XMyPxF2YZbK+0e6OrpJ8FNZ/h1E=
X-Google-Smtp-Source: APXvYqy7VWLMbNqG/W2LLhjOF8PJXwGZFIUb3U7q/D31WA+R2ny3gSjSE2yPLf/nf8mfIABUrhwX1Q==
X-Received: by 2002:a92:405a:: with SMTP id n87mr78046844ila.299.1578095643063;
        Fri, 03 Jan 2020 15:54:03 -0800 (PST)
Received: from rob-hp-laptop ([64.188.179.251])
        by smtp.gmail.com with ESMTPSA id v64sm21511812ila.36.2020.01.03.15.54.01
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Jan 2020 15:54:01 -0800 (PST)
Received: from rob (uid 1000)
        (envelope-from rob@rob-hp-laptop)
        id 2219b7
        by rob-hp-laptop (DragonFly Mail Agent v0.11);
        Fri, 03 Jan 2020 16:53:59 -0700
Date:   Fri, 3 Jan 2020 16:53:59 -0700
From:   Rob Herring <robh@kernel.org>
To:     pisa@cmp.felk.cvut.cz
Cc:     devicetree@vger.kernel.org, mkl@pengutronix.de,
        linux-can@vger.kernel.org, socketcan@hartkopp.net,
        wg@grandegger.com, davem@davemloft.net, mark.rutland@arm.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        martin.jerabek01@gmail.com, ondrej.ille@gmail.com,
        jnovak@fel.cvut.cz, jara.beran@gmail.com, porazil@pikron.com
Subject: Re: [PATCH v3 2/6] dt-bindings: net: can: binding for CTU CAN FD
 open-source IP core.
Message-ID: <20200103235359.GA23875@bogus>
References: <cover.1576922226.git.pisa@cmp.felk.cvut.cz>
 <61533d59378822f8c808abf193b40070810d3d35.1576922226.git.pisa@cmp.felk.cvut.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <61533d59378822f8c808abf193b40070810d3d35.1576922226.git.pisa@cmp.felk.cvut.cz>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Dec 21, 2019 at 03:07:31PM +0100, pisa@cmp.felk.cvut.cz wrote:
> From: Pavel Pisa <pisa@cmp.felk.cvut.cz>
> 
> Signed-off-by: Pavel Pisa <pisa@cmp.felk.cvut.cz>
> ---
>  .../devicetree/bindings/net/can/ctu,ctucanfd.txt   | 61 ++++++++++++++++++++++
>  1 file changed, 61 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/net/can/ctu,ctucanfd.txt

Bindings are moving DT schema format now. Not something I'd require on a 
respin I've already reviewed, but OTOH it's been 10 months to respin 
from v2. So:

Reviewed-by: Rob Herring <robh@kernel.org>

If you have a v4, then please convert to a schema.

Rob
