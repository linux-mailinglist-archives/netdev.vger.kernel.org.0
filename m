Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 70EA8966E0
	for <lists+netdev@lfdr.de>; Tue, 20 Aug 2019 18:57:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729980AbfHTQ5K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Aug 2019 12:57:10 -0400
Received: from mail-lj1-f194.google.com ([209.85.208.194]:38129 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726663AbfHTQ5J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Aug 2019 12:57:09 -0400
Received: by mail-lj1-f194.google.com with SMTP id x3so5786340lji.5;
        Tue, 20 Aug 2019 09:57:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=JAtJPN5LPz1NP7Kvc+Pi0qxaQWdr//qiRCcQt5w3p7Q=;
        b=L3hLxwYuiq8sL0sadcDvCKGQgKYHCZ+Rza6UC0Qub5NfC8iP4zdNqmxT9/veutW/xy
         Q4lBuqsovJEgtb1udxomRnVQhzWGi7WqTJ26GOd6+P+191qMuve/E2+AnozyA+UL5VHQ
         DeJQ569LLDji4yZKjMd5ydDJnjXXjeDBBf7e0Fcd4BHxsDu7aNHfbL1tG+/n/opWcVvH
         /o/ltiCHc1/FB48PdAayH0Uwq7g7ohT8QpX2yTLy5nWZpb2srwmXbMUnhq2/sGxen4/D
         +06/+fXKPLI6w4DtYQvpCYscN60ob7wK+4zgx4O4chACnUZk3rm7d+PQLMKf0K8CUWYr
         0s3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=JAtJPN5LPz1NP7Kvc+Pi0qxaQWdr//qiRCcQt5w3p7Q=;
        b=dhmlZIFR2op7+5gO09u62M4+DSwm8cPi+J68zOgkHQS0asPjNHT0kNWps5ANecWQ1M
         N04isb1oLxz+ksToeDEMMrhgXZTOywznKe9jdxHPeJbr1WvrCAgp7bPkNiRL+Q9b6q/S
         QFtvrkDGvLCYmVdaAbmZqIfkqn6fstZLYW6BUi3VPvmY026uicBldIMT2jAY/G6AhNjE
         Py7hh+trCDm5V1mEVaFaSQMvA5+eJcGnGI1l2lrXh1EdgEISJjUC6rzGGDo7QfsbK/Dg
         3c9SjDiByjhdTnx5hSQhJvAZQv73N0tOPF4Me6+ZCcK/kwi4/07dOvEY1IVJKnG1J4YU
         rM4A==
X-Gm-Message-State: APjAAAXKA1MeLPtBF5imM4cvGTcUdW9yyjHyIADn58Qxa7O7y4hcrRFI
        54mlF5Ev4o5pt77NTLInB9QfcBrbHxJ4nWXaDG7trs8UZ88=
X-Google-Smtp-Source: APXvYqwZTQIi+Miv3ig95Y4LIzK3YiEQuHgN2CRZAKDjTP/f30nmYWalpCzx2UKlkiLJyQy1odWpuqvCL/UXxQCqptg=
X-Received: by 2002:a2e:8004:: with SMTP id j4mr16032792ljg.231.1566320227639;
 Tue, 20 Aug 2019 09:57:07 -0700 (PDT)
MIME-Version: 1.0
References: <20190820084833.6019-1-hubert.feurstein@vahle.at>
 <20190820084833.6019-3-hubert.feurstein@vahle.at> <20190820094903.GI891@localhost>
 <CAFfN3gW-4avfnrV7t-2nC+cVt3sgMD33L44P4PGU-MCAtuR+XA@mail.gmail.com>
 <20190820142537.GL891@localhost> <20190820152306.GJ29991@lunn.ch> <20190820154005.GM891@localhost>
In-Reply-To: <20190820154005.GM891@localhost>
From:   Hubert Feurstein <h.feurstein@gmail.com>
Date:   Tue, 20 Aug 2019 18:56:56 +0200
Message-ID: <CAFfN3gUgpzMebyUt8_-9e+5vpm3q-DVVszWdkUEFAgZQ8ex73w@mail.gmail.com>
Subject: Re: [PATCH net-next v3 2/4] net: mdio: add PTP offset compensation to mdiobus_write_sts
To:     Miroslav Lichvar <mlichvar@redhat.com>
Cc:     Andrew Lunn <andrew@lunn.ch>, netdev <netdev@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Richard Cochran <richardcochran@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am Di., 20. Aug. 2019 um 17:40 Uhr schrieb Miroslav Lichvar
<mlichvar@redhat.com>:
>
> On Tue, Aug 20, 2019 at 05:23:06PM +0200, Andrew Lunn wrote:
> > > - take a second "post" system timestamp after the completion
> >
> > For this hardware, completion is an interrupt, which has a lot of
> > jitter on it. But this hardware is odd, in that it uses an
> > interrupt. Every other MDIO bus controller uses polled IO, with an
> > mdelay(10) or similar between each poll. So the jitter is going to be
> > much larger.
>
> I think a large jitter is ok in this case. We just need to timestamp
> something that we know for sure happened after the PHC timestamp. It
> should have no impact on the offset and its stability, just the
> reported delay. A test with phc2sys should be able to confirm that.
> phc2sys selects the measurement with the shortest delay, which has
> least uncertainty. I'd say that applies to both interrupt and polling.
>
> If it is difficult to specify the minimum interrupt delay, I'd still
> prefer an overly pessimistic interval assuming a zero delay.
>
Currently I do not see the benefit from this. The original intention was to
compensate for the remaining offset as good as possible. The current code
of phc2sys uses the delay only for the filtering of the measurement record
with the shortest delay and for reporting and statistics. Why not simple shift
the timestamps with the offset to the point where we expect the PHC timestamp
to be captured, and we have a very good result compared to where we came
from.

Hubert
