Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDB9B486F08
	for <lists+netdev@lfdr.de>; Fri,  7 Jan 2022 01:47:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344143AbiAGAr3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jan 2022 19:47:29 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:40460 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343865AbiAGAr3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jan 2022 19:47:29 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BD29E61E99;
        Fri,  7 Jan 2022 00:47:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADD01C36AE0;
        Fri,  7 Jan 2022 00:47:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641516448;
        bh=8p9BpQCyT+mTWl/nJuQq7NeCOFByrwMQgbTqOh8G2QY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=pb8ILdnPmZqBloMWXDnBasqpgafZM9dks1NC1zEUs369NDrPfFApjRxeXrTfvtTp2
         93j/T8r1lL25IKxHSOAPSpB0hb2uNh6J9flCgmiuObyQKbxsqAqaSgt9GqwYR+Ffgf
         Lc1DjrPE4U8LmEUc5WJr7CjaC/UB4NaAd+go9NKPSgmnNRuEXzezkfybvBmVGBV3zl
         5Loi5UqCnev+Pt1xaH8DOuIsrY6PsjWGFAx79hxEz3RIm2RsAjO9cvpC44WWmDTI1y
         +lGycDs3MMfIS7lgvAhx7Qvt9LNYZHrEpLbiLp6ASGgrW15GSBQWy+8R/+3NBvj2Zc
         b3S2k/wxwabmg==
Date:   Thu, 6 Jan 2022 16:47:26 -0800
From:   Saeed Mahameed <saeed@kernel.org>
To:     Steffen Klassert <steffen.klassert@secunet.com>
Cc:     Raed Salem <raeds@nvidia.com>, herbert@gondor.apana.org.au,
        davem@davemloft.net, kuba@kernel.org, huyn@nvidia.com,
        saeedm@nvidia.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 net] net/xfrm: IPsec tunnel mode fix inner_ipproto
 setting in sec_path
Message-ID: <20220107004726.unyuuu2qki4gskxv@sx1>
References: <20220103111929.11563-1-raeds@nvidia.com>
 <20220106093223.GA2638190@gauss3.secunet.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20220106093223.GA2638190@gauss3.secunet.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 06, 2022 at 10:32:23AM +0100, Steffen Klassert wrote:
>On Mon, Jan 03, 2022 at 01:19:29PM +0200, Raed Salem wrote:
>> The inner_ipproto saves the inner IP protocol of the plain
>> text packet. This allows vendor's IPsec feature making offload
>> decision at skb's features_check and configuring hardware at
>> ndo_start_xmit, current code implenetation did not handle the
>> case where IPsec is used in tunnel mode.
>>
>> Fix by handling the case when IPsec is used in tunnel mode by
>> reading the protocol of the plain text packet IP protocol.
>>
>> Fixes: fa4535238fb5 ("net/xfrm: Add inner_ipproto into sec_path")
>> Signed-off-by: Raed Salem <raeds@nvidia.com>
>
>Applied, thanks Raed!

hmm, there are two mlx5 patches that depend on this patch, I thought Raed
was planning to send them along with this.

Steffen, is it ok if I submit those two patches to you and so you would
send them all at once in your next net PR ?

Thanks,
Saeed.

