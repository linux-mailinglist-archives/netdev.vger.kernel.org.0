Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 856755BE6BC
	for <lists+netdev@lfdr.de>; Tue, 20 Sep 2022 15:08:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229966AbiITNIl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Sep 2022 09:08:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230463AbiITNIc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Sep 2022 09:08:32 -0400
Received: from ms.lwn.net (ms.lwn.net [IPv6:2600:3c01:e000:3a1::42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D63EC12;
        Tue, 20 Sep 2022 06:08:31 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:281:8300:73::5f6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ms.lwn.net (Postfix) with ESMTPSA id 200A736E;
        Tue, 20 Sep 2022 13:08:30 +0000 (UTC)
DKIM-Filter: OpenDKIM Filter v2.11.0 ms.lwn.net 200A736E
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=lwn.net; s=20201203;
        t=1663679310; bh=9iFWsoOY9NsDR1zk/PFCAmIctBe5Q2ixlSUgt9DGg0s=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=AVswEb+Bfy0KhIMEPxLkyoux7FxMMf+YhI1Xx9tvRb/Kdqc0XMqXhlPRtceuaKPoP
         5pxgdb5r8nfU4DWr7qgMtgCPkOFFypjdQiJg9tL0d7fjFjV1X5H9USvqFFLapRC5T0
         Bh1+Pzra87vxz8xy4Edy4jE2bo+LXwmsgDbY0hXxW+iiTfzPlvX6TVUWWjNH8EHhRg
         KAnzIHjj+T9BWe6OV9cRAClAutG2XVYUi+C7H/RcFEaUHP9gUequcs/JVoKXOJorgk
         ZD8EB3Fje2f9lWMcB4xXqiHVPU8OeheS6IKau+lBMRksYBE1bboNt1jEM1dHu4MP+m
         z8W817/lr2lTw==
From:   Jonathan Corbet <corbet@lwn.net>
To:     Edward Cree <ecree.xilinx@gmail.com>,
        Bagas Sanjaya <bagasdotme@gmail.com>, ecree@xilinx.com,
        netdev@vger.kernel.org, linux-net-drivers@amd.com
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, linux-doc@vger.kernel.org,
        jacob.e.keller@intel.com, jesse.brandeburg@intel.com,
        michael.chan@broadcom.com, andy@greyhouse.net, saeed@kernel.org,
        jiri@resnulli.us, snelson@pensando.io, simon.horman@corigine.com,
        alexander.duyck@gmail.com, rdunlap@infradead.org, parav@nvidia.com,
        roid@nvidia.com, marcin.szycik@linux.intel.com
Subject: Re: [PATCH v3 net-next] docs: net: add an explanation of VF (and
 other) Representors
In-Reply-To: <482e66b4-9dae-1376-e59a-854bfc023c59@gmail.com>
References: <20220905135557.39233-1-ecree@xilinx.com>
 <228fb86d-4239-0aa9-ba88-e3fdc7cbe99f@gmail.com>
 <482e66b4-9dae-1376-e59a-854bfc023c59@gmail.com>
Date:   Tue, 20 Sep 2022 07:08:29 -0600
Message-ID: <87h712yz02.fsf@meer.lwn.net>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Edward Cree <ecree.xilinx@gmail.com> writes:

> On 06/09/2022 10:29, Bagas Sanjaya wrote:
>> I think by convention, footnotes should be put on bottom of the doc.
>
> Hmm, a quick and unscientific sample of Documentation/ suggests that
>  many/most existing examples put the footnote shortly after the
>  reference or at the end of the section, roughly as I did here.  I
>  looked at five rST files found by "grep \[#\]_" and all of them had
>  the footnote body close to the reference.
> The placement of the footnote text in the generated output is up to
>  the stylesheet / renderer, of course.

We certainly have no established convention in this area as far as I
know, and I'm not convinced we need one.

Bagas, could I ask you please to focus a bit more on doing useful work
and less on telling others how they should be working?

Thanks,

jon
