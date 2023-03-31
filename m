Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E8536D232B
	for <lists+netdev@lfdr.de>; Fri, 31 Mar 2023 16:54:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233038AbjCaOyh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Mar 2023 10:54:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233002AbjCaOy3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Mar 2023 10:54:29 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E13D820C12;
        Fri, 31 Mar 2023 07:54:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2669DB83034;
        Fri, 31 Mar 2023 14:53:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C86A7C433D2;
        Fri, 31 Mar 2023 14:53:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680274401;
        bh=F+ioLHZ3rr7JNaqQuVtErG2HRZESVfIcXLcf8KtrM+0=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=M9b9B57//m9Gc8eficQ3GUTts0Rx3tZ88f30ePjEXMqFLPaCAeH1MmKZXQhVruStp
         Jqcm54+zUoyqP0jibctxdy/95puoZStovP7pTs1S35q1wy9hthqwc3NtPOMF7l5v90
         YpRPp9K2+HUPc7nhWVK7shyI0mEbM9nYPKWbOj/1rKeXIaYHsRf0rVV2QtUrK9RS/3
         07nS6Uj0n/jK3wIoW57wnGtWideGpah6BNAhFPbHeaYgZxDFGBaqgYdcJ2qeO9hpxB
         eA2SaRMFlNtUxRU0UZ6jN83nQ8NBdzVmiu2s9ehxTv6al11z9v864j6aXc/LlQpAJG
         9aiB7j/DYa47Q==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [v2] wifi: rtlwifi: fix incorrect error codes in
 rtl_debugfs_set_write_reg()
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20230326054217.93492-1-harperchen1110@gmail.com>
References: <20230326054217.93492-1-harperchen1110@gmail.com>
To:     Wei Chen <harperchen1110@gmail.com>
Cc:     pkshih@realtek.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Wei Chen <harperchen1110@gmail.com>
User-Agent: pwcli/0.1.1-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <168027439802.32751.12727089467874347568.kvalo@kernel.org>
Date:   Fri, 31 Mar 2023 14:53:19 +0000 (UTC)
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Wei Chen <harperchen1110@gmail.com> wrote:

> If there is a failure during copy_from_user or user-provided data buffer is
> invalid, rtl_debugfs_set_write_reg should return negative error code instead
> of a positive value count.
> 
> Fix this bug by returning correct error code. Moreover, the check of buffer
> against null is removed since it will be handled by copy_from_user.
> 
> Fixes: 610247f46feb ("rtlwifi: Improve debugging by using debugfs")
> Signed-off-by: Wei Chen <harperchen1110@gmail.com>
> Reviewed-by: Simon Horman <simon.horman@corigine.com>

Patch applied to wireless-next.git, thanks.

5dbe1f8eb8c5 wifi: rtlwifi: fix incorrect error codes in rtl_debugfs_set_write_reg()

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20230326054217.93492-1-harperchen1110@gmail.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

