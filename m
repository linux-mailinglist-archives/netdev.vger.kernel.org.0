Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9296C84208
	for <lists+netdev@lfdr.de>; Wed,  7 Aug 2019 04:02:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728795AbfHGCC0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Aug 2019 22:02:26 -0400
Received: from mail-ot1-f49.google.com ([209.85.210.49]:43950 "EHLO
        mail-ot1-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726518AbfHGCCZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Aug 2019 22:02:25 -0400
Received: by mail-ot1-f49.google.com with SMTP id j11so40771628otp.10;
        Tue, 06 Aug 2019 19:02:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3j2UmLMhc3DW8sr9HQPJo3Bh/NJObVbth2e8SoSUnkA=;
        b=YvWNH8yFyW4xICEQSvHfIBlfbyLGR/nM18iOrAl689Jbbq8trosj+rv3/3HmUhvGX7
         bBXIicDitkiqa9s/A0QpUOVKmqKwPEAONq9TTClNzK2/1e9qCXwqLhHgwFvyVLEcpPRk
         lSPt3vG5cKmYx8k6b3EiZ5Jrt1GBAx/YbZ3wiOpC1CUtQZNoykh+MSysWN/QeiN/4h0Q
         H13tDujQdzxYv2kXdFCn211kAJLD2Jytf9+llYhLTf3cJYQPJNP6Fpu+544MOFU0mx1X
         NX9A4obeqEXOlJr4dVOBOWu4mnd+XxTJsG+J7XPsDTSaonevDBmSVStW3OBFTto7s7qV
         pyUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3j2UmLMhc3DW8sr9HQPJo3Bh/NJObVbth2e8SoSUnkA=;
        b=BmAuYPsh81dHw1ieiVUnX8dksiGAiJ3tCysu9vLMyn/QF+UaeRIsnJBCzrtIOimV8Y
         MhduJ7JgsnzPGip18UmsUP2AsX0RPA60Ao2vFQZIma+Ji71sluU5es/msSFHlyp+AFzk
         0VNaE1sXufqrivVjwMBpDPW13HrxJqSM9tHIZafJoFkGXZcBATtEVkWWp2/HQB5ybaV+
         ICj3lEBPiQ7cNoEVBjzA5qBHeojynauPJImEfw4gJfupyTdEBHT9nwuPWHjJAvw46v1V
         wagjegosrz+EEMbGNUm0qh9N6xfBWAapY3aShCI0iQXbDW0v5Pk7d+TsGmHAj3yT9qiA
         dIIw==
X-Gm-Message-State: APjAAAXq5t8KWNErJDql18ky3GCz2KdlgowZPGpI93newNi+fQR1lJhC
        Mwvl8ao3hDtR9P5mnSPrRnr+EV0pD0ZVliXkr8cHY87d
X-Google-Smtp-Source: APXvYqzIxWy3gYFb/WA6vjPSPIT3EBLvejV/dnLa0+4LbUQ7tn8WD//WcNCY3ZqYAsF9w2Mx9Vunds5/BsRRq0ilj7w=
X-Received: by 2002:a9d:5512:: with SMTP id l18mr6149601oth.260.1565143344701;
 Tue, 06 Aug 2019 19:02:24 -0700 (PDT)
MIME-Version: 1.0
References: <20190807093037.65ac614e@canb.auug.org.au> <CAEYOeXMV1DbTsy7U1-Fu0eztVGpw-+ZEJTK0Hzm8xbqCL7fabw@mail.gmail.com>
 <20190807115436.5f02155c@canb.auug.org.au>
In-Reply-To: <20190807115436.5f02155c@canb.auug.org.au>
From:   Yifeng Sun <pkusunyifeng@gmail.com>
Date:   Tue, 6 Aug 2019 19:02:13 -0700
Message-ID: <CAEYOeXNDR2q6S=6uwBizH=HUmrEtGzGqDMbDRLMp5ONT6Fkd6g@mail.gmail.com>
Subject: Re: linux-next: Signed-off-by missing for commit in the net-next tree
To:     Stephen Rothwell <sfr@canb.auug.org.au>
Cc:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Stephen,

Sure, thanks!
Yifeng

On Tue, Aug 6, 2019 at 6:54 PM Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>
> Hi Yifeng,
>
> On Tue, 6 Aug 2019 16:37:26 -0700 Yifeng Sun <pkusunyifeng@gmail.com> wrote:
> >
> > My apologies, thanks for the email. Please add the signed-off if you can.
>
> Dave does not rebase his trees, so that is not possible.  Just remember
> for next time, thanks :-)
>
> --
> Cheers,
> Stephen Rothwell
