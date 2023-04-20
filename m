Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 63BEC6E875C
	for <lists+netdev@lfdr.de>; Thu, 20 Apr 2023 03:20:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232503AbjDTBUG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Apr 2023 21:20:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230335AbjDTBUE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Apr 2023 21:20:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A476B49C4;
        Wed, 19 Apr 2023 18:20:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 32D5163BBE;
        Thu, 20 Apr 2023 01:20:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4AECCC433D2;
        Thu, 20 Apr 2023 01:20:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681953602;
        bh=AAD1RNUoCDTsOM9AZWqShakrG5fkFpKVZkDdmRFoae4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ZClINHvv3DYhwAZg+qL9fQSYNdIdqAIx1TG9Nz41Hm5J52gEMCjX2tP3hcSt8LgKr
         lwRaWVURc5dVq2YQIjunvSSMcOkXA0HKOQL8siILioVGHmS2jq6dqpa9XFKlFYvppP
         Mz9Ymhq/h0nbC0eh0ZErcSWIY4GsDPB4a04gYg0MUcZA2RyA3oPfgisJlcwgV8HZql
         M5lzL9vOkT6rhmbtkBPQKqQITtyb0GaiQhHBvpCAjf2BRQJapTxD4zoZhysKO+CLH9
         rNRyRcDovqjVL2280iS2jfXjAa+eGXDBCMm7g9sSl310Rkw9VQd6n55ZCpgs1eegAV
         SX4baLuMq+UIw==
Date:   Wed, 19 Apr 2023 18:20:01 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     Xin Long <lucien.xin@gmail.com>,
        network dev <netdev@vger.kernel.org>,
        linux-sctp@vger.kernel.org, davem@davemloft.net,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Subject: Re: [PATCH net-next 2/6] sctp: delete the nested flexible array
 skip
Message-ID: <20230419182001.7fe64d29@kernel.org>
In-Reply-To: <20230419083125.308b8732@hermes.local>
References: <cover.1681917361.git.lucien.xin@gmail.com>
        <48a8d405dd4d81f7be75b7f39685e090867d858b.1681917361.git.lucien.xin@gmail.com>
        <20230419083125.308b8732@hermes.local>
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

On Wed, 19 Apr 2023 08:31:25 -0700 Stephen Hemminger wrote:
> >  struct sctp_fwdtsn_hdr {
> >  	__be32 new_cum_tsn;
> > -	struct sctp_fwdtsn_skip skip[];
> > +	/* struct sctp_fwdtsn_skip skip[]; */
> >  };
> >    
> 
> Why leave the old structure in comments.
> Remove unused code and data structures please.

Did you see the note in the cover letter?
Is there any reason why this is not an acceptable way of documenting
what follows?
