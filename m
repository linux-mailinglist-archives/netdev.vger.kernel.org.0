Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8289B4AF55A
	for <lists+netdev@lfdr.de>; Wed,  9 Feb 2022 16:34:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235931AbiBIPex (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Feb 2022 10:34:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231876AbiBIPev (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Feb 2022 10:34:51 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D4FEC05CB87;
        Wed,  9 Feb 2022 07:34:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D31A9B81FB8;
        Wed,  9 Feb 2022 15:34:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86EFDC340E7;
        Wed,  9 Feb 2022 15:34:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644420889;
        bh=eVk5wWnJ0+/pF0UIa8PFw94fSYnY2gr12ZvgKyY4bzM=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=KLV+E1ipaXh8DngCmRPKmqkh0OLJJnvWw2Q++9H10THEHkuZfdPNYoee+SjVjK9k9
         PHKx2rwHxC+UkC+lLJOyvNPPEi+TEHDQY+2vaZMbRllTdTnqhz8RuthnX+BWR/R87T
         IHLtTfZzlmaizSgxfMv9v6j99a1Ecaybh3LRhcshgcr7iydVa7EJi+aNLRf/PZyfm6
         KvkBlkomoQeopjuCdOzogFp4e4Ds5Vgc21zBYZRznPSnpGtH84BWJFArZnn+0wg6ym
         8z4dJOVrw8dKBOqlC/cMtvYfJhwJqc3VE9xS2XA9sMrY/jC05DBQzuAVbc5R2jrfBE
         DL4S9YBa2ThJQ==
Received: by mail-ej1-f50.google.com with SMTP id y3so8536161ejf.2;
        Wed, 09 Feb 2022 07:34:49 -0800 (PST)
X-Gm-Message-State: AOAM533UoF1oMCG14JWkAu531kIZtOQSpyzrhcVIc1TnSkVAgxJPG/Jp
        z9as4lO6+V0Njlg+pyUa7WrFPw4ml5L9FDMdCA==
X-Google-Smtp-Source: ABdhPJxHXJN3u6QEbqWnNJZ4l9imA9ctiMCgn3zEkAbocpHml02pUDH1JiWkc/urG10Mf3qnVfS/W4TCc1PiSWkkUZw=
X-Received: by 2002:a17:906:4781:: with SMTP id cw1mr2480397ejc.264.1644420887835;
 Wed, 09 Feb 2022 07:34:47 -0800 (PST)
MIME-Version: 1.0
References: <20220209082820.2210753-1-o.rempel@pengutronix.de>
In-Reply-To: <20220209082820.2210753-1-o.rempel@pengutronix.de>
From:   Rob Herring <robh+dt@kernel.org>
Date:   Wed, 9 Feb 2022 09:34:36 -0600
X-Gmail-Original-Message-ID: <CAL_Jsq+nWLrs0eAvNwV3suT4Xw+sLo6=yJhV9CyZXj+-xRE+Zg@mail.gmail.com>
Message-ID: <CAL_Jsq+nWLrs0eAvNwV3suT4Xw+sLo6=yJhV9CyZXj+-xRE+Zg@mail.gmail.com>
Subject: Re: [PATCH net-next v1] dt-bindings: net: ethernet-controller:
 document label property
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Sascha Hauer <kernel@pengutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>, devicetree@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 9, 2022 at 2:28 AM Oleksij Rempel <o.rempel@pengutronix.de> wrote:
>
> "label" provides human readable name used on a box, board or schematic
> to identify Ethernet port.

Do you still need this?

> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
> ---
>  .../devicetree/bindings/net/ethernet-controller.yaml          | 4 ++++
>  1 file changed, 4 insertions(+)
>
> diff --git a/Documentation/devicetree/bindings/net/ethernet-controller.yaml b/Documentation/devicetree/bindings/net/ethernet-controller.yaml
> index 34c5463abcec..817794e56227 100644
> --- a/Documentation/devicetree/bindings/net/ethernet-controller.yaml
> +++ b/Documentation/devicetree/bindings/net/ethernet-controller.yaml
> @@ -13,6 +13,10 @@ properties:
>    $nodename:
>      pattern: "^ethernet(@.*)?$"
>
> +  label:
> +    $ref: /schemas/types.yaml#/definitions/string
> +    description: Human readable label on a port of a box.
> +
>    local-mac-address:
>      description:
>        Specifies the MAC address that was assigned to the network device.
> --
> 2.30.2
>
