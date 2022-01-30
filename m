Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D5734A3A92
	for <lists+netdev@lfdr.de>; Sun, 30 Jan 2022 22:35:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240824AbiA3Vfs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 Jan 2022 16:35:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232772AbiA3Vfs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 30 Jan 2022 16:35:48 -0500
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C644C061714;
        Sun, 30 Jan 2022 13:35:48 -0800 (PST)
Received: by mail-wm1-x331.google.com with SMTP id c190-20020a1c9ac7000000b0035081bc722dso8062561wme.5;
        Sun, 30 Jan 2022 13:35:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=hhfptTF0QU+Sw7HCy3Rem6U4HyEITu/6ey8H87LhF0o=;
        b=c1Db3XJBSZyDb+9hny32tkhEila7q9ctZCnalysr8mabHfQ1e7t7thvSggnntmC4jO
         rPZkF1zw2h6FLtyOhi1tAvrFQLYG/WY/LXDI6lCj/x2CfeYjSPETj8f+dFL3uoNacMWj
         rDeBwJV2b4y0WvAljJ6a5YZL0yE399UcpX3b7sDtH6nUZ0Wpt4F0Gvd949ebsqRP0rn/
         RtbkhJoBjORSs7GzKyQHJB7DV2p/A+QnomleBY65RKALNlZaLY6xv/ZzZ7g2+lR+Sm4n
         GqfwNaIihW42P5g7+xBepLTPmR7uU7HdstNQLFU3bKydrh/O+UO5upDcrCblakO35VhY
         TeHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hhfptTF0QU+Sw7HCy3Rem6U4HyEITu/6ey8H87LhF0o=;
        b=NLWaSNq88NHzzeTQumY+u1KKPwGHp38nCqXMO9KGKVV9MCIjmt9IDM/kGurcjVjjoy
         7ijqlT1UpBhnocUPwmLzXVcFQn02cj9HTzNgZgQ4aA6zo+hg64Lt8iNycfLnZ46ztutm
         Q5Qz9dqv27CBvSQpf7SjhqkieowE6pp/oKbTfL1hhIhS/5O1CVMiaittuk/yOmX5kX7X
         D18GN6mojKJbazZl0ub4Z72i4Q92VKjI9ks6uv48qEVeKOxDd6NJnWiZx7pEn3493a1Z
         VZd7TFOwUuYU25Gmry9p5sKTkakUUajtaw+3qoTC9ZrGE3WZLSYDiDRhqM4tD0FDVNSu
         JN6A==
X-Gm-Message-State: AOAM533OcqglUI5+ITbmdeqriFrcRY+mO2WHmSyxiOxjAAwJ5ETMLsTO
        rhw63ZGlFS+b8fi05NSm84BvvlKXy6NLo5lnC+y1ZOc2
X-Google-Smtp-Source: ABdhPJw8SlOGgfUEH1XEIzGH2E2Q9E04MwiSRnaDzAhXtd5wufFaYbHrXL/cc36hWOVsXRjod4BDXWbXa94bRwU1MXE=
X-Received: by 2002:a05:600c:3488:: with SMTP id a8mr24668816wmq.185.1643578546660;
 Sun, 30 Jan 2022 13:35:46 -0800 (PST)
MIME-Version: 1.0
References: <20220128110825.1120678-1-miquel.raynal@bootlin.com> <20220128110825.1120678-2-miquel.raynal@bootlin.com>
In-Reply-To: <20220128110825.1120678-2-miquel.raynal@bootlin.com>
From:   Alexander Aring <alex.aring@gmail.com>
Date:   Sun, 30 Jan 2022 16:35:35 -0500
Message-ID: <CAB_54W60OiGmjLQ2dAvnraq6fkZ6GGTLMVzjVbVAobcvNsaWtQ@mail.gmail.com>
Subject: Re: [PATCH wpan-next v2 1/5] net: ieee802154: Improve the way
 supported channels are declared
To:     Miquel Raynal <miquel.raynal@bootlin.com>
Cc:     Stefan Schmidt <stefan@datenfreihafen.org>,
        linux-wpan - ML <linux-wpan@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        Michael Hennerich <michael.hennerich@analog.com>,
        Varka Bhadram <varkabhadram@gmail.com>,
        Xue Liu <liuxuenetmail@gmail.com>, Alan Ott <alan@signal11.us>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Fri, Jan 28, 2022 at 6:08 AM Miquel Raynal <miquel.raynal@bootlin.com> wrote:
>
> The idea here is to create a structure per set of channels so that we
> can define much more than basic bitfields for these.
>
> The structure is currently almost empty on purpose because this change
> is supposed to be a mechanical update without additional information but
> more details will be added in the following commits.
>

In my opinion you want to put more information in this structure which
is not necessary and force the driver developer to add information
which is already there encoded in the page/channel bitfields. Why not
add helper functionality and get your "band" and "protocol" for a
page/channel combination?

- Alex
