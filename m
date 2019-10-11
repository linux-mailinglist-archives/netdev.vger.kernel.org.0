Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EC837D4618
	for <lists+netdev@lfdr.de>; Fri, 11 Oct 2019 19:02:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728661AbfJKRCF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Oct 2019 13:02:05 -0400
Received: from mail-ot1-f67.google.com ([209.85.210.67]:44839 "EHLO
        mail-ot1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726331AbfJKRCF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Oct 2019 13:02:05 -0400
Received: by mail-ot1-f67.google.com with SMTP id 21so8538179otj.11;
        Fri, 11 Oct 2019 10:02:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=vjnGO7jy/uIgC7C69kaFRlAqhB7BSVIYFxY9GpNzQxs=;
        b=pVxFtIWESc64KwuasaK23/zGkbDxC2dGBEt24LMBxn0ioQv+Zz0FUrpA+j6ay76H8K
         XtLlBPbnAKoIcDrqdVbrflmpB7gq1vj4X+R1lJdSvIovpKlyGW4/hCOwgsE9w/pOeJld
         L3EIsHJ53du3NUWBmsaFHJkGrQfyraRtJ3tlgJQqfd7kbU2LcmCi7Mlj5OJCgKU1f3Su
         AdbynD6Gc1XBnxLwl89SNwFA4+G2oKhc4eQ5Vcy9M+X8HLxYHolDsc5QFp/yBmJp+YsA
         gpfgWyoA8F5NfhGCvI0udyUuFf4nhoE5jb8Pu0nTPY0mJ/gdDtvZ2dPsSDO4ltU5XDDx
         awRg==
X-Gm-Message-State: APjAAAXNwuVC53jpeuAmVL2Q10KhtLNnC+1Jhx5z165T0XT0U/Z1fyn2
        BY71mKVBjo//cbzMhf3Pjg==
X-Google-Smtp-Source: APXvYqwfy0Na/MAFrRtPiSxZm/TDuDknMJwUXkcoSJDIX13TLHyRN+sMhY1EV3oTRDG1UunWf6kqIg==
X-Received: by 2002:a9d:6b0a:: with SMTP id g10mr13237581otp.303.1570813324600;
        Fri, 11 Oct 2019 10:02:04 -0700 (PDT)
Received: from localhost (24-155-109-49.dyn.grandenetworks.net. [24.155.109.49])
        by smtp.gmail.com with ESMTPSA id a69sm2791021oib.14.2019.10.11.10.02.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Oct 2019 10:02:03 -0700 (PDT)
Date:   Fri, 11 Oct 2019 12:02:03 -0500
From:   Rob Herring <robh@kernel.org>
To:     Andrew Jeffery <andrew@aj.id.au>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, robh+dt@kernel.org,
        mark.rutland@arm.com, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, joel@jms.id.au,
        benh@kernel.crashing.org, linux-aspeed@lists.ozlabs.org
Subject: Re: [PATCH v2 2/3] dt-bindings: net: ftgmac100: Describe clock
 properties
Message-ID: <20191011170203.GA16724@bogus>
References: <20191010020756.4198-1-andrew@aj.id.au>
 <20191010020756.4198-3-andrew@aj.id.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191010020756.4198-3-andrew@aj.id.au>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 10 Oct 2019 12:37:55 +1030, Andrew Jeffery wrote:
> Critically, the AST2600 requires ungating the RMII RCLK if e.g. NCSI is
> in use.
> 
> Signed-off-by: Andrew Jeffery <andrew@aj.id.au>
> Acked-by: Joel Stanley <joel@jms.id.au>
> ---
>  Documentation/devicetree/bindings/net/ftgmac100.txt | 7 +++++++
>  1 file changed, 7 insertions(+)
> 

Acked-by: Rob Herring <robh@kernel.org>
