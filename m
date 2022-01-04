Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3858483BCB
	for <lists+netdev@lfdr.de>; Tue,  4 Jan 2022 07:01:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231618AbiADGBb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jan 2022 01:01:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230181AbiADGBb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jan 2022 01:01:31 -0500
Received: from mail-lf1-x131.google.com (mail-lf1-x131.google.com [IPv6:2a00:1450:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E725BC061761
        for <netdev@vger.kernel.org>; Mon,  3 Jan 2022 22:01:30 -0800 (PST)
Received: by mail-lf1-x131.google.com with SMTP id h2so68832804lfv.9
        for <netdev@vger.kernel.org>; Mon, 03 Jan 2022 22:01:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fungible.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=AZumGzPyu8n81EhUkVEMDX+PBqguz+KqWIdPEURq+x4=;
        b=mi+e+49Wj+5YJrW1LSa1W8q2qySgGX2H6L59LhhSw3/rsFJ1XTmLgtNcOawfjn4Omh
         fycFHB3nLvMFToxwF4Lc+p5yp/OJ04/oqiqVYEmhmtn8vDgDIMKwps2G44XoYi1p47fu
         jxcbvGZp26bzvh47AqiW8PGcKsF9/PqjPdl/U=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=AZumGzPyu8n81EhUkVEMDX+PBqguz+KqWIdPEURq+x4=;
        b=fRc7tIPghKXD+zEKf8NPes0vTvP1rZ1AFC04O+2Bc5IPt7htzZT0VOX6CJIwRfEPYY
         9uvxPSk0dUi/YVZ0/VoxIa3OpTeIau/txGvefc1V93Nd0iu2WbWJlH+dNL/uNpHXCSlE
         kqMRmxqNuoCIZB3AEl6Kgu3jgxWXVHTQfMjGR5AB40taoFJdUjauLVpr51PrCbWXJWRG
         QcWJICTdKJ93tL92fi9PlUdFs5ndVRBgfGF8pMU97vihFkZXYternoe6d71JWUeuWsp+
         ja+bT1MpFrpKU71E8EWX7xP1bsuaj9tG/kMFYf/wN2yF5CH/Uia/CzAOy1aEaJCR5ivl
         9JpQ==
X-Gm-Message-State: AOAM532udZYLHnjxSh7xhGJP+S8awXMAJDwVVVesiyaOmybNQtPQaSN7
        r6/cMFGDIFSG/FIq7xBj+LQL2lbes+QENeaQbHZaoc+IGluCmA==
X-Google-Smtp-Source: ABdhPJxD8l2E1cHX5/S/QdSekSjXD3wvxqucmEks6o8yWknykK3ZC3oY931RdjTR7GRR9xNUSDI7Bhxd2zbn6/F2WNw=
X-Received: by 2002:a05:6512:3223:: with SMTP id f3mr43086642lfe.593.1641276088836;
 Mon, 03 Jan 2022 22:01:28 -0800 (PST)
MIME-Version: 1.0
References: <20220104010933.1770777-1-dmichail@fungible.com>
 <20220104010933.1770777-9-dmichail@fungible.com> <20220103190838.102886d5@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20220103190838.102886d5@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
From:   Dimitris Michailidis <d.michailidis@fungible.com>
Date:   Mon, 3 Jan 2022 22:01:17 -0800
Message-ID: <CAOkoqZnTdWfpwdsg_yirLr-keMbbRuSgZSpYhVs3nLjh_dzY-A@mail.gmail.com>
Subject: Re: [PATCH net-next v3 8/8] net/fungible: Kconfig, Makefiles, and MAINTAINERS
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 3, 2022 at 7:17 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Mon,  3 Jan 2022 17:09:33 -0800 Dimitris Michailidis wrote:
> > Hook up the new driver to configuration and build.
>
> bpf-next merge brought in some changes last week:
>
> drivers/net/ethernet/fungible/funeth/funeth_rx.c:180:17: error: too few a=
rguments to function =E2=80=98bpf_warn_invalid_xdp_action=E2=80=99
>   180 |                 bpf_warn_invalid_xdp_action(act);
>       |                 ^~~~~~~~~~~~~~~~~~~~~~~~~~~

Thanks, update coming shortly. I'll also remove the 32b
dma_set_mask_and_coherent()
as I see a number of such removals going in.
