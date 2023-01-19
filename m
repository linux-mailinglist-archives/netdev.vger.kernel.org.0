Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B6E7E674BCA
	for <lists+netdev@lfdr.de>; Fri, 20 Jan 2023 06:08:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231177AbjATFIO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Jan 2023 00:08:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230458AbjATFHu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Jan 2023 00:07:50 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9426F7DF83;
        Thu, 19 Jan 2023 20:54:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0BF45B82467;
        Thu, 19 Jan 2023 14:07:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9CEBC4339B;
        Thu, 19 Jan 2023 14:07:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674137265;
        bh=V6D1Whq/133RJweFtsglTPssFvXVcRwUueRw5yX1e1E=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=N76cApJBOCg4Ozy2pWetDMwgnjcm6bfS0yChGipJ5cNP3LYIBUHOFnkL4kVvWV2rs
         y0Fldofzq7rs4vu2W+krLrDdZCOH8DIUJlHQtEnEchsNTfL36Sx9pgekmK3ZiJhKSF
         LcZ7ROHz6jv5GbdWkjts0S5NV97uGCDWdW44N6XKupNRikTBh8afIVIgP0FDVCcR9P
         HHFCrDRWJK1+/wcpQpH+oxpyoy4k7F2umwKcmXsaGWTysf3+bF1kiLx5t4GYz8w6RZ
         ckkgkRVxrw6EtwMRCTPJEOg+lKSamel+Z54++knPmAmLNt76kyOu3MGOzVn39TZhbR
         Kpgizbtfg5JDw==
Received: by mail-vs1-f54.google.com with SMTP id l125so2265842vsc.2;
        Thu, 19 Jan 2023 06:07:45 -0800 (PST)
X-Gm-Message-State: AFqh2kqcpizL1WOrnNcT8TvzajSYmZhq0ntTbnyJnil+43cl06C6NVAc
        XjFKjpi6oyNyMtuZC3MljMKYoNR92l65+Uodyw==
X-Google-Smtp-Source: AMrXdXvqbcIdbsMzCI05ip3J+eiziZeU8xc1us3omMXeQO8UDC7EBK8dggKEeW28pmCRL4bXw3ORRjFLf+P042gmv7g=
X-Received: by 2002:a67:f506:0:b0:3d3:c767:4570 with SMTP id
 u6-20020a67f506000000b003d3c7674570mr1656447vsn.85.1674137263974; Thu, 19 Jan
 2023 06:07:43 -0800 (PST)
MIME-Version: 1.0
References: <20230119003613.111778-1-kuba@kernel.org> <20230119003613.111778-3-kuba@kernel.org>
In-Reply-To: <20230119003613.111778-3-kuba@kernel.org>
From:   Rob Herring <robh@kernel.org>
Date:   Thu, 19 Jan 2023 08:07:31 -0600
X-Gmail-Original-Message-ID: <CAL_JsqKk5RT6PmRSrq=YK7AvzCbcVkxasykJqe1df=3g-=kD7A@mail.gmail.com>
Message-ID: <CAL_JsqKk5RT6PmRSrq=YK7AvzCbcVkxasykJqe1df=3g-=kD7A@mail.gmail.com>
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

On Wed, Jan 18, 2023 at 6:36 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> Add schemas for Netlink spec files. As described in the docs
> we have 4 "protocols" or compatibility levels, and each one
> comes with its own schema, but the more general / legacy
> schemas are superset of more modern ones: genetlink is
> the smallest followed by genetlink-c and genetlink-legacy.
> There is no schema for raw netlink, yet, I haven't found the time..
>
> I don't know enough jsonschema to do inheritance or something
> but the repetition is not too bad. I hope.

Generally you put common schemas under '$defs' and the then reference
them with '$ref'.

$defs:
  some-prop-type:
    type: integer
    minimum: 0

properties:
  foo:
    $ref: '#/$defs/some-prop-type'
  bar:
    $ref: '#/$defs/some-prop-type'

If you have objects with common sets of properties, you can do the
same thing, but then you need 'unevaluatedProperties' if you want to
define a base set of properties and add to them. We do that frequently
in DT schemas. Unlike typical inheritance, you can't override the
'base' schema. It's an AND operation.

> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
>  Documentation/netlink/genetlink-c.yaml      | 318 ++++++++++++++++++
>  Documentation/netlink/genetlink-legacy.yaml | 346 ++++++++++++++++++++
>  Documentation/netlink/genetlink.yaml        | 284 ++++++++++++++++
>  3 files changed, 948 insertions(+)
>  create mode 100644 Documentation/netlink/genetlink-c.yaml
>  create mode 100644 Documentation/netlink/genetlink-legacy.yaml
>  create mode 100644 Documentation/netlink/genetlink.yaml
>
> diff --git a/Documentation/netlink/genetlink-c.yaml b/Documentation/netlink/genetlink-c.yaml
> new file mode 100644
> index 000000000000..53a7fe94a47e
> --- /dev/null
> +++ b/Documentation/netlink/genetlink-c.yaml
> @@ -0,0 +1,318 @@
> +# SPDX-License-Identifier: GPL-2.0
> +%YAML 1.2
> +---
> +$id: "http://kernel.org/schemas/netlink/genetlink-c.yaml#"
> +$schema: "http://kernel.org/meta-schemas/netlink/core.yaml#"

There's no core.yaml. If you don't have a custom meta-schema, then
just set this to the schema for the json-schema version you are using.
Then the tools can validate the schemas without your own validator
class.

Also, you can drop quotes on these.

> +
> +title: Protocol
> +description: Specification of a genetlink protocol
> +type: object
> +required: [ name, doc, attribute-sets, operations ]
> +additionalProperties: False
> +properties:
> +  name:
> +    description: Name of the genetlink family.
> +    type: string
> +  doc:
> +    type: string
> +  version:
> +    description: Generic Netlink family version. Default is 1.
> +    type: integer

Constraints?

minimum: 0

Same on all other integers.

> +  protocol:
> +    description: Schema compatibility level. Default is "genetlink".
> +    enum: [ genetlink, genetlink-c]
> +  # Start genetlink-c
> +  uapi-header:
> +    description: Path to the uAPI header, default is linux/${family-name}.h
> +    type: string
> +  c-family-name:
> +    description: Name of the define for the family name.
> +    type: string
> +  c-version-name:
> +    description: Name of the define for the verion of the family.

typo

> +    type: string
> +  max-by-define:
> +    description: Makes the number of attributes and commands be specified by a define, not an enum value.
> +    type: boolean
> +  # End genetlink-c
> +
> +  definitions:
> +    description: Array of type and constant definitions.
> +    type: array
> +    items:
> +      type: object
> +      required: [ type, name ]
> +      additionalProperties: False
> +      properties:
> +        name:
> +          type: string
> +        header:
> +          description: For C-compatible languages, header which already defines this value.
> +          type: string
> +        type:
> +          enum: [ const, enum, flags ]
> +        doc:
> +          type: string
> +        # For const
> +        value:
> +          description: For const - the value.
> +          type: [ string, integer ]
> +        # For enum and flags
> +        value-start:
> +          description: For enum or flags the literal initializer for the first value.
> +          type: [ string, integer ]
> +        entries:
> +          description: For enum or flags array of values
> +          type: array
> +          items:
> +            oneOf:
> +              - type: string
> +              - type: object
> +                required: [ name ]
> +                additionalProperties: False
> +                properties:
> +                  name:
> +                    type: string
> +                  value:
> +                    type: integer
> +                  doc:
> +                    type: string
> +        render-max:
> +          description: Render the max members for this enum.
> +          type: boolean
> +        # Start genetlink-c
> +        enum-name:
> +          description: Name for enum, if empty no name will be used.
> +          type: [ string, "null" ]
> +        name-prefix:
> +          description: For enum the prefix of the values, optional.
> +          type: string
> +        # End genetlink-c
> +
> +  attribute-sets:
> +    description: Definition of attribute spaces for this family.
> +    type: array
> +    items:
> +      description: Definition of a single attribute space.
> +      type: object
> +      required: [ name, attributes ]
> +      additionalProperties: False
> +      properties:
> +        name:
> +          description: |
> +            Name used when referring to this space in other definitions, not used outside of YAML.
> +          type: string
> +        # Strictly speaking 'name-prefix' and 'subset-of' should be mutually exclusive.

If one is required:

oneOf:
  - required: [ name-prefix ]
  - required: [ subset-of ]

Or if both are optional:

dependencies:
  name-prefix:
    not:
      required: [ subset-of ]
  subset-of:
    not:
      required: [ name-prefix ]


