Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 67FD819A162
	for <lists+netdev@lfdr.de>; Tue, 31 Mar 2020 23:56:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731466AbgCaV4A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Mar 2020 17:56:00 -0400
Received: from mail-io1-f66.google.com ([209.85.166.66]:33861 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728840AbgCaV4A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Mar 2020 17:56:00 -0400
Received: by mail-io1-f66.google.com with SMTP id h131so23449837iof.1;
        Tue, 31 Mar 2020 14:55:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=KLFkL5VmABExnsnu6K0TICgigmo+8J+FeedYQ3KtQo0=;
        b=eHHut5C/PqbY2gP6xIlqSHGcPMIKxanycWJD+zNPRlewAi1NAF+aU6BM+9OS0+a/3F
         4ZSa7xCUxIM7wtXvidLGsS71UAgaaIXlyXnShe6Odr0R4fBeDI6QFeZD6xozlutpDhRe
         hN+VRh0n0Dh3/qOc9UVKDNOo/Z7DUCAsLBn/7Eddg7FcrKh/93Lg5izGYjd7/mCAPg5S
         qgGxcUboqMzmhai92lEbFYV/V65SBn5OVMSryrc1fWe5PdRumoe5xwKMKIml+XD/iPi+
         Iw9932mTzz3ZWlpW0jRVw4qMoI3b+dW+60SvGZKOHL1IzF5E6eap7CD3Ikn2hA6afWO6
         3QPA==
X-Gm-Message-State: ANhLgQ3HLUzSABaAOQGp6y7dOs+2n5PNsFKZNuaQIe0b3sZ8UNIsFDDM
        DXutSmioRF3HoHrHawqCUFEkohlnkg==
X-Google-Smtp-Source: ADFU+vtpkqBye15ILw7rC1GRkMoDqGKOfsqWCDyyfrWUNNrg+7rjxptxkdu6cCEvwak8rmkvb2UfNg==
X-Received: by 2002:a5d:9142:: with SMTP id y2mr17099533ioq.185.1585691759566;
        Tue, 31 Mar 2020 14:55:59 -0700 (PDT)
Received: from rob-hp-laptop ([64.188.179.250])
        by smtp.gmail.com with ESMTPSA id o7sm38349ilb.60.2020.03.31.14.55.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Mar 2020 14:55:59 -0700 (PDT)
Received: (nullmailer pid 9559 invoked by uid 1000);
        Tue, 31 Mar 2020 21:55:57 -0000
Date:   Tue, 31 Mar 2020 15:55:57 -0600
From:   Rob Herring <robh@kernel.org>
To:     Martin Fuzzey <martin.fuzzey@flowbird.group>
Cc:     Fugang Duan <fugang.duan@nxp.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Fabio Estevam <festevam@gmail.com>,
        linux-kernel@vger.kernel.org,
        Sascha Hauer <s.hauer@pengutronix.de>,
        NXP Linux Team <linux-imx@nxp.com>,
        devicetree@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>
Subject: Re: [PATCH v2 3/4] dt-bindings: fec: document the new gpr property.
Message-ID: <20200331215557.GA9526@bogus>
References: <1585159919-11491-1-git-send-email-martin.fuzzey@flowbird.group>
 <1585159919-11491-4-git-send-email-martin.fuzzey@flowbird.group>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1585159919-11491-4-git-send-email-martin.fuzzey@flowbird.group>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 25 Mar 2020 19:11:58 +0100, Martin Fuzzey wrote:
> This property allows the gpr register bit to be defined
> for wake on lan support.
> 
> Signed-off-by: Martin Fuzzey <martin.fuzzey@flowbird.group>
> ---
>  Documentation/devicetree/bindings/net/fsl-fec.txt | 2 ++
>  1 file changed, 2 insertions(+)
> 

Acked-by: Rob Herring <robh@kernel.org>
