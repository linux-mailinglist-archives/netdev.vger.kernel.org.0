Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6AFFBD1C53
	for <lists+netdev@lfdr.de>; Thu, 10 Oct 2019 00:57:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732322AbfJIW5j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Oct 2019 18:57:39 -0400
Received: from mail-ed1-f66.google.com ([209.85.208.66]:44636 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730815AbfJIW5i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Oct 2019 18:57:38 -0400
Received: by mail-ed1-f66.google.com with SMTP id r16so3614419edq.11;
        Wed, 09 Oct 2019 15:57:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=TLKAB20NJ4mG79AwI1Zw5Vd419N/hLfm1s9oXYim4aQ=;
        b=j8gwvtYlNfvlgcQ5D1sETxQxUnyN9H7oHHT8mZFThK5rhUkKIRZN7tzU+ulJvmo5dJ
         6YkCah47L5JIeZx0/roqO0U37ivmO6+36tnNzmR7GCJGyuyg/WII4+rSj1ocvtflwu+v
         LVFvzBmRRVkUKf/kO52MIFVqtwYxESrjWOIZSvPzK2NLFRJCkB/ZqtGzYqBJE5qt+Aed
         M+dAoAjbws5s1SIn7WXC7ZD7gkZridUvLN29AvxJnQLvyL98W3If1zm6S/D2eRagbmdm
         gENfd3MYTgHDMEyVHY37S1Z75tVxIjLRtY/leVau37sPLemzO8vYL6zA2/lsCfqx9aFT
         nawA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=TLKAB20NJ4mG79AwI1Zw5Vd419N/hLfm1s9oXYim4aQ=;
        b=PoLinT6dhuofVJ3/zRk+zjnejMjWs8+Txc3+twiXpHhcaszlwgPqR8NasdZy/3ak6z
         XmkJ5KMX9/ufE9jCsJM1FiBk1/tn/KLfSsDyIgQmJ+U8jlxKFACpAQb9Sjxw3JRDZZKs
         vvhpc9Y9thwUYaFDsxVioyro6HIOB4ZrtEUxWEvHGMcCrZZqbbamyBxHFGXZ7C5EsXk9
         8QPTwyvlXRxeBiodXBnXTjT3GuxCNUy/xyoinU4qXJNtQewMbv1MqgaNrNysHPNRnP4D
         hMFc8B9fIltot7LpcQEtbCRHGggzTDIB0VjIclhp8NEnGa/igt7sMgIDdK94EcAgnw77
         kdGw==
X-Gm-Message-State: APjAAAUHW+HKj6tpgP6oWivzNhcbZ+h3B4bfYmHFdN2anPEE33yqkLaC
        dSBl8RGK/ba8J+qpnfWPe8GMxJNm8tcbAajFKhA=
X-Google-Smtp-Source: APXvYqwYUsKHv7PThKGpnEpqXfpkOPngRiW9gzxpeqrSnk/roSAAFnQQITw3Bv4rByly/JmvWMye1kNWtprDV41TtZo=
X-Received: by 2002:a17:906:28ce:: with SMTP id p14mr5246086ejd.164.1570661856358;
 Wed, 09 Oct 2019 15:57:36 -0700 (PDT)
MIME-Version: 1.0
References: <20190905010114.26718-3-olteanv@gmail.com> <20191008105254.99A6D274299F@ypsilon.sirena.org.uk>
 <CA+h21hoid_bQ37qC30fDt62ces40PwSQ2v=KHTGkadV_ycrd5A@mail.gmail.com>
 <20191008164259.GQ4382@sirena.co.uk> <20191009151348.2e2e2383@cakuba.netronome.com>
In-Reply-To: <20191009151348.2e2e2383@cakuba.netronome.com>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Thu, 10 Oct 2019 01:57:25 +0300
Message-ID: <CA+h21hoDAuKwLj--pbm=TGaO0PKwUeTUFDu=36KjDN+XwP80jw@mail.gmail.com>
Subject: Re: Applied "spi: Add a PTP system timestamp to the transfer
 structure" to the spi tree
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     Mark Brown <broonie@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Hubert Feurstein <h.feurstein@gmail.com>,
        linux-spi@vger.kernel.org, Miroslav Lichvar <mlichvar@redhat.com>,
        netdev <netdev@vger.kernel.org>,
        Richard Cochran <richardcochran@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 10 Oct 2019 at 01:14, Jakub Kicinski
<jakub.kicinski@netronome.com> wrote:
>
> On Tue, 8 Oct 2019 17:42:59 +0100, Mark Brown wrote:
> > On Tue, Oct 08, 2019 at 03:58:51PM +0300, Vladimir Oltean wrote:
> >
> > > Dave, do you think you can somehow integrate this patch into net-next
> > > as well, so that I can send some further patches that depend on the
> > > newly introduced ptp_sts member of struct spi_transfer without waiting
> > > for another kernel release?
> >
> > Ugh, it'd have been good to have been more aware of this before applying
> > things since I put them on the one development branch (I used to make
> > more topic branches but Linus doesn't like them).  I've pulled things
> > out into a branch with a signed tag for merging into other trees:
> >
> > The following changes since commit 54ecb8f7028c5eb3d740bb82b0f1d90f2df63c5c:
> >
> >   Linux 5.4-rc1 (2019-09-30 10:35:40 -0700)
> >
> > are available in the Git repository at:
> >
> >   https://git.kernel.org/pub/scm/linux/kernel/git/broonie/spi.git tags/spi-ptp-api
> >
> > for you to fetch changes up to 79591b7db21d255db158afaa48c557dcab631a1c:
> >
> >   spi: Add a PTP system timestamp to the transfer structure (2019-10-08 17:38:15 +0100)
> >
> > ----------------------------------------------------------------
> > spi: Add a PTP API
> >
> > For detailed timestamping of operations.
> >
> > ----------------------------------------------------------------
> > Vladimir Oltean (1):
> >       spi: Add a PTP system timestamp to the transfer structure
> >
> >  drivers/spi/spi.c       | 127 ++++++++++++++++++++++++++++++++++++++++++++++++
> >  include/linux/spi/spi.h |  61 +++++++++++++++++++++++
> >  2 files changed, 188 insertions(+)
>
> Thanks for the branch, I pulled it into net-next, it should show up once
> build testing is done.

Thanks to both of you, Jakub and Mark!

-Vladimir
