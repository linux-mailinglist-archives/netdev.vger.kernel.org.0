Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D7735809AE
	for <lists+netdev@lfdr.de>; Tue, 26 Jul 2022 04:54:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235723AbiGZCyC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jul 2022 22:54:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231724AbiGZCyB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jul 2022 22:54:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E0ED63C0;
        Mon, 25 Jul 2022 19:54:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 51DCC614E6;
        Tue, 26 Jul 2022 02:54:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B35BC341C6;
        Tue, 26 Jul 2022 02:53:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658804039;
        bh=VAwM0Pukcei9J+HLXOrH7tgP0PnsOl9w/ECuXeSfQCY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=nXV1tOduPvxTFYnv5fQcSFpPmueFO9M4S3LwPvnShrcHqIWC3R0vPCVQKAK2jQLmT
         d2GTMTuAfSycaeiuTp9PsaWFmykUNvj9ZacinvLzSEDAqS9rdxZFoZSHWUiiID3edX
         czRII5wq+i/oKFjNCjSTY8zJJIZVMM2jYxxMeX898msaWVOoZGVici82HLxWUyHpN0
         jXkDmHMJH65idgY9BzO5o0SRDtZQiKIHMn7NJ0gjUWPp9vW13DpW8a4Sk1wBF1h3il
         DSj5FcGzOTFZ0qMI6UzNJfwKG0cuBgfcLYhZgHB/XVrJbaOWrtBtwRUda+6KCYJTVq
         MzEtMBs1BeQcg==
Date:   Mon, 25 Jul 2022 19:53:58 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jacob Keller <jacob.e.keller@intel.com>
Cc:     netdev@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        Jiri Pirko <jiri@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        David Ahern <dsahern@kernel.org>,
        Stephen Hemminger <stephen@networkplumber.org>,
        linux-doc@vger.kernel.org
Subject: Re: [net-next v3 2/4] devlink: add dry run attribute to flash
 update
Message-ID: <20220725195358.05dbbd49@kernel.org>
In-Reply-To: <20220725205629.3993766-3-jacob.e.keller@intel.com>
References: <20220725205629.3993766-1-jacob.e.keller@intel.com>
        <20220725205629.3993766-3-jacob.e.keller@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 25 Jul 2022 13:56:27 -0700 Jacob Keller wrote:
> +		NL_SET_ERR_MSG_ATTR(info->extack, nla_dry_run,

nla_dry_run is not initialized now (credit: clang)
