Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 834C0645AFA
	for <lists+netdev@lfdr.de>; Wed,  7 Dec 2022 14:33:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229988AbiLGNdU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Dec 2022 08:33:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229665AbiLGNdS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Dec 2022 08:33:18 -0500
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 204F32DAAF
        for <netdev@vger.kernel.org>; Wed,  7 Dec 2022 05:33:17 -0800 (PST)
Received: by mail-ed1-x52e.google.com with SMTP id d14so19954332edj.11
        for <netdev@vger.kernel.org>; Wed, 07 Dec 2022 05:33:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=VyWW55iEeVhMuwfe/0nAilRUr6ChqikW4mzOhMv1GDA=;
        b=R5Na6xNJ+oHKXpUVCSCdarbqkxUJ5AHEDBv+qUtcRT00v5vzJnK6fIC7njycrbYwaw
         3oZ/QUshdhOOlqGov6H0O37LG4XYsudcIAFtlwSIZex/KuhRjmkEriKGJN2mJpnRRupj
         BWkWPJlADAG6HZoMD5BJEChznjqqST93ZW1viCTWdfRVk52Gt1+y+1swz+Sz2Cb5XtaW
         DuVHEd8Ed3rixVINNNHCwnjWGs0EBMUxErLQ9iiYelZxQ2FAzsSI4+mqyThIeHa3h72e
         eW1yL2kBqNslJflTrmgQpmHczEDKlcy2+wAO2YjrObHKPIZkDJ8ifclNJStvUo29hEFX
         dXcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VyWW55iEeVhMuwfe/0nAilRUr6ChqikW4mzOhMv1GDA=;
        b=vKukWO/VfKi54IEYzXbXo/dWVfYF/Q70bWQFYazrFixYefihkO8ttPFSmNQyiTX6GC
         jnBVFOJSn5w3gT+KiABN0xN6JFBN1ruIEk9QJFBnzpYJYHfCDWeGieN9gXiWoaPhYyI2
         pOKvHzZeHSUJfQdNONm9hCzDYYuYjObw8HjzD4wcde+nIHTWh2mrCopLfRwexf2IJrLa
         HdnlVUS0um6wf0Hi6aLVpub5MzH2bvspIwKxhp4iI94pC3xCch3Cn3RQ/P8qw4GRgocE
         i3D8DkKv3lbRNzifSAU6gA2gYhCIN+aVHCmoHx6a0PZTSqJlWR+a3gxXGKYktd6eGOHJ
         dMug==
X-Gm-Message-State: ANoB5plC9tMXOB/pLFRzft8EU4CIdSoc1JN2NzPBd23CkN1tlyE+pw9q
        YPYiMzo3t6PWNCSZGZN7HAQgkg==
X-Google-Smtp-Source: AA0mqf57nXY4ut0tPaC+qgvOgbEV51O66hwwvZYmzxOe2Z2wTP7iKB8Mt2rfPqBTYXCZOkMfAATxug==
X-Received: by 2002:a05:6402:a52:b0:46b:d3b3:669f with SMTP id bt18-20020a0564020a5200b0046bd3b3669fmr26182468edb.414.1670419995671;
        Wed, 07 Dec 2022 05:33:15 -0800 (PST)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id a19-20020aa7cf13000000b00463c475684csm2229870edy.73.2022.12.07.05.33.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Dec 2022 05:33:15 -0800 (PST)
Date:   Wed, 7 Dec 2022 14:33:14 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Shannon Nelson <shannon.nelson@amd.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        jiri@nvidia.com
Subject: Re: [PATCH net-next 2/2] devlink: add enable_migration parameter
Message-ID: <Y5CWGgXUwPGBzfWY@nanopsycho>
References: <20221205172627.44943-1-shannon.nelson@amd.com>
 <20221205172627.44943-3-shannon.nelson@amd.com>
 <Y48FrgEvbj21eIMS@nanopsycho>
 <4bf5baa0-d0c7-7600-7d59-605dc6504fd0@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4bf5baa0-d0c7-7600-7d59-605dc6504fd0@amd.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tue, Dec 06, 2022 at 07:28:33PM CET, shannon.nelson@amd.com wrote:
>On 12/6/22 1:04 AM, Jiri Pirko wrote:
>> Mon, Dec 05, 2022 at 06:26:27PM CET, shannon.nelson@amd.com wrote:
>> > To go along with existing enable_eth, enable_roce,
>> > enable_vnet, etc., we add an enable_migration parameter.
>> 
>> In the patch description, you should be alwyas imperative to the
>> codebase. Tell it what to do, don't describe what you (plural) do :)
>
>This will be better described when rolled up in the pds_core patchset.
>
>> 
>> 
>> > 
>> > This follows from the discussion of this RFC patch
>> > https://lore.kernel.org/netdev/20221118225656.48309-11-snelson@pensando.io/
>> > 
>> > Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>
>> > ---
>> > Documentation/networking/devlink/devlink-params.rst | 4 ++++
>> > include/net/devlink.h                               | 4 ++++
>> > net/core/devlink.c                                  | 5 +++++
>> > 3 files changed, 13 insertions(+)
>> > 
>> > diff --git a/Documentation/networking/devlink/devlink-params.rst b/Documentation/networking/devlink/devlink-params.rst
>> > index ed62c8a92f17..c56caad32a7c 100644
>> > --- a/Documentation/networking/devlink/devlink-params.rst
>> > +++ b/Documentation/networking/devlink/devlink-params.rst
>> > @@ -141,3 +141,7 @@ own name.
>> >       - u8
>> >       - In a multi-bank flash device, select the FW memory bank to be
>> >         loaded from on the next device boot/reset.
>> > +   * - ``enable_migration``
>> > +     - Boolean
>> > +     - When enabled, the device driver will instantiate a live migration
>> > +       specific auxiliary device of the devlink device.
>> 
>> Devlink has not notion of auxdev. Use objects and terms relevant to
>> devlink please.
>> 
>> I don't really understand what is the semantics of this param at all.
>
>Perhaps we need to update the existing descriptions for enable_eth,
>enable_vnet, etc, as well?  Probably none of them should mention the aux
>device, tho' I know they all came in together after a long discussion.

Yep, I think so.


>
>I'll work this to be more generic to the result and not the underlying
>specifics of how.

Thanks!

>
>sln
>
>> 
>> 
>> > diff --git a/include/net/devlink.h b/include/net/devlink.h
>> > index 8a1430196980..1d35056a558d 100644
>> > --- a/include/net/devlink.h
>> > +++ b/include/net/devlink.h
>> > @@ -511,6 +511,7 @@ enum devlink_param_generic_id {
>> >        DEVLINK_PARAM_GENERIC_ID_IO_EQ_SIZE,
>> >        DEVLINK_PARAM_GENERIC_ID_EVENT_EQ_SIZE,
>> >        DEVLINK_PARAM_GENERIC_ID_FW_BANK,
>> > +      DEVLINK_PARAM_GENERIC_ID_ENABLE_MIGRATION,
>> > 
>> >        /* add new param generic ids above here*/
>> >        __DEVLINK_PARAM_GENERIC_ID_MAX,
>> > @@ -572,6 +573,9 @@ enum devlink_param_generic_id {
>> > #define DEVLINK_PARAM_GENERIC_FW_BANK_NAME "fw_bank"
>> > #define DEVLINK_PARAM_GENERIC_FW_BANK_TYPE DEVLINK_PARAM_TYPE_U8
>> > 
>> > +#define DEVLINK_PARAM_GENERIC_ENABLE_MIGRATION_NAME "enable_migration"
>> > +#define DEVLINK_PARAM_GENERIC_ENABLE_MIGRATION_TYPE DEVLINK_PARAM_TYPE_BOOL
>> > +
>> > #define DEVLINK_PARAM_GENERIC(_id, _cmodes, _get, _set, _validate)    \
>> > {                                                                     \
>> >        .id = DEVLINK_PARAM_GENERIC_ID_##_id,                           \
>> > diff --git a/net/core/devlink.c b/net/core/devlink.c
>> > index 6872d678be5b..0e32a4fe7a66 100644
>> > --- a/net/core/devlink.c
>> > +++ b/net/core/devlink.c
>> > @@ -5236,6 +5236,11 @@ static const struct devlink_param devlink_param_generic[] = {
>> >                .name = DEVLINK_PARAM_GENERIC_FW_BANK_NAME,
>> >                .type = DEVLINK_PARAM_GENERIC_FW_BANK_TYPE,
>> >        },
>> > +      {
>> > +              .id = DEVLINK_PARAM_GENERIC_ID_ENABLE_MIGRATION,
>> > +              .name = DEVLINK_PARAM_GENERIC_ENABLE_MIGRATION_NAME,
>> > +              .type = DEVLINK_PARAM_GENERIC_ENABLE_MIGRATION_TYPE,
>> > +      },
>> > };
>> > 
>> > static int devlink_param_generic_verify(const struct devlink_param *param)
>> > --
>> > 2.17.1
>> > 
