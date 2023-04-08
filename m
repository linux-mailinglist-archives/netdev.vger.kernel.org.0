Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9CA6D6DB893
	for <lists+netdev@lfdr.de>; Sat,  8 Apr 2023 05:21:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229931AbjDHDVQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Apr 2023 23:21:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229973AbjDHDVA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Apr 2023 23:21:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 052D5D508;
        Fri,  7 Apr 2023 20:20:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 94BB7611EE;
        Sat,  8 Apr 2023 03:20:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61F4AC433D2;
        Sat,  8 Apr 2023 03:20:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680924058;
        bh=4tz+Y7AStFIssVMMwG3wbNmFjM/3VYC5QrEq0DdskkY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=D6WapE0r4yDAWQkXzJhh23qiyGB8T/+p32cpbChBnMPkatl407uBldvhjCO4mICFw
         Rum1mWODnTj4Yt0RAlJrnkekmDa/e61yVTGxeQFNtlSX8ppolepI/5vnQdLfm9e1AB
         BcaauGlRoQ3WF0hJUdrP1EHsGsULlhM4+Vnf23xtA0rWDNkr6/VY4yDcDCSxkT55K1
         sCxF2mAsrxKK3w+NWtKWPShWHZ/kZ7xq2OWfed8Kx6kPQ9ac9hyBxDWKUzP4d09xk9
         EsEfVczxzoIRHdb3qn2B1oox5D8I+frjsX2t+7n/m1n6XBRbOYGeBeUCQSCfOM8gg3
         Od+zeXEP07mJA==
Date:   Fri, 7 Apr 2023 20:20:56 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Gautam Dawar <gautam.dawar@amd.com>
Cc:     <linux-net-drivers@amd.com>, <jasowang@redhat.com>,
        Edward Cree <ecree.xilinx@gmail.com>,
        Martin Habets <habetsm.xilinx@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Richard Cochran <richardcochran@gmail.com>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <eperezma@redhat.com>, <harpreet.anand@amd.com>,
        <tanuj.kamde@amd.com>, <koushik.dutta@amd.com>
Subject: Re: [PATCH net-next v4 09/14] sfc: implement device status related
 vdpa config operations
Message-ID: <20230407202056.366ad15c@kernel.org>
In-Reply-To: <20230407081021.30952-10-gautam.dawar@amd.com>
References: <20230407081021.30952-1-gautam.dawar@amd.com>
        <20230407081021.30952-10-gautam.dawar@amd.com>
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

On Fri, 7 Apr 2023 13:40:10 +0530 Gautam Dawar wrote:
> vDPA config opertions to handle get/set device status and device
> reset have been implemented. Also .suspend config operation is
> implemented to support Live Migration.

drivers/net/ethernet/sfc/ef100_vdpa.h:65: warning: Enum value 'EF100_VDPA_STATE_SUSPENDED' not described in enum 'ef100_vdpa_nic_state'
