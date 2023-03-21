Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 95EC86C2858
	for <lists+netdev@lfdr.de>; Tue, 21 Mar 2023 03:54:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229657AbjCUCyN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Mar 2023 22:54:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229511AbjCUCyM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Mar 2023 22:54:12 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D9798A77
        for <netdev@vger.kernel.org>; Mon, 20 Mar 2023 19:54:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 160AE618EB
        for <netdev@vger.kernel.org>; Tue, 21 Mar 2023 02:54:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C2E8C433D2;
        Tue, 21 Mar 2023 02:54:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679367248;
        bh=+e8NPxp91HzoORgKcFaDNZq+OCICLaEsyOkrdkmV858=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=cvtpVte1Bq2O1H51wJAr0TJC1lncntArPTEldYI7YO/nh5cLlHouyeZanN2wUYxcN
         h+TGoXtfiJX2kG3+7sGiIfM0vWGCD+m3XxdQpC52oJNYwupkn0KFbuDM7jCxkps2QU
         H10i5R7UqDSltrdzWvaRlC/LLo2DQOta5YIbIewBPK9I4fApI1u0Bbp1+/32+qX7eN
         tTBGmKGUcp4J1E+VlNRmXVdfElgM1cBd7jRRCKzQcnjhBOt8i9YbUwY+LLw8hsBCrG
         xwxnooXJvZdK67s2vN5JldtcJ/KNaoh02X48tPUQ+N7IshE6FPKDE6HPuNUfoSdAzh
         qYtNX5z/7Qikg==
Date:   Mon, 20 Mar 2023 19:54:07 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Davide Caratti <dcaratti@redhat.com>
Cc:     Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ilya Maximets <i.maximets@ovn.org>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 2/2] net/sched: act_tunnel_key: add support for
 "don't fragment"
Message-ID: <20230320195407.69ac5e2c@kernel.org>
In-Reply-To: <13672bdb258d2f261ef233033437f1034995785b.1679312049.git.dcaratti@redhat.com>
References: <cover.1679312049.git.dcaratti@redhat.com>
        <13672bdb258d2f261ef233033437f1034995785b.1679312049.git.dcaratti@redhat.com>
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

On Mon, 20 Mar 2023 12:44:55 +0100 Davide Caratti wrote:
>  .../selftests/net/forwarding/tc_tunnel_key.sh | 161 ++++++++++++++++++

Ah, and make sure to include the script in the Makefile so it's
actually run.
