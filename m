Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA215674BD9
	for <lists+netdev@lfdr.de>; Fri, 20 Jan 2023 06:11:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231279AbjATFLU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Jan 2023 00:11:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230455AbjATFK5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Jan 2023 00:10:57 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6B76BF895;
        Thu, 19 Jan 2023 20:59:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8F3FAB8276E;
        Thu, 19 Jan 2023 23:02:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25B15C433F2;
        Thu, 19 Jan 2023 23:02:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674169338;
        bh=zAeCxgJp6CHkFtBJbMXTYY9UHGAlFauWe5Vz7iwtS2Q=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=ibAIFPtIrLecpTzrYX+dWTffkqfYBt9m6J6U4RwfOXf2zrBwu5NL1KHUJp3hbmvl6
         Zy751fxQLKeY2Dg/uEYWwF6vJWGcB3PSndH7H8B8JwV9vGcaVAtTErKRKxj4qugMCh
         NGbXcJLNmDlndbYCHUcNr8o90Hp8YsK8D2OHIMHQ5vkGeB5g5k4P+VS6okOKS0/e8L
         3e6ZodIvZ70ruOmJlTXp0zT3n8FtNNlcxUcWD93lv/7qrzS/VzuuLlUzE1kE9GDqb+
         jheCBoilFV3ohhJcIsB4nLXk/LBDyH9V2Um9TVoAU3zaJJPeyYSEV1nkeDSFWz7Xr6
         qrxJFoI9S1Ywg==
Received: by mail-vk1-f173.google.com with SMTP id v81so1730670vkv.5;
        Thu, 19 Jan 2023 15:02:18 -0800 (PST)
X-Gm-Message-State: AFqh2kpZN2sGFM1lGyx9ghvd+57XMBagQkov3t2Vk6CRXwZlpPa9INkh
        18RMRhbrOggggsh+emVRq2GJrAmNtcspUR3QCg==
X-Google-Smtp-Source: AMrXdXsG99tPvEHV5aCUuw0mR/bhT8/DAp2LNwREx+popn9Mxb1fPwFw16qdDUVsIULN0+2sfi3gOhp9scpEPwEz6v8=
X-Received: by 2002:a1f:ad56:0:b0:3bc:8497:27fd with SMTP id
 w83-20020a1fad56000000b003bc849727fdmr1636148vke.15.1674169336954; Thu, 19
 Jan 2023 15:02:16 -0800 (PST)
MIME-Version: 1.0
References: <20230119003613.111778-1-kuba@kernel.org> <20230119003613.111778-3-kuba@kernel.org>
 <CAL_JsqKk5RT6PmRSrq=YK7AvzCbcVkxasykJqe1df=3g-=kD7A@mail.gmail.com> <20230119134922.3fa24ed2@kernel.org>
In-Reply-To: <20230119134922.3fa24ed2@kernel.org>
From:   Rob Herring <robh@kernel.org>
Date:   Thu, 19 Jan 2023 17:02:05 -0600
X-Gmail-Original-Message-ID: <CAL_Jsq+_m0gn1vpAdxpcgwF4-wDtpK6wCwXgmE9pdPCJo5KTdw@mail.gmail.com>
Message-ID: <CAL_Jsq+_m0gn1vpAdxpcgwF4-wDtpK6wCwXgmE9pdPCJo5KTdw@mail.gmail.com>
Subject: Re: [PATCH net-next v3 2/8] netlink: add schemas for YAML specs
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, johannes@sipsolutions.net,
        stephen@networkplumber.org, ecree.xilinx@gmail.com, sdf@google.com,
        f.fainelli@gmail.com, fw@strlen.de, linux-doc@vger.kernel.org,
        razor@blackwall.org, nicolas.dichtel@6wind.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 19, 2023 at 3:49 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Thu, 19 Jan 2023 08:07:31 -0600 Rob Herring wrote:
> > On Wed, Jan 18, 2023 at 6:36 PM Jakub Kicinski <kuba@kernel.org> wrote:
> > >
> > > Add schemas for Netlink spec files. As described in the docs
> > > we have 4 "protocols" or compatibility levels, and each one
> > > comes with its own schema, but the more general / legacy
> > > schemas are superset of more modern ones: genetlink is
> > > the smallest followed by genetlink-c and genetlink-legacy.
> > > There is no schema for raw netlink, yet, I haven't found the time..
> > >
> > > I don't know enough jsonschema to do inheritance or something
> > > but the repetition is not too bad. I hope.
> >
> > Generally you put common schemas under '$defs' and the then reference
> > them with '$ref'.
> >
> > $defs:
> >   some-prop-type:
> >     type: integer
> >     minimum: 0
> >
> > properties:
> >   foo:
> >     $ref: '#/$defs/some-prop-type'
> >   bar:
> >     $ref: '#/$defs/some-prop-type'
>
> Thanks! Is it possible to move the common definitions to a separate
> file? I tried to create a file called defs.yaml and change the ref to:
>
>   $ref: "defs.yaml#/$defs/len-or-define"

