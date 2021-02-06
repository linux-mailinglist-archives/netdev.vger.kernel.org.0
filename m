Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45F03311E7C
	for <lists+netdev@lfdr.de>; Sat,  6 Feb 2021 16:44:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229976AbhBFPnt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 6 Feb 2021 10:43:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229586AbhBFPnr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 6 Feb 2021 10:43:47 -0500
Received: from mail-il1-x12f.google.com (mail-il1-x12f.google.com [IPv6:2607:f8b0:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8808BC06174A;
        Sat,  6 Feb 2021 07:43:06 -0800 (PST)
Received: by mail-il1-x12f.google.com with SMTP id e7so8695451ile.7;
        Sat, 06 Feb 2021 07:43:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=aLDSj186f0bR5X7Y8YAcIhnfvG2HaPYJ7L9LPKrPwA8=;
        b=pWgHDJ1CWcvw+AZdGCS9agQtQZkHarO5t4EvG6ZiuRTCKMC/hZWM3ZBjXn71tmlUCl
         njiWna7r5z36slxDTiVoESyGopv9nSRHfk9Gfa6HNGWbI2DJE73XrR5px34p3fGP52IN
         fVgXslELR5Dj5+uJHPYYqcBt30WMrKAJqskn3uCd7/hy1+Phkrcl32hOmupWBU5q5J5/
         6AepUiLCf7hhiYfN+GJxNVgwiNXtNnhMdAw4vE+J/8P1EXnu6yu5eS/NC3UNsVIm2ZM3
         SpDvjwaN9o1n7obSIx1v4fBRSFlAnanvUA0rEZeVVSB2pnxUXlWposd8bA31pBuafNeW
         1gsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=aLDSj186f0bR5X7Y8YAcIhnfvG2HaPYJ7L9LPKrPwA8=;
        b=cRr+xJtTu6my7OW0FSOfCR4F1TbCu56/GiUuKRpUBpuHwte2QCabnkin4+QA4lgDE7
         VpkQoFzTQrlqWVLQNipY2l7imR/sqIPAu9TH2f/vxDmFShW9IQuKV3lAduQBqX8wRGZh
         5PmMmsTX6hI9Tp8CgymqZx9qx8qsWnlEtNFRuV9AvO9+bD6wkJLeAolInwT1Es5ceT/P
         /Hou47hapZ8s6IpG/UwPjgd+YdJBWsaORIOUo2oLqRofJS5wT26/s1njbsHVLncvUHKT
         tMfQWeK3WQ+Ri7H8eB+S3twBQlOx78rYb/+uKk3NE+D0SExSExD0TN8FmTWmjrD6HuhT
         PHeQ==
X-Gm-Message-State: AOAM5325L5rBF4L311TXYBTyh6ZSjMy6hbS4icabLaThjkz6Db+dnWSD
        5VrMhkGyGWW4lfC6WXXQQEcjoyp5bD9ZKe1kqrs=
X-Google-Smtp-Source: ABdhPJyyv9u3uNtECdpZl23ih66cCZxfAMNVVrEe0JMbN8NsMQ5Q6rPJ/Hxg27ee8RgHx2/i/90fAbey5Iq87EZlcSw=
X-Received: by 2002:a05:6e02:1a29:: with SMTP id g9mr8283633ile.54.1612626185418;
 Sat, 06 Feb 2021 07:43:05 -0800 (PST)
MIME-Version: 1.0
References: <20210205224124.21345-1-xie.he.0141@gmail.com> <CA+FuTScLTZqZhNU7bWEw4OMTQzcKV106iRLwA--La0uH+JrTtg@mail.gmail.com>
In-Reply-To: <CA+FuTScLTZqZhNU7bWEw4OMTQzcKV106iRLwA--La0uH+JrTtg@mail.gmail.com>
From:   Eyal Birger <eyal.birger@gmail.com>
Date:   Sat, 6 Feb 2021 17:42:54 +0200
Message-ID: <CAHsH6GuW-xYp01ovBBC7+j8_v_WfiDmYznxW3Ajzo_qSFLy93A@mail.gmail.com>
Subject: Re: [PATCH net-next] net/packet: Improve the comment about LL header
 visibility criteria
To:     Xie He <xie.he.0141@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        John Ogness <john.ogness@linutronix.de>,
        Tanner Love <tannerlove@google.com>,
        Network Development <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Sat, Feb 6, 2021 at 4:52 AM Willem de Bruijn
<willemdebruijn.kernel@gmail.com> wrote:
>
> On Fri, Feb 5, 2021 at 5:42 PM Xie He <xie.he.0141@gmail.com> wrote:
> >
> > The "dev_has_header" function, recently added in
> > commit d549699048b4 ("net/packet: fix packet receive on L3 devices
> > without visible hard header"),
> > is more accurate as criteria for determining whether a device exposes
> > the LL header to upper layers, because in addition to dev->header_ops,
> > it also checks for dev->header_ops->create.
> >
> > When transmitting an skb on a device, dev_hard_header can be called to
> > generate an LL header. dev_hard_header will only generate a header if
> > dev->header_ops->create is present.
> >
> > Signed-off-by: Xie He <xie.he.0141@gmail.com>
>
> Acked-by: Willem de Bruijn <willemb@google.com>
>
> Indeed, existence of dev->header_ops->create is the deciding factor. Thanks Xie.

As such, may I suggest making this explicit by making
dev_hard_header() use dev_has_header()?

Eyal.
