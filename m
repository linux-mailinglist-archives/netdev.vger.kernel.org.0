Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C8AB54B257
	for <lists+netdev@lfdr.de>; Tue, 14 Jun 2022 15:34:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242567AbiFNNeo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jun 2022 09:34:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237360AbiFNNej (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jun 2022 09:34:39 -0400
Received: from mail-oa1-x29.google.com (mail-oa1-x29.google.com [IPv6:2001:4860:4864:20::29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8C9D1C10E
        for <netdev@vger.kernel.org>; Tue, 14 Jun 2022 06:34:37 -0700 (PDT)
Received: by mail-oa1-x29.google.com with SMTP id 586e51a60fabf-f2a4c51c45so12455719fac.9
        for <netdev@vger.kernel.org>; Tue, 14 Jun 2022 06:34:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=wxZe6L1nXRSo/rEGlh3/Z3W3UQpOfnPlrbhGyQa89iM=;
        b=jdQoiAUs5HNMpbnUDsHeNGxCy0MwUrPaxuGGOAdUM+86D1Y7rB3cS3ljEDYsFxMxqJ
         t5dYo0O/MYdnpJsS8rMfgx3VHrFbB9mfgTFu/5X2LO+yCB8F3i6VvxfYQJXCLvmzfkTT
         7iMrS8UbMonnfudG0pz45vZDCSrmEIk4AjBpLX1LjtE0BZIHEUpUk0k6Jw8+Yh+gXjn9
         1eVNNOmS0Q8k2BzyfyWW5e7b2YnGJZBmkpkV37g1TsSztBt97JoGBYWo+BERGWcHKJMm
         /futwy78sj59wVyLT/3C3SQREcMoUQqqESHMXMjDn4xsNlw9p2fC+VBK2WiXiR+QUCaY
         XC3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=wxZe6L1nXRSo/rEGlh3/Z3W3UQpOfnPlrbhGyQa89iM=;
        b=vp9KTh/XXmpSd2CakjwGeLbXdafuaQxQdz5amCASQ10g/v8bFZ1p4aLppfF8JAduOZ
         QE5CKPAgr1C8Ybxo6AiN/a2Xdi1RumEww2HXZ3YJDEQzzJCu/1cny8WFP1PzCXEHFIKs
         rnwGE+NyjNuLbLRb9PbxDFAdfVvV4kzNibycSAFLlXz9dplIrIjNOg6q375o/QieUS22
         pg/LAHVN9iNbyHs9oomX7GiH3cKwr7cL4ppCkYTu9dQlqgYwUcEZRux6Q6EmbDfMScgl
         zk9GvCtIZTKjbSunTzK+XclFGvZmctdNFwoGbQUcEk5cvjVcztucAy2n43k6ZypYPlp0
         0skA==
X-Gm-Message-State: AJIora8RGcNsfVqV3M+JKgtnVjweVaCELU1R3+h0YH5tXOnUradsBhBA
        xf0icAtOUSiUFeFfqPYLcMVudBYw17w/8mVOlwfM/g==
X-Google-Smtp-Source: AGRyM1shSsjH9+nQeZGkuBjftOK2ByQh7wQgjTsQ2WG9AHGsBGGVqz3ZiPR2LHS1CCcjcG2DhVb2fuuoiEZuLK8ri38=
X-Received: by 2002:a05:6870:a198:b0:100:ed11:2fcc with SMTP id
 a24-20020a056870a19800b00100ed112fccmr2470639oaf.50.1655213676772; Tue, 14
 Jun 2022 06:34:36 -0700 (PDT)
MIME-Version: 1.0
References: <20220607104015.2126118-1-poprdi@google.com> <CAPUC6bJbVMPn1FMLYnXg2GUX4ikesMSRjj=oPOOrS5H2DOx_bA@mail.gmail.com>
In-Reply-To: <CAPUC6bJbVMPn1FMLYnXg2GUX4ikesMSRjj=oPOOrS5H2DOx_bA@mail.gmail.com>
From:   =?UTF-8?Q?Tam=C3=A1s_Koczka?= <poprdi@google.com>
Date:   Tue, 14 Jun 2022 15:34:25 +0200
Message-ID: <CAPUC6b+xMnk8VDGv_7p9j4GHD75FrxG3hWKpTSF2zHj508=x9A@mail.gmail.com>
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
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Marcel,

I hope this was the change you originally requested, and I did not
misunderstand anything, but if you need any additional modification to
the code or the commit, please feel free to let me know!

Thank you,
Tamas

On Tue, Jun 7, 2022 at 1:44 PM Tam=C3=A1s Koczka <poprdi@google.com> wrote:
>
> Hello Marcel,
>
> I added some comments into the code about what the kcov_remote calls do a=
nd
> why they were implemented and I also added some reasoning to the commit
> message.
>
> I did not mention in the commit but these functions only run if the kerne=
l
> is compiled with CONFIG_KCOV.
>
> Thank you again for reviewing the patch!
>
> --
> Tamas
>
> On Tue, Jun 7, 2022 at 12:40 PM Tamas Koczka <poprdi@google.com> wrote:
> >
> > Annotate hci_rx_work() with kcov_remote_start() and kcov_remote_stop()
> > calls, so remote KCOV coverage is collected while processing the rx_q
> > queue which is the main incoming Bluetooth packet queue.
> >
> > Coverage is associated with the thread which created the packet skb.
> >
> > The collected extra coverage helps kernel fuzzing efforts in finding
> > vulnerabilities.
> >
> > Signed-off-by: Tamas Koczka <poprdi@google.com>
> > ---
> > Changelog since v1:
> >  - add comment about why kcov_remote functions are called
> >
> > v1: https://lore.kernel.org/all/20220517094532.2729049-1-poprdi@google.=
com/
> >
> >  net/bluetooth/hci_core.c | 10 +++++++++-
> >  1 file changed, 9 insertions(+), 1 deletion(-)
> >
> > diff --git a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
> > index 45c2dd2e1590..0af43844c55a 100644
> > --- a/net/bluetooth/hci_core.c
> > +++ b/net/bluetooth/hci_core.c
> > @@ -29,6 +29,7 @@
> >  #include <linux/rfkill.h>
> >  #include <linux/debugfs.h>
> >  #include <linux/crypto.h>
> > +#include <linux/kcov.h>
> >  #include <linux/property.h>
> >  #include <linux/suspend.h>
> >  #include <linux/wait.h>
> > @@ -3780,7 +3781,14 @@ static void hci_rx_work(struct work_struct *work=
)
> >
> >         BT_DBG("%s", hdev->name);
> >
> > -       while ((skb =3D skb_dequeue(&hdev->rx_q))) {
> > +       /* The kcov_remote functions used for collecting packet parsing
> > +        * coverage information from this background thread and associa=
te
> > +        * the coverage with the syscall's thread which originally inje=
cted
> > +        * the packet. This helps fuzzing the kernel.
> > +        */
> > +       for (; (skb =3D skb_dequeue(&hdev->rx_q)); kcov_remote_stop()) =
{
> > +               kcov_remote_start_common(skb_get_kcov_handle(skb));
> > +
> >                 /* Send copy to monitor */
> >                 hci_send_to_monitor(hdev, skb);
> >
> > --
> > 2.36.1.255.ge46751e96f-goog
> >
