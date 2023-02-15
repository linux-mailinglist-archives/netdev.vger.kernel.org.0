Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5270269859F
	for <lists+netdev@lfdr.de>; Wed, 15 Feb 2023 21:36:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229787AbjBOUgt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Feb 2023 15:36:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229489AbjBOUgs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Feb 2023 15:36:48 -0500
Received: from mail-lj1-x230.google.com (mail-lj1-x230.google.com [IPv6:2a00:1450:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A46EE3B3C4;
        Wed, 15 Feb 2023 12:36:47 -0800 (PST)
Received: by mail-lj1-x230.google.com with SMTP id m10so23570950ljp.3;
        Wed, 15 Feb 2023 12:36:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=E5V1ZdTdvcE7drkxcFR/cP3t+37fXHswTkqQ+7j3RCA=;
        b=ddce220YJIYbkdz1ID8+Z6NSXl8zDp1BJAgxC3+54RkwSQ/Fld8XCsxuy6yCULD3Un
         KzvFoGDf41/j4yyeGdZ8IfnAQmSi3lBEq1pG+0knDHUnUdXhhBvYNldyKjovvYpgoAe/
         GCQJjKAnVjSEl8ISCsisSZxLmIQDB5jzxu0JHMXrSJQKJFJLLDP3BQATyO3ukiqbCJ7b
         sP/6sqy7mxFZZfTqxIQtUqhzU/jAUs1f9Ki3GDtDO2NE11Tihsy9eSF9QHzGZS8NJJV3
         NqiwoWAlt6D7ytcsDQE3XeC2xg+cKqqZTJHN5OAXqWQK8FoGo6YvPgGsUh/Wro6fEQDv
         aZCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=E5V1ZdTdvcE7drkxcFR/cP3t+37fXHswTkqQ+7j3RCA=;
        b=T+ct5YP//Y2uGncQGp4fOk/WSRxK/ev1T5vl+RUS/Wle8LF0tO3WkjcXMdog6JZ5O5
         I3j2rL4Hucl7AehNunr69k8lR2DCqfw9Os/KtFolM2Sl1TKES/fpIzHaPFJ12GmuY6An
         zn/N3lou5g/0xZUg698NSZ0KsCjM2HhBAFsoPbji0hu3Fz+LflZ4TjPpu8RBWZ90iGac
         DlzwXnqJfsHz1x8dedJVGLOS3Kw/hUIWXXnr/PRNi3+JYxmGKEFMxVE3Vqm/hi14sSOP
         vB1z33Q/PMUNOp4WZJxPfZTCYhewPTJAOVES+DF7WEa0w9WlZRjeJfVCnnmlARYKriXD
         sw5g==
X-Gm-Message-State: AO0yUKVBN9czLez1qaQT+oLNTDnZQML8HDVwYgzNPSyMqp+JWxZkSfft
        +9pRwf1sBV4/9gL2LlVGdMJ0dK/NrwsNnM4hjJ0=
X-Google-Smtp-Source: AK7set95pVLcVG5npoPY1aY8WLoZDkMtgDrncHbyQguMuWq7gDe08kZ5qkJWk+GGUPSBrCTMEbx02OGoGFdZN95Ajhs=
X-Received: by 2002:a2e:8e21:0:b0:293:603a:7631 with SMTP id
 r1-20020a2e8e21000000b00293603a7631mr983840ljk.9.1676493405842; Wed, 15 Feb
 2023 12:36:45 -0800 (PST)
MIME-Version: 1.0
References: <20230213120926.8166-1-francesco@dolcini.it>
In-Reply-To: <20230213120926.8166-1-francesco@dolcini.it>
From:   Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Date:   Wed, 15 Feb 2023 12:36:34 -0800
Message-ID: <CABBYNZ+y2jDi=0FFx31oB86skpDFTm5n+fDd5LBmvdxzOhqoSA@mail.gmail.com>
Subject: Re: [PATCH v3 0/5] Bluetooth: hci_mrvl: Add serdev support for 88W8997
To:     Francesco Dolcini <francesco@dolcini.it>
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        Marcel Holtmann <marcel@holtmann.org>,
        linux-arm-kernel@lists.infradead.org,
        Francesco Dolcini <francesco.dolcini@toradex.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Shawn Guo <shawnguo@kernel.org>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Fabio Estevam <festevam@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Francesco,

On Mon, Feb 13, 2023 at 4:09 AM Francesco Dolcini <francesco@dolcini.it> wrote:
>
> From: Francesco Dolcini <francesco.dolcini@toradex.com>
>
> Add serdev support for the 88W8997 from NXP (previously Marvell). It includes
> support for changing the baud rate. The command to change the baud rate is
> taken from the user manual UM11483 Rev. 9 in section 7 (Bring-up of Bluetooth
> interfaces) from NXP.
>
> v3:
>  - Use __hci_cmd_sync_status instead of __hci_cmd_sync
>
> v2:
>  - Fix the subject as pointed out by Krzysztof. Thanks!
>  - Fix indentation in marvell-bluetooth.yaml
>  - Fix compiler warning for kernel builds without CONFIG_OF enabled
>
> Stefan Eichenberger (5):
>   dt-bindings: bluetooth: marvell: add 88W8997
>   dt-bindings: bluetooth: marvell: add max-speed property
>   Bluetooth: hci_mrvl: use maybe_unused macro for device tree ids
>   Bluetooth: hci_mrvl: Add serdev support for 88W8997
>   arm64: dts: imx8mp-verdin: add 88W8997 serdev to uart4
>
>  .../bindings/net/marvell-bluetooth.yaml       | 20 ++++-
>  .../dts/freescale/imx8mp-verdin-wifi.dtsi     |  5 ++
>  drivers/bluetooth/hci_mrvl.c                  | 90 ++++++++++++++++---
>  3 files changed, 104 insertions(+), 11 deletions(-)
>
> --
> 2.25.1

There seems to be missing one patch 5/5:

https://patchwork.kernel.org/project/bluetooth/list/?series=721269

Other than that the Bluetooth parts seem fine, and perhaps can be
merged if the patch above is not really required.


-- 
Luiz Augusto von Dentz
