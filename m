Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A58A55E79A2
	for <lists+netdev@lfdr.de>; Fri, 23 Sep 2022 13:33:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229549AbiIWLdI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Sep 2022 07:33:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231224AbiIWLdG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Sep 2022 07:33:06 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B132B12DEE1;
        Fri, 23 Sep 2022 04:33:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5C6E7B80BD9;
        Fri, 23 Sep 2022 11:33:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE980C433C1;
        Fri, 23 Sep 2022 11:33:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663932783;
        bh=WngHBVKe75GnbeKVGJV693JtqPmK9h0wa4JCC0ZrN1o=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=ZGOSmX0wUwdOSNKbcfEwNxU44KqJV/+hchMJ5V7R2kKHMo8PB4S2y8/qVNZdW2q+k
         QWcBtGlIunZ8hBu50vQL1896AwejomZ1od5puwH7M84h5GjhDgA7L+LjRoI/O0FBGn
         MV+cM7nHnsFNtai6mz6jIdIaafHVtjJ4iqKdMqYzJmQq0LHqbOu5TjlRTUxGxERVIl
         NqtgUFiKKTwoivBhkFfTJ2X1SpAqn494WdOgR5ECisfQrQ5ym/0DUBFjNL12O72izP
         nhW9o8aEYf5gEV5rNPOiMy6xEONOuA7ZKPWe+yk5SEzG+WcNtP4U1Qa0aNqibP+KR0
         TGJI6ikYjW9og==
Message-ID: <5fffcfcd-6156-d3ba-0d92-39836830359e@kernel.org>
Date:   Fri, 23 Sep 2022 13:32:59 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.0
Subject: Re: [PATCH net-next 2/7] dt-bindings: net: tsnep: Allow additional
 interrupts
Content-Language: en-US
To:     Gerhard Engleder <gerhard@engleder-embedded.com>,
        davem@davemloft.net, kuba@kernel.org, robh+dt@kernel.org
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org
References: <20220915203638.42917-1-gerhard@engleder-embedded.com>
 <20220915203638.42917-3-gerhard@engleder-embedded.com>
From:   Krzysztof Kozlowski <krzk@kernel.org>
In-Reply-To: <20220915203638.42917-3-gerhard@engleder-embedded.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 15/09/2022 22:36, Gerhard Engleder wrote:
> Additional TX/RX queue pairs require dedicated interrupts. Extend
> binding with additional interrupts.
> 
> Signed-off-by: Gerhard Engleder <gerhard@engleder-embedded.com>

Use scripts/get_maintainers.pl to CC all maintainers and relevant
mailing lists.

Best regards,
Krzysztof

