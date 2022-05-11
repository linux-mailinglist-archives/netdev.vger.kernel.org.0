Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D3A5F522E57
	for <lists+netdev@lfdr.de>; Wed, 11 May 2022 10:28:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243654AbiEKI2o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 May 2022 04:28:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235054AbiEKI2l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 May 2022 04:28:41 -0400
Received: from mail-yw1-f173.google.com (mail-yw1-f173.google.com [209.85.128.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0F35170F2A;
        Wed, 11 May 2022 01:28:38 -0700 (PDT)
Received: by mail-yw1-f173.google.com with SMTP id 00721157ae682-2f7ca2ce255so12175137b3.7;
        Wed, 11 May 2022 01:28:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Cr6Do/TDm+VJ0R4NXV674tpi+dJjugQTOmccea4yw04=;
        b=0U9xaAHMfrhiGbDAOKbD7r+IHTHlrWC1tAWZEJoHZ1F8/Oky8j1HjhN387eB2vqYKe
         0gY1bqLoYkqtAgYf1SU4uOQygHUwQlTlBWOFA12bP3OdEKlLKZXlN1IcacuADY8UkR0G
         /Nc/uJVJlmn8W47FC7uo07p+IkofYZy1d1x0O4GXpvj1leXAgHE5NL+cvUS4HlLzLKGk
         3eqBScZESOCDXi6FtHnzfczDIXx6WiwCHcTZtP1oGrwLv7XAOblXha+i2+rucSFB7abo
         dSsmQUdbDgeVJ2F4XCKbh0UEaKS+X92w+rXgSdK+e529AMVosJiKtAlezNzFtkfQO477
         KvZg==
X-Gm-Message-State: AOAM532TfL8Kb/ES+77rlJNC7iD9KvuMxYy60DLNkAVEtWsQWgMGQ7g+
        ew4EGVpgF5jOisjzi8AdDwmF+bR5aoMSDlrZUKQ=
X-Google-Smtp-Source: ABdhPJzeYQGMvBhE1nU1RquNSVPuKz41BjQqSGfswleYfqAENsfPxVjWWp0KdTJcrd2vNXmaSco53vBAFa247cMhopI=
X-Received: by 2002:a81:3d43:0:b0:2f9:7d:f320 with SMTP id k64-20020a813d43000000b002f9007df320mr24659563ywa.191.1652257717437;
 Wed, 11 May 2022 01:28:37 -0700 (PDT)
MIME-Version: 1.0
References: <20220511063850.649012-1-zhaojunkui2008@126.com>
 <20220511064450.phisxc7ztcc3qkpj@pengutronix.de> <4986975d.3de3.180b1f57189.Coremail.zhaojunkui2008@126.com>
In-Reply-To: <4986975d.3de3.180b1f57189.Coremail.zhaojunkui2008@126.com>
From:   Vincent MAILHOL <mailhol.vincent@wanadoo.fr>
Date:   Wed, 11 May 2022 17:28:26 +0900
Message-ID: <CAMZ6RqKHs4gdcNjVONfOTsHh6ZFEt0qpbEaKqDM7c1Cbc1OLdQ@mail.gmail.com>
Subject: Re: Re: [PATCH] usb/peak_usb: cleanup code
To:     z <zhaojunkui2008@126.com>
Cc:     Marc Kleine-Budde <mkl@pengutronix.de>,
        Wolfgang Grandegger <wg@grandegger.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        =?UTF-8?Q?Stefan_M=C3=A4tje?= <stefan.maetje@esd.eu>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bernard@vivo.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed. 11 May 2022 at 16:11, z <zhaojunkui2008@126.com> wrote:
> At 2022-05-11 14:44:50, "Marc Kleine-Budde" <mkl@pengutronix.de> wrote:
> >On 10.05.2022 23:38:38, Bernard Zhao wrote:
> >> The variable fi and bi only used in branch if (!dev->prev_siblings)
> >> , fi & bi not kmalloc in else branch, so move kfree into branch
> >> if (!dev->prev_siblings),this change is to cleanup the code a bit.
> >
> >Please move the variable declaration into that scope, too. Adjust the
> >error handling accordingly.
>
> Hi Marc:
>
> I am not sure if there is some gap.
> If we move the variable declaration into that scope, then each error branch has to do the kfree job, like:
> if (err) {
>                         dev_err(dev->netdev->dev.parent,
>                                 "unable to read %s firmware info (err %d)\n",
>                                 pcan_usb_pro.name, err);
>                         kfree(bi);
>                         kfree(fi);
>                         kfree(usb_if);
>
>                        return err;
>                 }
> I am not sure if this looks a little less clear?
> Thanks!

A cleaner way would be to move all the content of the if
(!dev->prev_siblings) to a new function.


Yours sincerely,
Vincent Mailhol
