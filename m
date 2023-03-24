Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 543736C8868
	for <lists+netdev@lfdr.de>; Fri, 24 Mar 2023 23:33:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232257AbjCXWdP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Mar 2023 18:33:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231843AbjCXWdO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Mar 2023 18:33:14 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBB831F4A6
        for <netdev@vger.kernel.org>; Fri, 24 Mar 2023 15:32:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 774A9B82424
        for <netdev@vger.kernel.org>; Fri, 24 Mar 2023 22:31:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAABEC4339C;
        Fri, 24 Mar 2023 22:31:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679697085;
        bh=C41qwfrxgEuNcpWCRiPXdnNBQFw4UQp0E7Kptl7l5Ro=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=GaKtpbawiDhf7nO0gb0YAxNuWfkiCWaf7BaMPQaMVRpHzGEMnsrN+dfiRxU7H/NWx
         p1l3sSnJzFN6hOnBJ8YzAlmSIATlmVNJRiIPiCWhvRV+2jmSf2RPqAN8ZCoEOhGhaW
         ntLrto4PoRBoMFkT6mq52jwUo3nCS1jVMCCD5jVdzah03hcxl9dHflnKsQSEBjvoK9
         NdXnbqCbOeYbFQduwyz4a4xvIom1OHjJQ0p1K23b5pPcg1POz1BLXUNQlXF1obEudX
         LcFcobLW8UXA1Co7UktxsRUnVzTg+a+E+cMntXgBsTHhPfXnqlS/b6ZOB5s276es6X
         ZwIx28s+4SkYg==
Date:   Fri, 24 Mar 2023 15:31:23 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Michal Michalik <michal.michalik@intel.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, pabeni@redhat.com,
        edumazet@google.com
Subject: Re: [PATCH net-next v4] tools: ynl: Add missing types to
 encode/decode
Message-ID: <20230324153123.0907c3cf@kernel.org>
In-Reply-To: <20230324175258.25145-1-michal.michalik@intel.com>
References: <20230324175258.25145-1-michal.michalik@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 24 Mar 2023 18:52:58 +0100 Michal Michalik wrote:
> While testing the tool I noticed we miss the u16 type on payload create.
> On the code inspection it turned out we miss also u64 - add them.
> 
> We also miss the decoding of u16 despite the fact `NlAttr` class
> supports it - add it.
> 
> Signed-off-by: Michal Michalik <michal.michalik@intel.com>

Acked-by: Jakub Kicinski <kuba@kernel.org>
