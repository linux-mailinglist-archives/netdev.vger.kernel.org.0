Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F29A6C6DCA
	for <lists+netdev@lfdr.de>; Thu, 23 Mar 2023 17:37:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232347AbjCWQgq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Mar 2023 12:36:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231811AbjCWQg1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Mar 2023 12:36:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05AB137B51;
        Thu, 23 Mar 2023 09:35:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E29AF62802;
        Thu, 23 Mar 2023 16:34:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F00B0C4339B;
        Thu, 23 Mar 2023 16:34:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679589299;
        bh=LyBfXjJqpHyUE5vbMBXLTB7FVvUW7RtidE1SohE8dZ8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=GteXB2FHv99MNT1dkR/BjGBbHbTY5pl8Fo+sV7Cj2CTHZKxoW9/zXmahl71zbmC0l
         moCOgWw55LN3YTO9KeN0aFFuI67OGl/36k2QikBP4yOZp43xsZiyYugIc5EFvHk9vE
         f1kzcUgZc0gZ4oetSvI3WqZFqOgMVFbzrgr43/oZOhchStHD8/8MPYZ/+Dg+CfrW9u
         No/4g57ytpm3P98F9IR10RRKe+/WTGN7yi4crdRqmFqEhphFkRPr7/NEfFMeoz+md1
         41AJPZ/NJjVSdb6Ca/bY7aWyep6JSRewUTWeDGsyygemYPunnTfyx+4vQY6Tr0MYQA
         oXS+uA9crawDQ==
Date:   Thu, 23 Mar 2023 09:34:57 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Cc:     Lukas Bulwahn <lukas.bulwahn@gmail.com>,
        Bongsu Jeon <bongsu.jeon@samsung.com>,
        Mark Greer <mgreer@animalcreek.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: Status of linux-nfc@lists.01.org mailing list
Message-ID: <20230323093457.76289346@kernel.org>
In-Reply-To: <1b105e1a-580c-6f75-731e-4823eba4073d@linaro.org>
References: <CAKXUXMzggxQ43DUZZRkPMGdo5WkzgA=i14ySJUFw4kZfE5ZaZA@mail.gmail.com>
        <1b105e1a-580c-6f75-731e-4823eba4073d@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 23 Mar 2023 12:29:04 +0100 Krzysztof Kozlowski wrote:
> I am not a maintainer of this mailing list. I did not get any
> notifications from 01.org that they are shutting down their lists. Maybe
> we should just drop it.
> 
> +Cc net folks

Dropping the list SGTM.
