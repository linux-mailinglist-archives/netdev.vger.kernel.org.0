Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 14FDD6757A4
	for <lists+netdev@lfdr.de>; Fri, 20 Jan 2023 15:45:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230171AbjATOo6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Jan 2023 09:44:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231265AbjATOox (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Jan 2023 09:44:53 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 831184C6F0;
        Fri, 20 Jan 2023 06:44:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AE32EB82704;
        Fri, 20 Jan 2023 14:43:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55814C433EF;
        Fri, 20 Jan 2023 14:43:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674225827;
        bh=yH64qNXWbBWLU8pt/tbtBcCf1Jh8HCRvlhuU0Th6WeU=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=SiXACMjL0zIvQOfexaofJ9MWMPON+6Nety5z6DL3MRYRcNCPMsx1bSpcjvhFddfY4
         YI9gvGcN+wFE8EghvS28dxud4k8diDJ+/Dxpl30BdvtknceDYiX/osWMFj377Gb+vc
         7SDJXCsEiutgd/XKuF3Dmh40AqjYKP4764lJKmtCHfU6pLCqCCpp8NfV+ldB3lVii+
         USWkufZhNFXU5ewxj64hQZWMIX/dOeNqik7MRBGuy7/Y3bxmaus+i7aP7+Y1zHduTN
         XlIXE4D9ysqezcbe/zPH9Y05I6wHEtJA3yYNbqNpRUKZ2AZeLWLay+bkAeoW5KB6OZ
         ViVpoRQp6XCaw==
Received: by mail-vs1-f44.google.com with SMTP id j185so5834067vsc.13;
        Fri, 20 Jan 2023 06:43:47 -0800 (PST)
X-Gm-Message-State: AFqh2kpUNylftih4HUkkCw4nV1DVS+jtUC327p9XNeXR4J/FZ7lGZ/Ts
        B+TtYWZUB6N4ZU3uoNvB7gF5/yy5+wHehSgznQ==
X-Google-Smtp-Source: AMrXdXtYq+FHV6CIFWw7jjhdPUkkINoBhmMu3OSPiTx/nbC2aeHL/xC7aIulRRJjB1nW50GO2R2TCbC9skwpT8psFtw=
X-Received: by 2002:a67:f506:0:b0:3d3:c767:4570 with SMTP id
 u6-20020a67f506000000b003d3c7674570mr2292533vsn.85.1674225826296; Fri, 20 Jan
 2023 06:43:46 -0800 (PST)
MIME-Version: 1.0
References: <20230119003613.111778-1-kuba@kernel.org> <20230119003613.111778-3-kuba@kernel.org>
 <CAL_JsqKk5RT6PmRSrq=YK7AvzCbcVkxasykJqe1df=3g-=kD7A@mail.gmail.com> <20230119160812.6ea60396@kernel.org>
In-Reply-To: <20230119160812.6ea60396@kernel.org>
From:   Rob Herring <robh@kernel.org>
Date:   Fri, 20 Jan 2023 08:43:35 -0600
X-Gmail-Original-Message-ID: <CAL_Jsq+PmWcF0z0gYdRVeC=sPH9qkaG2Q5K6tRvOt62YgDMoyA@mail.gmail.com>
Message-ID: <CAL_Jsq+PmWcF0z0gYdRVeC=sPH9qkaG2Q5K6tRvOt62YgDMoyA@mail.gmail.com>
Subject: Re: [PATCH net-next v3 2/8] netlink: add schemas for YAML specs
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-doc@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 19, 2023 at 6:08 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Thu, 19 Jan 2023 08:07:31 -0600 Rob Herring wrote:
> > > +$id: "http://kernel.org/schemas/netlink/genetlink-c.yaml#"
> > > +$schema: "http://kernel.org/meta-schemas/netlink/core.yaml#"
> >
> > There's no core.yaml. If you don't have a custom meta-schema, then
> > just set this to the schema for the json-schema version you are using.
> > Then the tools can validate the schemas without your own validator
> > class.
>
> $schema: https://json-schema.org/draft/2020-12/schema
>
> or
>
> $schema: https://json-schema.org/draft-09/schema

s/draft-09/draft\/2019-09/

Or did you mean draft-07?

> ?
>
> It seems like the documentation suggests the former but the latter
> appears widespread.

Yes, 2019-09 is generally not recommended as it had some one off
features that 2020-12 replaced (nothing you'd care about). DT uses
2019-09 because we needed unevaluatedProperties, but not 'prefixItems'
replacing 'items' list variant in 2020-12. I think you only used the
schema version of 'items' (not the list version), so you are probably
compatible with any version. 'dependencies' changing to
'dependentSchema/dependentRequired' is the other difference you might
hit.

TLDR: draft-07 is probably sufficient for your needs.

Rob
