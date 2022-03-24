Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 32EFE4E64E2
	for <lists+netdev@lfdr.de>; Thu, 24 Mar 2022 15:16:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344512AbiCXOSW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Mar 2022 10:18:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236272AbiCXOSW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Mar 2022 10:18:22 -0400
Received: from ms.lwn.net (ms.lwn.net [IPv6:2600:3c01:e000:3a1::42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4B96985B1;
        Thu, 24 Mar 2022 07:16:50 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:281:8300:35::5f6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ms.lwn.net (Postfix) with ESMTPSA id 0733F383;
        Thu, 24 Mar 2022 14:16:49 +0000 (UTC)
DKIM-Filter: OpenDKIM Filter v2.11.0 ms.lwn.net 0733F383
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=lwn.net; s=20201203;
        t=1648131410; bh=yS1ubCJTHIR2926NxuT8v2aGs1iGi1pDc1Z66+ccMkg=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=B/lbbzHJuDVfPqmId7ZMMxqmZxyzjCEqVM+5zxdpiMPjti70pPwPq3euvSkx+JEkz
         aZ8rzFHnOZvsLUeYVueu4+QRYls67x/4Arb8lza6gxAFjtCPK0NrwfaDYX8SGrgMSy
         ffC7Qe+f1NujLNR7XW5NALantF/uIzxiUNS8oxupD3W/FxqEtu6paV05qA2U7VOR93
         FhG0CnQ3q5yCjiYxkJei4VaEp81JQIui7loWdTkSRgHr66NT5EDF71WaR61CXPgKqp
         Fu/LIiZ4FWm4+i3lpuIIQuG0//SdtkGri0S0usR3r86e19WmorOjCSlX393yOc9dN4
         kK+IEHEWeFEow==
From:   Jonathan Corbet <corbet@lwn.net>
To:     Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net
Cc:     netdev@vger.kernel.org, pabeni@redhat.com, imagedong@tencent.com,
        edumazet@google.com, dsahern@kernel.org, talalahmad@google.com,
        linux-doc@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>
Subject: Re: [RFC net-next 1/3] skbuff: add a basic intro doc
In-Reply-To: <20220323233715.2104106-2-kuba@kernel.org>
References: <20220323233715.2104106-1-kuba@kernel.org>
 <20220323233715.2104106-2-kuba@kernel.org>
Date:   Thu, 24 Mar 2022 08:16:49 -0600
Message-ID: <87a6dfigfi.fsf@meer.lwn.net>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub Kicinski <kuba@kernel.org> writes:

> Add basic skb documentation. It's mostly an intro to the subsequent
> patches - it would looks strange if we documented advanced topics
> without covering the basics in any way.
>
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>

Glad to see improved docs!  One nit...

>  Documentation/networking/skbuff.rst | 25 ++++++++++++++++++
>  include/linux/skbuff.h              | 40 +++++++++++++++++++++++++++++
>  2 files changed, 65 insertions(+)
>  create mode 100644 Documentation/networking/skbuff.rst
>
> diff --git a/Documentation/networking/skbuff.rst b/Documentation/networking/skbuff.rst
> new file mode 100644
> index 000000000000..7c6be64f486a
> --- /dev/null
> +++ b/Documentation/networking/skbuff.rst
> @@ -0,0 +1,25 @@
> +.. SPDX-License-Identifier: GPL-2.0
> +
> +struct sk_buff
> +==============
> +
> +:c:type:`struct sk_buff` is the main networking structure representing
> +a packet.

You shouldn't need :c:type: here, our magic stuff should see "struct
sk_buff" and generate the cross reference.  Of course, it will be a
highly local reference in this case...

Thanks,

jon
