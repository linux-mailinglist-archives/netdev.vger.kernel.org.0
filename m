Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7510868FFE4
	for <lists+netdev@lfdr.de>; Thu,  9 Feb 2023 06:32:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229580AbjBIFbQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Feb 2023 00:31:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229461AbjBIFbP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Feb 2023 00:31:15 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 307B42DE62
        for <netdev@vger.kernel.org>; Wed,  8 Feb 2023 21:31:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DD5EDB81FAB
        for <netdev@vger.kernel.org>; Thu,  9 Feb 2023 05:31:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03300C433D2;
        Thu,  9 Feb 2023 05:31:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675920672;
        bh=vrmRAjrrpDp7hQnAEVAjCNEQyzIG3wdZxcVW+wmRqSw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=IYRN63LSPsSdv5ytVoplOZaJQeccUm8xgJX8J3qnavJId1in55tKQD6aDbiOrCu7C
         pwmLT+ihJ5UDslVDNHlDweZTLtUfwgzfX/DNZbvwvyqskEc570T1LEx1C6eQSTtKel
         0U9WAlRCLzfOF1l9EbIbz4p6kazRFpaJHhBXr6OoYeAtEa3aeeihgdAB6QJ206cuxE
         LbaSc3N2SP7pff/eG0DTbqMW/DZokiXFLfzOSdESaK/O0epDZfkAPXa6h504Qu1xvL
         x5yXaUy+S/3oH76dUQeIXJMAmqVWJq1+pGqNLPBHwpgB4LkMfJQE5YU0CisaPi0C61
         Ug2YGzeqQfthQ==
Date:   Wed, 8 Feb 2023 21:31:11 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Muhammad Husaini Zulkifli <muhammad.husaini.zulkifli@intel.com>
Cc:     intel-wired-lan@osuosl.org, vinicius.gomes@intel.com,
        naamax.meir@linux.intel.com, anthony.l.nguyen@intel.com,
        leon@kernel.org, davem@davemloft.net, pabeni@redhat.com,
        edumazet@google.com, tee.min.tan@linux.intel.com,
        netdev@vger.kernel.org, sasha.neftin@intel.com
Subject: Re: [PATCH net-next v4] igc: offload queue max SDU from tc-taprio
Message-ID: <20230208213111.711d8337@kernel.org>
In-Reply-To: <20230209022924.24154-1-muhammad.husaini.zulkifli@intel.com>
References: <20230209022924.24154-1-muhammad.husaini.zulkifli@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu,  9 Feb 2023 10:29:24 +0800 Muhammad Husaini Zulkifli wrote:
> V3 -> V4: Rebase to the latest tree as per requested by Anthony.
> V2 -> V3: Rework based on Leon Romanovsky's comment.

Eh. Comment from v3 apply.
