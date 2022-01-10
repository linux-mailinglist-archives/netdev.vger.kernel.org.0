Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 362BA48A0E1
	for <lists+netdev@lfdr.de>; Mon, 10 Jan 2022 21:20:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343518AbiAJUUc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jan 2022 15:20:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241448AbiAJUUb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Jan 2022 15:20:31 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86EC8C06173F;
        Mon, 10 Jan 2022 12:20:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 23CC46136C;
        Mon, 10 Jan 2022 20:20:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C8AAC36AE9;
        Mon, 10 Jan 2022 20:20:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641846030;
        bh=6CvoGhLIrSY9W79bJED17D45fNrMnq8zcv1GM6TVH5w=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=hw5rwjVnZhPsMx6CFtsubh2qO3SYyft/eoY+ZMXfwVn5E/dhCdP3Rf13HWjYeorty
         5OEz6dLGKS+nMgYEYFKV+NDFHAFiaevKAvF11C9a05jV/AB8TJrrCNLM1ectZwjXKz
         871gtTf/otIoN/13EMWj7NDNNc4yDkJVCeW/N/BHVaDa+sKyBHjxlyfTnwi3bgBjCt
         9h7UG8OZY2GVIkE9BCQJZGDbBfK1r+rmBO88RqLrZmKNjdIGgdKQmzVZP971yBEV9c
         Gq9hmB0dUrQBg0Ql5z+E7dAm29/ypvlLoUSdrtnrJr6RhjzfzebhsETitDyN16aCru
         CdBXfTZ+mFKxA==
Date:   Mon, 10 Jan 2022 12:20:28 -0800
From:   Saeed Mahameed <saeed@kernel.org>
To:     Steffen Klassert <steffen.klassert@secunet.com>
Cc:     Raed Salem <raeds@nvidia.com>, herbert@gondor.apana.org.au,
        davem@davemloft.net, kuba@kernel.org, huyn@nvidia.com,
        saeedm@nvidia.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 net] net/xfrm: IPsec tunnel mode fix inner_ipproto
 setting in sec_path
Message-ID: <20220110202028.ll3v2yy43gx37zih@sx1>
References: <20220103111929.11563-1-raeds@nvidia.com>
 <20220106093223.GA2638190@gauss3.secunet.de>
 <20220107004726.unyuuu2qki4gskxv@sx1>
 <20220107110306.GT3272477@gauss3.secunet.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20220107110306.GT3272477@gauss3.secunet.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 07, 2022 at 12:03:06PM +0100, Steffen Klassert wrote:
>On Thu, Jan 06, 2022 at 04:47:26PM -0800, Saeed Mahameed wrote:
>> On Thu, Jan 06, 2022 at 10:32:23AM +0100, Steffen Klassert wrote:
>> > On Mon, Jan 03, 2022 at 01:19:29PM +0200, Raed Salem wrote:
>> > > The inner_ipproto saves the inner IP protocol of the plain
>> > > text packet. This allows vendor's IPsec feature making offload
>> > > decision at skb's features_check and configuring hardware at
>> > > ndo_start_xmit, current code implenetation did not handle the
>> > > case where IPsec is used in tunnel mode.
>> > >
>> > > Fix by handling the case when IPsec is used in tunnel mode by
>> > > reading the protocol of the plain text packet IP protocol.
>> > >
>> > > Fixes: fa4535238fb5 ("net/xfrm: Add inner_ipproto into sec_path")
>> > > Signed-off-by: Raed Salem <raeds@nvidia.com>
>> >
>> > Applied, thanks Raed!
>>
>> hmm, there are two mlx5 patches that depend on this patch, I thought Raed
>> was planning to send them along with this.
>>
>> Steffen, is it ok if I submit those two patches to you and so you would
>> send them all at once in your next net PR ?
>
>The pull request with that patch included is already merged into
>the net tree. So if you pull the net tree, you can apply the
>mlx5 patches yourself. But if you prefer, I can take them too.
>

Didn't know they are already in net, i will post them to net soon,
thanks !

