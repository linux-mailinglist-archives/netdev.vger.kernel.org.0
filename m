Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B6AD3F09C4
	for <lists+netdev@lfdr.de>; Wed, 18 Aug 2021 19:01:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230009AbhHRRBj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Aug 2021 13:01:39 -0400
Received: from mail-oi1-f182.google.com ([209.85.167.182]:46859 "EHLO
        mail-oi1-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229784AbhHRRBg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Aug 2021 13:01:36 -0400
Received: by mail-oi1-f182.google.com with SMTP id o185so4210921oih.13;
        Wed, 18 Aug 2021 10:01:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=6MI4ZiJrNc1T/pvShWCww0N420PCI/tCznhAZae3qLY=;
        b=Zc94I36nMtkzsLU1cWyMjBqVnuf/AIm9B0QO52knXf9YlBryM8F9PxFoaHc2m0aFKb
         up4tw/3zSCNRmXBb900bkJ1dbG+/zKHt7Br4+tQvEwwlUzT27g9uci1zd7fx2uz9GweA
         Is+OdT2Wddq1c6sQnpYAqpXLuVY5CQw9q1JtjpvUVydOnMTOh92p6GRoDTU0wWsoEN9v
         FKCX8zVqx+YrhMFKrDv7/tCOhagtO8AB/rdA0/L+3gHx7pylCqFUlkLqJz7UebE+4BIq
         86uk0UEZi6SdaJ7nL9OIkql+O2D8j8ooZ1YSzSataIjcqN5W+wjPI9csnvtNgy3RMihC
         gweA==
X-Gm-Message-State: AOAM532XLjlSvlM7ICKAWF70ThErFCuDpHnInRgkPSRnfM/NjTru3+kN
        4IOMfdLL96XStIjchWkfyw==
X-Google-Smtp-Source: ABdhPJxk8ZFY/WDqbc8NNEGPO5Phd6iPHAzs9/XobnK73ZV2yYlOraEfKHWOpUpUzbL3mrlxjh7bhA==
X-Received: by 2002:a05:6808:81:: with SMTP id s1mr7958816oic.130.1629306061257;
        Wed, 18 Aug 2021 10:01:01 -0700 (PDT)
Received: from robh.at.kernel.org (24-155-109-49.dyn.grandenetworks.net. [24.155.109.49])
        by smtp.gmail.com with ESMTPSA id 4sm121064otp.23.2021.08.18.10.01.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Aug 2021 10:01:00 -0700 (PDT)
Received: (nullmailer pid 2758836 invoked by uid 1000);
        Wed, 18 Aug 2021 17:00:59 -0000
Date:   Wed, 18 Aug 2021 12:00:59 -0500
From:   Rob Herring <robh@kernel.org>
To:     Saravana Kannan <saravanak@google.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Frank Rowand <frowand.list@gmail.com>,
        devicetree@vger.kernel.org, kernel-team@android.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>
Subject: Re: [PATCH v2] of: property: fw_devlink: Add support for
 "phy-handle" property
Message-ID: <YR08yzmns7S2ieHx@robh.at.kernel.org>
References: <20210818021717.3268255-1-saravanak@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210818021717.3268255-1-saravanak@google.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 17 Aug 2021 19:17:16 -0700, Saravana Kannan wrote:
> Allows tracking dependencies between Ethernet PHYs and their consumers.
> 
> Cc: Andrew Lunn <andrew@lunn.ch>
> Cc: netdev@vger.kernel.org
> Signed-off-by: Saravana Kannan <saravanak@google.com>
> ---
> v1 -> v2:
> - Fixed patch to address my misunderstanding of how PHYs get
>   initialized.
> 
>  drivers/of/property.c | 2 ++
>  1 file changed, 2 insertions(+)
> 

Applied, thanks!
