Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0953BD4614
	for <lists+netdev@lfdr.de>; Fri, 11 Oct 2019 19:01:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728599AbfJKRBn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Oct 2019 13:01:43 -0400
Received: from mail-ot1-f68.google.com ([209.85.210.68]:43269 "EHLO
        mail-ot1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726331AbfJKRBn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Oct 2019 13:01:43 -0400
Received: by mail-ot1-f68.google.com with SMTP id o44so8535551ota.10;
        Fri, 11 Oct 2019 10:01:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=2k6iJvLdkfVozjkI9NSZfVogwjqk7AYxF3ZCmE3mp+M=;
        b=FmNxzxSIj/Cv8+g9fHMgKJKZ4trc2vYqb7SfKV49FErI0q+2zqspigLPr3hLbqhumP
         geFw0Dim9LQhpwrgXGdoGwzLf7K5pTx0Br3LE4GMMeaNeOuMT70UEWrFKzgMnzyR6Bvl
         cuCLFoeZZKxc4viPp8PJJl4nZ0q9oZy+PB46972Hfviwk2X0Yu20W9C0mE5ZwviQAbRx
         AA/Xv483hSSWjlXHQEnAqB0v5gs3PH9Lw7Vx9s2WpWkTiQlkoJwZ0TU/IOaD7q5d/f9F
         RIkN6TqfC2ilDC1z3gymfBkxjJsMb/C828T3x3qCbVyOBs2xhfgKJ95O0WKlh4Uo1rgb
         xPiQ==
X-Gm-Message-State: APjAAAVNX9PnGpF1/3HO2IWrpZN13T9svdfrdV4SkqYuKs+V3hwxX1GM
        j3G+u8XCk9ZNyVbaQWeHTQ==
X-Google-Smtp-Source: APXvYqyxTCyx1p90Vg8GKWBh8CskGgy1s5uYdHxkKeWfkTkOSo8sUcAJXHydLulLRSMM841tjFMBmQ==
X-Received: by 2002:a9d:70c3:: with SMTP id w3mr7433016otj.246.1570813300970;
        Fri, 11 Oct 2019 10:01:40 -0700 (PDT)
Received: from localhost (24-155-109-49.dyn.grandenetworks.net. [24.155.109.49])
        by smtp.gmail.com with ESMTPSA id u141sm2827663oie.40.2019.10.11.10.01.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Oct 2019 10:01:40 -0700 (PDT)
Date:   Fri, 11 Oct 2019 12:01:39 -0500
From:   Rob Herring <robh@kernel.org>
To:     Andrew Jeffery <andrew@aj.id.au>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, robh+dt@kernel.org,
        mark.rutland@arm.com, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, joel@jms.id.au,
        benh@kernel.crashing.org, linux-aspeed@lists.ozlabs.org
Subject: Re: [PATCH v2 1/3] dt-bindings: net: ftgmac100: Document AST2600
 compatible
Message-ID: <20191011170139.GA16006@bogus>
References: <20191010020756.4198-1-andrew@aj.id.au>
 <20191010020756.4198-2-andrew@aj.id.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191010020756.4198-2-andrew@aj.id.au>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 10 Oct 2019 12:37:54 +1030, Andrew Jeffery wrote:
> The AST2600 contains an FTGMAC100-compatible MAC, although the MDIO
> controller previously embedded in the MAC has been moved out to a
> dedicated MDIO block.
> 
> Signed-off-by: Andrew Jeffery <andrew@aj.id.au>
> Acked-by: Joel Stanley <joel@jms.id.au>
> ---
>  Documentation/devicetree/bindings/net/ftgmac100.txt | 1 +
>  1 file changed, 1 insertion(+)
> 

Acked-by: Rob Herring <robh@kernel.org>