> +        name-prefix:
> +          description: |
> +            Prefix for the C enum name of the attributes. Default family[name]-set[name]-a-
> +          type: string
> +        enum-name:
> +          description: Name for the enum type of the attribute.
> +          type: string
> +        doc:
> +          description: Documentation of the space.
> +          type: string
> +        subset-of:
> +          description: |
> +            Name of another space which this is a logical part of. Sub-spaces can be used to define
> +            a limited group of attributes which are used in a nest.
> +          type: string
> +        # Start genetlink-c
> +        attr-cnt-name:
> +          description: The explicit name for constant holding the count of attributes (last attr + 1).
> +          type: string
> +        attr-max-name:
> +          description: The explicit name for last member of attribute enum.
> +          type: string
> +        # End genetlink-c
> +        attributes:
> +          description: List of attributes in the space.
> +          type: array
> +          items:
> +            type: object
> +            required: [ name, type ]
> +            additionalProperties: False
> +            properties:
> +              name:
> +                type: string
> +              type: &attr-type
> +                enum: [ unused, pad, flag, binary, u8, u16, u32, u64, s32, s64,
> +                        string, nest, array-nest, nest-type-value ]
> +              doc:
> +                description: Documentation of the attribute.
> +                type: string
> +              value:
> +                description: Value for the enum item representing this attribute in the uAPI.
> +                type: integer
> +              type-value:
> +                description: Name of the value extracted from the type of a nest-type-value attribute.
> +                type: array
> +                items:
> +                  type: string
> +              byte-order:
> +                enum: [little-endian, big-endian]
> +              multi-attr:
> +                type: boolean
> +              nested-attributes:
> +                description: Name of the space (sub-space) used inside the attribute.
> +                type: string
> +              enum:
> +                description: Name of the enum type used for the atttribute.

typo

> +                type: string
> +              enum-as-flags:
> +                description: |
> +                  Treat the enum as flags. In most cases enum is either used as flags or as values.
> +                  Sometimes, however, both forms are necessary, in which case header contains the enum
> +                  form while specific attributes may request to convert the values into a bitfield.
> +                type: boolean
> +              checks:
> +                description: Kernel input validation.
> +                type: object
> +                additionalProperties: False
> +                properties:
> +                  flags-mask:
> +                    description: Name of the flags constant on which to base mask (unsigned scalar types only).
> +                    type: string
> +                  min:
> +                    description: Min value for an integer attribute.
> +                    type: integer
> +                  min-len:
> +                    description: Min length for a binary attribute.
> +                    oneOf:
> +                      - type: string
> +                        pattern: ^[0-9A-Za-z_-]*( - 1)?$
> +                      - type: integer

How can a length be a string?

Anyways, this is something you could pull out into a $defs entry and
reference. It will also work without the oneOf because 'pattern' will
just be ignored for an integer. That's one gotcha with json-schema. If
a keyword doesn't apply to the instance, it is silently ignored. (That
includes unknown keywords such as ones with typos. Fun!). 'oneOf' will
give you pretty crappy error messages, so it's good to avoid when
possible.

