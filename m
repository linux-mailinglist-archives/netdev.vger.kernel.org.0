Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F2582926C0
	for <lists+netdev@lfdr.de>; Mon, 19 Oct 2020 13:52:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728279AbgJSLwj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Oct 2020 07:52:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:45546 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726015AbgJSLwj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 19 Oct 2020 07:52:39 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0C6302080D;
        Mon, 19 Oct 2020 11:52:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603108358;
        bh=JnT9sHQRIZ3jZpGC9ANCu7yXrVu9WDXvQ3urEiT7Vxk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=eBN01PXE0XDenSuu6kOiyfxPJAv9vezu+f1ivm25Ec1241EK3EIHJIndkXL+8Wvv/
         IEiUi0DttLAlHXku3dDWgnrpXwdDlehYkPU280YGE808uhi/clwVc9OvlOMVCHa0Qm
         gff2Oac3+VltTgwVx4SbviQ/cZyun8Nea/Z8hdCE=
Date:   Mon, 19 Oct 2020 07:52:36 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     David Ahern <dsahern@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        netdev@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 5.9 035/111] ipv6/icmp: l3mdev: Perform icmp
 error route lookup on source device routing table (v2)
Message-ID: <20201019115236.GA4060117@sasha-vm>
References: <20201018191807.4052726-1-sashal@kernel.org>
 <20201018191807.4052726-35-sashal@kernel.org>
 <20201018124004.5f8c50a3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <842ae8c4-44ef-2005-18d5-80e00c140107@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <842ae8c4-44ef-2005-18d5-80e00c140107@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Oct 18, 2020 at 07:40:12PM -0600, David Ahern wrote:
>On 10/18/20 1:40 PM, Jakub Kicinski wrote:
>> This one got applied a few days ago, and the urgency is low so it may be
>> worth letting it see at least one -rc release ;)
>
>agreed

Definitely - AUTOSEL patches get extra soaking time before getting
queued up. This is more of a request to make sure it's not doing
anything silly.

-- 
Thanks,
Sasha
