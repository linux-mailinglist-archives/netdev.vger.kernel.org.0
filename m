Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C294A2CF7C0
	for <lists+netdev@lfdr.de>; Sat,  5 Dec 2020 01:04:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726171AbgLEACE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Dec 2020 19:02:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:45280 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725847AbgLEACD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 4 Dec 2020 19:02:03 -0500
Date:   Fri, 4 Dec 2020 16:01:22 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607126483;
        bh=23qVClDHPV1oFidF0DV8I2U4DCbmedJxl7OOwMjZhos=;
        h=From:To:Cc:Subject:In-Reply-To:References:From;
        b=kc8MYwXhcKbLPmP6o645WNrYAdJGWIrQ/enZQwpF8MQ1yMiY9GnnVaj6MiuWdysa8
         bUJhBtIPgjX7pBV3h/TtBpX4rmAR/fiMBjuZ+Fe7Tt9NGeRYR4AbOQe1iPQfKbaiNG
         g+A7BpNja4UOIVyqqsI3m5H5N+JVhHEQK0tqoIW4fHI9ahKR9/Gbw7H0t3Qln6aiIT
         XHnit0pidFxKdRgkHo22QY5g7/9+p1nGWAutSfpNplR8i6hnKFWGFEmIDifzseyVDN
         P/2a03khiUyEpNNKygQUj252+SF4jqpW+gAd2Jte14mzQiSBOkm0sg0GgIPFO4tpnp
         TBFtM91tYCMjw==
From:   Jakub Kicinski <kuba@kernel.org>
To:     Simon Horman <simon.horman@netronome.com>
Cc:     David Miller <davem@davemloft.net>,
        Louis Peens <louis.peens@netronome.com>,
        netdev@vger.kernel.org, oss-drivers@netronome.com,
        "Gustavo A . R . Silva" <gustavoars@kernel.org>
Subject: Re: [PATCH] nfp: Replace zero-length array with flexible-array
 member
Message-ID: <20201204160122.3de3fd05@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
In-Reply-To: <20201204125601.24876-1-simon.horman@netronome.com>
References: <20201204125601.24876-1-simon.horman@netronome.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri,  4 Dec 2020 13:56:01 +0100 Simon Horman wrote:
> There is a regular need in the kernel to provide a way to declare having a
> dynamically sized set of trailing elements in a structure. Kernel code
> should always use "flexible array members"[1] for these cases. The older
> style of one-element or zero-length arrays should no longer be used[2].
> 
> [1] https://en.wikipedia.org/wiki/Flexible_array_member
> [2] https://www.kernel.org/doc/html/v5.9/process/deprecated.html#zero-length-and-one-element-arrays
> 
> Cc: Gustavo A. R. Silva <gustavoars@kernel.org>
> Signed-off-by: Simon Horman <simon.horman@netronome.com>
> Signed-off-by: Louis Peens <louis.peens@netronome.com>

Applied, thank you!
