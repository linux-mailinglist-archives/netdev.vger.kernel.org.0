Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 593D953FDC0
	for <lists+netdev@lfdr.de>; Tue,  7 Jun 2022 13:44:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243072AbiFGLok (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jun 2022 07:44:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231336AbiFGLoi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jun 2022 07:44:38 -0400
Received: from mail-ot1-x32d.google.com (mail-ot1-x32d.google.com [IPv6:2607:f8b0:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 846A16D1A5
        for <netdev@vger.kernel.org>; Tue,  7 Jun 2022 04:44:36 -0700 (PDT)
Received: by mail-ot1-x32d.google.com with SMTP id a21-20020a9d4715000000b0060bfaac6899so3939409otf.12
        for <netdev@vger.kernel.org>; Tue, 07 Jun 2022 04:44:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=CC06lgSkGCWh2r8wfAjwA7M8zDgeCJ0ppn5yYsqmoig=;
        b=HqM5sBfI+Wffho9iQKZFCEXNcdbw+bZ00r50l6VV2zoaRZm3V64sxJZIx0FGeKUUA6
         TKzNgYEbcrLQn5eE3KEEGL6HCVLLNpQW+rp0ZuUwlR28dz67wARscmwnXF4ZKfpl3H94
         k2/HYjU7+2Xt35P9Qz4g3YixC9T21Bp5z816THKeYPEXa4sJk2GHjN4yyFf5sYDzOFj6
         nqzf5QpOOAFNMSo7Tt8b8TD6DYq87i/0uqBpd4nbSmlA9yxw7qOycxFzIOKQj8LPYvIb
         30Z6OO0vgjLuXEiJy3ACjdeaBpCDVbw3DtqjlTonVvEx9hjZhYjjuchZVQXP8LoOenWD
         x6Gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=CC06lgSkGCWh2r8wfAjwA7M8zDgeCJ0ppn5yYsqmoig=;
        b=Y0KzpehI0zMHDheRvjubqn6k5QkbME7wA8D3Hha2f72sic7Ao9VVpPbusdwdvf/TdE
         twtthjm0n8/Xktr6iE9lDyX7Z4joevggCz0EFW0DSvLVAOOESTsnAbCrr9pW0E+cqMcN
         wiE3hEl9USfaGhm264I3JD4EZlY3FUoXkZo1gWdm+2BIUNmKyJ4hz+c5wOukNxzrtLsS
         OKsdr05kGSTyZ0JMY0nudE10Fs84QfsJ52UxVdl8HIb/IdLA/OkBdGEUemcYj33+hJAI
         AzulYphWmpZTDfqF+Omrj3odxwD0AchkfsWBz6BZpGFQV5GBstZVPGixwgG5EKBCrmwH
         GRVw==
X-Gm-Message-State: AOAM531fMKXW5GceC3ExUlIuFDQSdcl6zWXwb3E71wyiZz7oynNiQnOt
        5bQfJj3MldhLPg380OVtEajPDq/ZRALYAsYzUOgLEA==
X-Google-Smtp-Source: ABdhPJzL7Vuh/AufKDbpBMNH4VLSCca/2H5JVQO9+WcMs4dxgzTHQWSvnGABZmiJbFgtR97Vg6CDSkoqnxbUYtfkRU4=
X-Received: by 2002:a05:6830:1be8:b0:60c:1e7:52d7 with SMTP id
 k8-20020a0568301be800b0060c01e752d7mr2732437otb.126.1654602275684; Tue, 07
 Jun 2022 04:44:35 -0700 (PDT)
MIME-Version: 1.0
References: <20220607104015.2126118-1-poprdi@google.com>
In-Reply-To: <20220607104015.2126118-1-poprdi@google.com>
From:   =?UTF-8?Q?Tam=C3=A1s_Koczka?= <poprdi@google.com>
Date:   Tue, 7 Jun 2022 13:44:24 +0200
Message-ID: <CAPUC6bJbVMPn1FMLYnXg2GUX4ikesMSRjj=oPOOrS5H2DOx_bA@mail.gmail.com>
Subject: Re: [PATCH v2] Bluetooth: Collect kcov coverage from hci_rx_work
To:     Marcel Holtmann <marcel@holtmann.org>
Cc:     Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Andy Nguyen <theflow@google.com>,
        Aleksandr Nogikh <nogikh@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Marcel,

I added some comments into the code about what the kcov_remote calls do and
why they were implemented and I also added some reasoning to the commit
message.

I did not mention in the commit but these functions only run if the kernel
is compiled with CONFIG_KCOV.

Thank you again for reviewing the patch!

--
Tamas

On Tue, Jun 7, 2022 at 12:40 PM Tamas Koczka <poprdi@google.com> wrote:
>
> Annotate hci_rx_work() with kcov_remote_start() and kcov_remote_stop()
> calls, so remote KCOV coverage is collected while processing the rx_q
> queue which is the main incoming Bluetooth packet queue.
>
> Coverage is associated with the thread which created the packet skb.
>
> The collected extra coverage helps kernel fuzzing efforts in finding
> vulnerabilities.
>
> Signed-off-by: Tamas Koczka <poprdi@google.com>
> ---
> Changelog since v1:
>  - add comment about why kcov_remote functions are called
>
> v1: https://lore.kernel.org/all/20220517094532.2729049-1-poprdi@google.com/
>
>  net/bluetooth/hci_core.c | 10 +++++++++-
>  1 file changed, 9 insertions(+), 1 deletion(-)
>
> diff --git a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
> index 45c2dd2e1590..0af43844c55a 100644
> --- a/net/bluetooth/hci_core.c
> +++ b/net/bluetooth/hci_core.c
> @@ -29,6 +29,7 @@
>  #include <linux/rfkill.h>
>  #include <linux/debugfs.h>
>  #include <linux/crypto.h>
> +#include <linux/kcov.h>
>  #include <linux/property.h>
>  #include <linux/suspend.h>
>  #include <linux/wait.h>
> @@ -3780,7 +3781,14 @@ static void hci_rx_work(struct work_struct *work)
>
>         BT_DBG("%s", hdev->name);
>
> -       while ((skb = skb_dequeue(&hdev->rx_q))) {
> +       /* The kcov_remote functions used for collecting packet parsing
> +        * coverage information from this background thread and associate
> +        * the coverage with the syscall's thread which originally injected
> +        * the packet. This helps fuzzing the kernel.
> +        */
> +       for (; (skb = skb_dequeue(&hdev->rx_q)); kcov_remote_stop()) {
> +               kcov_remote_start_common(skb_get_kcov_handle(skb));
> +
>                 /* Send copy to monitor */
>                 hci_send_to_monitor(hdev, skb);
>
> --
> 2.36.1.255.ge46751e96f-goog
>
