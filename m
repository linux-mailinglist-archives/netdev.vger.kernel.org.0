Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36B892F69CD
	for <lists+netdev@lfdr.de>; Thu, 14 Jan 2021 19:44:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726822AbhANSnR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jan 2021 13:43:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:51642 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726131AbhANSnR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 14 Jan 2021 13:43:17 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9C1C523A55;
        Thu, 14 Jan 2021 18:42:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610649756;
        bh=fBmP9/6I4s8rWa63E5u5DuL9tPglqbny3Wl9cNND3Rc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=GeXChYPZ83wti/52ovjGj7YZcxAWz2HzDS7j4t8CSAfX/HsjXgyDkxxr/OSppsP7J
         0ZYJKQdcjH1cAEaqJBhlgTB0UD1IK/I1b/DMLDiREvQJ9prMmeYzI1u2EKaxdTN87p
         KaPh8IRJODEr8I8HunFbKYuGd8WJS6xIawCNGPuy8KpsHS5QWkdHra5ReZwXymNVub
         gRA34RGCxZS1vFJxPCWZKkEH+e9nrxoIaFe4ztjXZV4tNzlbDRj+5+qzKoth5JdRYB
         6kV4h10dfCextamt/GHBIgA99Mm6IYFsuvFojYJUV6StdQFiqYF090kuimQzNVJ6p/
         LyvT9CsR5UhUg==
Date:   Thu, 14 Jan 2021 10:42:35 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Ayush Sawal <ayush.sawal@chelsio.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, secdev@chelsio.com
Subject: Re: [PATCH net] ch_ipsec: Remove initialization of rxq related data
Message-ID: <20210114104235.00a87c1a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210113044302.25522-1-ayush.sawal@chelsio.com>
References: <20210113044302.25522-1-ayush.sawal@chelsio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 13 Jan 2021 10:13:02 +0530 Ayush Sawal wrote:
> Removing initialization of nrxq and rxq_size in uld_info. As
> ipsec uses nic queues only, there is no need to create uld
> rx queues for ipsec.

Why is this a fix? Does it break something or just wastes resources?
If it's just about efficient use of resources I'll apply to net-next.
