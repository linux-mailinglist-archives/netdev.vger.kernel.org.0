Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A49CE50ED07
	for <lists+netdev@lfdr.de>; Tue, 26 Apr 2022 01:55:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238050AbiDYX6p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Apr 2022 19:58:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237497AbiDYX6o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Apr 2022 19:58:44 -0400
Received: from mail-ua1-x92d.google.com (mail-ua1-x92d.google.com [IPv6:2607:f8b0:4864:20::92d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 638B6E8A;
        Mon, 25 Apr 2022 16:55:39 -0700 (PDT)
Received: by mail-ua1-x92d.google.com with SMTP id x5so2511003uap.8;
        Mon, 25 Apr 2022 16:55:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=tH/ROVgKY3OT6LRZuUX9V9tkUlYpErNSE1cVABWRc/0=;
        b=TfqcjRGnMHUjrb34mmbVPfHSaNQYuMbIy6msF1RO80iuMW62Z3vx5lcbN4wylTKXVi
         /qCPW29EOvm9iGGWVUFrOTYMlaz0Lrcql5XHu1Hk5CA0MS9QUprvuIPBgLlIz+jeKD0G
         1Zr8Bi1bofZXqGFDjDrA1GjyRUUZuA471gnGqm7WjctFN1x95DF136XNKLiB9ofkwIMW
         bGN89DD0MYPScD8u4SXPVGuxZM205Vd8zgHY0+v7GbrHR0rOdsfpe7TsV9EWJ9Pah2Wr
         XflwxPsohU/XyWCWqx0YjDn1gHskwFlm3wnyvmCX3umShj+B1PnTupJyLRy/xmnt+1pd
         pYYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=tH/ROVgKY3OT6LRZuUX9V9tkUlYpErNSE1cVABWRc/0=;
        b=PnRszXaCi8AvpaZ4OjSk7RbSlrijB9gy/KOMYayj8LsQEsHWVvMMB/ifiwqcvCxTfD
         E4eo9c3r7C1x5UnA3FUvIlhpEt12BcGaHUFc70XxWjPG7K7UVYHVlDdneG0isr6nIrQC
         nEU/fOeE3q8WhKe/FuJQe9shReSiATZKszB2SNzH6N6aM86qmYbztZa7Q7uvAKrxiX08
         F/pvj7PRd8ZL4RYcZhCKEEaFuLEkaPbW+eUVvzxWDork1PRS1w+jLyaGM/KF3bgduC4d
         /GE/8zs5aO61WMwD66UsHEQ2a+RFRDhwvJN8KU0xgQbLMNNGqvJNUMQja9Ujm5BlYgEW
         r6oA==
X-Gm-Message-State: AOAM5305pwcPviiY8JnBDaPRSkdpQUmWHvNv0Mt18zRdgsjONKTydQFZ
        RnPwQwpX2rT6MdAgx1bMg8EfsG6o8dnkpiy3SX8=
X-Google-Smtp-Source: ABdhPJw6KWmyL2s3n0gRxiUuWRnAHpxXakpaH0QTYnCaFMqA6llRM+33a+lswcCjCl1Xnr0gPaboWBcWE5s0E+FjcZ8=
X-Received: by 2002:ab0:284c:0:b0:362:88a1:979e with SMTP id
 c12-20020ab0284c000000b0036288a1979emr2525497uaq.74.1650930938575; Mon, 25
 Apr 2022 16:55:38 -0700 (PDT)
MIME-Version: 1.0
References: <20220407223629.21487-1-ricardo.martinez@linux.intel.com> <20220407223629.21487-10-ricardo.martinez@linux.intel.com>
In-Reply-To: <20220407223629.21487-10-ricardo.martinez@linux.intel.com>
From:   Sergey Ryazanov <ryazanov.s.a@gmail.com>
Date:   Tue, 26 Apr 2022 02:55:38 +0300
Message-ID: <CAHNKnsR41Okpt58ToJhBcjrA-O1rW8P2dRSPnp5t6E7XwXyJ7w@mail.gmail.com>
Subject: Re: [PATCH net-next v6 09/13] net: wwan: t7xx: Add WWAN network interface
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
> Creates the Cross Core Modem Network Interface (CCMNI) which implements
> the wwan_ops for registration with the WWAN framework, CCMNI also
> implements the net_device_ops functions used by the network device.
> Network device operations include open, close, start transmission, TX
> timeout and change MTU.
>
> Signed-off-by: Haijun Liu <haijun.liu@mediatek.com>
> Co-developed-by: Chandrashekar Devegowda <chandrashekar.devegowda@intel.com>
> Signed-off-by: Chandrashekar Devegowda <chandrashekar.devegowda@intel.com>
> Co-developed-by: Ricardo Martinez <ricardo.martinez@linux.intel.com>
> Signed-off-by: Ricardo Martinez <ricardo.martinez@linux.intel.com>
>
> From a WWAN framework perspective:
> Reviewed-by: Loic Poulain <loic.poulain@linaro.org>

Reviewed-by: Sergey Ryazanov <ryazanov.s.a@gmail.com>
