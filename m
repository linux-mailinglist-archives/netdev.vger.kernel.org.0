Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 802875429E8
	for <lists+netdev@lfdr.de>; Wed,  8 Jun 2022 10:53:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232572AbiFHIv6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jun 2022 04:51:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232078AbiFHIvU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jun 2022 04:51:20 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E48D51F5E2E;
        Wed,  8 Jun 2022 01:08:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8F4FAB81B34;
        Wed,  8 Jun 2022 08:08:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 773CAC3411D;
        Wed,  8 Jun 2022 08:08:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654675725;
        bh=0rmeDxH2LOuJMzOB9clFW5E196/GYii+wOBxsNS4+CA=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=DEvtvPV0OD4wBqeh15EYlYSRCoBUnGUJ6rAq1u0CeZXN0fLERtmObYI4WUzX4gS2O
         hd12+x4wWaN9XOqI2xh3CQg8I8CvxGn1V5/PUy7uN7pVLJJMHcCLM2LDrFVyi6XdRX
         D/Ub0lKOp++o+f7M3Vf+bkdV7aqnTlJPfl/iuz8LlPBBwKUtPpvUXxGr1LbKaMZztE
         LeAv7WSPBcmoNSxEW8cnK05Ts/EomXxuqp446Nj0J688AKedfC5VCmaggIsyQErf4F
         JPqQLUlFE2Y/MkhSb8ogeBo5qA6MPtZ783/3cnNnoOAsddGIl0CU/KG/QuufnhXHYe
         DBLbVXNetYECQ==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [v1,1/2] wifi: ray_cs: Utilize strnlen() in parse_addr()
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20220603164414.48436-1-andriy.shevchenko@linux.intel.com>
References: <20220603164414.48436-1-andriy.shevchenko@linux.intel.com>
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
User-Agent: pwcli/0.1.1-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <165467572143.10728.1561784129090001480.kvalo@kernel.org>
Date:   Wed,  8 Jun 2022 08:08:43 +0000 (UTC)
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Andy Shevchenko <andriy.shevchenko@linux.intel.com> wrote:

> Instead of doing simple operations and using an additional variable on stack,
> utilize strnlen() and reuse len variable.
> 
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

2 patches applied to wireless-next.git, thanks.

9e8e9187673c wifi: ray_cs: Utilize strnlen() in parse_addr()
4dfc63c002a5 wifi: ray_cs: Drop useless status variable in parse_addr()

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20220603164414.48436-1-andriy.shevchenko@linux.intel.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

