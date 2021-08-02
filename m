Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D7C33DDE3E
	for <lists+netdev@lfdr.de>; Mon,  2 Aug 2021 19:13:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230025AbhHBRN2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Aug 2021 13:13:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229571AbhHBRN1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Aug 2021 13:13:27 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2812DC06175F
        for <netdev@vger.kernel.org>; Mon,  2 Aug 2021 10:13:17 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id a8so3058827pjk.4
        for <netdev@vger.kernel.org>; Mon, 02 Aug 2021 10:13:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=wygq9ENKH3bQQnXnWPKpkSwKibpqnj2KnfbJhRQa5pY=;
        b=oCVVw2lnN3O07xD5Pf9aciuS9v4sy7e6RKOCPtnJiWr+TL70WuMSn6oZlRi0GvgJ/b
         kWxm8In/I3les2svlCUigNdOPckAQFPaeODUHbuSSFzHZ2m79nmYFgWUevPobN7CUe7J
         pF6DliIOaqPUjUqdr6WgBi76FALC5ejrdHNnioOun2vGVMWrh6blIA0ctDCfnR0mLGux
         l3rBc5yEfGrw5iVlE/oPxIvLLW4Uw0+8vA+ruslL6PcIY3s/TwbMn15Z3WdqCAC5fU+g
         xzdaV0wOLif+9RlEZP1pieIKvWquiXanMlKpIFoq1/iDU9lSNdq2VK5gaYy9AopfVjaZ
         8O7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=wygq9ENKH3bQQnXnWPKpkSwKibpqnj2KnfbJhRQa5pY=;
        b=jR48veQVVH5DVDITEco1s2uAvAGgR0VWAOVa7P7/oitjjQFRkEJUTa/XB3RDRBWZtc
         lGwKpyCVQqF3/gDwTwPIb8Xxzcs7FXEhSAbQDY4KoVCVXMorOudYRYUitv0/eGbSStY+
         iBXP66I12L+7b6y/yblvQzlUBxLx+6Ho7s+pLq2hAeAoQfCSiSKwtEVDesFVoEe6ReC8
         0zUXKVAG2jkk8ziTjFNRz6gS7jmZgfjQQAs6E5LX7I1p6qbBMwM7LRxKq9yhGkpFfhI9
         iEKcUv5+ttDSTwPxGq/IxZajfLz3ANGelx1LEz46ZBimMLQsH0vlue9otLvEmi9pa0uE
         jQhQ==
X-Gm-Message-State: AOAM532hbvtwQHRPvgg1vbBCS4InWfzp2BXvlnMjy3wf9+vdjewm11ft
        OJIFv0yvxvoRMFP30C9pgLID2F6UDHQeQ/SFb1nlzg==
X-Google-Smtp-Source: ABdhPJyLNub45jGQBU6OsmDWzVt76+LDOEV+mqEGmkMUbzEetsm0FIrD9B5FnJ3jq4U9uPZ4efnE4bU6Kw/sDgoZ2W0=
X-Received: by 2002:a17:90a:a896:: with SMTP id h22mr18683623pjq.231.1627924396503;
 Mon, 02 Aug 2021 10:13:16 -0700 (PDT)
MIME-Version: 1.0
References: <1627890663-5851-1-git-send-email-loic.poulain@linaro.org>
 <1627890663-5851-2-git-send-email-loic.poulain@linaro.org> <20210802094054.7bc27154@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210802094054.7bc27154@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Loic Poulain <loic.poulain@linaro.org>
Date:   Mon, 2 Aug 2021 19:22:58 +0200
Message-ID: <CAMZdPi9ZNU2d+CMKkT3xifOCbTsEeDr6Cj_90Zt3EYW=D6qMqg@mail.gmail.com>
Subject: Re: [PATCH net-next RESEND 1/2] net: wwan: Add MHI MBIM network driver
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Network Development <netdev@vger.kernel.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        Richard Laing <richard.laing@alliedtelesis.co.nz>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2 Aug 2021 at 18:40, Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Mon,  2 Aug 2021 09:51:02 +0200 Loic Poulain wrote:
> > Add new wwan driver for MBIM over MHI. MBIM is a transport protocol
> > for IP packets, allowing packet aggregation and muxing. Initially
> > designed for USB bus, it is also exposed through MHI bus for QCOM
> > based PCIe wwan modems.
> >
> > This driver supports the new wwan rtnetlink interface for multi-link
> > management and has been tested with Quectel EM120R-GL M2 module.
>
> Let's make sure it builds cleanly with W=3D1 C=3D1 first.

Sure.

>
> drivers/net/wwan/mhi_wwan_mbim.c:83:23: warning: no previous prototype fo=
r =E2=80=98mhi_mbim_get_link=E2=80=99 [-Wmissing-prototypes]
>    83 | struct mhi_mbim_link *mhi_mbim_get_link(struct mhi_mbim_context *=
mbim,
>       |                       ^~~~~~~~~~~~~~~~~
> drivers/net/wwan/mhi_wwan_mbim.c:83:22: warning: symbol 'mhi_mbim_get_lin=
k' was not declared. Should it be static?
>
> Also - please start putting someone in the To: header, preferably the
> maintainer / mailing list thru which you expect the code to be merged.

Not sure why my `git send-email` keeps ignoring the to field for that
series, but going to fix that, thanks for pointing this.

Regards,
Loic
