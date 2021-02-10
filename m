Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8BB99316C89
	for <lists+netdev@lfdr.de>; Wed, 10 Feb 2021 18:25:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232318AbhBJRZQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Feb 2021 12:25:16 -0500
Received: from mail-ot1-f48.google.com ([209.85.210.48]:46311 "EHLO
        mail-ot1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232172AbhBJRZA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Feb 2021 12:25:00 -0500
Received: by mail-ot1-f48.google.com with SMTP id r21so2476833otk.13;
        Wed, 10 Feb 2021 09:24:45 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=8nNFiLXbySId1/XyNUqt5xlgqNafoMDnEfdcSbaBkSc=;
        b=Bwn6KHLEyAg9Ss+RRSiBsjMzhGUXRej8q11ZZvvBJYFO2b4uV+JEkBRV0tnheE4f7W
         x3hS5JDKN2JdX5g008yPvm8nsw2b0BNpHNQUMt3ulMKjRP1SMSYnJ/x+O+cYHmaFptDa
         lTWwpVWhk8VLcuphQUkaPEfUAGY5IILlSpo97lvDzIFC02qmuxEGcBPflvtV/veaavW7
         6c5/K4vFNknTF1FUJ5irgQage891uO1ocguUiFJE3TN9WM0cWbJRSnuE9Ap8cI7IUfw0
         8DPgS4L7IAB3p5V6KbP0AQMJstW9upyBRc8/6OHrfm2HEoLsH5SURTX7c+rpfwdqsXEk
         benA==
X-Gm-Message-State: AOAM533cdFKDDR3eo+ZFS4RmUwyopjzWZdcj5l3JLV512sJFOaVaLHzz
        VAB9yhpnQ9I1FbsBID8uhA==
X-Google-Smtp-Source: ABdhPJwxJhxyU838P5kr+mpJ1CXXyIzFrPmOrIk4EQh1nYd0zbXwgroTPA6OF11JO28JV3Ur2mvM5Q==
X-Received: by 2002:a05:6830:1d45:: with SMTP id p5mr2918738oth.272.1612977860067;
        Wed, 10 Feb 2021 09:24:20 -0800 (PST)
Received: from robh.at.kernel.org (24-155-109-49.dyn.grandenetworks.net. [24.155.109.49])
        by smtp.gmail.com with ESMTPSA id x201sm567169oix.2.2021.02.10.09.24.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Feb 2021 09:24:19 -0800 (PST)
Received: (nullmailer pid 2377742 invoked by uid 1000);
        Wed, 10 Feb 2021 17:24:17 -0000
Date:   Wed, 10 Feb 2021 11:24:17 -0600
From:   Rob Herring <robh@kernel.org>
To:     stefanc@marvell.com
Cc:     davem@davemloft.net, linux-kernel@vger.kernel.org,
        atenart@kernel.org, sebastian.hesselbarth@gmail.com,
        devicetree@vger.kernel.org, andrew@lunn.ch,
        thomas.petazzoni@bootlin.com, ymarkman@marvell.com,
        rmk+kernel@armlinux.org.uk, nadavh@marvell.com, kuba@kernel.org,
        mw@semihalf.com, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, robh+dt@kernel.org,
        gregory.clement@bootlin.com, linux@armlinux.org.uk
Subject: Re: [PATCH v12 net-next 01/15] doc: marvell: add CM3 address space
 and PPv2.3 description
Message-ID: <20210210172417.GA2377694@robh.at.kernel.org>
References: <1612950500-9682-1-git-send-email-stefanc@marvell.com>
 <1612950500-9682-2-git-send-email-stefanc@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1612950500-9682-2-git-send-email-stefanc@marvell.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 10 Feb 2021 11:48:06 +0200, stefanc@marvell.com wrote:
> From: Stefan Chulski <stefanc@marvell.com>
> 
> Patch adds CM3 address space and PPv2.3 description.
> 
> Signed-off-by: Stefan Chulski <stefanc@marvell.com>
> Acked-by: Marcin Wojtas <mw@semihalf.com>
> ---
>  Documentation/devicetree/bindings/net/marvell-pp2.txt | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 

Acked-by: Rob Herring <robh@kernel.org>
