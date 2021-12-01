Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 281CD464508
	for <lists+netdev@lfdr.de>; Wed,  1 Dec 2021 03:45:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346219AbhLACsn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Nov 2021 21:48:43 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:59748 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234763AbhLACsm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Nov 2021 21:48:42 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E6ABDB81DD3;
        Wed,  1 Dec 2021 02:45:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07DD5C53FC7;
        Wed,  1 Dec 2021 02:45:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638326720;
        bh=c7hJ9HIoELtKP6OKUj1vtcydNI3UfAgZbDNjwfxHPuY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Hpab0wjPbIMJ2G/7bv4j3z2vi7TEKBKl/jr5GrRPnYVuHUABVGtsaVbVj4qszg0ce
         TsDGHcLgyUCgtRTeNM62KJbGLNzCGnFQd+oM/52xIS02IYusV5/tyL1mmaCgWhgIu7
         PnR8LvAFOd5jq9YGYABmXlGZleVY82CQeQXH1Ex7d2wT1IX1Zt2LRbFlaKD+81Tmdv
         Sz2Cbd1LqaAVjnmoatn2HmUYPE53Pq/6P+53lKPDbAmObTVYa2dq6whfa9Zaan1AXf
         F3ZPxQo/LQAt2lZ65061cap4ga7V6NGWlujrqsWfoahb07AwZVQz6EpjWbh+y3a86T
         KNVAJIV37ExiQ==
Date:   Tue, 30 Nov 2021 18:45:18 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Xiaoliang Yang <xiaoliang.yang_1@nxp.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, qiangqing.zhang@nxp.com,
        peppe.cavallaro@st.com, alexandre.torgue@foss.st.com,
        joabreu@synopsys.com, yannick.vignon@nxp.com,
        boon.leong.ong@intel.com, Jose.Abreu@synopsys.com, mst@redhat.com,
        Joao.Pinto@synopsys.com, mingkai.hu@nxp.com, leoyang.li@nxp.com
Subject: Re: [PATCH net-next 1/2] arm64: dts: imx8mp-evk: configure multiple
 queues on eqos
Message-ID: <20211130184518.5d221cdd@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211201014705.6975-2-xiaoliang.yang_1@nxp.com>
References: <20211201014705.6975-1-xiaoliang.yang_1@nxp.com>
        <20211201014705.6975-2-xiaoliang.yang_1@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed,  1 Dec 2021 09:47:04 +0800 Xiaoliang Yang wrote:
> Eqos ethernet support five queues on hardware, enable these queues and
> configure the priority of each queue. Uses Strict Priority as scheduling
> algorithms to ensure that the TSN function works.

I believe you need to CC Rob on DT changes?
