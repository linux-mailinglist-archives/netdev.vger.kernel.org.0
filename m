Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 912292A09F4
	for <lists+netdev@lfdr.de>; Fri, 30 Oct 2020 16:35:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726973AbgJ3Pfy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Oct 2020 11:35:54 -0400
Received: from mail-ot1-f65.google.com ([209.85.210.65]:35197 "EHLO
        mail-ot1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726662AbgJ3Pfx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Oct 2020 11:35:53 -0400
Received: by mail-ot1-f65.google.com with SMTP id n11so5916675ota.2;
        Fri, 30 Oct 2020 08:35:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=vccbzc68bHDBMq++68aYNYRwmXj6zqZzAG4IULiUytU=;
        b=WN9UevQrRBy7YS32/UB5XF3oHokMjh5O6MTqhLGZV7lC15M9hXnbVXQWhJ6ocPMool
         5lYOgTBROWjsZBU8Yo+iComxe79beCP2jGm1/MEIPB1Ek4dbe8iIu6c64U79GENg0SuL
         dlngdYdWxvG/mbY72LPm/M3Qk2w8593lZzaRmbabZz/sVYwBXKxMl9DgDE6aEp0c41WL
         lbCZHVMxcl0LUYDnrVNzxCM3eNV/3bxUXG8pMoGcu1/LBsjNcN0zFpY5W7f6IYfCVJMy
         06CdzuqQTP5t9GeHKI0ALoXgwyXJ0XQg6/3eAh8TxQ5JVfvhatBuD8tNfFLjd1AMRQMo
         U0dQ==
X-Gm-Message-State: AOAM533cMkWyxpnXGm0cXxDNUXc3l4hFNlYEG2dYaFRax41bLhky4EDO
        nb+UUZx3igUpWjN5B6IqNjHS5waeOg==
X-Google-Smtp-Source: ABdhPJxDzsHszcfmPSSK8SXja5epS0jPUbOvnuPlJZo6cIJfTjcLhW4RSJwxy4Wz4GiyrV9szB+9RQ==
X-Received: by 2002:a05:6830:154d:: with SMTP id l13mr2258986otp.61.1604072149752;
        Fri, 30 Oct 2020 08:35:49 -0700 (PDT)
Received: from xps15 (24-155-109-49.dyn.grandenetworks.net. [24.155.109.49])
        by smtp.gmail.com with ESMTPSA id x83sm1452216oig.39.2020.10.30.08.35.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Oct 2020 08:35:49 -0700 (PDT)
Received: (nullmailer pid 3886857 invoked by uid 1000);
        Fri, 30 Oct 2020 15:35:48 -0000
Date:   Fri, 30 Oct 2020 10:35:48 -0500
From:   Rob Herring <robh@kernel.org>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     "David S. Miller" <davem@davemloft.net>, linux-can@vger.kernel.org,
        mkl@pengutronix.de, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org,
        Wolfgang Grandegger <wg@grandegger.com>, kernel@pengutronix.de,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Joakim Zhang <qiangqing.zhang@nxp.com>, netdev@vger.kernel.org
Subject: Re: [PATCH v3 2/2] dt-bindings: can: flexcan: convert fsl,*flexcan
 bindings to yaml
Message-ID: <20201030153548.GA3886754@bogus>
References: <20201022075218.11880-1-o.rempel@pengutronix.de>
 <20201022075218.11880-3-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201022075218.11880-3-o.rempel@pengutronix.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 22 Oct 2020 09:52:18 +0200, Oleksij Rempel wrote:
> In order to automate the verification of DT nodes convert
> fsl-flexcan.txt to fsl,flexcan.yaml
> 
> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
> Link: https://lore.kernel.org/r/20201016073315.16232-3-o.rempel@pengutronix.de
> Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
> ---
>  .../bindings/net/can/fsl,flexcan.yaml         | 135 ++++++++++++++++++
>  .../bindings/net/can/fsl-flexcan.txt          |  57 --------
>  2 files changed, 135 insertions(+), 57 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/net/can/fsl,flexcan.yaml
>  delete mode 100644 Documentation/devicetree/bindings/net/can/fsl-flexcan.txt
> 

Reviewed-by: Rob Herring <robh@kernel.org>
