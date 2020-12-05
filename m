Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD09F2CFF4F
	for <lists+netdev@lfdr.de>; Sat,  5 Dec 2020 22:41:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726024AbgLEVk2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Dec 2020 16:40:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:42292 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725270AbgLEVk1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 5 Dec 2020 16:40:27 -0500
Date:   Sat, 5 Dec 2020 13:39:45 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607204387;
        bh=xKAfTsmFBrQGroYfV2jagCaxzsw23GnVJ6z7PU8y0G8=;
        h=From:To:Cc:Subject:In-Reply-To:References:From;
        b=LWzvxyDaFWqTfVG55e1ePv6txUJ1wQRinzOQebzBdfLCR2Fm1cqUVE+m93TH1yHEQ
         0i1Oom9MBWXfusS6rxjL0ewzydnT63mENcW1+hMMGiIqAm1syPYhRDnRFux17Gw4hC
         WdT5IvYAj8q399IjI2rnA+75r1IP2+QRgL9qGrYFGAeKn3MnSUiLj3c1RJE25os+ZI
         vp48vWHVMu2Cy//1zJX8lYS1Y067MKhVomHAEYcOfLW2OJGLBKRRwX5oATGhIE7EJg
         xp7nVHgBDQpvnVl02Iukr44JtKVIJ4q8EyWpTSWKuNEKue/1Nat5//3NyybOftDwzV
         Ehawmub/aLr2A==
From:   Jakub Kicinski <kuba@kernel.org>
To:     Joakim Zhang <qiangqing.zhang@nxp.com>
Cc:     peppe.cavallaro@st.com, alexandre.torgue@st.com,
        joabreu@synopsys.com, davem@davemloft.net, netdev@vger.kernel.org,
        linux-imx@nxp.com
Subject: Re: [PATCH V2 0/5] patches for stmmac
Message-ID: <20201205133945.3278723c@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
In-Reply-To: <20201204024638.31351-1-qiangqing.zhang@nxp.com>
References: <20201204024638.31351-1-qiangqing.zhang@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri,  4 Dec 2020 10:46:33 +0800 Joakim Zhang wrote:
> A patch set for stmmac, fix some driver issues.

These don't apply cleanly to the net tree where fixes go:

https://patchwork.kernel.org/project/netdevbpf/list/?delegate=netdev&param=1&order=date

Please rebase / retest / repost.
