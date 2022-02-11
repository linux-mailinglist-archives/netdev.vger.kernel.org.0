Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D4714B2822
	for <lists+netdev@lfdr.de>; Fri, 11 Feb 2022 15:42:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350962AbiBKOmC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Feb 2022 09:42:02 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:41646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240287AbiBKOmB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Feb 2022 09:42:01 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B214188;
        Fri, 11 Feb 2022 06:41:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1926961F5F;
        Fri, 11 Feb 2022 14:41:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 528B0C340E9;
        Fri, 11 Feb 2022 14:41:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644590518;
        bh=RY+RiJqGo1HMpzgN9TFSdlD9X2lbkG4RDXWfubFeNzQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=COnpToWE0ntRobHtXfkns9r+udoebeeWlHmKqECJGBNny/lQbM8vqpX+8MArBTpcw
         uIhq4YjX0NSm0345Iq8RK+8+hsL/PbFkCIWq27Rdh9iSi5JA+u0GkiIk8XqP/SEhjk
         LBsIAx6hEt0zq2IF3iC6kGZx6phCVX2s/LVyWccUwRFoIkUOp5/exo3BJmLr/xbX2N
         zdffmTh95iNgWDI+0Nk7Ttjpq5I4o2fb/2Ii+u6XPHKhP5nW1uvpOVzBEFdRMGzXRR
         MokPDO2UuCRjjyj9LD2AbCtK0KqBGKEvr3KzoDvGqhU67nMlBnblLU0bqiRx38HKEQ
         B1e/PVDvASN9w==
Date:   Fri, 11 Feb 2022 09:41:57 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Yi Chen <yiche@redhat.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        kadlec@netfilter.org, davem@davemloft.net,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 5.16 05/52] netfilter: nf_conntrack_netbios_ns:
 fix helper module alias
Message-ID: <YgZ1tYtQ4jdb7Z4I@sashalap>
References: <20220203202947.2304-1-sashal@kernel.org>
 <20220203202947.2304-5-sashal@kernel.org>
 <20220203134622.5964eb15@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20220203222319.GB14142@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20220203222319.GB14142@breakpoint.cc>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 03, 2022 at 11:23:19PM +0100, Florian Westphal wrote:
>Jakub Kicinski <kuba@kernel.org> wrote:
>> On Thu,  3 Feb 2022 15:28:59 -0500 Sasha Levin wrote:
>> > Intentionally not adding a fixes-tag because i don't want this to go to
>> > stable.
>>
>> Ekhm. ;)
>
>Seems there is no way to hide fixes from stable guys :-)
>
>Seriously, I don't think there is anything going to break here because
>'modinfo nfct-helper-netbios_ns' and 'modinfo nfct-helper-netbios-ns'
>return same module.
>
>OTOH, this was noticed by pure coincidence; I don't think its
>important to have it in stable.

I'll drop it, thanks :)

-- 
Thanks,
Sasha
