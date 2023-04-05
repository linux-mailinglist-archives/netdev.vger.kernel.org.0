Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F13986D7717
	for <lists+netdev@lfdr.de>; Wed,  5 Apr 2023 10:39:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237128AbjDEIjZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Apr 2023 04:39:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236804AbjDEIjY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Apr 2023 04:39:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64CEA270C;
        Wed,  5 Apr 2023 01:39:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D7B166386A;
        Wed,  5 Apr 2023 08:39:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E50EC433EF;
        Wed,  5 Apr 2023 08:39:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680683961;
        bh=dhFI2ergYdPcVtaYz5CXtSEukcIvS2GwqaX9nKDBxLQ=;
        h=From:Subject:Date:To:Cc:From;
        b=dl1bFMpVOzblCxjdT5NaMvuz1xLXrQuBGlMIfBGI27tB/FaXIOh3s6YBB2/Da59TE
         ir1z8E26bPZN7+AHORAWNEegryBlPgjkgMPqHSg+vEpf52a2ckrWhAsvv2JjyQu95d
         npL23VVr4KYaRferRILPX4wb0KYY8PNplfNfgxAIUhszzdcXaBznzHmeo/njdYN8G8
         kExzU8SUlG/GOFDu/V4WBRq3e/VlE35mgVR0IAI47YYa4HWjzkd6+JvYcN8lvSD1Ga
         kZOPEEzfdRo0C65Df2Amx2HXS6c52FPp/PKw4V7aetmAEWCDIyHm73pgVoR7+ePMoY
         ILfCMghRF/4Qw==
From:   Simon Horman <horms@kernel.org>
Subject: [PATCH net-next 0/3] ksz884x: remove unused functions and #defines
Date:   Wed, 05 Apr 2023 10:39:15 +0200
Message-Id: <20230405-ksz884x-unused-code-v1-0-a3349811d5ef@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIALMzLWQC/x2NQQqDMBAAvyJ77sIaLYZ+pfQQk00NlbVkTQkV/
 97Q4wwMc4ByTqxw6w7I/EmaNmnQXzrwi5MnYwqNwZAZaKQrvvRr7VixSFEO6LfAGMlNQ6Bo+8l
 AK2enjHN24pfWSlnXJt+ZY6r/1R2EdxSuOzzO8wfylMsfhAAAAA==
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Tom Rix <trix@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, llvm@lists.linux.dev
X-Mailer: b4 0.12.2
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Remove unused #defines and functions from ksz884x driver.

These #defines may have some value in documenting the hardware.
But that information may be accessed via scm history.

---
Simon Horman (3):
      ksz884x: remove commented-out #defines
      ksz884x: remove unused #defines
      ksz884x: remove unused functions

 drivers/net/ethernet/micrel/ksz884x.c | 718 ----------------------------------
 1 file changed, 718 deletions(-)

base-commit: 054fbf7ff8143d35ca7d3bb5414bb44ee1574194

