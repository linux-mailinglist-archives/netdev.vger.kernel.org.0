Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B42F6E1332
	for <lists+netdev@lfdr.de>; Thu, 13 Apr 2023 19:10:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229821AbjDMRKT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Apr 2023 13:10:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229575AbjDMRKS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Apr 2023 13:10:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B08B1B4
        for <netdev@vger.kernel.org>; Thu, 13 Apr 2023 10:10:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 03F54611F5
        for <netdev@vger.kernel.org>; Thu, 13 Apr 2023 17:10:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01E0BC433D2;
        Thu, 13 Apr 2023 17:10:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681405816;
        bh=DCYNeAxmuuHge96cF+T/P48aPEcedlZnTQUazLAu8YM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=bzfMyVkxtxZk6LEV+LOkC3VacD+QAn0pfMm0GbgiMrksIno/KmzvaLDF5G6jH9VTt
         Ugg6YV7hKLhnXi/skiZEVubW1B1VsFxC+/Y0zc+S9EHKxYEC4XKlVUUqCW4Nx8aVkL
         7EsjAnWQAGguR/pqQOVpplN+szqpEQtUv3BxKPoShU1GQbGCUc+0bPg8HVE+ZjmXwD
         FCStN6Ho4sQW9j2rPbO5L580VLdhPXV5MHtZ21xHnHuKuthAg2jWeNMV7Pd28D21JP
         Ksx/eVKZMHoEKK7qwgDKNbmwXuxXbijf4FKjdaGwJnxOF9aBSVxHg90WsAMOX3RjOs
         4BrSCgcVp9QsQ==
Date:   Thu, 13 Apr 2023 10:10:15 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Shannon Nelson <shannon.nelson@amd.com>, brett.creeley@amd.com,
        davem@davemloft.net, netdev@vger.kernel.org, drivers@pensando.io,
        jiri@resnulli.us
Subject: Re: [PATCH v9 net-next 13/14] pds_core: publish events to the
 clients
Message-ID: <20230413101015.0427a6c8@kernel.org>
In-Reply-To: <20230413170704.GV17993@unreal>
References: <20230406234143.11318-1-shannon.nelson@amd.com>
        <20230406234143.11318-14-shannon.nelson@amd.com>
        <20230409171143.GH182481@unreal>
        <f5fbc5c7-2329-93e6-044d-7b70d96530be@amd.com>
        <20230413085501.GH17993@unreal>
        <20230413081410.2cbaf2a2@kernel.org>
        <20230413164434.GT17993@unreal>
        <20230413095509.7f15e22c@kernel.org>
        <20230413170704.GV17993@unreal>
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

On Thu, 13 Apr 2023 20:07:04 +0300 Leon Romanovsky wrote:
> > Hm, my memory may be incorrect and I didn't look at the code but 
> > I thought that knob came from the "hit-less upgrade" effort.
> > And for "hit-less upgrade" not respawning the devices was the whole
> > point.
> > 
> > Which is not to disagree with you. What I'm trying to get at is that
> > there are different types of reset which deserve different treatment.  
> 
> I don't disagree with you either, just have a feeling that proposed
> behaviour is wrong.

Shannon, can you elaborate on what the impact of the reset is?
What loss of state and/or configuration is possible?
