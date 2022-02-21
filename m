Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 840694BE21E
	for <lists+netdev@lfdr.de>; Mon, 21 Feb 2022 18:54:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347876AbiBUJJg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Feb 2022 04:09:36 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:36066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347828AbiBUJI4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Feb 2022 04:08:56 -0500
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A19127146
        for <netdev@vger.kernel.org>; Mon, 21 Feb 2022 01:00:52 -0800 (PST)
Received: by mail-pj1-x1033.google.com with SMTP id b8so14532449pjb.4
        for <netdev@vger.kernel.org>; Mon, 21 Feb 2022 01:00:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Dud4wl8y+LZmCLdkFSU7QbiakBoSq1Jeyz9YQqn3rNo=;
        b=j8DP+wEhblNq85DGtSuK/djC85WwiCCmIZtk/X4JdxyenucKDmSH5VN7O27KlDjzfO
         h2r4vbZm64h9wVbwBIic0ytf76wuCn/Gi67prU5CXRcbUHbmi7FzmkYIOn72/rIuTWLK
         Ckw/5cPEqcVWiEapgX9H31QOYSe6eGxf2nfvbjV8KYMAjEgnd90frGoNRCqNGUFgAOrQ
         AnMFSb5rVKMkJlCddmvsj6y7B6Kg4OjLpuZH4uMiCttMVAVJYLyFLojI9bYfte5kVYel
         Il9CV9D4EmtflvudRQ44llKaq2QnCgMiTX2AFk8JcrI42ZHVzZC8nsZj79ZwOAbis5DO
         xz4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Dud4wl8y+LZmCLdkFSU7QbiakBoSq1Jeyz9YQqn3rNo=;
        b=glf9llMtauQ+zqnMpv5sf5bRfyuKFjT1FLdwgewZcJtlsgHmw6Z7Ex0h2C1YLAk+5o
         qCJFi2GIyMz46xrUbT7FuFJoUSqE8C3jNbpVBMy3weSrj9fOp2OBe2/Htr3HU/4ySSGN
         mzjC8jJTnMRvQ1pTIPbH8qUA9GD5RSWzxA2cAU3RDEs5X+fNG7oaV+39MS4my7d0lyV+
         2k+FzC1y5cP6Q7Sn0R24QDIBEQ/rTqZYRQpa2dYUV4flxR084jpZQuopFyNv0Zdjzy+I
         VASRBNHpwkcSjkjmDCFLKtF8fKHxJi8A0ClsR6yz/XV7HjHQeAxYIC6HcmAYc/n+cZvw
         /2EQ==
X-Gm-Message-State: AOAM532/ngE8YbXmHnbeK+Vki/sw/WiY6qmoLUffgIqRd84n0Z+gaxak
        11ToN03V0NUBI/g3caHmDFRu+xivc2acAuGyy6OzaA==
X-Google-Smtp-Source: ABdhPJypnza5WDBfv//wdLcCfitImT4GppEIr1iPQiLUs6bmG84m9QM8ZrlyiOzwoE1AuHLUbKmH+OK6gMwC0+rS2AI=
X-Received: by 2002:a17:902:e550:b0:14f:a673:bb50 with SMTP id
 n16-20020a170902e55000b0014fa673bb50mr6666414plf.51.1645434051793; Mon, 21
 Feb 2022 01:00:51 -0800 (PST)
MIME-Version: 1.0
References: <yonglin.tan@outlook.com> <MEYP282MB237443EA389045F03FF2B48BFD3A9@MEYP282MB2374.AUSP282.PROD.OUTLOOK.COM>
In-Reply-To: <MEYP282MB237443EA389045F03FF2B48BFD3A9@MEYP282MB2374.AUSP282.PROD.OUTLOOK.COM>
From:   Loic Poulain <loic.poulain@linaro.org>
Date:   Mon, 21 Feb 2022 10:00:16 +0100
Message-ID: <CAMZdPi9xN_gQRUz3C2MPoSu9O_byaHnydZm3spX3Buecb8_hng@mail.gmail.com>
Subject: Re: [PATCH] net: wwan: To support SAHARA port for Qualcomm WWAN module.
To:     Yonglin Tan <yonglin.tan@outlook.com>
Cc:     ryazanov.s.a@gmail.com, johannes@sipsolutions.net,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Manivannan Sadhasivam <mani@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Yonglin,

On Mon, 21 Feb 2022 at 09:42, Yonglin Tan <yonglin.tan@outlook.com> wrote:
>
> The SAHARA port for Qualcomm WWAN module is used to capture
> memory dump. But now this feature has not been supported by
> linux kernel code. Such that no SAHARA driver matched while
> the device entered to DUMP mode.

So this is SAHARA debug mode? Can you share an example of usage and
tool to communicate via this channel, AFAIU SAHARA is already partly
supported in MHI stack to load the firehose programmer automatically,
so can you elaborate a bit on how it works?

Regards,
Loic


>
> Cc: stable@vger.kernel.org
> Fixes: fa588eba632d ("net: Add Qcom WWAN control driver")
> Signed-off-by: Yonglin Tan <yonglin.tan@outlook.com>
> ---
>  drivers/net/wwan/mhi_wwan_ctrl.c | 1 +
>  drivers/net/wwan/wwan_core.c     | 4 ++++
>  include/linux/wwan.h             | 1 +
>  3 files changed, 6 insertions(+)
>
> diff --git a/drivers/net/wwan/mhi_wwan_ctrl.c b/drivers/net/wwan/mhi_wwan_ctrl.c
> index e4d0f69..4cf420e 100644
> --- a/drivers/net/wwan/mhi_wwan_ctrl.c
> +++ b/drivers/net/wwan/mhi_wwan_ctrl.c
> @@ -262,6 +262,7 @@ static const struct mhi_device_id mhi_wwan_ctrl_match_table[] = {
>         { .chan = "QMI", .driver_data = WWAN_PORT_QMI },
>         { .chan = "DIAG", .driver_data = WWAN_PORT_QCDM },
>         { .chan = "FIREHOSE", .driver_data = WWAN_PORT_FIREHOSE },
> +       { .chan = "SAHARA", .driver_data = WWAN_PORT_SAHARA },
>         {},
>  };
>  MODULE_DEVICE_TABLE(mhi, mhi_wwan_ctrl_match_table);
> diff --git a/drivers/net/wwan/wwan_core.c b/drivers/net/wwan/wwan_core.c
> index b8c7843..2630677 100644
> --- a/drivers/net/wwan/wwan_core.c
> +++ b/drivers/net/wwan/wwan_core.c
> @@ -318,6 +318,10 @@ static const struct {
>                 .name = "FIREHOSE",
>                 .devsuf = "firehose",
>         },
> +       [WWAN_PORT_SAHARA] = {
> +               .name = "SAHARA",
> +               .devsuf = "sahara",
> +       },
>  };
>
>  static ssize_t type_show(struct device *dev, struct device_attribute *attr,
> diff --git a/include/linux/wwan.h b/include/linux/wwan.h
> index 5ce2acf..fc8ecaf 100644
> --- a/include/linux/wwan.h
> +++ b/include/linux/wwan.h
> @@ -26,6 +26,7 @@ enum wwan_port_type {
>         WWAN_PORT_QMI,
>         WWAN_PORT_QCDM,
>         WWAN_PORT_FIREHOSE,
> +       WWAN_PORT_SAHARA,
>
>         /* Add new port types above this line */
>
> --
> 2.7.4
>
