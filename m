Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8E8030FA46
	for <lists+netdev@lfdr.de>; Thu,  4 Feb 2021 18:54:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238774AbhBDRwB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Feb 2021 12:52:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238602AbhBDRuq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Feb 2021 12:50:46 -0500
Received: from mail-oi1-x22c.google.com (mail-oi1-x22c.google.com [IPv6:2607:f8b0:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97085C0613D6;
        Thu,  4 Feb 2021 09:50:06 -0800 (PST)
Received: by mail-oi1-x22c.google.com with SMTP id k25so4538006oik.13;
        Thu, 04 Feb 2021 09:50:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Var8WHICuKwrMmPlWUsvpEAeSED3aCJArZ1/+YoG3X0=;
        b=Nh0oRKRR7Enme9e5B4FB9VI7nGxkEavMoxXr+rJKKhkqrfTxzukhkG/YWJ3aGKmvaS
         4YMrTKCyv1d3KC/d1dQjo0EKSh6jUZ8qolhJ5b8scuL46qG8PP2CdSwdecnlx6czn6HM
         M4ZvD/AZ56esViQVcQwrxH+YCdZKeLoMmxR9FsbjdrxGHir2jnYfDxwwVFjo6lmXR9gQ
         djcwtLc81H6CpI2UuY9H69VTMhh0d0RU9t/DNeKpyIsdSWy0af/XpkawQPqZAei2LZxU
         PZTgG9KsRUqby9il9OR/tRHiQzusIACYL0iw/4kSkOaaIVKv3ZN7Vcf0XNxIwdTkorf5
         RBaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Var8WHICuKwrMmPlWUsvpEAeSED3aCJArZ1/+YoG3X0=;
        b=US4dt377I/UaLbSe4keC60RwyPue9JnQHwnTLFqFzhqrAxWE9VsFU1JFJI2aXI414z
         IfVO5emNf1H85YQrHyazsHJlQN1wxlcNznwI19hfUmTRgP/x7fQFPpNIhe+5KvsNzRrE
         T9w/6b9YCuwBbVoPs+DEQICrxaTDI/KTXFM3vRV3aURBltY1NmM0UUluczCnEJfvOQBI
         PqRuTPQoOnzBCc4Og2XM+nPFzIqsIUzO05wZp/Ph3/nr1wmNoXJYQumyh902f18YlcUS
         XUloMLMTgQzQywKia/rYhULFBuy92Ydmrymt0t4OEolO7xKO47zguNQTYiHei9Vku7d1
         fHFQ==
X-Gm-Message-State: AOAM530qQh5K2JHRAkJeE7nGUH5Kw7ttUg6V9/J9Yr2t4drRfw6aT92x
        67+zEKjVA26CG/gLhQPgJli5C6qjSZ+HevVOGg==
X-Google-Smtp-Source: ABdhPJwt6p7MRn488JbydwljimYx34MQQI8pFoYxFRyeKsyjrwiZSxhqPqizhzHHbdnM3BLAnXk7xY7/2U5rIvBuDuk=
X-Received: by 2002:a05:6808:f09:: with SMTP id m9mr450484oiw.92.1612461006039;
 Thu, 04 Feb 2021 09:50:06 -0800 (PST)
MIME-Version: 1.0
References: <20210204171942.469883-1-brianvv@google.com>
In-Reply-To: <20210204171942.469883-1-brianvv@google.com>
From:   George McCollister <george.mccollister@gmail.com>
Date:   Thu, 4 Feb 2021 11:49:54 -0600
Message-ID: <CAFSKS=P2d-szPdjukc_3HGBXKYv4k-fwh=OWBdHy2knqr-4-Hg@mail.gmail.com>
Subject: Re: [PATCH net-next 1/2] net: add EXPORT_INDIRECT_CALLABLE wrapper
To:     Brian Vazquez <brianvv@google.com>
Cc:     Brian Vazquez <brianvv.kernel@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        open list <linux-kernel@vger.kernel.org>,
        netdev@vger.kernel.org, Stephen Rothwell <sfr@canb.auug.org.au>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I don't see the second patch.

Regards,
George McCollister
