Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 36B42120D4
	for <lists+netdev@lfdr.de>; Thu,  2 May 2019 19:05:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726415AbfEBRFv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 May 2019 13:05:51 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:43880 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725951AbfEBRFv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 May 2019 13:05:51 -0400
Received: by mail-wr1-f65.google.com with SMTP id a12so4380561wrq.10;
        Thu, 02 May 2019 10:05:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=in1uQTMBWtOh64av0pw1ODlK0jXEz8TDIIxX4L0HSRA=;
        b=kOwCFJtflkHUjyiXGdvExSqjhcE5ZYlpIXr5N+Iaq/I7vPUktq+UOIo6Ddbgl29+Kd
         t145ckjj9usNhRH61XvBAw06oO9570T9O25OFCelvhXRnA7Hl9pzjjB0nc0enMJcnfLw
         /BW78bYnTn6bg1hTqKPOh0MsdcORklFgNpj5UOsTVV8oUUdGosPonUFtrK+amxHBCp21
         4zX91N0M1tdODQt2dcSdoKcICUKsANr3txBbtTan44bjzFqbESdFBXPXlQL3CdZY5CZT
         uDkRBv8nr6yB8/Zy1yy0AR2Pn9KtKxzPZYkCrnqFYh6p9s6niYqvga8SBhSQwZ/PpFHT
         Ak9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=in1uQTMBWtOh64av0pw1ODlK0jXEz8TDIIxX4L0HSRA=;
        b=bz8nYG9qtwgLNE7WQxHvXEAZIt/crkok2FlvkX8KgJ3XKZGDno5I/838ilLALzU3yv
         cpMmeHsVJg0j/5hOiKY3JXFk89b4/nE3h4voIWJ1kWMD9H9KSnGqP1rIDtP2gtHS2Pk1
         7aT5xbp/0GtH0M0AObJtoV4Rah3PA2e9H4ZGX3PYMXG+h/b+wqEuVHFfW1JPRR0VSmZI
         qX1ZYqi+fbFqcuUf1CNWW265U/PM55G08iEStgOO/TXgizOWsKyKsa1d3K+/3iTpoJce
         bnB3ZUFrsHvx/b3aFJeKXKsnLlvj3ZDs9lDIhN2o6bc50mhj0sCDzCEKJ3VGw4OBTsIJ
         Oq/A==
X-Gm-Message-State: APjAAAU1iwy5tvtIvlvlTxOU2W7HsMwaIBBqp9dRpEUqCRVLq/r4UvmC
        nsFJaSRkdJSTbwxi7WcxMB0W69r6jmw3l+QUam+FJOd5
X-Google-Smtp-Source: APXvYqzJDJeZH+u5wLZrtMk5dWcg78roX9gJZ5vsT311mdXiEx6qouJx5Vb1BhPWlULehIojAMrngHojXiE6gEFNXmk=
X-Received: by 2002:a5d:4dc1:: with SMTP id f1mr3668977wru.300.1556816749412;
 Thu, 02 May 2019 10:05:49 -0700 (PDT)
MIME-Version: 1.0
References: <20190429001706.7449-1-olteanv@gmail.com> <20190430.234425.732219702361005278.davem@davemloft.net>
 <CA+h21hrmXaAAepTrY-HfbrmZPVRf3Qg1-fA8EW4prwSkrGYogQ@mail.gmail.com> <20190502165530.GJ19809@lunn.ch>
In-Reply-To: <20190502165530.GJ19809@lunn.ch>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Thu, 2 May 2019 20:05:38 +0300
Message-ID: <CA+h21hrBY+TW9cqyovH93HE=Ho26Qdm12s4J4JqMmwNF2YNb6Q@mail.gmail.com>
Subject: Re: [PATCH v4 net-next 00/12] NXP SJA1105 DSA driver
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     David Miller <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        vivien.didelot@gmail.com, netdev <netdev@vger.kernel.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2 May 2019 at 19:55, Andrew Lunn <andrew@lunn.ch> wrote:
>
> > Wow I am sorry, Gmail apparently moved your reply to spam and I only
> > got it when I posted my message just now.
> > Do you know what causes these whitespace errors, so I can avoid them
> > next time? I think I'm generating my patches rather normally, with
> > $(git format-patch -12 --subject-prefix="PATCH v4 net-next"
> > --cover-letter).
>
> What happens when you run checkpatch on the patches? Does it report
> white space problems.
>
> Another possibility is your email system has mangled the patches.
> First try applying the patches you generated from format-patch to a
> clean tree. If you don't get any warnings, email the patches to
> yourself, and then apply them.
>
>      Andrew

Hi Andrew,

checkpatch.pl --strict doesn't appear to catch this. It looks like
it's caused by introducing new files that are terminated in a blank
line. I will stop doing that.

Thanks,
-Vladimir
