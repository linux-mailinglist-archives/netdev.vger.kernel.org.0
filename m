Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64635497287
	for <lists+netdev@lfdr.de>; Sun, 23 Jan 2022 16:29:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237593AbiAWP3Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Jan 2022 10:29:16 -0500
Received: from mail-oo1-f42.google.com ([209.85.161.42]:43805 "EHLO
        mail-oo1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237591AbiAWP3O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Jan 2022 10:29:14 -0500
Received: by mail-oo1-f42.google.com with SMTP id s5-20020a4adb85000000b002e7955c286cso719199oou.10;
        Sun, 23 Jan 2022 07:29:14 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=l0fU/1IbRuCduAfZRQ567kFrjgV7bspoFhDn/88UCLU=;
        b=oF35c7TMaMaFqjwWEVNnJHHhHTI5eHXdHNQOU15YxkmWNfpzLzIN4VgmC95iiZasn2
         9HvOXApptXZUS/aWq65TC9FQcXeda2u+EWdlZXS/Sycsv+B8hESy8xsTmRRqPxDHSEzS
         qYFMRx0g2VcO8ZR8Om+E8zD80OCZL+4zn/GnvOha6KOHFuGbbqgf5hdSJUvR/w5YkiB8
         DYhqti0pYVd8+tLxfbwnDwClBVLXrExtwnY/3un6ifDMFJraA/CFlFS0WRX9JolZkKxe
         7TDQN3epptxC/qa8F135dFrVz+/QDYGJ+9CJhsGaIy9vSz27gjSEg2/oYrqenjAQJAFW
         GMMg==
X-Gm-Message-State: AOAM5309f7ltk0cBPhRaSBWYLzDhFw1wzkVMJ8gIfXRy0tNeJ6I2/wWR
        cFAGX+QzU9ZtOnk68k0GZRR6UfsUIg==
X-Google-Smtp-Source: ABdhPJwnZV5cquv1nBxvlDmnJPFM0RXEih3//UPGh5OUCHAE4AjeZ7v20vQGa057mdVITSWROEPLsw==
X-Received: by 2002:a4a:5252:: with SMTP id d79mr26181oob.78.1642951753920;
        Sun, 23 Jan 2022 07:29:13 -0800 (PST)
Received: from robh.at.kernel.org (66-90-148-213.dyn.grandenetworks.net. [66.90.148.213])
        by smtp.gmail.com with ESMTPSA id d22sm1007359otp.79.2022.01.23.07.29.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 23 Jan 2022 07:29:13 -0800 (PST)
Received: (nullmailer pid 1429140 invoked by uid 1000);
        Sun, 23 Jan 2022 15:29:12 -0000
Date:   Sun, 23 Jan 2022 09:29:12 -0600
From:   Rob Herring <robh@kernel.org>
To:     Rob Herring <robh@kernel.org>
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Sekhar Nori <nsekhar@ti.com>
Subject: Re: [PATCH] dt-bindings: net: ti,k3-am654-cpts: Fix
 assigned-clock-parents
Message-ID: <Ye10SGPRkGjwcvmr@robh.at.kernel.org>
References: <20220120172319.1628500-1-robh@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220120172319.1628500-1-robh@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 20 Jan 2022 11:23:18 -0600, Rob Herring wrote:
> The schema has a typo with 'assigned-clocks-parents'. As it is not
> required to list assigned clocks in bindings, just drop the assigned-clocks
> property definitions to fix this
> 
> Signed-off-by: Rob Herring <robh@kernel.org>
> ---
>  Documentation/devicetree/bindings/net/ti,k3-am654-cpts.yaml | 6 ------
>  1 file changed, 6 deletions(-)
> 

Applied, thanks!
