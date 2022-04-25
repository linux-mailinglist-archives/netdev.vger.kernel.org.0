Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1EA1F50ED02
	for <lists+netdev@lfdr.de>; Tue, 26 Apr 2022 01:55:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239015AbiDYX5m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Apr 2022 19:57:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239296AbiDYX5h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Apr 2022 19:57:37 -0400
Received: from mail-vs1-xe2f.google.com (mail-vs1-xe2f.google.com [IPv6:2607:f8b0:4864:20::e2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A76F1229D1;
        Mon, 25 Apr 2022 16:54:16 -0700 (PDT)
Received: by mail-vs1-xe2f.google.com with SMTP id q2so2098391vsr.5;
        Mon, 25 Apr 2022 16:54:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=YFkcDicRHSZajVBrdo4GhgjyHM8SuMV6+B6++T6citk=;
        b=XHilT0RUqv9fU04YqgopxYoMskd7PE2BmZA+qc4EOtlnasy6p/KO/Z7sx1pe2ibne3
         QXsASz4xpTToImRgDh5yftQ5eRhaLUeUXtnr0vgreKecPbJgsQcbgNzYMLpfYlrIsand
         MscEZdlhoNbOIu1xI7L04qPPD4F9WNliCBQV2korItmItsAY+pzK2D9JSQYh2qqfI88U
         5ISxqJOJ8X4UQGgq6FcyQPJBANx4HDGnKbNXqBmRGO/GvP8zRoH/Y0R9p1iQ43W7Rh7Q
         ScMseBzZdesbo8OFuzrARoIWGUpCajh+fJC4pEbstHU2rx6F3RVLPNt/GF6vq+AJW5FM
         pTpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=YFkcDicRHSZajVBrdo4GhgjyHM8SuMV6+B6++T6citk=;
        b=5IO/IlZEVqKFRTn8xme0+gnO0+dpryVmXAt1M/dZGsFiEIA1qZ81LE+YdKw4nOgtL8
         ZtWnq/hWq4xSC8Gp7SSIoaVFmZ8IKwuGRD3MiAf8XZlAPLKiV35y7+E6ZsFmtdoOO1wS
         DAGKHKupT5aVr31E/yPmARWLRIKciRmDJdKNAiSNmwIPYKJ3x4qV9V0uCyH2Z9MPUWv/
         mbojgb7elqBdW1K7nsLMDMyFzo0geBC6TuVfa3O5358h3IxZ9Z8NdaVJrHIqI+PsCz2p
         T29aA87F6NQHCnD2Y735fkKF3bH/qDiQtAk+X5YhMVKrfucKuuly+YKbAXmsbhYtIIZN
         +eOg==
X-Gm-Message-State: AOAM532/gZGaWu/GrbSjlPW772UVLcD0H7wieq5qCYZc5x2Pu95NyvHV
        Bps+7VGPh9s+dVoipiPjK0erSd/n7lgy1a0goRw=
X-Google-Smtp-Source: ABdhPJyew2B74Wv1osPFd4N6iGW+zgI4Aq+mawdQg88ozXRkEWxiODMB/shmn9/WxxWXQfVSI6eMO2eTM7hrLkJ9/HM=
X-Received: by 2002:a05:6102:a85:b0:32c:e106:c795 with SMTP id
 n5-20020a0561020a8500b0032ce106c795mr753571vsg.50.1650930856122; Mon, 25 Apr
 2022 16:54:16 -0700 (PDT)
MIME-Version: 1.0
References: <20220407223629.21487-1-ricardo.martinez@linux.intel.com> <20220407223629.21487-6-ricardo.martinez@linux.intel.com>
In-Reply-To: <20220407223629.21487-6-ricardo.martinez@linux.intel.com>
From:   Sergey Ryazanov <ryazanov.s.a@gmail.com>
Date:   Tue, 26 Apr 2022 02:54:15 +0300
Message-ID: <CAHNKnsRCCMdnGeVbHQN6fybRpctGcbu3x7d8yrpnL7GNOvs2Zw@mail.gmail.com>
Subject: Re: [PATCH net-next v6 05/13] net: wwan: t7xx: Add control port
To:     Ricardo Martinez <ricardo.martinez@linux.intel.com>
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Johannes Berg <johannes@sipsolutions.net>,
        Loic Poulain <loic.poulain@linaro.org>,
        M Chetan Kumar <m.chetan.kumar@intel.com>,
        chandrashekar.devegowda@intel.com,
        Intel Corporation <linuxwwan@intel.com>,
        chiranjeevi.rapolu@linux.intel.com,
        =?UTF-8?B?SGFpanVuIExpdSAo5YiY5rW35YabKQ==?= 
        <haijun.liu@mediatek.com>, amir.hanania@intel.com,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        dinesh.sharma@intel.com, eliot.lee@intel.com,
        ilpo.johannes.jarvinen@intel.com, moises.veleta@intel.com,
        pierre-louis.bossart@intel.com, muralidharan.sethuraman@intel.com,
        Soumya.Prakash.Mishra@intel.com, sreehari.kancharla@intel.com,
        madhusmita.sahu@intel.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 8, 2022 at 1:37 AM Ricardo Martinez
<ricardo.martinez@linux.intel.com> wrote:
> Control Port implements driver control messages such as modem-host
> handshaking, controls port enumeration, and handles exception messages.
>
> The handshaking process between the driver and the modem happens during
> the init sequence. The process involves the exchange of a list of
> supported runtime features to make sure that modem and host are ready
> to provide proper feature lists including port enumeration. Further
> features can be enabled and controlled in this handshaking process.
>
> Signed-off-by: Haijun Liu <haijun.liu@mediatek.com>
> Signed-off-by: Chandrashekar Devegowda <chandrashekar.devegowda@intel.com=
>
> Co-developed-by: Ricardo Martinez <ricardo.martinez@linux.intel.com>
> Signed-off-by: Ricardo Martinez <ricardo.martinez@linux.intel.com>
>
> From a WWAN framework perspective:
> Reviewed-by: Loic Poulain <loic.poulain@linaro.org>
>
> Reviewed-by: Ilpo J=C3=A4rvinen <ilpo.jarvinen@linux.intel.com>

Reviewed-by: Sergey Ryazanov <ryazanov.s.a@gmail.com>
