Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A65F35BECE3
	for <lists+netdev@lfdr.de>; Tue, 20 Sep 2022 20:36:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230307AbiITSg2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Sep 2022 14:36:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230218AbiITSg1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Sep 2022 14:36:27 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 109505E32B;
        Tue, 20 Sep 2022 11:36:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9BB0CB81665;
        Tue, 20 Sep 2022 18:36:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 016C4C433C1;
        Tue, 20 Sep 2022 18:36:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663698984;
        bh=j06Czh6fa3r451X6L5qEQHRqs8sdGXQ7HkWUYOH22c8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=gu4/i48+XxWPr1uruu55gEbwTWHJlH+OG28dQQm/ENFadcXowBBkssb6Vch85U07v
         FC3Wu23m7IyrejC2Y/rmkPW/6t2YQx8bLJ/zF/iEpTQ0qIhfswzGC0/HYVUI3GLlOq
         7mwoc8ULpUamqtWtggk9WflM3sTQCQTaEtPJcBNRF0Rq1xWxl5thXLDSbT9zlTStKQ
         h8MNWmtgOkrVMJBENQnFIfci3FfuSNkK0CRhPmer2LG5SxhAGgkIF0FgRjxD14+haW
         Y2P2DK3sVTDIP99CkHVXq/3H35R6vuXvUdZBYxs9o7yg85ThSceuu8+MHzYw1MqRdE
         /lrhERQqzZ6OQ==
Date:   Tue, 20 Sep 2022 11:36:23 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Li Zhong <floridsleeves@gmail.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        intel-wired-lan@lists.osuosl.org, pabeni@redhat.com,
        edumazet@google.com, davem@davemloft.net,
        anthony.l.nguyen@intel.com, jesse.brandeburg@intel.com
Subject: Re: [PATCH v2] drivers/net/ethernet/intel/e100: check the return
 value of e100_exec_cmd()
Message-ID: <20220920113623.2f041e80@kernel.org>
In-Reply-To: <20220917001027.3799634-1-floridsleeves@gmail.com>
References: <20220917001027.3799634-1-floridsleeves@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 16 Sep 2022 17:10:27 -0700 Li Zhong wrote:
> Check the return value of e100_exec_cmd() which could return error code
> when execution fails.

You need to provide more detailed analysis in the commit message.
Right now it looks like you're just blindly finding cases where
return value is not checked and adding error checks. This is as
likely to fix something as it is to break.
