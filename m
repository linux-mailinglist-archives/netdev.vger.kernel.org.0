Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 26B605634D7
	for <lists+netdev@lfdr.de>; Fri,  1 Jul 2022 16:06:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231574AbiGAOGU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Jul 2022 10:06:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231557AbiGAOGT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Jul 2022 10:06:19 -0400
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77A2C3205B
        for <netdev@vger.kernel.org>; Fri,  1 Jul 2022 07:06:15 -0700 (PDT)
Received: by mail-wm1-x32a.google.com with SMTP id r81-20020a1c4454000000b003a0297a61ddso3795881wma.2
        for <netdev@vger.kernel.org>; Fri, 01 Jul 2022 07:06:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=1Z/mT3fDDdH8JukUsNUAeEComBrn2eg2dO2KaEAI2LQ=;
        b=8Ra9FMIoDI0o0BaALUgPFE1iLdhuMIaWKp2hKWcBzen1m+uTHXyVJAgOfEq7UVBv0M
         ON/91JaUREgvmPQpqf9TdXLeHsEfqhdtxstKErb9mX/7bNsMyelr2DpuYphM1jcGNSWa
         jN42WnvA0rqkuacKbptsGcdWeUiF5B8ShB7ANE7akdUktkd2/fEE5cAX8Iwq4Lqp/SLL
         qDheycdaR0iutk1RfYxLkxrHqYNxGQsvZBZqZiccqd1cGcakRuR/TTTWLM35LAD5MwsQ
         R8Y/A3tnkzMJLzu1gaVhqx1ak+P3O5lD5EQO47L0Vxb/DxFKEkVEz28LTq42DhDqVlYq
         QsJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=1Z/mT3fDDdH8JukUsNUAeEComBrn2eg2dO2KaEAI2LQ=;
        b=tggi3YTYGtVYPAYs/BFxnLXQYmHrzWfXQ1A/ohHJws+dtQ/IphC8WAOwsV/m1ajj1u
         c8C78Oqr2E0CkDMf6/ZHbDRiqjTGLZMh6R4vjGVhoekRonjlcUA02cVpgy0zJ2AKvdst
         KdNLktS0aZTahNotbeWmGx+jbyl9NT/9n5KDM/WdK/UjR3p08DsgXd0FVQvLZUOAKf+N
         Pmx6UkwkTidEVU++PQP0+gHImd2W00Y64zj1EuFm9zZtc1zFmUZH4UKw4fUJEhGJ198i
         kddOD4RkUERW0YXw89Fwafr3USstYiMH53ZjwmP4G/hJp/ouxT+zwUOLDT+Z0HvkdVc1
         W0vw==
X-Gm-Message-State: AJIora9jPz0lGZOguM523xq3/uYr6qXC/X+QXneC7MWHQb3BCWj/NsML
        Bp8o9ODPxKBSkfPpwfO3aMVT1w==
X-Google-Smtp-Source: AGRyM1vSYSbKrn5umfeskAumyIPzUDGtXG288DiMUN993SOTUCCG4lEX1ifU/00bF67hl5WX/ZdXRA==
X-Received: by 2002:a7b:c8d8:0:b0:3a0:42ca:d03 with SMTP id f24-20020a7bc8d8000000b003a042ca0d03mr18612608wml.167.1656684372914;
        Fri, 01 Jul 2022 07:06:12 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id bq8-20020a5d5a08000000b0021b903a018bsm18224262wrb.92.2022.07.01.07.06.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Jul 2022 07:06:12 -0700 (PDT)
Date:   Fri, 1 Jul 2022 16:06:11 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     David Lamparter <equinox@diac24.net>
Cc:     Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        corbet@lwn.net, linux-doc@vger.kernel.org
Subject: Re: [PATCH net-next] eth: remove neterion/vxge
Message-ID: <Yr7/UwsV4mqg0I5t@nanopsycho>
References: <20220701044234.706229-1-kuba@kernel.org>
 <Yr7NpQz6/esZAiZv@nanopsycho>
 <Yr7z7HU2Z79pMrM0@eidolon.nox.tf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yr7z7HU2Z79pMrM0@eidolon.nox.tf>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fri, Jul 01, 2022 at 03:17:32PM CEST, equinox@diac24.net wrote:
>[culled Cc:]
>
>On Fri, Jul 01, 2022 at 12:34:13PM +0200, Jiri Pirko wrote:
>> Fri, Jul 01, 2022 at 06:42:34AM CEST, kuba@kernel.org wrote:
>> >The last meaningful change to this driver was made by Jon in 2011.
>> >As much as we'd like to believe that this is because the code is
>> >perfect the chances are nobody is using this hardware.
>> 
>> Hmm, I can understand what for driver for HW that is no longer
>> developed, the driver changes might be very minimal. The fact that the
>> code does not change for years does not mean that there are users of
>> this NIC which this patch would break :/
>
>As a "reference datapoint", I'm a user that was affected by the removal
>of the Mellanox SwitchX-2 driver about a year ago.  But that was a bit

You could not be. There was really no functionality implemented in
switchx2 driver. I doubt you used 32x40G port switch with slow-path
forwarding through kernel with total max bandwidth of like 1-2G for the
whole switch :)


>different since the driver was apparently rather incomplete (I don't
>know the details, was still messing around to even get things going.)
>
>(FWIW my use case is in giving old hardware a second life, in this case
>completely throwing away the PowerPC control board from Mellanox SX6000
>series switches and replacing it with a new custom CPU board...  I might
>well be the only person interested in that driver.
>
>> Isn't there some obsoletion scheme globally applied to kernel device
>> support? I would expect something like that.
>
>I have the same question - didn't see any such policy but didn't look
>particularly hard.  But would like to avoid putting time into making
>something work just to have the kernel driver yanked shortly after :)
>
>
>-David
