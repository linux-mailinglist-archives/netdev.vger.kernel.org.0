Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5221459CDF4
	for <lists+netdev@lfdr.de>; Tue, 23 Aug 2022 03:39:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239347AbiHWBi1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Aug 2022 21:38:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236822AbiHWBi0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Aug 2022 21:38:26 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44FE764FE
        for <netdev@vger.kernel.org>; Mon, 22 Aug 2022 18:38:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A301EB81257
        for <netdev@vger.kernel.org>; Tue, 23 Aug 2022 01:38:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D18EDC433C1;
        Tue, 23 Aug 2022 01:38:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661218701;
        bh=PWJI9f8/lsEk14Uv9fCXZxWWI+HwSKBSrUNt8XQq2/0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ZwYa+GnHXRun1CfqpjoNK1G4B2Eszlpr540qNu4F39IHlC2ICN+sFMnv8u9CnvRl+
         TRZCx1FVKlN2wiSzkJbJNRp6aunhfGhkhWV9cnwDBPGfgVHvTDfYe6onpOe9NmOhXt
         +OTXGi+PxyqCkMxjgckHJP+Qn1NX+8vXDZ7Gx7yGDy/ojyUMM1SvrLixkploqgg+oH
         xSwxSkDIn0KYuaXhfaocwf0rE0dgm7MeQV3Gl0Bhf81OmmD6dl2FO4rV/LhmEQ7PIB
         gS3/9TuNW1mxQgIw5fEWkQa37SlYInIp4M39g7Vmw+2suQ1VrTMumXYLqGud4fc0x+
         7Sn4ZI4W2tx3g==
Date:   Mon, 22 Aug 2022 18:38:19 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Aaron Conole <aconole@redhat.com>
Cc:     Andrey Zhadchenko <andrey.zhadchenko@virtuozzo.com>,
        netdev@vger.kernel.org, dev@openvswitch.org, pshelar@ovn.org,
        davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        ptikhomirov@virtuozzo.com, alexander.mikhalitsyn@virtuozzo.com,
        avagin@google.com, brauner@kernel.org, mark.d.gray@redhat.com,
        i.maximets@ovn.org
Subject: Re: [PATCH net-next v2 2/3] openvswitch: fix memory leak at failed
 datapath creation
Message-ID: <20220822183819.2a599741@kernel.org>
In-Reply-To: <f7tzgfwmobr.fsf@redhat.com>
References: <20220819153044.423233-1-andrey.zhadchenko@virtuozzo.com>
        <20220819153044.423233-3-andrey.zhadchenko@virtuozzo.com>
        <f7tzgfwmobr.fsf@redhat.com>
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

On Mon, 22 Aug 2022 08:53:44 -0400 Aaron Conole wrote:
> Thanks for this patch.  I guess independent of this series, this patch
> should be applied to the net tree as well - it fixes an existing issue.

Yes, please, this needs to be reposted separately as [PATCH net].
