Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD5AC56B1EB
	for <lists+netdev@lfdr.de>; Fri,  8 Jul 2022 07:00:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237181AbiGHFA2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jul 2022 01:00:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236202AbiGHFA1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jul 2022 01:00:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5243176EB8;
        Thu,  7 Jul 2022 22:00:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EC8FD62440;
        Fri,  8 Jul 2022 05:00:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED703C341C8;
        Fri,  8 Jul 2022 05:00:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657256426;
        bh=ctspZOysU4hoJiaVJPrttyRUi78rR5sC4yqDKFIA4V8=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=lt92GpHqgDl/DF9whxA9JGYF0R9DIZXJSis/DCjaGSDU60lNpghyOHgUgV7QQoAXH
         RLAWwfagj+T2BMde7bxgG3E9ubwwMMcDatmbPJSgS0sCM85oVyrjtFtdv1wjqmRuY8
         du37QdD4V3zaZZtWlusfLaAPDWvzlvRpFYKFFqsxwqasXUCGqPa9x07Fxw9H9QuUjd
         +QHsN9M5iQIzsFw5+JbRerVS4T6NM03a53yi2nkim8OPq0sbnOUeoW9skeLR89iEZ+
         b4UtKNd9bVOvQT9L8FzsTf0D5gccVIrJ7+p1XCF/ekr9N7hl7TwIDBl1xDCNsoW+dF
         3Qtoahs+tyD7Q==
From:   Kalle Valo <kvalo@kernel.org>
To:     "Tan Zhongjun" <tanzhongjun@coolpad.com>
Cc:     <jirislaby@kernel.org>, <mickflemm@gmail.com>, <mcgrof@kernel.org>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <linux-wireless@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ath5k: Use swap() instead of open coding it
References: <20220704130614.37467-1-tanzhongjun@coolpad.com>
Date:   Fri, 08 Jul 2022 08:00:20 +0300
In-Reply-To: <20220704130614.37467-1-tanzhongjun@coolpad.com> (Tan Zhongjun's
        message of "Mon, 04 Jul 2022 21:06:23 +0800")
Message-ID: <87r12wtd0b.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

"Tan Zhongjun" <tanzhongjun@coolpad.com> writes:

> Use swap() instead of open coding it. 
>
> Signed-off-by: Tan Zhongjun 

Please don't send HTML emails, our lists automatically drop those. More
info in the wiki below.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
