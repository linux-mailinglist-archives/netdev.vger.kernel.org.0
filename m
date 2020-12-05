Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 151072CFD25
	for <lists+netdev@lfdr.de>; Sat,  5 Dec 2020 19:52:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729556AbgLESTe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Dec 2020 13:19:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:46154 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728204AbgLESBO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 5 Dec 2020 13:01:14 -0500
Date:   Sat, 5 Dec 2020 10:00:30 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607191232;
        bh=uck9HMwEih3IHUnkTrO3IT7M00NIKjBuKnwsqXY/FF0=;
        h=From:To:Cc:Subject:In-Reply-To:References:From;
        b=vGXa3vuIOQSvYx0qhBXENKVePy6swpuQ0v8UpV6bZ70Ti4yDrGpGuN0MffvaKmq7u
         p5jl/FNf0PLft9vGobcXS8FYmNhQ1ahgIU3kOWpe+qJGf5WGjzVsvWAK6m4h0gI115
         XihWUEKr9tNDVVgTzrFMd9e0nxZdGm3Na/ASuktD3nMmAvFzBbOhMsHo6ttbgw0ZAO
         xiW5mHqkLy4OjGqG6MmZSuY9s8ea2XOzYRhWMJMtDZ+UuKmQVs4Ewr2IFb7WeNTCX3
         z/9IWypo7jqt77IyFvUu/xase+SInI1+JtaQJ7Yp+EQjDHss88DEs8fFMh1ioRXm2K
         UW3YUPN2SLu/w==
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vinicius Costa Gomes <vinicius.gomes@intel.com>
Cc:     netdev@vger.kernel.org, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        jiri@resnulli.us, m-karicheri2@ti.com, vladimir.oltean@nxp.com,
        Jose.Abreu@synopsys.com, po.liu@nxp.com,
        intel-wired-lan@lists.osuosl.org, anthony.l.nguyen@intel.com
Subject: Re: [PATCH net-next v1 6/9] igc: Add support for tuning frame
 preemption via ethtool
Message-ID: <20201205100030.2e3c5dd2@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
In-Reply-To: <20201202045325.3254757-7-vinicius.gomes@intel.com>
References: <20201202045325.3254757-1-vinicius.gomes@intel.com>
        <20201202045325.3254757-7-vinicius.gomes@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue,  1 Dec 2020 20:53:22 -0800 Vinicius Costa Gomes wrote:
> The tc subsystem sets which queues are marked as preemptible, it's the
> role of ethtool to control more hardware specific parameters. These
> parameters include:
> 
>  - enabling the frame preemption hardware: As enabling frame
>  preemption may have other requirements before it can be enabled, it's
>  exposed via the ethtool API;
> 
>  - mininum fragment size multiplier: expressed in usually in the form
>  of (1 + N)*64, this number indicates what's the size of the minimum
>  fragment that can be preempted.
> 
> Signed-off-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>

WARNING: 'PREEMPTABLE' may be misspelled - perhaps 'PREEMPTIBLE'?
