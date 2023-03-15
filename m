Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5FA9B6BA9A5
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 08:45:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231340AbjCOHpn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 03:45:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231398AbjCOHpi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 03:45:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B68D126C4
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 00:45:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9ABE461B6F
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 07:45:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A0BBC433D2;
        Wed, 15 Mar 2023 07:45:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678866334;
        bh=Ei2dErapvQcli7gRxMm6FH7ptK6JI23BZRVcrNo46J8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=IwJQA1mAFXgdaV3EcwB39OPKhp5fu0xUIFmZCmjHkTBBeK3ZcNgtXa4SPBTjUwWp0
         6fCOsO0a9+pRBLZHoI+KQEPtsnqS5Z7doTa1Qbq1z0UDdDbf/v9zaiwaj06RMOQqh8
         PJ4QHRYqqRJ5r+WSCSkkQN+nbDq6k/1SfOrMyXfzi7bZ8tfGVnpWH8KPgV/bRF2kFQ
         wQP8PCCwDp4BqMUy/12KxwhMNH6kfpGjrzibzum8iRdmL8aLtIu/2Lw/0mwYCit8qY
         fRJAFIURxl2iXDCysG2JU1KgeQkYcJEbeFL9BGGDe3ZOgLv+e1LSz95Xi69SHVWEJZ
         kHBF88FUfrXLQ==
Date:   Wed, 15 Mar 2023 00:45:32 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Hangbin Liu <liuhangbin@gmail.com>
Cc:     netdev@vger.kernel.org, Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        David Ahern <dsahern@kernel.org>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Davide Caratti <dcaratti@redhat.com>,
        Pedro Tammela <pctammela@mojatatu.com>,
        Marcelo Leitner <mleitner@redhat.com>,
        Phil Sutter <psutter@redhat.com>
Subject: Re: [PATCH net 2/2] net/sched: act_api: add specific EXT_WARN_MSG
 for tc action
Message-ID: <20230315004532.60fb0a41@kernel.org>
In-Reply-To: <20230314065802.1532741-3-liuhangbin@gmail.com>
References: <20230314065802.1532741-1-liuhangbin@gmail.com>
        <20230314065802.1532741-3-liuhangbin@gmail.com>
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

On Tue, 14 Mar 2023 14:58:02 +0800 Hangbin Liu wrote:
> --- a/include/uapi/linux/rtnetlink.h
> +++ b/include/uapi/linux/rtnetlink.h
> @@ -789,6 +789,7 @@ enum {
>  	TCA_ROOT_FLAGS,
>  	TCA_ROOT_COUNT,
>  	TCA_ROOT_TIME_DELTA, /* in msecs */
> +	TCA_ACT_EXT_WARN_MSG,

Not TCA_ROOT_EXT_... ?
All other attrs in this set are called TCA_ROOT_x

>  	__TCA_ROOT_MAX,
>  #define	TCA_ROOT_MAX (__TCA_ROOT_MAX - 1)
