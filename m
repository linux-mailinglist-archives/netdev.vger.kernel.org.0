Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1DB2C5F93F
	for <lists+netdev@lfdr.de>; Thu,  4 Jul 2019 15:40:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727234AbfGDNkO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Jul 2019 09:40:14 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:44052 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727026AbfGDNkO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Jul 2019 09:40:14 -0400
Received: by mail-io1-f68.google.com with SMTP id s7so12871635iob.11
        for <netdev@vger.kernel.org>; Thu, 04 Jul 2019 06:40:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=FOC6m54qFzCKdSf2AHD5qRenMdphnUm3Kcp53LXRvFk=;
        b=eIFir22wgjriGWmJM6IEAywzKTt2FJT6sTRppnJG58L8wuO5A5TUvbAbOGnNk4DJ8K
         lonkHJTp8N2d0V7cCBNg39J38n8t1z3hMQDickWTTRDYRodr9+YccaZ3A6f+7+Q3q47p
         4GMjXZi9WS0D8+UYKCf+zbFY1nSLVCcEDwTJWhG0aAFZWBKFE8veNsbQvtlTJ28gpj46
         GvSGn5Q4fqulLg9quiABTuxbY0bG2PT5Enhy39NMRQWlyWP9mjl65iCXYnlyFXueHiev
         yb44qc4+lcl109XNM02UE+nae1NcaGLlF/EvrhdavPFxMLkmsIJpAne2mYBHfVs0y/Z9
         tSeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=FOC6m54qFzCKdSf2AHD5qRenMdphnUm3Kcp53LXRvFk=;
        b=DuhbBzA8kugT/L0d54ODSx2fYSYbmHrRfRZMNweWmCaEg+DKW/grSWOM+v1RuiitcD
         IGgxJ02x6cEnHQQvOziQBVCFugFnJkQm2OT/oqlB7x1ax29Ld3r65Eab8oTOlX+0nI6W
         4IxZtAgHK4a0s7aYtsyF/ZJixzkFPtsnLoPfmobzkEFntrtN2FR2JIXg8X2w1tQB//RG
         psJ3PKLQZ0KasYBVbkDDkMFZ98eWha5LTmFWV0LQ//bM0pWqq9BfsJNm5U29pXHagx1K
         /QFUCJoZhiSRBVSLm8LnEbE/eesa1yU9feSc4Z8yuKHe99zVTxYZGBRbSohK3/c88IAa
         1aaA==
X-Gm-Message-State: APjAAAX14O1gvkoNHoic1WQdkmSl4JU5Inu6gqWAL3nBn12bBMjew7Yx
        DKwJdikdPZsI3KPIXDAJW4w9fumqbFGMrLHJrgS2dA==
X-Google-Smtp-Source: APXvYqytkP0Jan2GuKxxG4n5TwDOgKJj2Lyya1+6cXAXEN1jlaiu4tnpOoySRM4+0QCFMg2wcaAHx4SBsMn9u7U4zgk=
X-Received: by 2002:a5e:8210:: with SMTP id l16mr15733654iom.240.1562247613461;
 Thu, 04 Jul 2019 06:40:13 -0700 (PDT)
MIME-Version: 1.0
References: <1562113531-29296-1-git-send-email-john.hurley@netronome.com>
 <1562113531-29296-6-git-send-email-john.hurley@netronome.com> <0130c56ef79f8bf360ddb0b01db5e7684f0bf62a.camel@redhat.com>
In-Reply-To: <0130c56ef79f8bf360ddb0b01db5e7684f0bf62a.camel@redhat.com>
From:   John Hurley <john.hurley@netronome.com>
Date:   Thu, 4 Jul 2019 14:40:02 +0100
Message-ID: <CAK+XE=kL9-0w+bUjEh84QwJ_60xOBKu54++MH337c+a5Tc3n0Q@mail.gmail.com>
Subject: Re: [PATCH net-next v5 5/5] selftests: tc-tests: actions: add MPLS tests
To:     Davide Caratti <dcaratti@redhat.com>
Cc:     Linux Netdev List <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Jiri Pirko <jiri@mellanox.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        David Ahern <dsahern@gmail.com>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Simon Horman <simon.horman@netronome.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        oss-drivers@netronome.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 4, 2019 at 9:40 AM Davide Caratti <dcaratti@redhat.com> wrote:
>
> On Wed, 2019-07-03 at 01:25 +0100, John Hurley wrote:
> > Add a new series of selftests to verify the functionality of act_mpls in
> > TC.
> >
> > Signed-off-by: John Hurley <john.hurley@netronome.com>
> > Reviewed-by: Simon Horman <simon.horman@netronome.com>
> > Acked-by: Jakub Kicinski <jakub.kicinski@netronome.com>
> > ---
> >  .../tc-testing/tc-tests/actions/mpls.json          | 812 +++++++++++++++++++++
> >  1 file changed, 812 insertions(+)
> >  create mode 100644 tools/testing/selftests/tc-testing/tc-tests/actions/mpls.json
> >
>
> hello John,
>
> (sorry for noticing this late). some scripts use
>
> tools/testing/selftests/tc-testing/config
>
> to rebuild vmlinux before running TDC. I think you should add a line
> there that sets CONFIG_NET_ACT_MPLS=y.
>
> WDYT?

Hi Davide,
Thanks for pointing this out.
Yes, I'll add it.
Thanks

>
> thanks!
> --
> davide
>
