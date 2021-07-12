Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20A173C5A86
	for <lists+netdev@lfdr.de>; Mon, 12 Jul 2021 13:04:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238178AbhGLKGm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Jul 2021 06:06:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235252AbhGLKGe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Jul 2021 06:06:34 -0400
Received: from mail-qt1-x82b.google.com (mail-qt1-x82b.google.com [IPv6:2607:f8b0:4864:20::82b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 875A8C0613E8;
        Mon, 12 Jul 2021 03:03:44 -0700 (PDT)
Received: by mail-qt1-x82b.google.com with SMTP id z12so13486532qtj.3;
        Mon, 12 Jul 2021 03:03:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=jms.id.au; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ngW9aOExkdA+8gr3Muk6ucNPU2ote1fxcTjHlDfbYPA=;
        b=ldgz/aTvlPE0wN5F95/vk6lbZSXd8s3hKumAUg0zKoiB769NTKawQ67pVUdhMPZbgZ
         Ah5SJP3fY611LFd5YJ9QeS/2H+ajPzMKnIcrY5ThqDetzV9GopwcNHwrtPCiMlmu12ts
         e2ZzVRdtZEYrlyfmni8ZY+DMV2zzapzHeRPD4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ngW9aOExkdA+8gr3Muk6ucNPU2ote1fxcTjHlDfbYPA=;
        b=cYISlhhiFxNlvHr2cz0o1OiUamUOXEncolzU7o7wv0wuFsjLvz2A1pcSP/AZob4WQb
         SMt3GRE2skjOR7aRqjxQO8xc6XIUIGJIPsIg2gpIInRYDOnSHO35uJFURd10LIuittWc
         b9O+ua7Lwg5lpCdJTwD3RQrTj/DxM2vniC0LAviUggavXmsFdT5S+UMIgJltb2n9Ib5b
         fpLL7KFLmIoqww4QhtTZ4XncMAQBDvtnoK8tox5KUBzsF1GgwI2Wfo54o6THKmty1xOo
         hguXtQVAn1Y0iUJcv1PGq0ft9QEoOdPf23sAAzBsRx/P7/569pjUk1HfmrAaWxGHAC8P
         RSZQ==
X-Gm-Message-State: AOAM531jHrMmS3+LMMMc5aZkmBTuJ67CeausTiourQL62gWNNZqotGxR
        mklBVMrwPL/zP6B7Dir13UhlQDqdRoYBBq/Hz6avgTWp
X-Google-Smtp-Source: ABdhPJwA6F+lr1GUCFpwTdOS+T8+z4SsfDpdbCxoXo57JEjvV1Tm8T70iYN2FbsFkhrmrrgUj+AIaHMTK6i3F8W+lJM=
X-Received: by 2002:ac8:588e:: with SMTP id t14mr46760025qta.363.1626084223702;
 Mon, 12 Jul 2021 03:03:43 -0700 (PDT)
MIME-Version: 1.0
References: <20210708122754.555846-1-i.mikhaylov@yadro.com> <20210708122754.555846-4-i.mikhaylov@yadro.com>
In-Reply-To: <20210708122754.555846-4-i.mikhaylov@yadro.com>
From:   Joel Stanley <joel@jms.id.au>
Date:   Mon, 12 Jul 2021 10:03:30 +0000
Message-ID: <CACPK8XcdUtzZCPcmr+=b5kJ=563KroEtfMATquwkqd6Z11JCDA@mail.gmail.com>
Subject: Re: [PATCH v2 3/3] net/ncsi: add dummy response handler for Intel boards
To:     Ivan Mikhaylov <i.mikhaylov@yadro.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Samuel Mendoza-Jonas <sam@mendozajonas.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Networking <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        OpenBMC Maillist <openbmc@lists.ozlabs.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 8 Jul 2021 at 12:28, Ivan Mikhaylov <i.mikhaylov@yadro.com> wrote:
>
> Add the dummy response handler for Intel boards to prevent incorrect
> handling of OEM commands.

What do you mean?

Is this to handle the response to the link up OEM command? If so,
include it in the same patch.

Can you check that the response is to the link up command and print a
warning if not?

>
> Signed-off-by: Ivan Mikhaylov <i.mikhaylov@yadro.com>
> ---
>  net/ncsi/ncsi-rsp.c | 9 ++++++++-
>  1 file changed, 8 insertions(+), 1 deletion(-)
>
> diff --git a/net/ncsi/ncsi-rsp.c b/net/ncsi/ncsi-rsp.c
> index 04bc50be5c01..d48374894817 100644
> --- a/net/ncsi/ncsi-rsp.c
> +++ b/net/ncsi/ncsi-rsp.c
> @@ -699,12 +699,19 @@ static int ncsi_rsp_handler_oem_bcm(struct ncsi_request *nr)
>         return 0;
>  }
>
> +/* Response handler for Intel card */
> +static int ncsi_rsp_handler_oem_intel(struct ncsi_request *nr)
> +{
> +       return 0;
> +}
> +
>  static struct ncsi_rsp_oem_handler {
>         unsigned int    mfr_id;
>         int             (*handler)(struct ncsi_request *nr);
>  } ncsi_rsp_oem_handlers[] = {
>         { NCSI_OEM_MFR_MLX_ID, ncsi_rsp_handler_oem_mlx },
> -       { NCSI_OEM_MFR_BCM_ID, ncsi_rsp_handler_oem_bcm }
> +       { NCSI_OEM_MFR_BCM_ID, ncsi_rsp_handler_oem_bcm },
> +       { NCSI_OEM_MFR_INTEL_ID, ncsi_rsp_handler_oem_intel }
>  };
>
>  /* Response handler for OEM command */
> --
> 2.31.1
>
