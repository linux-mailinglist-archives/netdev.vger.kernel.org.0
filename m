Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6A832EC910
	for <lists+netdev@lfdr.de>; Thu,  7 Jan 2021 04:23:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726687AbhAGDWX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jan 2021 22:22:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726233AbhAGDWX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jan 2021 22:22:23 -0500
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6483C0612F1;
        Wed,  6 Jan 2021 19:21:42 -0800 (PST)
Received: by mail-wr1-x42d.google.com with SMTP id t16so4239086wra.3;
        Wed, 06 Jan 2021 19:21:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=WXeOAc0tCF8n6yiT+2O8NqJe5mYQ0Xxd1S1U1t0Ljn4=;
        b=V9hIDBDEUZkaT3mD2hvGe2MPuZryp03cSUSIKG/9vzbOpTHRWeQRmbTkln5xdfbwTu
         lU3DCWIrOiZYyngzG73gW0but3FcxqbHXnP1W6h7P7gf0iBir3/fOArPb62Xa8p2ztE6
         iOGUM1XZWzEYc17pvM2vNhcXl7KZmXmNXrdgguRPhhJPS999IsQ8/CYZFsKpn00OHkWy
         S2FZkq+LWmn3ojCHNr+5mkPCMJkrayIe6gSrLzAPRBRbu/JR2Nh1v/IvHEKuYG0frLvK
         ccyZ3y/YPyhZkztmL1CV45drY+sB/kya0rGmp2u8qZ+u0cNzw3EYbb092QmHhZM0GHT/
         8EYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=WXeOAc0tCF8n6yiT+2O8NqJe5mYQ0Xxd1S1U1t0Ljn4=;
        b=fz9lCgjNUyf8trkfcgJE1x60nhKAeTBBJSnTFfDT+sdw1wpDyZJYjCYyQ9paVlqMlY
         8eUP7TN3asqf+Rqdrey8DaM22cS8zf7fcPETd17GvpWwZGJ8ZGoyoXNZDr29DiHN3EK6
         qhnwAe77K6CRm9O5YYq1j6XeBoIIw84xX3uXHeORlja6FHLvqB23LsbxmeuvmNmam2Oa
         Tc7PT898rW6mUY5DofqDQ7cFuPRzEQVLoOKJ7U3Km7/yr77I5Yux7CrAPjRJI0hGANMl
         0VHtdc/PGONfPtBtX2k8cPoIbeLdBBniNaG+SRWQ3r6FEOXfSyR5A+Jrdt6VLKhaUpJs
         aoaA==
X-Gm-Message-State: AOAM5339GhrI8EE9tlLm0lpi2r0vdCh3PYIaelZ5di+JF/O5QWVJiXIM
        CC6HpGCnBNf6C+GkYM3iap5GP4HnWmJH9LZ+ciR1XETRnmM4AQ==
X-Google-Smtp-Source: ABdhPJwrpVvYNkNGV7KzC6+y5kQVU8phqV4sgd/lhqHDM5p580MlX0cLvzFDa5zMbjz9t198Ls9M01kOo2MNCS8v0vo=
X-Received: by 2002:adf:e704:: with SMTP id c4mr6854263wrm.355.1609989701653;
 Wed, 06 Jan 2021 19:21:41 -0800 (PST)
MIME-Version: 1.0
References: <20210106161735.21751-1-lukas.bulwahn@gmail.com>
In-Reply-To: <20210106161735.21751-1-lukas.bulwahn@gmail.com>
From:   George Cherian <gcherianv@gmail.com>
Date:   Thu, 7 Jan 2021 08:51:31 +0530
Message-ID: <CABYS091dhHKL6UHvA1J9+4uCSZDNJnP8DR_URWW7Xhwpnec3Yg@mail.gmail.com>
Subject: Re: [PATCH v2] docs: octeontx2: tune rst markup
To:     Lukas Bulwahn <lukas.bulwahn@gmail.com>
Cc:     George Cherian <george.cherian@marvell.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Randy Dunlap <rdunlap@infradead.org>,
        linux-doc@vger.kernel.org, Sunil Goutham <sgoutham@marvell.com>,
        Linu Cherian <lcherian@marvell.com>,
        Geetha Sowjanya <gakula@marvell.com>,
        Jerin Jacob <jerinj@marvell.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 6, 2021 at 9:51 PM Lukas Bulwahn <lukas.bulwahn@gmail.com> wrote:
>
> Commit 80b9414832a1 ("docs: octeontx2: Add Documentation for NPA health
> reporters") added new documentation with improper formatting for rst, and
> caused a few new warnings for make htmldocs in octeontx2.rst:169--202.
>
> Tune markup and formatting for better presentation in the HTML view.
>
> Signed-off-by: Lukas Bulwahn <lukas.bulwahn@gmail.com>
> ---
> v1 -> v2: minor stylistic tuning as suggested by Randy
>
> applies cleanly on current master (v5.11-rc2) and next-20210106
>
> George, please ack.
> Jonathan, please pick this minor formatting clean-up patch.
>
Acked-by: George Cherian <george.cherian@marvell.com>

Regards
-George