> +                  max-len:
> +                    description: Max length for a string or a binary attribute.
> +                    oneOf:
> +                      - type: string
> +                        pattern: ^[0-9A-Za-z_-]*( - 1)?$
> +                      - type: integer
> +              sub-type: *attr-type
> +  operations:
> +    description: Operations supported by the protocol.
> +    type: object
> +    required: [ list ]
> +    additionalProperties: False
> +    properties:
> +      enum-model:
> +        description: |
> +          The model of assigning values to the operations.
> +          "unified" is the recommended model where all message types belong
> +          to a single enum.
> +          "directional" has the messages sent to the kernel and from the kernel
> +          enumerated separately.
> +          "notify-split" has the notifications and request-response types in
> +          different enums.
> +        enum: [ unified, directional, notify-split ]
> +      name-prefix:
> +        description: |
> +          Prefix for the C enum name of the command. The name is formed by concatenating
> +          the prefix with the upper case name of the command, with dashes replaced by underscores.
> +        type: string
> +      enum-name:
> +        description: Name for the enum type with commands.
> +        type: string
> +      async-prefix:
> +        description: Same as name-prefix but used to render notifications and events to separate enum.
> +        type: string
> +      async-enum:
> +        description: Name for the enum type with notifications/events.
> +        type: string
> +      list:
> +        description: List of commands
> +        type: array
> +        items:
> +          type: object
> +          additionalProperties: False
> +          required: [ name, doc ]
> +          properties:
> +            name:
> +              description: Name of the operation, also defining its C enum value in uAPI.
> +              type: string
> +            doc:
> +              description: Documentation for the command.
> +              type: string
> +            value:
> +              description: Value for the enum in the uAPI.
> +              type: integer
> +            attribute-set:
> +              description: |
> +                Attribute space from which attributes directly in the requests and replies
> +                to this command are defined.
> +              type: string
> +            flags: &cmd_flags
> +              description: Command flags.
> +              type: array
> +              items:
> +                enum: [ admin-perm ]
> +            dont-validate:
> +              description: Kernel attribute validation flags.
> +              type: array
> +              items:
> +                enum: [ strict, dump ]
> +            do: &subop-type
> +              description: Main command handler.
> +              type: object
> +              additionalProperties: False
> +              properties:
> +                request: &subop-attr-list
> +                  description: Definition of the request message for a given command.
> +                  type: object
> +                  additionalProperties: False
> +                  properties:
> +                    attributes:
> +                      description: |
> +                        Names of attributes from the attribute-set (not full attribute
> +                        definitions, just names).
> +                      type: array
> +                      items:
> +                        type: string
> +                reply: *subop-attr-list
> +                pre:
> +                  description: Hook for a function to run before the main callback (pre_doit or start).
> +                  type: string
> +                post:
> +                  description: Hook for a function to run after the main callback (post_doit or done).
> +                  type: string
> +            dump: *subop-type
> +            notify:
> +              description: Name of the command sharing the reply type with this notification.
> +              type: string
> +            event:
> +              type: object
> +              additionalProperties: False
> +              properties:
> +                attributes:
> +                  description: Explicit list of the attributes for the notification.
> +                  type: array
> +                  items:
> +                    type: string
> +            mcgrp:
> +              description: Name of the multicast group generating given notification.
> +              type: string
> +  mcast-groups:
> +    description: List of multicast groups.
> +    type: object
> +    required: [ list ]
> +    additionalProperties: False
> +    properties:
> +      list:
> +        description: List of groups.
> +        type: array
> +        items:
> +          type: object
> +          required: [ name ]
> +          additionalProperties: False
> +          properties:
> +            name:
> +              description: |
> +                The name for the group, used to form the define and the value of the define.
> +              type: string
> +            # Start genetlink-c
> +            c-define-name:
> +              description: Override for the name of the define in C uAPI.
> +              type: string
> +            # End genetlink-c
> +            flags: *cmd_flags
> diff --git a/Documentation/netlink/genetlink-legacy.yaml b/Documentation/netlink/genetlink-legacy.yaml
> new file mode 100644
> index 000000000000..5e57453eac1a
> --- /dev/null
> +++ b/Documentation/netlink/genetlink-legacy.yaml
> @@ -0,0 +1,346 @@
> +# SPDX-License-Identifier: GPL-2.0
> +%YAML 1.2
> +---
> +$id: "http://kernel.org/schemas/netlink/genetlink-legacy.yaml#"
> +$schema: "http://kernel.org/meta-schemas/netlink/core.yaml#"
> +
> +title: Protocol
> +description: Specification of a genetlink protocol
> +type: object
> +required: [ name, doc, attribute-sets, operations ]
> +additionalProperties: False
> +properties:
> +  name:
> +    description: Name of the genetlink family.
> +    type: string
> +  doc:
> +    type: string
> +  version:
> +    description: Generic Netlink family version. Default is 1.
> +    type: integer
> +  protocol:
> +    description: Schema compatibility level. Default is "genetlink".
> +    enum: [ genetlink, genetlink-c, genetlink-legacy, netlink-raw ] # Trim
> +  # Start genetlink-c
> +  uapi-header:
> +    description: Path to the uAPI header, default is linux/${family-name}.h
> +    type: string
> +  c-family-name:
> +    description: Name of the define for the family name.
> +    type: string
> +  c-version-name:
> +    description: Name of the define for the verion of the family.

typo

