Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A73654F9D67
	for <lists+netdev@lfdr.de>; Fri,  8 Apr 2022 20:58:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239106AbiDHTAf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Apr 2022 15:00:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239103AbiDHTAd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Apr 2022 15:00:33 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 033962A3F40;
        Fri,  8 Apr 2022 11:58:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BA2A8B82D14;
        Fri,  8 Apr 2022 18:58:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6BBDC385AC;
        Fri,  8 Apr 2022 18:58:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649444307;
        bh=2FhEMRs3hFUwIQavUMxPgezQCWX/rHj7GMlNJFdVk+Q=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Vt6ZhXFPmlZ6bZjJ/Qo62HKP7oUpFx+9tIcXVdPmGvJKwPFa8LarxaUp2qHdpV+gm
         CWgSl4xTLG6NJtUQmii8AlrTt0HBk/dh0nMKSKzTLb2+bt02HoU3LsEsKe5KLInzxJ
         3s2rdpOmjW8sXCTYJnjSMyKx04mEUjv24Li9v6xY33lwKVAbecVVQD+8F9ZfGXxkmb
         BYZUOkLq0kVEoth3LsMBRufkp+qELQwW8vcUEFI46eK9cfv7nUUz0DMTIRUWVTU9EH
         Uh3TOElH57Znvn5j1ozUNd2jtraA+JeDsrMvBx7fGFBT/vGWlSB5wdU/uUy2YqmpqD
         Jubrr1X6I8Y2A==
Date:   Fri, 8 Apr 2022 11:58:25 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Taehee Yoo <ap420073@gmail.com>
Cc:     davem@davemloft.net, pabeni@redhat.com, netdev@vger.kernel.org,
        irusskikh@marvell.com, ast@kernel.org, daniel@iogearbox.net,
        hawk@kernel.org, john.fastabend@gmail.com, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        kpsingh@kernel.org, bpf@vger.kernel.org
Subject: Re: [PATCH net-next v3 0/3] net: atlantic: Add XDP support
Message-ID: <20220408115825.319e815e@kernel.org>
In-Reply-To: <d4106b81-31cb-2569-6b49-9393bd2c2b34@gmail.com>
References: <20220408165950.10515-1-ap420073@gmail.com>
        <d4106b81-31cb-2569-6b49-9393bd2c2b34@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 9 Apr 2022 02:32:51 +0900 Taehee Yoo wrote:
> I will send v4 patch because of compile warning.

Please don't resend your series more often than once a day.

If your code doesn't compile cleanly, too bad, you'll have to wait.

This is sort of documented in the FAQ:

  2.10. I have received review feedback, when should I post a revised
        version of the patches?

        Allow at least 24 hours to pass between postings. This will
        ensure reviewers from all geographical locations have a chance
        to chime in. Do not wait too long (weeks) between postings
        either as it will make it harder for reviewers to recall all
        the context.

https://www.kernel.org/doc/html/latest/process/maintainer-netdev.html#i-have-received-review-feedback-when-should-i-post-a-revised-version-of-the-patches
