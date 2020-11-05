Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F7422A73EC
	for <lists+netdev@lfdr.de>; Thu,  5 Nov 2020 01:41:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730296AbgKEAlg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Nov 2020 19:41:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:50800 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729024AbgKEAlg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Nov 2020 19:41:36 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9C3772080D;
        Thu,  5 Nov 2020 00:41:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604536896;
        bh=dsiCjsRG+KfXz9bu/BUOhaBgXGuvZcCIvn2UmZQXN5M=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=NTE+zO4EsBAoVSXANmKKb569ZrmmiW3IG92V/eGgWmpyOFMHDQSdCJuJaLVrb9vtN
         8zNi6OcW5+zCfmK4hYHVoQ5F+nCFqiZFWVWJ7Um5JjWNF3jMOAaxVPZmEMfgddpW+W
         oABlW6EPtZ6Z33jsLKnWI/j9/K+j9+MNRTOf5Y8c=
Date:   Wed, 4 Nov 2020 16:41:34 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     DENG Qingfang <dqfext@gmail.com>
Cc:     netdev@vger.kernel.org, Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <landen.chao@mediatek.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?B?UmVuw6k=?= van Dorst <opensource@vdorst.com>,
        Chuanhong Guo <gch981213@gmail.com>
Subject: Re: [PATCH v3 net-next] net: dsa: mt7530: support setting MTU
Message-ID: <20201104164134.6cc8f817@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201103050618.11419-1-dqfext@gmail.com>
References: <20201103050618.11419-1-dqfext@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue,  3 Nov 2020 13:06:18 +0800 DENG Qingfang wrote:
> MT7530/7531 has a global RX packet length register, which can be used
> to set MTU.
> 
> Supported packet length values are 1522 (1518 if untagged), 1536,
> 1552, and multiple of 1024 (from 2048 to 15360).
> 
> Signed-off-by: DENG Qingfang <dqfext@gmail.com>

Applied, thank you!