> +    type: string
> +  max-by-define:
> +    description: Makes the number of attributes and commands be specified by a define, not an enum value.
> +    type: boolean
> +  # End genetlink-c
> +  # Start genetlink-legacy
> +  kernel-policy:
> +    description: |
> +      Defines if the input policy in the kernel is global, per-operation, or split per operation type.
> +      Default is split.
> +    enum: [split, per-op, global]
> +  # End genetlink-legacy
> +
> +  definitions:
> +    description: Array of type and constant definitions.
> +    type: array
> +    items:
> +      type: object
> +      required: [ type, name ]
> +      additionalProperties: False
> +      properties:
> +        name:
> +          type: string
> +        header:
> +          description: For C-compatible languages, header which already defines this value.
> +          type: string
> +        type:
> +          enum: [ const, enum, flags, struct ] # Trim
> +        doc:
> +          type: string
> +        # For const
> +        value:
> +          description: For const - the value.
> +          type: [ string, integer ]
> +        # For enum and flags
> +        value-start:
> +          description: For enum or flags the literal initializer for the first value.
> +          type: [ string, integer ]
> +        entries:
> +          description: For enum or flags array of values
> +          type: array
> +          items:
> +            oneOf:
> +              - type: string
> +              - type: object
> +                required: [ name ]
> +                additionalProperties: False
> +                properties:
> +                  name:
> +                    type: string
> +                  value:
> +                    type: integer
> +                  doc:
> +                    type: string
> +        render-max:
> +          description: Render the max members for this enum.
> +          type: boolean
> +        # Start genetlink-c
> +        enum-name:
> +          description: Name for enum, if empty no name will be used.
> +          type: [ string, "null" ]
> +        name-prefix:
> +          description: For enum the prefix of the values, optional.
> +          type: string
> +        # End genetlink-c
> +        # Start genetlink-legacy
> +        members:
> +          description: List of struct members. Only scalars and strings members allowed.
> +          type: array
> +          items:
> +            type: object
> +            required: [ name, type ]
> +            additionalProperties: False
> +            properties:
> +              name:
> +                type: string
> +              type:
> +                enum: [ u8, u16, u32, u64, s8, s16, s32, s64, string ]
> +              len:
> +                oneOf:
> +                  -
> +                    type: string
> +                    pattern: ^[0-9A-Za-z_-]*( - 1)?$
> +                  -
> +                    type: integer

Inconsistent style, but this is the subschema you can factor out.

