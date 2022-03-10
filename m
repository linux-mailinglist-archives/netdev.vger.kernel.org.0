Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D3A64D4D98
	for <lists+netdev@lfdr.de>; Thu, 10 Mar 2022 16:52:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239188AbiCJPw4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Mar 2022 10:52:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238811AbiCJPwu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Mar 2022 10:52:50 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0EA5184624;
        Thu, 10 Mar 2022 07:51:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3C248619BD;
        Thu, 10 Mar 2022 15:51:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E2D8C340E8;
        Thu, 10 Mar 2022 15:51:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646927508;
        bh=fDncGPJcRJVwshm603ffeV/SxF9a2whRf+pP4u1JBl8=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=WzmMnWO86JdzfXeSUkY5GL6hMokbLHjoyDE7uSZHEOjDqMorJp0bB7BVh3fTBp/da
         8tNLjbHKVKWjur1yEYB8zi1I9woRT1LUrSb26jTo6aa5n3gmF1wxzgIxG4x4BUDF0g
         g/Y5SSWQPpGDQ9Hjq2kqRJfncbJPHzXuT908OqGSDs6Nz2ha+YHrrvgb+kBuAKpoL9
         mDnuh7vD6ihJ3hxSQh9BvJjCAjGNdjCzj+ykT0V0EJT0VyNwO+WBOd19DOZSnIQYZ9
         so7nCNmhBaFeqrwGuP/x5PtV1aQM+x5z9STl0Wwz3RN4evV0htjAQDTGzXuldxulew
         0Wd1aqtmispkg==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] ath11k: remove unneeded flush_workqueue
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20220301013246.2052570-1-lv.ruyi@zte.com.cn>
References: <20220301013246.2052570-1-lv.ruyi@zte.com.cn>
To:     cgel.zte@gmail.com
Cc:     davem@davemloft.net, kuba@kernel.org, ath11k@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Lv Ruyi (CGEL ZTE)" <lv.ruyi@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <164692750437.18489.17708219137652842417.kvalo@kernel.org>
Date:   Thu, 10 Mar 2022 15:51:46 +0000 (UTC)
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

cgel.zte@gmail.com wrote:

> All work currently pending will be done first by calling destroy_workqueue,
> so there is no need to flush it explicitly.
> 
> Reported-by: Zeal Robot <zealci@zte.com.cn>
> Signed-off-by: Lv Ruyi (CGEL ZTE) <lv.ruyi@zte.com.cn>
> Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>

Patch applied to ath-next branch of ath.git, thanks.

57fe207f752a ath11k: remove unneeded flush_workqueue

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20220301013246.2052570-1-lv.ruyi@zte.com.cn/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

