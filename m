Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A3D357BA8E
	for <lists+netdev@lfdr.de>; Wed, 20 Jul 2022 17:38:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235940AbiGTPiP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jul 2022 11:38:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235929AbiGTPiO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jul 2022 11:38:14 -0400
Received: from mail-lf1-x12e.google.com (mail-lf1-x12e.google.com [IPv6:2a00:1450:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 652E22FFE1;
        Wed, 20 Jul 2022 08:38:13 -0700 (PDT)
Received: by mail-lf1-x12e.google.com with SMTP id e28so30836686lfj.4;
        Wed, 20 Jul 2022 08:38:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=38iTN6e5RVRnFpyB3AzTyzUK2iU07sRGeD+ht98rJLM=;
        b=OeIEXclTCOZsmRxunFCydVc7FBgYAN5L19I7RWf1k4e7aig2RX7gHchFoNQqWi6ATP
         RzIhyMB6iSBxjPYHOjivcDDk9IzLvKgfbFxmg/n4gheSybaX2eud51xTIL1+vebWQfrj
         HXXHoX8p0SYPG/4FYhGRbJDBji+C1Y1rK5t8Nc5VNmizf8EdLx0V6gYPm5zoAfdq0Zi7
         AP+1zo/Q3/3HU7Fz0Y0uc6/SUG2am/c5ybAgL3B/gTmeWT9OdlNsNzu5Hza1lBswvIVY
         JT/+95lN01UMvUQvH+E6iM9NhPHfw5x2Aj4VD4Dmxfkn4Gp5hso0zYoiA9StvKG6DWVJ
         4SqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=38iTN6e5RVRnFpyB3AzTyzUK2iU07sRGeD+ht98rJLM=;
        b=OAqFfZ4+CEzCbPjZ0v6RrLhXMemGwu3vo0DuC39E4ae2rLlErKJNUfuqMR1esWqNTO
         Z+y5qhUFzFpAWiRiyFpfg1lgwnAbPxxhrb6tO6j++HM1TggxqRjCn/+5kEWJ05VGaMkQ
         vc5ZwaOTlGZIGa8FKgA8Creal+9ScmvnUo8aN0O5JM3H6WOK19M9CRUF27Psi8/g5r+R
         YZa6FuDk7Vdu4q4oqhqUKJRHuxy1buMb7/u5HZ7i6U5c0IKV1Pazd82F1MUxtWxqdkOg
         z3DN5qKxkct7UQgwXQe32JtDiEnk/iZt4fua4VwLhyaIYOS7vcpY0/qpgMfoDB7vWuYT
         +EZA==
X-Gm-Message-State: AJIora8Rwcs4NhNO1cxPe65JYZLFLJHlbP9up64/bDbFKIBNy3+15Wyc
        gzyLn5SOjq9Z9DLvyA171sZcuwL8Saf3YQUQmvc=
X-Google-Smtp-Source: AGRyM1uEvI2dqMocc3hPmbDB1apJE/wE7korCP7jP5Q7g/ZgyZtE2X/AbemMGmcOL2O+iRdAmqj0bQLyG9zZMqwrS5k=
X-Received: by 2002:a05:6512:3409:b0:489:c549:4693 with SMTP id
 i9-20020a056512340900b00489c5494693mr19375109lfr.26.1658331491543; Wed, 20
 Jul 2022 08:38:11 -0700 (PDT)
MIME-Version: 1.0
References: <1658326045-9931-1-git-send-email-quic_zijuhu@quicinc.com> <1658326045-9931-4-git-send-email-quic_zijuhu@quicinc.com>
In-Reply-To: <1658326045-9931-4-git-send-email-quic_zijuhu@quicinc.com>
From:   Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Date:   Wed, 20 Jul 2022 08:38:01 -0700
Message-ID: <CABBYNZJ9Re7PZOFXhj-2tRwJ1UU2kY+QhB4dJT-=GyCYqb_Hhw@mail.gmail.com>
Subject: Re: [PATCH v1 3/3] Bluetooth: btusb: Remove HCI_QUIRK_BROKEN_ERR_DATA_REPORTING
 for fake CSR
To:     Zijun Hu <quic_zijuhu@quicinc.com>
Cc:     Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        David Miller <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Luiz Augusto Von Dentz <luiz.von.dentz@intel.com>,
        swyterzone@gmail.com,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-bluetooth@vger.kernel.org" <linux-bluetooth@vger.kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>
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

Hi Zijun,

On Wed, Jul 20, 2022 at 7:07 AM Zijun Hu <quic_zijuhu@quicinc.com> wrote:
>
> Fake CSR BT controllers do not enable feature "Erroneous Data Reporting"
> currently, BT core driver will check the feature bit instead of the quirk
> to decide if HCI command HCI_Read|Write_Default_Erroneous_Data_Reporting
> work fine, so remove HCI_QUIRK_BROKEN_ERR_DATA_REPORTING for fake CSR.
>
> Signed-off-by: Zijun Hu <quic_zijuhu@quicinc.com>
> ---
>  drivers/bluetooth/btusb.c | 1 -
>  1 file changed, 1 deletion(-)
>
> diff --git a/drivers/bluetooth/btusb.c b/drivers/bluetooth/btusb.c
> index f0f86c5c3b37..f2b3d31d56cf 100644
> --- a/drivers/bluetooth/btusb.c
> +++ b/drivers/bluetooth/btusb.c
> @@ -2072,7 +2072,6 @@ static int btusb_setup_csr(struct hci_dev *hdev)
>                  * without these the controller will lock up.
>                  */
>                 set_bit(HCI_QUIRK_BROKEN_STORED_LINK_KEY, &hdev->quirks);
> -               set_bit(HCI_QUIRK_BROKEN_ERR_DATA_REPORTING, &hdev->quirks);
>                 set_bit(HCI_QUIRK_BROKEN_FILTER_CLEAR_ALL, &hdev->quirks);
>                 set_bit(HCI_QUIRK_NO_SUSPEND_NOTIFIER, &hdev->quirks);

You will probably need to remove HCI_QUIRK_BROKEN_ERR_DATA_REPORTING
last otherwise it breaks the build in between patches, and please
double check if there are no other instances of driver using it or
perhaps leave it defined in case the feature is broken for some reason
but then we need a macro that checks both the quirk and the feature
bit.

> --
> The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum, a Linux Foundation Collaborative Project
>


-- 
Luiz Augusto von Dentz
