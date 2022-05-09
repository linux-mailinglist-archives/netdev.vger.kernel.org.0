Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A570520485
	for <lists+netdev@lfdr.de>; Mon,  9 May 2022 20:30:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240150AbiEIScw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 May 2022 14:32:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240116AbiEIScu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 May 2022 14:32:50 -0400
Received: from ms.lwn.net (ms.lwn.net [IPv6:2600:3c01:e000:3a1::42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B23DC24AC7A;
        Mon,  9 May 2022 11:28:56 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:281:8300:3d::5f6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ms.lwn.net (Postfix) with ESMTPSA id 644EC732;
        Mon,  9 May 2022 18:28:54 +0000 (UTC)
DKIM-Filter: OpenDKIM Filter v2.11.0 ms.lwn.net 644EC732
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=lwn.net; s=20201203;
        t=1652120934; bh=aopXsKjG2JOTUQWT8cXPDiKX9Sm6oB0ioiAME/kxMwo=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=cJ5TY9x1jRd54VzQrvUu9zGlTLXJ76da3QO5Kwbj2j1EEF2seBUrZ3PGGjLyVMAt8
         yau3ed1lH3lsrkhQ4mh286b9r9DlHQJQN1N7fE2zlgoPRkZwQY8SkE5CMsbp88kYU4
         DbYdt7UKVYaDWvV6f/dgU176YuGJZeC3R8EL3gUIGg8i5ap9VPV37gp838fbi/bQMN
         2zixLOAHPDTgwRC/SvibJLcRwOUbjzp2PvwNUGAHprogFBfg1xqrrO1T87GRXW4+nK
         LpM2w0qZ5u6E/K2GzZ51wORJIR7ZEnBqmzozr0qAv5wbrXP6k1cYJmF1YUW8YAibtT
         gZsWFlmj0pPAQ==
From:   Jonathan Corbet <corbet@lwn.net>
To:     Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>
Cc:     Lorenzo Bianconi <lorenzo@kernel.org>, netdev@vger.kernel.org,
        ilias.apalodimas@linaro.org, hawk@kernel.org, davem@davemloft.net,
        edumazet@google.com, pabeni@redhat.com, linux-doc@vger.kernel.org,
        jbrouer@redhat.com, lorenzo.bianconi@redhat.com
Subject: Re: [PATCH net-next] Documentation: update networking/page_pool.rst
 with ethtool APIs
In-Reply-To: <20220509091330.4e8c6d05@kernel.org>
References: <2b0f8921096d45e1f279d1b7b99fe467f6f3dc6d.1652090091.git.lorenzo@kernel.org>
 <YnkIJn2BhSzyfQjh@lunn.ch> <20220509091330.4e8c6d05@kernel.org>
Date:   Mon, 09 May 2022 12:28:53 -0600
Message-ID: <87czgmef16.fsf@meer.lwn.net>
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

> BTW does ``struct xyz`` result in correct linking to the kdoc like
> :c:type:`xyz` would or I think these days also pure struct xyz?

Putting text into ``literal markup`` will interfere with our automarkup
magic.  Please just say "struct foo" and the right thing should happen.

Thanks,

jon
