Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E1200600103
	for <lists+netdev@lfdr.de>; Sun, 16 Oct 2022 18:05:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229597AbiJPQFK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Oct 2022 12:05:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229728AbiJPQFI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 16 Oct 2022 12:05:08 -0400
Received: from mail-io1-xd2b.google.com (mail-io1-xd2b.google.com [IPv6:2607:f8b0:4864:20::d2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9D3825C71
        for <netdev@vger.kernel.org>; Sun, 16 Oct 2022 09:05:06 -0700 (PDT)
Received: by mail-io1-xd2b.google.com with SMTP id h203so7428927iof.1
        for <netdev@vger.kernel.org>; Sun, 16 Oct 2022 09:05:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=HouYtgbvJtXTPVuJ0r3QMQmROGWS/dh2Qg2Okyzerrg=;
        b=WLuDl/lQeh+cL9FGT70Ol7YQFiY85l8d6zZdR7wmH0Ry82kIi4jSuYEmDuqKYNmYuk
         7imrBqhVCLVMGAomAQuc8fCj781VmHDGFKifXGMlCBn8fV0TH59dNKG7Qy7v13vrfhL7
         F72tOci588EtuLQOg4a9QXAyndgZEqULO3811FiadDvGDECEKkVjPcN2lbx5KQNmB2ny
         LUb6kVaA48ZxEjMNt2jAs62s+FYb1jzCzpCT486Ml6KxqQDHIHKXKcopdLH4X/mqyU0M
         le+EM5zVQSm+mW2DtUFL8Azni150FBjjC9a5U7931BTJOCD36JPl9+aJKRjTXffW/twW
         nQfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=HouYtgbvJtXTPVuJ0r3QMQmROGWS/dh2Qg2Okyzerrg=;
        b=ELknoPJ/PtrCAiKJ+4s/IeJR5itV3JSurZnHpgIq+a7z48C9gXRFck2hEUzfZLZozw
         rmvXnM81xHeF609I5GOte0t1b43RT83cYqu/MLgeW6EYUzhvteSIbw/ApYVxntHDOv0i
         MJCvnc3RO4lprefhSV0v2Ld3UTemekfTuOsH1exFFMEoqScZL8YGrgYYc/OEc4WZgCcL
         K5mXMvhiowtjLr/VndD1+hfykcVhBWKeDoHfl7/aAaVyAoG0YA047YrjXz9O9msesc7Z
         Iod3ldsuTBLqXKX/F1H16Decb4Xhuc51QQ7xF7sxkCG/rdoQnoCPGE7r0kt8V3lLzIyW
         r2nA==
X-Gm-Message-State: ACrzQf14mXpFIhB/r2xL063FOPF80u9QgTOIzjPcIfH1DTBuMLJ4dCDH
        X4CYUKV7un75gMnenbb8/sR+vtsze7tYs9LG55k=
X-Google-Smtp-Source: AMsMyM6/3Ar5frKAV6E+wHIIYdcpluYXzeppxqW0mIyw1a8/5SZ2RLQ41/nkAyne9IOp03DKuZ34b9tpNytYwAcL6wo=
X-Received: by 2002:a05:6638:1455:b0:363:d1a9:5cc0 with SMTP id
 l21-20020a056638145500b00363d1a95cc0mr3516565jad.288.1665936305560; Sun, 16
 Oct 2022 09:05:05 -0700 (PDT)
MIME-Version: 1.0
References: <20221003095725.978129-1-m.chetan.kumar@linux.intel.com>
In-Reply-To: <20221003095725.978129-1-m.chetan.kumar@linux.intel.com>
From:   Sergey Ryazanov <ryazanov.s.a@gmail.com>
Date:   Sun, 16 Oct 2022 20:05:04 +0400
Message-ID: <CAHNKnsT9EpOCd2Rj=5dQO5a2JrsHuyZQUG9apbrxHTehe37yug@mail.gmail.com>
Subject: Re: [PATCH V3 net-next] net: wwan: t7xx: Add port for modem logging
To:     m.chetan.kumar@linux.intel.com
Cc:     netdev@vger.kernel.org, kuba@kernel.org, davem@davemloft.net,
        johannes@sipsolutions.net, loic.poulain@linaro.org,
        krishna.c.sudi@intel.com, linuxwwan@intel.com,
        Moises Veleta <moises.veleta@linux.intel.com>,
        Devegowda Chandrashekar <chandrashekar.devegowda@intel.com>,
        Ricardo Martinez <ricardo.martinez@linux.intel.com>
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

Hello Chetan,

On Mon, Oct 3, 2022 at 8:29 AM <m.chetan.kumar@linux.intel.com> wrote:
> The Modem Logging (MDL) port provides an interface to collect modem
> logs for debugging purposes. MDL is supported by the relay interface,
> and the mtk_t7xx port infrastructure. MDL allows user-space apps to
> control logging via mbim command and to collect logs via the relay
> interface, while port infrastructure facilitates communication between
> the driver and the modem.

[skip]

> diff --git a/drivers/net/wwan/t7xx/t7xx_port.h b/drivers/net/wwan/t7xx/t7xx_port.h
> index dc4133eb433a..702e7aa2ef31 100644
> --- a/drivers/net/wwan/t7xx/t7xx_port.h
> +++ b/drivers/net/wwan/t7xx/t7xx_port.h
> @@ -122,6 +122,11 @@ struct t7xx_port {
>         int                             rx_length_th;
>         bool                            chan_enable;
>         struct task_struct              *thread;
> +#ifdef CONFIG_WWAN_DEBUGFS
> +       void                            *relaych;
> +       struct dentry                   *debugfs_dir;
> +       struct dentry                   *debugfs_wwan_dir;

Both of these debugfs directories are device-wide, why did you place
these pointers in the item port context?

-- 
Sergey
