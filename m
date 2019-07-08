Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D9FB362702
	for <lists+netdev@lfdr.de>; Mon,  8 Jul 2019 19:25:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388854AbfGHRZC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jul 2019 13:25:02 -0400
Received: from mail-io1-f65.google.com ([209.85.166.65]:42511 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728744AbfGHRZB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Jul 2019 13:25:01 -0400
Received: by mail-io1-f65.google.com with SMTP id u19so37010136ior.9
        for <netdev@vger.kernel.org>; Mon, 08 Jul 2019 10:25:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=aErlu6fvYbW7WJ9LzWOWg2BZGtOQx1pF2GQfzMk3Y/8=;
        b=VCBfnJPXV9syPat1kOEmvhib+2y3XP+4I0d7KywQrjJK826YVQSQ0s+LuNsImrvn7b
         8Kt4ZrBdf9irHKHIhcOfyzDdDPQ9KmQ3syDTUC9m8Hrzag67kXSDFF0OpfH4EzvMmeAi
         y3l+uz3jPkzLyDlU5qr0SirGbWvNsXDt0vSZ391CMP7xfWbMKNnQMXL2TVU/uPh49965
         foTtStDx8zVQ5TmsAPLcijGC5lLscwJbLEtQdKqQ5KP9QaMCWJKz8VjDL8PbAOiKqxvu
         ehOfmz1IG8nw38KZSlcBAoDfwqUXUtBK+ZNlSMRnsaSTT1tCo1WBUYE+KOYBfhW9uKGW
         elyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=aErlu6fvYbW7WJ9LzWOWg2BZGtOQx1pF2GQfzMk3Y/8=;
        b=rRIeqrBGPUPkL8aJeTkPetTupysorDrylVvmQtsY0v1ZjlME5I5Rv2BggopFWSM1Xi
         AjEoJzMZuBzTRijDfwBm6NXmm82kb17ME3Q7CasrHxFwJOQSixAxezhEyxUHKL8jEcx7
         JqwjgYZt9ZdMKe7kPDSZbPihYemOCrbcubVMtqAQjHgL6CuOeoWRNmvk9e9cwECAUNte
         F52S0E4qskWy29yl6lgJdgHWPgQmfmdErnshQ7DT5H7uJ5uQtlaz9lSijkPKAzMH1HTl
         X+5XXg32U4A9fKX88WdSI6cwEOO1M9/D8dYhYV8s9HtdVGsle64sYcNxOc/OZ19b51u+
         /rQw==
X-Gm-Message-State: APjAAAX14CKmUVljtoSI+6iRpYRK4hY/gKc77ZLDV9Fu+pC+f4cm2Ef3
        yMP2c1ku+ON1VL4ulBw45JBHH2ouo3w=
X-Google-Smtp-Source: APXvYqyMmY7+V0915DbqfY3XR7MKKomjkgbNlHvFF8mGQoP8L00oFD2ZeAVcPparY+bnJBfoSEvlYw==
X-Received: by 2002:a02:c6b8:: with SMTP id o24mr23731592jan.80.1562606701181;
        Mon, 08 Jul 2019 10:25:01 -0700 (PDT)
Received: from x220t ([64.26.149.125])
        by smtp.gmail.com with ESMTPSA id e22sm16459241iob.66.2019.07.08.10.25.00
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 08 Jul 2019 10:25:00 -0700 (PDT)
Date:   Mon, 8 Jul 2019 13:24:58 -0400
From:   Alexander Aring <aring@mojatatu.com>
To:     Lucas Bates <lucasb@mojatatu.com>
Cc:     David Miller <davem@davemloft.net>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Marcelo Ricardo Leitner <mleitner@redhat.com>,
        Vlad Buslov <vladbu@mellanox.com>,
        Davide Caratti <dcaratti@redhat.com>, kernel@mojatatu.com
Subject: Re: [PATCH v2 net-next 1/3] tc-testing: Add JSON verification to tdc
Message-ID: <20190708172458.syopc3bvvkjb3sxv@x220t>
References: <1562201102-4332-1-git-send-email-lucasb@mojatatu.com>
 <1562201102-4332-2-git-send-email-lucasb@mojatatu.com>
 <20190704202130.tv2ivy5tjj7pjasj@x220t>
 <CAMDBHY+Mg9W0wJRQWeUBHCk=G0Qp4nij8B4Oz77XA6AK2Dt7Gw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAMDBHY+Mg9W0wJRQWeUBHCk=G0Qp4nij8B4Oz77XA6AK2Dt7Gw@mail.gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Mon, Jul 08, 2019 at 12:48:12PM -0400, Lucas Bates wrote:
> On Thu, Jul 4, 2019 at 4:21 PM Alexander Aring <aring@mojatatu.com> wrote:
> 
> > why you just use eval() as pattern matching operation and let the user
> > define how to declare a matching mechanism instead you introduce another
> > static matching scheme based on a json description?
> >
> > Whereas in eval() you could directly use the python bool expression
> > parser to make whatever you want.
> >
> > I don't know, I see at some points you will hit limitations what you can
> > express with this matchFOO and we need to introduce another matchBAR,
> > whereas in providing the code it should be no problem expression
> > anything. If you want smaller shortcuts writing matching patterns you
> > can implement them and using in your eval() operation.
> 
> Regarding hitting limitations: quite possibly, yes.
> 
> Using eval() to provide code for matching is going to put more of a
> dependency on the test writer knowing Python.  I know it's not a
> terribly difficult language to pick up, but it's still setting a
> higher barrier to entry.  This is the primary reason I scrapped the
> work I had presented at Netdev 1.2 in Tokyo, where all the tests were
> coded using Python's unittest framework - I want to be sure it's as
> easy as possible for people to use tdc and write tests for it.
> 
> Unless I'm off-base here?

yes you need to know some python, complex code can be hidden by some
helper functionality I guess.

I have no problem to let this patch in, it will not harm anything...

Maybe I work on a matchEval and show some examples... in a human
readable way you can even concatenate bool expressions in combinations
with helpers.

I just was curious, so I might add the matchEval or something to show
this approach.

add the and it shows like:

"x == 5 or x == '5'"

Whereas you could introduce helpers to do:

"str_or_num(x, 5)"

even

"str_or_num_any_base(x, 5)"

to also catch if somebody change the base.
In this case "or" could be also concatenate with python bool
expression... depends on how lowlvl your helpers be.

Pretty sure the x as inputstring to match can also be hidden by user or
transformed with split, regex, etc before. At the end it will work like
TC with actions just provide the code to run... or is it more like
"act_bpf"?, where act is the hook and bpf the eval(). :-)

- Alex
