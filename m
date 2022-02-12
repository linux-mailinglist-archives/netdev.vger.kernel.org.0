Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 681884B36B2
	for <lists+netdev@lfdr.de>; Sat, 12 Feb 2022 18:00:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237119AbiBLRAU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Feb 2022 12:00:20 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:36452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231926AbiBLRAT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Feb 2022 12:00:19 -0500
Received: from mail-yb1-xb2e.google.com (mail-yb1-xb2e.google.com [IPv6:2607:f8b0:4864:20::b2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D439240A0
        for <netdev@vger.kernel.org>; Sat, 12 Feb 2022 09:00:16 -0800 (PST)
Received: by mail-yb1-xb2e.google.com with SMTP id j2so34153178ybu.0
        for <netdev@vger.kernel.org>; Sat, 12 Feb 2022 09:00:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=owF5cfZ+BXJ6UxcBh0ZD8f6bL9+OjHJRfQKYzFIZQtQ=;
        b=HCcj2GAaMx1fpRZD6uT21lhHIUmS7CfgLvEk3ZCLTcg48fnGgp75X3cDlFcff/7GH7
         ld6jvbrV+nAo9IhdBk85i3a7ezr9ULK7S8/BqyuJlJfFTL6lBJPf637ANgBpqQMoFIac
         xAGjKtErpAoBXabM1ro/gm0I8SbbTdPHAYBBqwi79TPud1QgQ4vhbfsmStno3Axi1hEM
         9PdIKKhTDVz/lJ8Ertwa1EZA/1eV+rLgvPZqQkFczZqixEhGFDXisc5461at1Nj4x1fy
         fawHHOHKyL3qc6/OSKjm2CiTCSMOJauF70WrkSJc3Iay7SXmQEHzwqVeuh10FPJPcUF6
         uv9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=owF5cfZ+BXJ6UxcBh0ZD8f6bL9+OjHJRfQKYzFIZQtQ=;
        b=CcX/x5uBrWUiwdOBq0P0mNmN8thXP+18i7CF/1LtuCQWuqiR9HQHCqKLVFcv4x5rR2
         S/vSiKVeHLzOIuN3DOSlmFM84lioQoYANK9eSl5O9I7H6Xk0anfgSkr6iffS7giisSZR
         BlVMxKxTP3aSeVojOOUXLNJld4qEjGTVphae/AhbNpqRJtMDem9PydcyM8fcTvK8P6KV
         DeK9jeW/I4HGS4KDVVFQYDNB6SV1kMenQIzbxjSIbCTw3fcMqyr3KiDr+S8ZutAZuJ1c
         nnm48/yWUNlr31s5X0aBDp+VLn5huQOvWRqI7V0bvsO+tVG9BqIvD3mDjtxmY8OSXPXD
         wrtA==
X-Gm-Message-State: AOAM531FHC8rcA/FqUhOtaWbMiUCvkjlAjDQA9ujt4jkGRLSO6pw5IAo
        CPwpCwEksN3m9WlsKaP4zbQm7cMcNEx7GJM1LJ+C3w==
X-Google-Smtp-Source: ABdhPJwOFf82AjUj+xsSdFa4/D3Gt3NaUGIlc2YBlcOS7z1jjLD+pLHLYEAlwqHG2ocTzIvM6ohy/g9CB6OFkc9oEnA=
X-Received: by 2002:a25:684a:: with SMTP id d71mr6083195ybc.284.1644685211120;
 Sat, 12 Feb 2022 09:00:11 -0800 (PST)
MIME-Version: 1.0
References: <20220212022533.2416-1-luizluca@gmail.com>
In-Reply-To: <20220212022533.2416-1-luizluca@gmail.com>
From:   Linus Walleij <linus.walleij@linaro.org>
Date:   Sat, 12 Feb 2022 18:00:00 +0100
Message-ID: <CACRpkdaa8eevcH+os0iVdQXaPLyVnS4bLCJn=MgY_Zu_zK=vjQ@mail.gmail.com>
Subject: Re: [PATCH net-next] net: dsa: realtek: rename macro to match filename
To:     Luiz Angelo Daros de Luca <luizluca@gmail.com>
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, olteanv@gmail.com, davem@davemloft.net,
        kuba@kernel.org, ALSI@bang-olufsen.dk, arinc.unal@arinc9.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Feb 12, 2022 at 3:26 AM Luiz Angelo Daros de Luca
<luizluca@gmail.com> wrote:

> The macro was missed while renaming realtek-smi.h to realtek.h.
>
> Fixes: f5f119077b1c (net: dsa: realtek: rename realtek_smi to)
> Signed-off-by: Luiz Angelo Daros de Luca <luizluca@gmail.com>

Reviewed-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
