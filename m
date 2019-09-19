Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 795E0B7A95
	for <lists+netdev@lfdr.de>; Thu, 19 Sep 2019 15:33:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390470AbfISNdP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Sep 2019 09:33:15 -0400
Received: from mail-ed1-f50.google.com ([209.85.208.50]:45159 "EHLO
        mail-ed1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388898AbfISNdP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Sep 2019 09:33:15 -0400
Received: by mail-ed1-f50.google.com with SMTP id h33so3178376edh.12
        for <netdev@vger.kernel.org>; Thu, 19 Sep 2019 06:33:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=S3UwS/TmvhYeR3SY0Vup236nL18uDULwNvU5vmC4ufQ=;
        b=hnLUzS9iekx+5sR2VNOC7y2ZL5t8bfT2eoA8UClBbx9b2Ufd5gi0OPvDFVnDvx4z3f
         CFud1JSlwgfqBf0t6s/kbdP4YJ5fODR3BCCpeXa12rn5fh3zhZIcJhxYzMyJ9kXszfa2
         z0R1TP7drZTAslIkbBqsSMbHM6BWd35sBJUsBqRES07MKcE7VJWC8uMhTO5mzUKPXx2G
         mdp8igAIi5cFykB7elX8lyjpnjf6MU+RO6vCSupASpQaRuLsSux36HtQVzN+XqcojiC9
         MKUeo8jhQXQNhmIo2YfenNMKI5vzkXqtxuUTfM77Ikq24s7YIHjX/oXrTiiYRaFj44cB
         J5vA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=S3UwS/TmvhYeR3SY0Vup236nL18uDULwNvU5vmC4ufQ=;
        b=s8SM7eZmKJGeUdL886YX4qainCtSNWJ5AHBymWdi+EYqJZVGx/fwqQ/dy44yQ0hVMZ
         eE2RZIxaDmWOZaxcBYltEUKQkCoPWUpVvX2/edSEbhdAIypTdojmOUNeKudMMil4PI5C
         4TZlljUsZcF0KbjTDDK3LbOVNusvHZS32cF22TOfl6MLVcMjbqFelZvWxQHiFCehcF+s
         +XwpOtOlmqbnFsD5amVP32WWQbFv9u3zS3qD2sO97ARBd9xz1StcRu+CY85vqamYCJB6
         6c5O9x4W2QbSl9YBExYnyr77KcNU2tKzXTbxgH7z7gsbW0LOR1lQs47kNw3nkuTo2TZg
         Vs+Q==
X-Gm-Message-State: APjAAAXy59n3nIXcA98ngR5hLrms/UkYn/cR7kws8c4f+p6VTjCnkXYj
        iX/TJgGesjsVP5nqq4lL5QkKQeg6A1rpHtsIZv2YpCZ5
X-Google-Smtp-Source: APXvYqxQdVHdPV56dMF7N0ro4Zat1zfos/dpFzfXkn+9mv86MD1yROZeOcciEkl/723vAwzouG9SIurATtjYQ70xDsE=
X-Received: by 2002:a50:e701:: with SMTP id a1mr16415204edn.108.1568899992100;
 Thu, 19 Sep 2019 06:33:12 -0700 (PDT)
MIME-Version: 1.0
References: <20190918140225.imqchybuf3cnknob@pengutronix.de>
 <CA+h21hpG52R6ScGpGX86Q7MuRHCgGNY-TxzaQGu2wZR8EtPtbA@mail.gmail.com>
 <1b80f9ed-7a62-99c4-10bc-bc1887f80867@gmail.com> <06d2ca7441c899b4da8475f82dc706351edd0976.camel@pengutronix.de>
In-Reply-To: <06d2ca7441c899b4da8475f82dc706351edd0976.camel@pengutronix.de>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Thu, 19 Sep 2019 16:33:00 +0300
Message-ID: <CA+h21hoNAMVb8HQxHcGxU8vn3TACAZ=jim5wSL4NS21inHSMMQ@mail.gmail.com>
Subject: Re: dsa traffic priorization
To:     =?UTF-8?Q?Jan_L=C3=BCbbe?= <jlu@pengutronix.de>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        netdev <netdev@vger.kernel.org>,
        Vivien Didelot <vivien.didelot@savoirfairelinux.com>,
        kernel@pengutronix.de, Andrew Lunn <andrew@lunn.ch>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jan,

On Thu, 19 Sep 2019 at 16:21, Jan L=C3=BCbbe <jlu@pengutronix.de> wrote:
>
> Hi,
>
> On Wed, 2019-09-18 at 10:41 -0700, Florian Fainelli wrote:
> > > Technically, configuring a match-all rxnfc rule with ethtool would
> > > count as 'default priority' - I have proposed that before. Now I'm no=
t
> > > entirely sure how intuitive it is, but I'm also interested in being
> > > able to configure this.
> >
> > That does not sound too crazy from my perspective.
>
> Sascha and myself aren't that familiar with that part of ethtool.
> You're talking about using ethtool --config-nfc/--config-ntuple on the
> (external) sw1p1, sw1p2 ports? Something like this (completely untested
> from the manpage):
> ethtool --config-nfc sw1p1 flow-type ether queue 2 # high prio queue for =
ethercat
> ethtool --config-nfc sw1p2 flow-type ether queue 1 # normal for rest
>

Yes, something like that.

> Currently, there seems to be no "match-all" option.
>

Well, some keys for flow steering can be masked. See:

           src xx:yy:zz:aa:bb:cc [m xx:yy:zz:aa:bb:cc]
                  Includes the source MAC address, specified as 6
bytes in hexadecimal separated by colons, along with an optional mask.
Valid only for flow-type ether.

           dst xx:yy:zz:aa:bb:cc [m xx:yy:zz:aa:bb:cc]
                  Includes the destination MAC address, specified as 6
bytes in hexadecimal separated by colons, along with an optional mask.
Valid only for flow-type ether.

           proto N [m N]
                  Includes the Ethernet protocol number (ethertype)
and an optional mask.  Valid only for flow-type ether.

The idea is that any rule with e.g. src 00:00:00:00:00:00 and m
00:00:00:00:00:00 is an implicit match-all, because any (SMAC & m) =3D=3D
src.
The issue I see (and why I said it's not intuitive) is that there is
more than 1 way to express the same thing, and that it raises sanity
questions about rule ordering (if the rule is first, should all
subsequent flow steering rules be ignored?). Also, the driver would
have to open-code the "matchall" condition in order to detect it and
configure the default qpri.

It appears that there is a way to do this with tc-flower (or any other
classifier) as well, by specifying any null key with a mask of zero.

I don't know enough either to understand what is preferable.

> Alternatives to "queue X" might be "action" or "context", but I don't
> know enough about the details to prefer one above the other.
>
> Regards,
> Jan
>

Thanks,
-Vladimir
