Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 94C4A5EDCBD
	for <lists+netdev@lfdr.de>; Wed, 28 Sep 2022 14:32:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233887AbiI1Mcd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Sep 2022 08:32:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233622AbiI1Mcb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Sep 2022 08:32:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D50A593516;
        Wed, 28 Sep 2022 05:32:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3FD4E61E82;
        Wed, 28 Sep 2022 12:32:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A121BC433C1;
        Wed, 28 Sep 2022 12:32:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664368348;
        bh=EyNm9e/kospwfUBKMSLkr0M2BSBwrVHn2fh1tDOdwuM=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=dfamZNM5fP+jn1l5pyh80H1snVTZr8zfNWZmV0lU2et4mkWHw2nG4TrGClGDvYOrV
         EEktRyPQv/7b62/9h6h2UohFiwIAobSGr/eGKFTJmWuNnBPo7B5jW6DuEDkjRq/e0R
         x3u88+dSTqXXhTHF2UzCz8xJHbjSANofTRcPiIr7MGpLZl8fbdiuSM9tolDSftwo+S
         25DyQJcfykPBCBSAT8aS3NKb5CZ2xralbCPtDaKbwkoWSMWIS9Ov20IO6X18CvS0Pa
         saR47y/KECX3v/JG33rJEFGIorc8WBXzw9A0wZuZ0/sRnNoDRYNCmSluEoexLld8un
         ek88SPjumXegw==
Received: by mail-vs1-f48.google.com with SMTP id m66so12471730vsm.12;
        Wed, 28 Sep 2022 05:32:28 -0700 (PDT)
X-Gm-Message-State: ACrzQf02zzQU12ZGk9eaN7CsSlRYhT7IEPDlpjzLDjHoRZetbsWQHb3O
        q0vNRENBnu7F3+K2FMdA+lYe1o09B8d9An3fhA==
X-Google-Smtp-Source: AMsMyM6cV6HG80bHtUqnkMS+FDPOKphyXe4bLYl971eCVshhJr4zTcZBzeEWdG5eCe0dGT9yqfT3s/YdKFKkUqsBVrI=
X-Received: by 2002:a67:3c7:0:b0:39b:45c2:6875 with SMTP id
 190-20020a6703c7000000b0039b45c26875mr13161363vsd.6.1664368347626; Wed, 28
 Sep 2022 05:32:27 -0700 (PDT)
MIME-Version: 1.0
References: <20220811022304.583300-1-kuba@kernel.org> <20220811022304.583300-3-kuba@kernel.org>
 <20220926161056.GA2002659-robh@kernel.org> <20220927145622.4e3339a4@kernel.org>
In-Reply-To: <20220927145622.4e3339a4@kernel.org>
From:   Rob Herring <robh@kernel.org>
Date:   Wed, 28 Sep 2022 07:32:16 -0500
X-Gmail-Original-Message-ID: <CAL_JsqJTg58HGJG6QbdNmHuUVK8EoEtzbQkMQOiprw01ryv83g@mail.gmail.com>
Message-ID: <CAL_JsqJTg58HGJG6QbdNmHuUVK8EoEtzbQkMQOiprw01ryv83g@mail.gmail.com>
Subject: Re: [RFC net-next 2/4] ynl: add the schema for the schemas
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        pabeni@redhat.com, sdf@google.com, jacob.e.keller@intel.com,
        vadfed@fb.com, johannes@sipsolutions.net, jiri@resnulli.us,
        dsahern@kernel.org, stephen@networkplumber.org, fw@strlen.de,
        linux-doc@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 27, 2022 at 4:56 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Mon, 26 Sep 2022 11:10:56 -0500 Rob Herring wrote:
> > On Wed, Aug 10, 2022 at 07:23:02PM -0700, Jakub Kicinski wrote:
> > > A schema in jsonschema format which should be familiar
> > > to dt-bindings writers. It looks kinda hard to read, TBH,
> > > I'm not sure how to make it better.

[...]

> > > +    description: Description of the family
> > > +    type: string
> > > +  version:
> > > +    description: Version of the family as defined by genetlink.
> > > +    type: integer
> >
> > Do you have the need to define the int size? We did our own keyword for
> > this, but since then I've looked at several other projects that have
> > used something like 'format: uint32'. There was some chatter about
> > trying to standardize this, but I haven't checked in a while.
>
> It's 8 bits in theory (struct genlmsghdr::version), in practice it's
> never used, and pretty much ignored. The jsonschema I have on Fedora
> does not know about uint8.

It wouldn't. It's some users of jsonschema that have added their own
thing. With python-jsonschema, you can add your own FormatChecker
class to handle custom 'format' entries.


> > > +  attr-cnt-suffix:
> > > +    description: Suffix for last member of attribute enum, default is "MAX".
> > > +    type: string
> > > +  headers:
> > > +    description: C headers defining the protocol
> > > +    type: object
> > > +    additionalProperties: False
> > > +    properties:
> > > +      uapi:
> > > +        description: Path under include/uapi where protocol definition is placed
> > > +        type: string
> > > +      kernel:
> > > +        description: Additional headers on which the protocol definition depends (kernel side)
> > > +        anyOf: &str-or-arrstr
> > > +          -
> > > +            type: array
> > > +            items:
> > > +              type: string
> > > +          -
> > > +            type: string
> > > +      user:
> > > +        description: Additional headers on which the protocol definition depends (user side)
> > > +        anyOf: *str-or-arrstr
> >
> > For DT, we stick to a JSON compatible subset of YAML, so no anchors. The
> > jsonschema way to do this is using '$defs' (or 'definitions' before the
> > spec standardized it) and '$ref'.
>
> I need to read up on this. Is it possible to extend a type?
> We really need a way to define a narrow set of properties for "going
> forward" while the old families have extra quirks. I couldn't find any
> jsonschema docs on how the inherit and extend.

You can add constraints, but you can't override what you inherit.

You do that with a $ref (and unevaluatedProperties if adding
properties) to the base schema and then add more schema constraints.
For example, we define something as an array with a $ref and then add
the bounds to it. That can also be done by 2 schemas applied
independently. However, if it's constraining properties present in an
object, then that can't be independent (that's where
unevaluatedProperties comes into play).

Rob
