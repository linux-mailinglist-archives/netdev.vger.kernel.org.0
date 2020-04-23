Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA4D61B5340
	for <lists+netdev@lfdr.de>; Thu, 23 Apr 2020 05:54:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726505AbgDWDys (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Apr 2020 23:54:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725854AbgDWDys (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Apr 2020 23:54:48 -0400
Received: from mail-ua1-x944.google.com (mail-ua1-x944.google.com [IPv6:2607:f8b0:4864:20::944])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B28CBC03C1AB
        for <netdev@vger.kernel.org>; Wed, 22 Apr 2020 20:54:46 -0700 (PDT)
Received: by mail-ua1-x944.google.com with SMTP id c24so4322356uap.13
        for <netdev@vger.kernel.org>; Wed, 22 Apr 2020 20:54:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=R8UTQx3Ey5Chrhv1kbfg5h3YLmYWwpsMJJB9YIonatg=;
        b=gHbeX08L0pNOEnOC1tiBd6cYw4YvMLn48lLeG5b5wb+usUjoda440Vwm94zUgxpR+W
         SxJi7/ITqJ+MqmInvywBG8Ykcm+T6NzRKQZhA9fxc//5KAfRjli2hLHb+zrOGXbxfg+y
         eM5P5kpZfTkRAcHqc2JFp6UUSU2sHYQaaAuCLxLvtVB72tmAiPYIo+f/f+S0vH2b7jaK
         5gsEh4scV5JFePEEu68TpwZR/BhkyNpXgAs+ahdCR65EFzHDeIAQn7X9r4rZXLwTsIdu
         RxelfamttufL074EYne9BMjkwQXfIpCYm9XESsaXS8L0lfOUW8poeAFDJ646m/9vq5kS
         fVtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=R8UTQx3Ey5Chrhv1kbfg5h3YLmYWwpsMJJB9YIonatg=;
        b=jrwG60XPtGEf1G+FLkb14Cr9grpzvuhIVUXxKGddaJuLiP08p9r1NaiZEaVxdWN1Uf
         C9i1/udqZoiUvfHZURMWYbakMfzW4Mn/LXCBA43iZF3zhDFybWSeC2G8YXuAkRoREI0J
         Aoo0WIBc7z8k+uJkeRcHfv4pB4U5ooWzzCgYkCLk8PnGv2cFFLpSi4S4aigh0zxC6H+U
         JzTPFNIaJeHdkjw5jfmjtyaZ7lGNL8bsOm7FA+KQRZMkkjPZOpsVqaY3+csI0C6dt7L8
         tIynohQSYup2DDzPH3xmCLvDOKyG/iTnbUle0d/iQnYrCY/Ifqi4btfPB8LcN1M8kBwd
         m7IA==
X-Gm-Message-State: AGi0PuYKPvSji1WERMPIfwmugnGufmnX5V52/jr79xODd8lWmyJa3Bbz
        flSQSpya7z04IMynobuaioDSTbkNUO/c+PuvCUw=
X-Google-Smtp-Source: APiQypIO1LJ5QFkj+FhMhj3a3TWf6P0/84tiojtFoY3Ra/tyx9uZjlRnlTZ9ESRSscKprvhMzqqerubnzWjvHzqqH1E=
X-Received: by 2002:a67:d998:: with SMTP id u24mr1673389vsj.93.1587614086019;
 Wed, 22 Apr 2020 20:54:46 -0700 (PDT)
MIME-Version: 1.0
References: <1584969039-74113-1-git-send-email-xiangxia.m.yue@gmail.com>
 <1587575340-6790-1-git-send-email-xiangxia.m.yue@gmail.com> <1587575340-6790-4-git-send-email-xiangxia.m.yue@gmail.com>
In-Reply-To: <1587575340-6790-4-git-send-email-xiangxia.m.yue@gmail.com>
From:   Pravin Shelar <pravin.ovn@gmail.com>
Date:   Wed, 22 Apr 2020 20:54:35 -0700
Message-ID: <CAOrHB_APuw_5Bf+HQppk04nxHRPxhpzXCd+ONPZBwP4sRv7oOg@mail.gmail.com>
Subject: Re: [PATCH net-next v3 3/5] net: openvswitch: remove the unnecessary check
To:     Tonghao Zhang <xiangxia.m.yue@gmail.com>
Cc:     Andy Zhou <azhou@ovn.org>, Ben Pfaff <blp@ovn.org>,
        William Tu <u9012063@gmail.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        ovs dev <dev@openvswitch.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 22, 2020 at 10:10 AM <xiangxia.m.yue@gmail.com> wrote:
>
> From: Tonghao Zhang <xiangxia.m.yue@gmail.com>
>
> Before invoking the ovs_meter_cmd_reply_stats, "meter"
> was checked, so don't check it agin in that function.
>
> Cc: Pravin B Shelar <pshelar@ovn.org>
> Cc: Andy Zhou <azhou@ovn.org>
> Signed-off-by: Tonghao Zhang <xiangxia.m.yue@gmail.com>
> ---
>  net/openvswitch/meter.c | 9 ++++-----
>  1 file changed, 4 insertions(+), 5 deletions(-)
>
Acked-by: Pravin B Shelar <pshelar@ovn.org>

Thanks.