Yes, but...

> But:
>
>   File "/usr/lib/python3.11/site-packages/jsonschema/validators.py", line 257, in iter_errors
>     for error in errors:
>   File "/usr/lib/python3.11/site-packages/jsonschema/_validators.py", line 294, in ref
>     scope, resolved = validator.resolver.resolve(ref)
>                       ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
>   File "/usr/lib/python3.11/site-packages/jsonschema/validators.py", line 856, in resolve
>     return url, self._remote_cache(url)
>                 ^^^^^^^^^^^^^^^^^^^^^^^
>   File "/usr/lib/python3.11/site-packages/jsonschema/validators.py", line 870, in resolve_from_url
>     raise exceptions.RefResolutionError(exc)
> jsonschema.exceptions.RefResolutionError: Expecting value: line 1 column 1 (char 0)

You either need the ref at the URL or a custom resolver to convert
http path to a file path. Also, the default resolver doesn't handle
YAML either. It's not much code to do and the DT tools do this. The
hardest part was just getting the path right. For a ref with just a
filename and no path, the URL will be the same path as the $id in the
referring schema.

> > If you have objects with common sets of properties, you can do the
> > same thing, but then you need 'unevaluatedProperties' if you want to
> > define a base set of properties and add to them. We do that frequently
> > in DT schemas. Unlike typical inheritance, you can't override the
> > 'base' schema. It's an AND operation.
>
> This is hard to comprehend :o Most of the time I seem to need only the
> ability to add a custom "description" to the object, so for example:

By object, schemas here which are 'type: object'. Those all have a
list of properties. If several schemas for 'objects' have the same set
of properties like 'name' and 'type' for example, then you could
define a schema for that and then add more properties for each
specific object. I didn't really look close enough whether that makes
sense here.

> $defs:
>   len-or-define:
>     oneOf:
>       -
>         type: string
>         pattern: ^[0-9A-Za-z_-]*( - 1)?$
>       -
>         type: integer
>         minimum: 0
>
> Then:
>
>        min-len:
>          description: Min length for a binary attribute.
>          $ref: '#/$defs/len-or-define'
>
> And that seems to work. Should I be using unevaluatedProperties somehow
> as well here?

No, it looks fine. 'unevaluatedProperties' wouldn't make sense here as
'type' is a string or integer.

>
> > > +          description: |
> > > +            Name used when referring to this space in other definitions, not used outside of YAML.
> > > +          type: string
> > > +        # Strictly speaking 'name-prefix' and 'subset-of' should be mutually exclusive.
> >
> > If one is required:
> >
> > oneOf:
> >   - required: [ name-prefix ]
> >   - required: [ subset-of ]
> >
> > Or if both are optional:
> >
> > dependencies:
> >   name-prefix:
> >     not:
> >       required: [ subset-of ]
> >   subset-of:
> >     not:
> >       required: [ name-prefix ]
>
> Nice, let me try this.
>
> > > +                  min-len:
> > > +                    description: Min length for a binary attribute.
> > > +                    oneOf:
> > > +                      - type: string
> > > +                        pattern: ^[0-9A-Za-z_-]*( - 1)?$
> > > +                      - type: integer
> >
> > How can a length be a string?
>
> For readability in C I wanted to allow using a define for the length.
> Then the name of the define goes here, and the value can be fetched
> from the "definitions" section of the spec.

Ah, makes sense.

Don't you need to drop the '-' in the regex then? Also, the '*' should
be a '+' for 1 or more instead of 0 or more.

> > Anyways, this is something you could pull out into a $defs entry and
> > reference. It will also work without the oneOf because 'pattern' will
> > just be ignored for an integer. That's one gotcha with json-schema. If
> > a keyword doesn't apply to the instance, it is silently ignored. (That
> > includes unknown keywords such as ones with typos. Fun!). 'oneOf' will
> > give you pretty crappy error messages, so it's good to avoid when
> > possible.
>
> Oh, interesting. Changed to:
>
> $defs:
>   len-or-define:
>     type: [ string, integer ]
>     pattern: ^[0-9A-Za-z_-]*( - 1)?$
>     minimum: 0