> +        # End genetlink-legacy
> +
> +  attribute-sets:
> +    description: Definition of attribute spaces for this family.
> +    type: array
> +    items:
> +      description: Definition of a single attribute space.
> +      type: object
> +      required: [ name, attributes ]
> +      additionalProperties: False
> +      properties:
> +        name:
> +          description: |
> +            Name used when referring to this space in other definitions, not used outside of YAML.
> +          type: string
> +        # Strictly speaking 'name-prefix' and 'subset-of' should be mutually exclusive.
> +        name-prefix:
> +          description: |
> +            Prefix for the C enum name of the attributes. Default family[name]-set[name]-a-
> +          type: string
> +        enum-name:
> +          description: Name for the enum type of the attribute.
> +          type: string
> +        doc:
> +          description: Documentation of the space.
> +          type: string
> +        subset-of:
> +          description: |
> +            Name of another space which this is a logical part of. Sub-spaces can be used to define
> +            a limited group of attributes which are used in a nest.
> +          type: string
> +        # Start genetlink-c
> +        attr-cnt-name:
> +          description: The explicit name for constant holding the count of attributes (last attr + 1).
> +          type: string
> +        attr-max-name:
> +          description: The explicit name for last member of attribute enum.
> +          type: string
> +        # End genetlink-c
> +        attributes:
> +          description: List of attributes in the space.
> +          type: array
> +          items:
> +            type: object
> +            required: [ name, type ]
> +            additionalProperties: False
> +            properties:
> +              name:
> +                type: string
> +              type: &attr-type
> +                enum: [ unused, pad, flag, binary, u8, u16, u32, u64, s32, s64,
> +                        string, nest, array-nest, nest-type-value ]
> +              doc:
> +                description: Documentation of the attribute.
> +                type: string
> +              value:
> +                description: Value for the enum item representing this attribute in the uAPI.
> +                type: integer
> +              type-value:
> +                description: Name of the value extracted from the type of a nest-type-value attribute.
> +                type: array
> +                items:
> +                  type: string
> +              byte-order:
> +                enum: [little-endian, big-endian]
> +              multi-attr:
> +                type: boolean
> +              nested-attributes:
> +                description: Name of the space (sub-space) used inside the attribute.
> +                type: string
> +              enum:
> +                description: Name of the enum type used for the atttribute.
> +                type: string
> +              enum-as-flags:
> +                description: |
> +                  Treat the enum as flags. In most cases enum is either used as flags or as values.
> +                  Sometimes, however, both forms are necessary, in which case header contains the enum
> +                  form while specific attributes may request to convert the values into a bitfield.
> +                type: boolean
> +              checks:
> +                description: Kernel input validation.
> +                type: object
> +                additionalProperties: False
> +                properties:
> +                  flags-mask:
> +                    description: Name of the flags constant on which to base mask (unsigned scalar types only).
> +                    type: string
> +                  min:
> +                    description: Min value for an integer attribute.
> +                    type: integer
> +                  min-len:
> +                    description: Min length for a binary attribute.
> +                    oneOf:
> +                      - type: string
> +                        pattern: ^[0-9A-Za-z_-]*( - 1)?$
> +                      - type: integer
> +                  max-len:
> +                    description: Max length for a string or a binary attribute.
> +                    oneOf:
> +                      - type: string
> +                        pattern: ^[0-9A-Za-z_-]*( - 1)?$
> +                      - type: integer
> +              sub-type: *attr-type
> +  operations:
> +    description: Operations supported by the protocol.
> +    type: object
> +    required: [ list ]
> +    additionalProperties: False
> +    properties:
> +      enum-model:
> +        description: |
> +          The model of assigning values to the operations.
> +          "unified" is the recommended model where all message types belong
> +          to a single enum.
> +          "directional" has the messages sent to the kernel and from the kernel
> +          enumerated separately.
> +          "notify-split" has the notifications and request-response types in
> +          different enums.
> +        enum: [ unified, directional, notify-split ]
> +      name-prefix:
> +        description: |
> +          Prefix for the C enum name of the command. The name is formed by concatenating
> +          the prefix with the upper case name of the command, with dashes replaced by underscores.
> +        type: string
> +      enum-name:
> +        description: Name for the enum type with commands.
> +        type: string
> +      async-prefix:
> +        description: Same as name-prefix but used to render notifications and events to separate enum.
> +        type: string
> +      async-enum:
> +        description: Name for the enum type with notifications/events.
> +        type: string
> +      list:
> +        description: List of commands
> +        type: array
> +        items:
> +          type: object
> +          additionalProperties: False
> +          required: [ name, doc ]
> +          properties:
> +            name:
> +              description: Name of the operation, also defining its C enum value in uAPI.
> +              type: string
> +            doc:
> +              description: Documentation for the command.
> +              type: string
> +            value:
> +              description: Value for the enum in the uAPI.
> +              type: integer
> +            attribute-set:
> +              description: |
> +                Attribute space from which attributes directly in the requests and replies
> +                to this command are defined.
> +              type: string
> +            flags: &cmd_flags
> +              description: Command flags.
> +              type: array
> +              items:
> +                enum: [ admin-perm ]
> +            dont-validate:
> +              description: Kernel attribute validation flags.
> +              type: array
> +              items:
> +                enum: [ strict, dump ]
> +            do: &subop-type
> +              description: Main command handler.
> +              type: object
> +              additionalProperties: False
> +              properties:
> +                request: &subop-attr-list
> +                  description: Definition of the request message for a given command.
> +                  type: object
> +                  additionalProperties: False
> +                  properties:
> +                    attributes:
> +                      description: |
> +                        Names of attributes from the attribute-set (not full attribute
> +                        definitions, just names).
> +                      type: array
> +                      items:
> +                        type: string
> +                reply: *subop-attr-list
> +                pre:
> +                  description: Hook for a function to run before the main callback (pre_doit or start).
> +                  type: string
> +                post:
> +                  description: Hook for a function to run after the main callback (post_doit or done).
> +                  type: string
> +            dump: *subop-type
> +            notify:
> +              description: Name of the command sharing the reply type with this notification.
> +              type: string
> +            event:
> +              type: object
> +              additionalProperties: False
> +              properties:
> +                attributes:
> +                  description: Explicit list of the attributes for the notification.
> +                  type: array
> +                  items:
> +                    type: string
> +            mcgrp:
> +              description: Name of the multicast group generating given notification.
> +              type: string
> +  mcast-groups:
> +    description: List of multicast groups.
> +    type: object
> +    required: [ list ]
> +    additionalProperties: False
> +    properties:
> +      list:
> +        description: List of groups.
> +        type: array
> +        items:
> +          type: object
> +          required: [ name ]
> +          additionalProperties: False
> +          properties:
> +            name:
> +              description: |
> +                The name for the group, used to form the define and the value of the define.
> +              type: string
> +            # Start genetlink-c
> +            c-define-name:
> +              description: Override for the name of the define in C uAPI.
> +              type: string
> +            # End genetlink-c
> +            flags: *cmd_flags
> diff --git a/Documentation/netlink/genetlink.yaml b/Documentation/netlink/genetlink.yaml
> new file mode 100644
> index 000000000000..aafaaaabcfbe
> --- /dev/null
> +++ b/Documentation/netlink/genetlink.yaml
> @@ -0,0 +1,284 @@
> +# SPDX-License-Identifier: GPL-2.0
> +%YAML 1.2
> +---
> +$id: "http://kernel.org/schemas/netlink/genetlink.yaml#"
> +$schema: "http://kernel.org/meta-schemas/netlink/core.yaml#"
> +
> +title: Protocol
> +description: Specification of a genetlink protocol
> +type: object
> +required: [ name, doc, attribute-sets, operations ]
> +additionalProperties: False
> +properties:
> +  name:
> +    description: Name of the genetlink family.
> +    type: string
> +  doc:
> +    type: string
> +  version:
> +    description: Generic Netlink family version. Default is 1.
> +    type: integer
> +  protocol:
> +    description: Schema compatibility level. Default is "genetlink".
> +    enum: [ genetlink ]
> +
> +  definitions:
> +    description: Array of type and constant definitions.
> +    type: array
> +    items:
> +      type: object
> +      required: [ type, name ]
> +      additionalProperties: False
> +      properties:
> +        name:
> +          type: string
> +        header:
> +          description: For C-compatible languages, header which already defines this value.
> +          type: string
> +        type:
> +          enum: [ const, enum, flags ]
> +        doc:
> +          type: string
> +        # For const
> +        value:
> +          description: For const - the value.
> +          type: [ string, integer ]
> +        # For enum and flags
> +        value-start:
> +          description: For enum or flags the literal initializer for the first value.
> +          type: [ string, integer ]
> +        entries:
> +          description: For enum or flags array of values
> +          type: array
> +          items:
> +            oneOf:
> +              - type: string
> +              - type: object
> +                required: [ name ]
> +                additionalProperties: False
> +                properties:
> +                  name:
> +                    type: string
> +                  value:
> +                    type: integer
> +                  doc:
> +                    type: string
> +
> +        render-max:
> +          description: Render the max members for this enum.
> +          type: boolean
> +
> +  attribute-sets:
> +    description: Definition of attribute spaces for this family.
> +    type: array
> +    items:
> +      description: Definition of a single attribute space.
> +      type: object
> +      required: [ name, attributes ]
> +      additionalProperties: False
> +      properties:
> +        name:
> +          description: |
> +            Name used when referring to this space in other definitions, not used outside of YAML.
> +          type: string
> +        # Strictly speaking 'name-prefix' and 'subset-of' should be mutually exclusive.
> +        name-prefix:
> +          description: |
> +            Prefix for the C enum name of the attributes. Default family[name]-set[name]-a-
> +          type: string
> +        enum-name:
> +          description: Name for the enum type of the attribute.
> +          type: string
> +        doc:
> +          description: Documentation of the space.
> +          type: string
> +        subset-of:
> +          description: |
> +            Name of another space which this is a logical part of. Sub-spaces can be used to define
> +            a limited group of attributes which are used in a nest.
> +          type: string
> +        attributes:
> +          description: List of attributes in the space.
> +          type: array
> +          items:
> +            type: object
> +            required: [ name, type ]
> +            additionalProperties: False
> +            properties:
> +              name:
> +                type: string
> +              type: &attr-type
> +                enum: [ unused, pad, flag, binary, u8, u16, u32, u64, s32, s64,
> +                        string, nest, array-nest, nest-type-value ]
> +              doc:
> +                description: Documentation of the attribute.
> +                type: string
> +              value:
> +                description: Value for the enum item representing this attribute in the uAPI.
> +                type: integer
> +              type-value:
> +                description: Name of the value extracted from the type of a nest-type-value attribute.
> +                type: array
> +                items:
> +                  type: string
> +              byte-order:
> +                enum: [little-endian, big-endian]
> +              multi-attr:
> +                type: boolean
> +              nested-attributes:
> +                description: Name of the space (sub-space) used inside the attribute.
> +                type: string
> +              enum:
> +                description: Name of the enum type used for the atttribute.
> +                type: string
> +              enum-as-flags:
> +                description: |
> +                  Treat the enum as flags. In most cases enum is either used as flags or as values.
> +                  Sometimes, however, both forms are necessary, in which case header contains the enum
> +                  form while specific attributes may request to convert the values into a bitfield.
> +                type: boolean
> +              checks:
> +                description: Kernel input validation.
> +                type: object
> +                additionalProperties: False
> +                properties:
> +                  flags-mask:
> +                    description: Name of the flags constant on which to base mask (unsigned scalar types only).
> +                    type: string
> +                  min:
> +                    description: Min value for an integer attribute.
> +                    type: integer
> +                  min-len:
> +                    description: Min length for a binary attribute.
> +                    oneOf:
> +                      - type: string
> +                        pattern: ^[0-9A-Za-z_-]*( - 1)?$
> +                      - type: integer
> +                  max-len:
> +                    description: Max length for a string or a binary attribute.
> +                    oneOf:
> +                      - type: string
> +                        pattern: ^[0-9A-Za-z_-]*( - 1)?$
> +                      - type: integer
> +              sub-type: *attr-type
> +  operations:
> +    description: Operations supported by the protocol.
> +    type: object
> +    required: [ list ]
> +    additionalProperties: False
> +    properties:
> +      enum-model:
> +        description: |
> +          The model of assigning values to the operations.
> +          "unified" is the recommended model where all message types belong
> +          to a single enum.
> +          "directional" has the messages sent to the kernel and from the kernel
> +          enumerated separately.
> +          "notify-split" has the notifications and request-response types in
> +          different enums.
> +        enum: [ unified, directional, notify-split ]
> +      name-prefix:
> +        description: |
> +          Prefix for the C enum name of the command. The name is formed by concatenating
> +          the prefix with the upper case name of the command, with dashes replaced by underscores.
> +        type: string
> +      enum-name:
> +        description: Name for the enum type with commands.
> +        type: string
> +      async-prefix:
> +        description: Same as name-prefix but used to render notifications and events to separate enum.
> +        type: string
> +      async-enum:
> +        description: Name for the enum type with notifications/events.
> +        type: string
> +      list:
> +        description: List of commands
> +        type: array
> +        items:
> +          type: object
> +          additionalProperties: False
> +          required: [ name, doc ]
> +          properties:
> +            name:
> +              description: Name of the operation, also defining its C enum value in uAPI.
> +              type: string
> +            doc:
> +              description: Documentation for the command.
> +              type: string
> +            value:
> +              description: Value for the enum in the uAPI.
> +              type: integer
> +            attribute-set:
> +              description: |
> +                Attribute space from which attributes directly in the requests and replies
> +                to this command are defined.
> +              type: string
> +            flags: &cmd_flags
> +              description: Command flags.
> +              type: array
> +              items:
> +                enum: [ admin-perm ]
> +            dont-validate:
> +              description: Kernel attribute validation flags.
> +              type: array
> +              items:
> +                enum: [ strict, dump ]
> +            do: &subop-type
> +              description: Main command handler.
> +              type: object
> +              additionalProperties: False
> +              properties:
> +                request: &subop-attr-list
> +                  description: Definition of the request message for a given command.
> +                  type: object
> +                  additionalProperties: False
> +                  properties:
> +                    attributes:
> +                      description: |
> +                        Names of attributes from the attribute-set (not full attribute
> +                        definitions, just names).
> +                      type: array
> +                      items:
> +                        type: string
> +                reply: *subop-attr-list
> +                pre:
> +                  description: Hook for a function to run before the main callback (pre_doit or start).
> +                  type: string
> +                post:
> +                  description: Hook for a function to run after the main callback (post_doit or done).
> +                  type: string
> +            dump: *subop-type
> +            notify:
> +              description: Name of the command sharing the reply type with this notification.
> +              type: string
> +            event:
> +              type: object
> +              additionalProperties: False
> +              properties:
> +                attributes:
> +                  description: Explicit list of the attributes for the notification.
> +                  type: array
> +                  items:
> +                    type: string
> +            mcgrp:
> +              description: Name of the multicast group generating given notification.
> +              type: string
> +  mcast-groups:
> +    description: List of multicast groups.
> +    type: object
> +    required: [ list ]
> +    additionalProperties: False
> +    properties:
> +      list:
> +        description: List of groups.
> +        type: array
> +        items:
> +          type: object
> +          required: [ name ]
> +          additionalProperties: False
> +          properties:
> +            name:
> +              description: |
> +                The name for the group, used to form the define and the value of the define.
> +              type: string
> +            flags: *cmd_flags
> --
> 2.39.0
>
