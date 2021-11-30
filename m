Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83969462A20
	for <lists+netdev@lfdr.de>; Tue, 30 Nov 2021 03:03:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237232AbhK3CHH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Nov 2021 21:07:07 -0500
Received: from mail-oi1-f171.google.com ([209.85.167.171]:39691 "EHLO
        mail-oi1-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231586AbhK3CHH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Nov 2021 21:07:07 -0500
Received: by mail-oi1-f171.google.com with SMTP id bf8so38285969oib.6;
        Mon, 29 Nov 2021 18:03:48 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=6HL57uNm/H3xt7eFy3jGsf6zDANHIZw3K9BhNFFQgsU=;
        b=KxPsovdTEdf6kEHp8FDMR6HqKgZP6gJkekukYn9t3HQhuRCmC5uWCZP5yV4q5zypr0
         eczFh22RWJ85b0/0h5BlsJlWIDW0za7YiXVQmFY/lq0qz4nQWlQAzao0RiBoqBH/6qiI
         aWUt0TWwZUZoHdX7fYCrUaSE5eXUjzTIaVdVTl5UcApWHIwacYZjSmrCNPGS4dDB2IpV
         c8BTnfKuItrR+zTYy8UxlquxjZ7p80n4K3RqNzwBKtWTR4I14TL1/2H4YTqCk5qIIQwq
         hVXh6kGh8hD7k154f9tabK6ny3REB4PIgk04GuoEUszOhawmaw76jdPkqIIJt6JmwPxQ
         0zXg==
X-Gm-Message-State: AOAM532MQX/siJOtQcDlqkuPYipU7lhhOZskdMWU8sEwx2oCnfKSMrgM
        kJdQ9em5cNlZJHkFhDDRHQ==
X-Google-Smtp-Source: ABdhPJzOmVmNGzsEMWhKZIgbvbXPWb4ecvt+TZtewukIEOSoqpZKG7AzZEk7dQl7Uh6mwUZLEEvFTg==
X-Received: by 2002:a05:6808:bc7:: with SMTP id o7mr1633511oik.172.1638237828387;
        Mon, 29 Nov 2021 18:03:48 -0800 (PST)
Received: from robh.at.kernel.org (66-90-148-213.dyn.grandenetworks.net. [66.90.148.213])
        by smtp.gmail.com with ESMTPSA id q44sm3008476otv.80.2021.11.29.18.03.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Nov 2021 18:03:47 -0800 (PST)
Received: (nullmailer pid 1025108 invoked by uid 1000);
        Tue, 30 Nov 2021 02:03:46 -0000
Date:   Mon, 29 Nov 2021 20:03:46 -0600
From:   Rob Herring <robh@kernel.org>
To:     "Peng Fan (OSS)" <peng.fan@oss.nxp.com>
Cc:     linux-kernel@vger.kernel.org, s.hauer@pengutronix.de,
        shawnguo@kernel.org, devicetree@vger.kernel.org,
        aisheng.dong@nxp.com, linux-imx@nxp.com, robh+dt@kernel.org,
        kuba@kernel.org, Peng Fan <peng.fan@nxp.com>, davem@davemloft.net,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        festevam@gmail.com, kernel@pengutronix.de, qiangqing.zhang@nxp.com
Subject: Re: [PATCH 1/4] dt-bindings: net: fec: simplify yaml
Message-ID: <YaWGgt1grmKCMQNZ@robh.at.kernel.org>
References: <20211120115825.851798-1-peng.fan@oss.nxp.com>
 <20211120115825.851798-2-peng.fan@oss.nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211120115825.851798-2-peng.fan@oss.nxp.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 20 Nov 2021 19:58:22 +0800, Peng Fan (OSS) wrote:
> From: Peng Fan <peng.fan@nxp.com>
> 
> i.MX7D, i.MX8MQ and i.MX8QM are compatible with i.MX6SX, so no need
> to split them into three items.
> 
> Signed-off-by: Peng Fan <peng.fan@nxp.com>
> ---
>  Documentation/devicetree/bindings/net/fsl,fec.yaml | 8 ++------
>  1 file changed, 2 insertions(+), 6 deletions(-)
> 

Reviewed-by: Rob Herring <robh@kernel.org>
