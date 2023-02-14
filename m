Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D8F6C6971BF
	for <lists+netdev@lfdr.de>; Wed, 15 Feb 2023 00:22:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232785AbjBNXWI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Feb 2023 18:22:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231843AbjBNXWH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Feb 2023 18:22:07 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CCA422003
        for <netdev@vger.kernel.org>; Tue, 14 Feb 2023 15:22:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E230FB81F53
        for <netdev@vger.kernel.org>; Tue, 14 Feb 2023 23:22:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5861DC433D2;
        Tue, 14 Feb 2023 23:22:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676416924;
        bh=/ymdliqKuo5JxhQIjHsGpGM0euvQGWeI1VARy+d0Dy0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=XrtZvUVXwB1gnynyNVTmp46jrtoiXkvVvieEebS3uDtENrEQpfFlxT/Dpa9xvi3uI
         1HVbbLuz8CTGO1TvVii3fcF/WWCfBryEjDU4OeznOVYk8lRH6Bc7exptln2zCjcmO4
         jrG2pQ5r5LoXxQAIftHBXPB2XlCEVDM1eBFrvPuerUKBXk+Wb96YLgYcghh8er4hWA
         WdfAXkbUpCPl996xAS3mj+c5DLgtUutuHOhW1eu+Y8lGf3p+PxqtqiDUpR40n4c2qs
         c+9gnnh0jdSLfdkKzYZSLshbUXIZYHYEV1AqML/d0BPsZNgbuoaDeQh84K8h4Hqk0+
         h1F05zaouLr6Q==
Date:   Tue, 14 Feb 2023 15:22:03 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jamal Hadi Salim <jhs@mojatatu.com>
Cc:     Jiri Pirko <jiri@resnulli.us>, netdev@vger.kernel.org,
        xiyou.wangcong@gmail.com, davem@davemloft.net, edumazet@google.com,
        pabeni@redhat.com, stephen@networkplumber.org, dsahern@gmail.com
Subject: Re: [PATCH net-next 0/5] net/sched: Retire some tc qdiscs and
 classifiers
Message-ID: <20230214152203.6ba83960@kernel.org>
In-Reply-To: <CAM0EoM=gOFgSufjrX=+Qwe6x9KN=PkBaDLBZqxeKDktCy=R=sw@mail.gmail.com>
References: <20230214134915.199004-1-jhs@mojatatu.com>
        <Y+uZ5LLX8HugO/5+@nanopsycho>
        <20230214134013.0ad390dd@kernel.org>
        <20230214134101.702e9cdf@kernel.org>
        <CAM0EoM=gOFgSufjrX=+Qwe6x9KN=PkBaDLBZqxeKDktCy=R=sw@mail.gmail.com>
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

On Tue, 14 Feb 2023 18:05:23 -0500 Jamal Hadi Salim wrote:
> Looking at that code - the user is keeping their own copy of the uapi
> and listening to generated events from the kernel.

I searched the repo for TCA_TCINDEX_CLASSID - I don't see the local
copy of the header. Can you point me?
