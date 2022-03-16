Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B01AF4DB3A8
	for <lists+netdev@lfdr.de>; Wed, 16 Mar 2022 15:49:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356889AbiCPOuh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Mar 2022 10:50:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356881AbiCPOue (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Mar 2022 10:50:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5690E3B574;
        Wed, 16 Mar 2022 07:49:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E594F615B4;
        Wed, 16 Mar 2022 14:49:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 982E9C340EC;
        Wed, 16 Mar 2022 14:49:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647442159;
        bh=oZ+E0tASMS+zo951CxfrtXx7IyUm5V1n5YMii3AwOqY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Q7jqjqkqx93V35an0pxHi+thWxhFjpkTR3sLs7FAIzQY1yDVHjPB8DBJxBjlCuph6
         3/5j+hzTkqJiBnMJIuqFzNEXyupyI4Sv6bjZtlKg6juI8yKrKBQiMsl/SQUv7iakMR
         IwRNK1GHSwK0AyRIJkYRWTFwIIpv4hnpOkLQ372dQJ87rQWx0W2RCwgSDfVSZ8Szzq
         viF1KPxZn07ZlCS3o5cmjKEdOBIM4Hi7WdLaBtV60nQRBsiO+bKem1OCqStv0hrSYA
         xxdexsPnucIDrmNEmjo769rZWAb86fAb+m0I9iYHgWOa+0yk4W4eW3N8QcomAp1ink
         LGBCYYYwJZeqQ==
Date:   Wed, 16 Mar 2022 10:49:15 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Jia-Ju Bai <baijiaju1990@gmail.com>,
        TOTE Robot <oslab@tsinghua.edu.cn>,
        "David S . Miller" <davem@davemloft.net>, 3chas3@gmail.com,
        linux-atm-general@lists.sourceforge.net, netdev@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 5.16 17/27] atm: firestream: check the return
 value of ioremap() in fs_init()
Message-ID: <YjH462h0dpMAE5Jp@sashalap>
References: <20220309161711.135679-1-sashal@kernel.org>
 <20220309161711.135679-17-sashal@kernel.org>
 <20220309084856.4e6ca9e1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20220309084856.4e6ca9e1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 09, 2022 at 08:48:56AM -0800, Jakub Kicinski wrote:
>On Wed,  9 Mar 2022 11:16:54 -0500 Sasha Levin wrote:
>> From: Jia-Ju Bai <baijiaju1990@gmail.com>
>>
>> [ Upstream commit d4e26aaea7f82ba884dcb4acfe689406bc092dc3 ]
>>
>> The function ioremap() in fs_init() can fail, so its return value should
>> be checked.
>
>I'd hold off on backporting the bot fixes. They break more than they
>fix.

That's why we give AUTOSEL an extra week to soak :)

-- 
Thanks,
Sasha
