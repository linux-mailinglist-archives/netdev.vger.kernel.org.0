Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C6E224057A
	for <lists+netdev@lfdr.de>; Mon, 10 Aug 2020 13:52:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726412AbgHJLwE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Aug 2020 07:52:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726143AbgHJLwD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Aug 2020 07:52:03 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAA9AC061756
        for <netdev@vger.kernel.org>; Mon, 10 Aug 2020 04:52:03 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id q76so8037703wme.4
        for <netdev@vger.kernel.org>; Mon, 10 Aug 2020 04:52:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=UbGvgy+LM0W6ldbwhRTwAq0qgpDqMGu8DNSM976BCHs=;
        b=TRI/A2yCuSKDuiyVXcsZz9R/nlRUYWoZTCiNbQ3v57IuhTCwVvIr0G4hbNPtgL5D8B
         f8FDSlHoqqcT0VN2WjhJ2jr7HYfdyFhTQe0MUAwhzn9wCn5Z+1BPjKlUoGPwjrie0TbL
         c8qaIih/Cv1g+SFe+kbVbKrgETI/I0sVe8L9L8rdQqRgkj3TL6fi3n2tIBMVnTo09k7o
         mUrw6mEb+eq61fScSY3AxlX7ogV6ayx64/6tScVaWr7hfpugqmCjESSIpHgerUL2xjn1
         3A85hoVEan10x97NJCs8m/tsR6NF5E+yuMLWMHjZPyC5yfgwwEeXAoUZ4dIoapY7VQyG
         Yr8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=UbGvgy+LM0W6ldbwhRTwAq0qgpDqMGu8DNSM976BCHs=;
        b=EmC+GXSdUYjy4lg13vzK6pgB2aKTFG8DE0WikqJJt51PWY4kAiDbDIJ7oppE3vSr2W
         ILZOp/F8gP0+VUdr7ECdi5kgzFI9pkuDZFQxQ5AHlcrFMVtNqSY5ESIvqBPCLofahdb0
         yMpxVvMI7XijdX2s1rOk8O4B24vulkvUEp/ue8bHGT3lJtjp3DRtK91A3mJnx8r6OLXv
         DX06V41gE5d4CCZntoERfV4tCppb4ZPjmKAOO5kAlBoR2KvWwEUz4rhrNtnUqg+cuyQ/
         FBPEDQKGtDbk11v7DF0tJtIe3yq3Qj5UaND0EaBghdXXPBlEXkkjDh3dtEvv9oVMTaic
         nyUQ==
X-Gm-Message-State: AOAM532YjKkpKonI2I56UDXj0yTw5vU8Wj8LA3WW6uSnXZf6LtTtjskQ
        R/58d4lmIwoxruRF+MYTFYEyR6Rsw16MFP7s+88IZhrU
X-Google-Smtp-Source: ABdhPJzvZYjbPUXgN3+8dUMcR/ZViCy4XGdnWaTml8Oc6sxARzbFp6+CchV9XcB6B6cyT8G2fsd+i6oFlWt2jE6tH5I=
X-Received: by 2002:a05:600c:210:: with SMTP id 16mr25955450wmi.165.1597060322426;
 Mon, 10 Aug 2020 04:52:02 -0700 (PDT)
MIME-Version: 1.0
References: <20200728190842.1284145-1-anthony.l.nguyen@intel.com>
 <20200728131653.3b90336b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com> <CAJ+HfNjBCNcb+KO+V0hmSvo2i5L+Cf52F3=-+7TonXkGJ9dXgA@mail.gmail.com>
In-Reply-To: <CAJ+HfNjBCNcb+KO+V0hmSvo2i5L+Cf52F3=-+7TonXkGJ9dXgA@mail.gmail.com>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Date:   Mon, 10 Aug 2020 13:51:51 +0200
Message-ID: <CAJ+HfNgyMAD45bWyoZVUiqS_TDTAX7QeD4+JX6GSNh-bcA+P7A@mail.gmail.com>
Subject: Re: [net-next 0/6][pull request] 40GbE Intel Wired LAN Driver Updates 2020-07-28
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>,
        David Miller <davem@davemloft.net>,
        Netdev <netdev@vger.kernel.org>, nhorman@redhat.com,
        sassmann@redhat.com, Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 10 Aug 2020 at 13:47, Bj=C3=B6rn T=C3=B6pel <bjorn.topel@gmail.com>=
 wrote:
>
> On Tue, 28 Jul 2020 at 22:20, Jakub Kicinski <kuba@kernel.org> wrote:
> >
> > On Tue, 28 Jul 2020 12:08:36 -0700 Tony Nguyen wrote:
> > > This series contains updates to i40e driver only.
> > >
> > > Li RongQing removes binding affinity mask to a fixed CPU and sets
> > > prefetch of Rx buffer page to occur conditionally.
> > >
> > > Bj=C3=B6rn provides AF_XDP performance improvements by not prefetchin=
g HW
> > > descriptors, using 16 byte descriptors, increasing budget for AF_XDP
> > > receive, and moving buffer allocation out of Rx processing loop.
> >
> > My comment on patch #2 is really a nit, but for patch 5 I think we
> > should consider carefully a common path rather than "tweak" the drivers
> > like this.
>
> Yup, I agree that tweaks like this should be avoided, and I said that
> I'll address it in a follow up. However, I was under the impression
> that this series would still be pulled (discussed in patch 5), but I
> can't find it in the tree.
>

Ugh. Please ignore the noise. Patchwork says "Changes Requested".

I'll rework the series!


Cheers,
Bj=C3=B6rn
