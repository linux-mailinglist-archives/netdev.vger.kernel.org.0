Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49A4B485B7C
	for <lists+netdev@lfdr.de>; Wed,  5 Jan 2022 23:16:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244804AbiAEWQG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jan 2022 17:16:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244799AbiAEWQD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jan 2022 17:16:03 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A601BC061245;
        Wed,  5 Jan 2022 14:16:02 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 67563B81E1E;
        Wed,  5 Jan 2022 22:16:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7814CC36AEB;
        Wed,  5 Jan 2022 22:15:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641420960;
        bh=/5CdrMGqcvmU2fXVGxsl475sKEqFdt3t9MSe6vFuV6E=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=EkRLrlKUx5x/oHZteV1HeI3DpVdOdVR3RFLhig619mLJByBsjVbWJUFkK3M40BDvF
         R8qngirWQbCAIF3YDTV+S1vJbQWe75gbV+5XnObwvtzwCFUmEYCVxt3LfFmwtz7cwO
         1q/D6lvwJinmok3qulNQXKvxlBMDYlUSsCp7AXyVmvDUlUVSHqVIVnP5PZi2xys3M9
         akpdZTanES1Tuv3nwcXoCA1TLxyEiUFRWSKP4gWenqhfzGKky7vQiHYERLnyS6in7r
         wqr/q9XuHP+OG0J1JR4NaiGnhXW4mCICllRnqb8KSQznVXxMUcWanJL4Qlm/xmuV3C
         SgtDHC7SENWbQ==
Date:   Wed, 5 Jan 2022 14:15:58 -0800
From:   Saeed Mahameed <saeed@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        Abdul Haleem <abdhalee@linux.vnet.ibm.com>,
        jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        saeedm@nvidia.com, leon@kernel.org,
        intel-wired-lan@lists.osuosl.org, linux-rdma@vger.kernel.org,
        bpf@vger.kernel.org
Subject: Re: [PATCH net-next] net: fixup build after bpf header changes
Message-ID: <20220105221558.53bxq4q3jdch4wxa@sx1>
References: <20220104034827.1564167-1-kuba@kernel.org>
 <20220104072411.esukmdx7sy3milmx@sx1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20220104072411.esukmdx7sy3milmx@sx1>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 03, 2022 at 11:24:11PM -0800, Saeed Mahameed wrote:
>On Mon, Jan 03, 2022 at 07:48:27PM -0800, Jakub Kicinski wrote:
>>Recent bpf-next merge brought in header changes which uncovered
>>includes missing in net-next which were not present in bpf-next.
>>Build problems happen only on less-popular arches like hppa,
>>sparc, alpha etc.
>>
>>I could repro the build problem with ice but not the mlx5 problem
>>Abdul was reporting. mlx5 does look like it should include filter.h,
>>anyway.
>>
>
>I got an internal report on the same thing also, but I couldn't repro
>myself neither, I will ask them to test your patch.
>

The patch seems to have fixed the issue.
Thanks.
