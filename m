Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4FD775EAD99
	for <lists+netdev@lfdr.de>; Mon, 26 Sep 2022 19:06:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230173AbiIZRGp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Sep 2022 13:06:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229812AbiIZRG1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Sep 2022 13:06:27 -0400
Received: from mail-oi1-f176.google.com (mail-oi1-f176.google.com [209.85.167.176])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACFDC5757C;
        Mon, 26 Sep 2022 09:10:58 -0700 (PDT)
Received: by mail-oi1-f176.google.com with SMTP id n83so8793366oif.11;
        Mon, 26 Sep 2022 09:10:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=EnxGpPNSu9tkRW91egZi/JyRBJEVMjafDP7wp2vUUJg=;
        b=2sWKyfTMnFBu77l7jcpA4XBhpoUbpS9EbiUSLfjWXvASRNkEzNmLVM3oim0S6FMAxu
         IEZ85C7f182OtpupjCdZGUYYQsRjf0BMpxAip8cjuOsC1PXzfE1Kn7rqYF0Am+VKdE4d
         poaKDdO1IGwTbf3zrjDJXcFJsPZ0+XsUDE0DHjC+uNAXHp/b69IsN6i1gYAhg2U1WQed
         K0X4kcTBnBnLLHxfqa9gG/gltx3AxwQWfVrJwTZtiUIZQ8eGGFGzqnyGxfnVH3t474SO
         q0g8ZQPLwVFSQfZjrgESfVxCTs7f6a8ugKDUu19n9hK2Uypcy96ZkCX9R1aWcx30unsL
         UYVw==
X-Gm-Message-State: ACrzQf2vjBb6jJhRCpU9Ho+tZ3BBN0JiprkrcGoemi9jPONgjxEywGF2
        CUO/LsrVWySgyFJvX306wA==
X-Google-Smtp-Source: AMsMyM7NfWKMkOVO+VVgVFP1qw8jgussZbCmQjL2fU6ahxMuW012gWRlYXSUT+SY6Ab3Rfic439fLQ==
X-Received: by 2002:a05:6808:13cf:b0:34f:f317:df4e with SMTP id d15-20020a05680813cf00b0034ff317df4emr15599550oiw.124.1664208657892;
        Mon, 26 Sep 2022 09:10:57 -0700 (PDT)
Received: from robh.at.kernel.org (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id o10-20020a056871078a00b0012b2b0b6281sm8985547oap.9.2022.09.26.09.10.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Sep 2022 09:10:57 -0700 (PDT)
Received: (nullmailer pid 2123602 invoked by uid 1000);
        Mon, 26 Sep 2022 16:10:56 -0000
Date:   Mon, 26 Sep 2022 11:10:56 -0500
From:   Rob Herring <robh@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        pabeni@redhat.com, sdf@google.com, jacob.e.keller@intel.com,
        vadfed@fb.com, johannes@sipsolutions.net, jiri@resnulli.us,
        dsahern@kernel.org, stephen@networkplumber.org, fw@strlen.de,
        linux-doc@vger.kernel.org
Subject: Re: [RFC net-next 2/4] ynl: add the schema for the schemas
Message-ID: <20220926161056.GA2002659-robh@kernel.org>
References: <20220811022304.583300-1-kuba@kernel.org>
 <20220811022304.583300-3-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220811022304.583300-3-kuba@kernel.org>
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 10, 2022 at 07:23:02PM -0700, Jakub Kicinski wrote:
> A schema in jsonschema format which should be familiar
> to dt-bindings writers. It looks kinda hard to read, TBH,
> I'm not sure how to make it better.

This got my attention in the Plumbers agenda though I missed the talk. 
It's nice to see another jsonschema user in the kernel. I hope you make 
jsonschema a dependency for everyone before I do. :) Hopefully we don't 
hit any comflict in required version of jsonschema as I've needed both a 
minimum version for features as well as been broken by new versions.

I would avoid calling all this 'YAML netlink' as YAML is just the file 
format you are using. We started with calling things YAML, but I nudge 
folks away from that to 'DT schema'. Also, probably not an issue here, 
but be aware that YAML is much slower to parse than JSON. 

> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
>  Documentation/netlink/schema.yaml | 242 ++++++++++++++++++++++++++++++
>  1 file changed, 242 insertions(+)
>  create mode 100644 Documentation/netlink/schema.yaml
> 
> diff --git a/Documentation/netlink/schema.yaml b/Documentation/netlink/schema.yaml
> new file mode 100644
> index 000000000000..1290aa4794ba
> --- /dev/null
> +++ b/Documentation/netlink/schema.yaml
> @@ -0,0 +1,242 @@
> +# SPDX-License-Identifier: GPL-2.0
> +%YAML 1.2
> +---
> +$id: "http://kernel.org/schemas/netlink/schema.yaml#"
> +$schema: "http://kernel.org/meta-schemas/core.yaml#"

In case there's ever another one: meta-schemas/netlink/core.yaml

Or something similar.

> +
> +title: Protocol
> +description: Specification of a genetlink protocol
> +type: object
> +required: [ name, description, attribute-spaces, operations ]
> +additionalProperties: False
> +properties:
> +  name:
> +    description: Name of the genetlink family
> +    type: string
> +  description:

It's better if your schema vocabulary is disjoint from jsonschema 
vocabulary. From what I've seen, it's fairly common to get the 
indentation off and jsonschema behavior is to ignore unknown keywords. 
If the vocabularies are disjoint, you can write a meta-schema that only 
allows jsonschema schema vocabulary at the right levels. Probably less 
of an issue here as you don't have 1000s of schemas.

> +    description: Description of the family
> +    type: string
> +  version:
> +    description: Version of the family as defined by genetlink.
> +    type: integer

Do you have the need to define the int size? We did our own keyword for 
this, but since then I've looked at several other projects that have 
used something like 'format: uint32'. There was some chatter about 
trying to standardize this, but I haven't checked in a while.

> +  attr-cnt-suffix:
> +    description: Suffix for last member of attribute enum, default is "MAX".
> +    type: string
> +  headers:
> +    description: C headers defining the protocol
> +    type: object
> +    additionalProperties: False
> +    properties:
> +      uapi:
> +        description: Path under include/uapi where protocol definition is placed
> +        type: string
> +      kernel:
> +        description: Additional headers on which the protocol definition depends (kernel side)
> +        anyOf: &str-or-arrstr
> +          -
> +            type: array
> +            items:
> +              type: string
> +          -
> +            type: string
> +      user:
> +        description: Additional headers on which the protocol definition depends (user side)
> +        anyOf: *str-or-arrstr

For DT, we stick to a JSON compatible subset of YAML, so no anchors. The 
jsonschema way to do this is using '$defs' (or 'definitions' before the 
spec standardized it) and '$ref'.

> +  constants:
> +    description: Enums and defines of the protocol
> +    type: array
> +    items:
> +      type: object
> +      required: [ type, name ]
> +      additionalProperties: False
> +      properties:
> +        name:
> +          type: string
> +        type:
> +          enum: [ enum, flags ]
> +        value-prefix:
> +          description: For enum the prefix of the values, optional.
> +          type: string
> +        value-start:
> +          description: For enum the literal initializer for the first value.
> +          oneOf: [ { type: string }, { type: integer }]

I think you can do just 'type: [ string, integer ]'.

Rob
