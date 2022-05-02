Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F3445171BC
	for <lists+netdev@lfdr.de>; Mon,  2 May 2022 16:38:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238065AbiEBOmJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 May 2022 10:42:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238024AbiEBOmI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 May 2022 10:42:08 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A9A410BD;
        Mon,  2 May 2022 07:38:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9808160FAD;
        Mon,  2 May 2022 14:38:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AAF0C385AC;
        Mon,  2 May 2022 14:38:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651502314;
        bh=5xmYs16DqQgvQQ7n8Eayk+zOE2UfeGbZ788MYHG/7C0=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=IwFi0V7jBWekNpU1Soz8LkJsUFRzMgEoIqJaHkIc3S8nt49GInIlirO6RrYn9pRGx
         wkXv32V1UOIlev3yzM9vqY3UmUhU/MnOEHVRslt0gDj8Sgz+Hml8/uV0mUfDo8yMlQ
         W5A6TbYsElP40EEPUbGbaCTUdrti70OqGustplloPw8QEMpuVsNl1LBJorO3vnpl/+
         9nJjF09qS2CFYPhDITC1IH54GLNgvN61MUfsX81TD8YWgKuVun9/hFIU2BQcfDvTj+
         jCDtFr3JZQZRlot/nNbBNJYIU+5AsX38ntxfWk7vCugJZnyS1ynU7grlN0NirkVsi2
         DmOYkCWreUluw==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] [v3] plfxlc: fix le16_to_cpu warning for beacon_interval
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <CWLP265MB3217FDFE8E945E52492B002FE0FC9@CWLP265MB3217.GBRP265.PROD.OUTLOOK.COM>
References: <CWLP265MB3217FDFE8E945E52492B002FE0FC9@CWLP265MB3217.GBRP265.PROD.OUTLOOK.COM>
To:     Srinivasan Raju <srini.raju@purelifi.com>
Cc:     unlisted-recipients:; (no To-header on input)
        "David S. Miller" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "open list:NETWORKING DRIVERS (WIRELESS)" 
        <linux-wireless@vger.kernel.org>,
        "open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Illegal-Object: Syntax error in Cc: address found on vger.kernel.org:
        Cc:     unlisted-recipients:; (no To-header on input)"David S. Miller" <davem@davemloft.net>
                                                                     ^-missing end of address
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <165150230926.32510.3611898103134896335.kvalo@kernel.org>
Date:   Mon,  2 May 2022 14:38:31 +0000 (UTC)
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Srinivasan Raju <srini.raju@purelifi.com> wrote:

> Fix the following sparse warnings:
> drivers/net/wireless/purelifi/plfxlc/chip.c:36:31: sparse: expected unsigned short [usertype] beacon_interval
> drivers/net/wireless/purelifi/plfxlc/chip.c:36:31: sparse: got restricted __le16 [usertype]
> 
> Reported-by: kernel test robot <lkp@intel.com>
> Signed-off-by: Srinivasan Raju <srini.raju@purelifi.com>

Failed to apply, please rebase on top of wireless-next. And also I
strongly recommend to use git send-email for avoiding any formatting
problems.

error: patch failed: drivers/net/wireless/purelifi/plfxlc/chip.c:29
error: drivers/net/wireless/purelifi/plfxlc/chip.c: patch does not apply
error: Did you hand edit your patch?
It does not apply to blobs recorded in its index.
hint: Use 'git am --show-current-patch=diff' to see the failed patch
Applying: plfxlc: fix le16_to_cpu warning for beacon_interval
Using index info to reconstruct a base tree...
Patch failed at 0001 plfxlc: fix le16_to_cpu warning for beacon_interval

Patch set to Changes Requested.

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/CWLP265MB3217FDFE8E945E52492B002FE0FC9@CWLP265MB3217.GBRP265.PROD.OUTLOOK.COM/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

