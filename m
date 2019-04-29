Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5D32DE95A
	for <lists+netdev@lfdr.de>; Mon, 29 Apr 2019 19:39:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728928AbfD2Rjc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Apr 2019 13:39:32 -0400
Received: from mail-oi1-f194.google.com ([209.85.167.194]:39540 "EHLO
        mail-oi1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728798AbfD2Rjc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Apr 2019 13:39:32 -0400
Received: by mail-oi1-f194.google.com with SMTP id n187so8991204oih.6;
        Mon, 29 Apr 2019 10:39:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=7oQF0Ow5NvfcIZT8v2Y1XPltRGNq4bwG9X6rczwxJZo=;
        b=mBJkrRwjwnkOlbT7LDozrVhUKWTJdWv6kPY5t+JcMYb1jYh4g9ko7+k6SpOAML/SZu
         12yk8EjezxraQhgs3v/bjy2nibEUh/MX09+stLEKCv934fSQNTp1HLZjzEK1xVqy4zKX
         ouL0mrT4yv7vQ3sAx419Jt1eGLmkONOXf2ZPGZRLgVJkwlDWQFYUC+/qh0vEMtUxTgS0
         Xc95Ha+l99DgIj7rT65+4vWUlkZULYs5nICE8Ed47ckeBYg9xk0eH1NnanMGrGWNMH6H
         fk/HLw4xIbTxCOCKykAlwZXOfhLtyg0hLoWyOppmZNcoqGI46vChq6wcuNxuTfSFAitL
         kFbg==
X-Gm-Message-State: APjAAAXzut8xqJecyPCtKcIeM4IRV8H/sExq9MiB+wa38UIw2VPa/llr
        e2g31M+IAkHH3vfqa/0nVN0MZQ8=
X-Google-Smtp-Source: APXvYqwSc4oXqoFOkpxHHg/zKQLj1+50eBpDWqLOcAaw1ZRIXoX8wtbXrnmnVvm8tvs8AKPbQIoL0w==
X-Received: by 2002:aca:57d8:: with SMTP id l207mr183569oib.44.1556559571571;
        Mon, 29 Apr 2019 10:39:31 -0700 (PDT)
Received: from localhost (24-155-109-49.dyn.grandenetworks.net. [24.155.109.49])
        by smtp.gmail.com with ESMTPSA id 3sm9041240oti.45.2019.04.29.10.39.30
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 29 Apr 2019 10:39:30 -0700 (PDT)
Date:   Mon, 29 Apr 2019 12:39:30 -0500
From:   Rob Herring <robh@kernel.org>
To:     Sean Nyekjaer <sean@geanix.com>
Cc:     netdev@vger.kernel.org, linux-can@vger.kernel.org,
        mkl@pengutronix.de, robh+dt@kernel.org,
        Sean Nyekjaer <sean@geanix.com>, devicetree@vger.kernel.org
Subject: Re: [PATCH 2/2] dt-bindings: can: flexcan: add can wakeup property
Message-ID: <20190429173930.GA11283@bogus>
References: <20190409083949.27917-1-sean@geanix.com>
 <20190409083949.27917-2-sean@geanix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190409083949.27917-2-sean@geanix.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue,  9 Apr 2019 10:39:49 +0200, Sean Nyekjaer wrote:
> add wakeup-source boolean property.
> 
> Signed-off-by: Sean Nyekjaer <sean@geanix.com>
> ---
>  Documentation/devicetree/bindings/net/can/fsl-flexcan.txt | 2 ++
>  1 file changed, 2 insertions(+)
> 

Reviewed-by: Rob Herring <robh@kernel.org>
