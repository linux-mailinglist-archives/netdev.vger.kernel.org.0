Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F20564FE31C
	for <lists+netdev@lfdr.de>; Tue, 12 Apr 2022 15:54:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348051AbiDLN4I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Apr 2022 09:56:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356424AbiDLNz7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Apr 2022 09:55:59 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27CAB580E2;
        Tue, 12 Apr 2022 06:53:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CDD10B81DE5;
        Tue, 12 Apr 2022 13:53:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5B7EC385A1;
        Tue, 12 Apr 2022 13:53:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649771617;
        bh=f6+0yAute3D1sg9nKa60UP+JQ9RmGfPECbrxZ/b8Smg=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=TAmtS/NGMrd0Ls/VqsZoIaFQtUjjsjovfXNfvh574ipZ5j12+teg/+8iMgsM9MTpM
         hh1tXQCLfSt9PzBGqtrciQWr6+rrCcYhB2VLzZ2brFnJxKqARPxt7xXs7HNAxLlmav
         km54lmNI9s7E1uhPDyaQwI632VQ+gJZM1u7J7dtdiRm0bqFUkYGHxxSnGXDObd7GHZ
         Z8b6a+rARtfT4opNhCKbP3lYoyysZe/70AdwyUXWMD2OLzpOu4NM/IfYqLX4oyF9Kp
         oazHpIYYj3Ktgw5GZKtDkLT2yhS4c5JOOrL1ocAnrz4F7UqBMLbNLEOB4B5f2JDjY9
         Ir/bWjdgNht4Q==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: wlcore: debugfs: use pm_runtime_resume_and_get() instead of
 pm_runtime_get_sync()
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20220408081205.2494512-1-chi.minghao@zte.com.cn>
References: <20220408081205.2494512-1-chi.minghao@zte.com.cn>
To:     cgel.zte@gmail.com
Cc:     davem@davemloft.net, kuba@kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Minghao Chi <chi.minghao@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <164977161395.6629.9490179643515926728.kvalo@kernel.org>
Date:   Tue, 12 Apr 2022 13:53:35 +0000 (UTC)
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

cgel.zte@gmail.com wrote:

> From: Minghao Chi <chi.minghao@zte.com.cn>
> 
> Using pm_runtime_resume_and_get is more appropriate
> for simplifing code
> 
> Reported-by: Zeal Robot <zealci@zte.com.cn>
> Signed-off-by: Minghao Chi <chi.minghao@zte.com.cn>

Patch applied to wireless-next.git, thanks.

b2268fd81c18 wlcore: debugfs: use pm_runtime_resume_and_get() instead of pm_runtime_get_sync()

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20220408081205.2494512-1-chi.minghao@zte.com.cn/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

