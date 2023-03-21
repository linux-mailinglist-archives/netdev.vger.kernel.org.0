Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 13D526C2905
	for <lists+netdev@lfdr.de>; Tue, 21 Mar 2023 05:12:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229541AbjCUEMC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Mar 2023 00:12:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230259AbjCUELX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Mar 2023 00:11:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5025621283;
        Mon, 20 Mar 2023 21:08:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 072C3618CD;
        Tue, 21 Mar 2023 04:01:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5559C433D2;
        Tue, 21 Mar 2023 04:01:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679371261;
        bh=RbnGONoE1gOWA8I/bFj6idggHbyoPFRsWZDvzLLDxb8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=s1FdFxwXi83R/jjWZ8Bp6EgrFqlAOT/WgTeyZuwwcjLofuCGfpjvZV5f+qkSDy95R
         /W5POTJsXlSXiytEqMWRX5k1A/4+jVr1Z+7xOa21a0SA9qXgG/YkeQEcNP9oohWKPD
         +//0neghvQqFIz/IyP6OOJGv1HtZkC7NDbsSvkX4x1G9Q2CG7GduthoeIOWvTXJ4IE
         t3JtS6Zq+jlwn3CpIgyM2w9JwC+uxrK4mgW3BwlxQcPuL3LSmJmdT1CIj9f+R9sGa8
         YdLcg8cMYL2d5/sujBhOQwO5hADyYUc65K1MpUMwxOrHSZcrQNcv3wKkRdVe95GW+c
         lNa7k24T3+2uQ==
Date:   Mon, 20 Mar 2023 21:00:59 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     Vadim Fedorenko <vadfed@meta.com>,
        Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Vadim Fedorenko <vadim.fedorenko@linux.dev>, poros@redhat.com,
        mschmidt@redhat.com, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-clk@vger.kernel.org,
        Michal Michalik <michal.michalik@intel.com>
Subject: Re: [PATCH RFC v6 1/6] dpll: spec: Add Netlink spec in YAML
Message-ID: <20230320210059.244daae0@kernel.org>
In-Reply-To: <ZBSUBWUwC0FLlS/D@nanopsycho>
References: <20230312022807.278528-1-vadfed@meta.com>
        <20230312022807.278528-2-vadfed@meta.com>
        <ZBSUBWUwC0FLlS/D@nanopsycho>
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

On Fri, 17 Mar 2023 17:23:33 +0100 Jiri Pirko wrote:
> >+/* Ops table for dpll */
> >+static const struct genl_split_ops dpll_nl_ops[6] = {  
> 
> It's odd to see 6 here. Should by just []
> But it's an issue of Jakub's generator.

In some modes of generation the array is visible outside the source file
i.e. there's a forward declaration in the header. So I had to get the
counting right, anyway. But sure, I'll send a "fix"..
