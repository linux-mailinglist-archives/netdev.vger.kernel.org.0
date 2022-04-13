Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E9EA50018E
	for <lists+netdev@lfdr.de>; Thu, 14 Apr 2022 00:07:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235410AbiDMWJ5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Apr 2022 18:09:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233989AbiDMWJz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Apr 2022 18:09:55 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC3E91FCC3;
        Wed, 13 Apr 2022 15:07:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9537AB8279C;
        Wed, 13 Apr 2022 22:07:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EF87C385A3;
        Wed, 13 Apr 2022 22:07:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649887650;
        bh=12vrk9awYVCTUe0RyKFzO2xA1hChf/BZAjoo3yOchN8=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=SiddX4+78YNil79bJnMmE4BaZgDEthqU0TFD9xmrSaWsmrNK0tw+LlHrNAEoHtKzE
         hAQA67iaxwPCntbzXPDhlZjNq2rpjmhvtkDHNw4e683xLY2KnP/X0jiyUknelNg3cR
         hloy7KKKlg+n4h9V2ZXYAd+gj1lafGEUFhH4lGlMWZO65sx+SX1MQU0cgS8LnY30fP
         OWzskynhi6XPU4vqeJA8ufYbKhsJ+JQb+r2lVoURQuA/pUZQmTYqdCNiA+Ataze5LP
         4CBMDkbDGGl/ZDITiofJteCJ6N6cgywYZ7FNYh4J3Zejj2pns1WYFaTIlaKD4mK+rZ
         1L+wAPZtJPv9g==
Message-ID: <350f6a02-2975-ac1b-1c9d-ab738722a9fe@kernel.org>
Date:   Wed, 13 Apr 2022 16:07:28 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.8.0
Subject: Re: [PATCH net-next v3] net/ipv6: Introduce accept_unsolicited_na
 knob to implement router-side changes for RFC9131
Content-Language: en-US
To:     Arun Ajith S <aajith@arista.com>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, yoshfuji@linux-ipv6.org,
        kuba@kernel.org, pabeni@redhat.com, corbet@lwn.net,
        prestwoj@gmail.com, gilligan@arista.com, noureddine@arista.com,
        gk@arista.com
References: <20220413143434.527-1-aajith@arista.com>
From:   David Ahern <dsahern@kernel.org>
In-Reply-To: <20220413143434.527-1-aajith@arista.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/13/22 8:34 AM, Arun Ajith S wrote:
> diff --git a/tools/testing/selftests/net/ndisc_unsolicited_na_test.py b/tools/testing/selftests/net/ndisc_unsolicited_na_test.py
> new file mode 100755
> index 000000000000..f508657ee126
> --- /dev/null
> +++ b/tools/testing/selftests/net/ndisc_unsolicited_na_test.py
> @@ -0,0 +1,255 @@
> +#!/bin/bash

that file name suffix should be .sh since it is a bash script; not .py

other than that looks good to me.

Reviewed-by: David Ahern <dsahern@kernel.org>
