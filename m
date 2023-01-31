Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 403F4683633
	for <lists+netdev@lfdr.de>; Tue, 31 Jan 2023 20:12:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230295AbjAaTMV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Jan 2023 14:12:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230306AbjAaTMT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Jan 2023 14:12:19 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B21F456490
        for <netdev@vger.kernel.org>; Tue, 31 Jan 2023 11:11:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 63591B81E3B
        for <netdev@vger.kernel.org>; Tue, 31 Jan 2023 19:11:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2045C433D2;
        Tue, 31 Jan 2023 19:11:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675192317;
        bh=wFxmLnpBqIFP8bY8MbUFOLTpD00oM5wLOM3MfGeTgj4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=R1BjmzRrgEFgvp09f22OEKxHFSRWzrnADV0WaWWjj0tM8Gm2wRKf1lzKtbYAIRoWx
         c9CTVmGoSjBs7vBr/IjlJ+iBboUe4gMDbN1waO8LT/zJYBFttqacVLEpSMI8E7hiwv
         HETltLzZC6HpR49iROxFZihOgqe6xIFhegEcPxn19SrawE82jaHkk58tPKXG+YLg7b
         Iob9gFSXEpzJqxpP/OHzVcWh70+QsSSsYoDogq4ywPd5hHbKx50WVmmqzVJQJG+u5J
         YgkkQ8VcqcbAfl/+F0ax/7kBz8SDYKbJ8eULmScL2quUjNzqJu44Z/piIG/h2wjSWZ
         QQNQPp+wSJv2w==
Date:   Tue, 31 Jan 2023 11:11:55 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Raju Rangoju <Raju.Rangoju@amd.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        pabeni@redhat.com, Shyam-sundar.S-k@amd.com
Subject: Re: [PATCH net-next 2/2] amd-xgbe: add support for rx-adaptation
Message-ID: <20230131111155.5cb607a6@kernel.org>
In-Reply-To: <c1ddd073-2494-9c8a-0f61-8330d7d6bb0c@amd.com>
References: <20230125072529.2222420-1-Raju.Rangoju@amd.com>
        <20230125072529.2222420-3-Raju.Rangoju@amd.com>
        <20230125230410.79342e6a@kernel.org>
        <f4a2cd5d-7d36-6f4d-6012-7e4e87d44d7c@amd.com>
        <c1ddd073-2494-9c8a-0f61-8330d7d6bb0c@amd.com>
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

On Tue, 31 Jan 2023 15:26:14 +0530 Raju Rangoju wrote:
> > Sure, I've re-ordered most of the functions correctly to avoid forward 
> > declarations. However, there is circular dependency on couple of them. 
> > Let us know if its fine to have forward declaration for the functions 
> > that have circular-dependency.  
> 
> Gentle reminder!
> 
> Let us know if it is okay to have forward declarations for functions 
> that have circular dependency.

Yes, in case of circular dependencies there's not much we can do.
