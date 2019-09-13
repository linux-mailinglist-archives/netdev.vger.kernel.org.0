Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2629AB1A93
	for <lists+netdev@lfdr.de>; Fri, 13 Sep 2019 11:15:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387608AbfIMJPE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Sep 2019 05:15:04 -0400
Received: from mail-io1-f65.google.com ([209.85.166.65]:37894 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387424AbfIMJPE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Sep 2019 05:15:04 -0400
Received: by mail-io1-f65.google.com with SMTP id k5so36257787iol.5
        for <netdev@vger.kernel.org>; Fri, 13 Sep 2019 02:15:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=BZYz4r8LKKZMJckNqySIN78GP3+8nmIk7Tu7AI7j78M=;
        b=moxbltNFRyTmjMVPWq6qw9NSRngSI5kk9L1i75J8igc30wDUAQ6qPNFnz+jYMRm0sn
         nxcwknDr4EmmrnthRsr4GN6VN13fU1GI7lj1aMxJJsENOjAVbBUdqfBprAv1bXJQ1Ky8
         NEyguiIbIx+XR0UEyl4l5PY4lEtCHOXzY+dMkFbpdc9ZVPuT5KMIeIxGPzlPJ+L9Qp5s
         kh/F1yNOKVR2O2pk5Jo39KIDRc29sgnOXW4JdRF2rmFnvCmuw5m30NAD7yOYHSoC+Ud0
         1duM5aCqfXRffF1OXYwtpXyR9GUcIIoT/4frV22l8KFPYxhAtGSKrJ0Q1jsBI3iWk5WF
         ImpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=BZYz4r8LKKZMJckNqySIN78GP3+8nmIk7Tu7AI7j78M=;
        b=t1lB7814H5IezqXQEXs7LBzTEqOcCbG6vHfNstXLH/xkjNcxCkOQXwjg5JdJxwomWf
         hVj1vEZV5R7jXNMYw5pv+9ZavZ+Q5WG/wtV0IikhmmJ8zWMhL3mcPjS6W1onx4PCyNUY
         YGvLzyLMahnzDjvS+j5JLhC66jVJmg0lts07ULRQeAZBsuDOe8ZVGiCJK/P1iaMwOx8D
         A3WiptMFML5yv8gAflWF7DOJTh5KKqD2XrxuP6HVMnA9Qa91siHZvER20BBnlv483t/0
         41++S5tJ9WT5IFbmVCZXnGkITlNTQSzrkPXWRFVJRlW2iij7hTfzrCSESntZPY7OOmnA
         NvWw==
X-Gm-Message-State: APjAAAVzqI8k+AimqK8/0efulErN4F6HW58F0eKYVB2E9TjC9mQVRptn
        sIXNVe18rsCLg1hDg3CTExsxfoe526i7z4kcrO3xAkcHCievHg==
X-Google-Smtp-Source: APXvYqw5MYajYxKjH+PAEU3A+ZfT8QacCpo9Zy3TUgM5TvR78pwZzqQQpJ7ftNDk4Eugl+5pQAW7JNt9FFZXlBkZIhU=
X-Received: by 2002:a6b:5814:: with SMTP id m20mr4028863iob.249.1568366103204;
 Fri, 13 Sep 2019 02:15:03 -0700 (PDT)
MIME-Version: 1.0
References: <CAO42Z2xH_R1YQBhpyFVziPnHzWwzNV61VqrVT0yMcdEoTd6ZNQ@mail.gmail.com>
In-Reply-To: <CAO42Z2xH_R1YQBhpyFVziPnHzWwzNV61VqrVT0yMcdEoTd6ZNQ@mail.gmail.com>
From:   Dave Taht <dave.taht@gmail.com>
Date:   Fri, 13 Sep 2019 10:14:51 +0100
Message-ID: <CAA93jw4SC2choBKXvaTD_5j93Op=RZ9ZEeKmyAu31ys_uNhSyA@mail.gmail.com>
Subject: Re: "[RFC PATCH net-next 2/2] Reduce localhost to 127.0.0.0/16"
To:     Mark Smith <markzzzsmith@gmail.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 13, 2019 at 9:54 AM Mark Smith <markzzzsmith@gmail.com> wrote:
>
> (Not subscribed to the ML)
>
> Hi,
>
> I've noticed this patch. I don't think it should be applied, as it
> contradicts RFC 1122, "Requirements for Internet Hosts --
> Communication Layers":

Yea!  I kicked off a discussion!

> "(g)  { 127, <any> }
>
>                  Internal host loopback address.  Addresses of this form
>                  MUST NOT appear outside a host."

That 1984 (89) definition of a "host" has been stretched considerably
in the past few decades. We now have
a hypervisor, multiple cores, multiple vms, vms stacked within vms,
and containers with virtual interfaces on them, and a confusing
plethora of rfc1918 and nat between them and the wire.

This RFC-to-netdev's proposed reduction to a /16 was sufficient to
cover the two main use cases for loopback in Linux,
127.0.0.1 - loopback
127.0.1.1 - dns

We'd also seen some usages of things like 127.0.0.53 and so on, and in
the discussion at linuxconf last week,
it came out that cumulus and a few others were possibly using high
values of 127.x for switch chassis addressing, but we haven't got any
documentation on how that works yet.

The 1995 IPv6 standard and later has only one loopback address.
127.0.0.0/8 is 16m wasted internal to the host addresses.

> RFC 1122 is one of the relatively few Internet Standards, specifically
> Standard Number 3:
>
> https://www.rfc-editor.org/standards

We have been exploring the solution space here:

https://github.com/dtaht/unicast-extensions/blob/master/rfcs/draft-gilmore-=
taht-v4uniext.txt

If you would like to file more comments and bugs - or discuss here!
that would be great.

>
> Regards,
> Mark.



--=20

Dave T=C3=A4ht
CTO, TekLibre, LLC
http://www.teklibre.com
Tel: 1-831-205-9740
