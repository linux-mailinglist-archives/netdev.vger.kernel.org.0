Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D58F82E212D
	for <lists+netdev@lfdr.de>; Wed, 23 Dec 2020 21:15:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728460AbgLWUOT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Dec 2020 15:14:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:37842 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727671AbgLWUOS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 23 Dec 2020 15:14:18 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id EF28120855;
        Wed, 23 Dec 2020 20:13:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608754418;
        bh=NmMOvUWBdvpzHz6flSDNP3SPo2mWAoQkRWhFGYLkknE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=FJbjNyIGI6GCn6idQbqv6cXtRNw8zbbWOViGI9NTSZYMZ+8UmyqCnKTwN2940zBmH
         tdpORhxiO/TXmZResTaZS9PqHc77t/80jmK9Yx/yEX+ULO5ZLXu+/0LU4ibh/iHXAD
         PsRDMCBm7YKdB9nPmnWwOlQQQWPSc8z7Wj9RkkEyZFfT0Ol1UOQLHaFtLpV3U2eMvM
         M4wKU6AFWFjc0pa6Ft7oMkGqJP91raDdRItYAI3/m2Ylz3x4qpaBDP07oA8tF7rVGQ
         i+nwzByleCS7+E2pX4EeKIwdIPU2/9NwJuv1o7CjTAMva0RuhwPqssX5FTMaqRTLxS
         52HGS3YtOHiTg==
Date:   Wed, 23 Dec 2020 12:13:37 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Muhammad Husaini Zulkifli <muhammad.husaini.zulkifli@intel.com>
Cc:     davem@davemloft.net, peppe.cavallaro@st.com,
        alexandre.torgue@st.com, joabreu@synopsys.com,
        netdev@vger.kernel.org, noor.azura.ahmad.tarmizi@intel.com,
        weifeng.voon@intel.com
Subject: Re: [PATCH net-next v1] stmmac: intel: Add PCI IDs for TGL-H
 platform
Message-ID: <20201223121337.58b0c276@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201222160337.30870-1-muhammad.husaini.zulkifli@intel.com>
References: <20201222160337.30870-1-muhammad.husaini.zulkifli@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 23 Dec 2020 00:03:37 +0800 Muhammad Husaini Zulkifli wrote:
> From: Noor Azura Ahmad Tarmizi <noor.azura.ahmad.tarmizi@intel.com>
> 
> Add TGL-H PCI info and PCI IDs for the new TSN Controller to the list
> of supported devices.
> 
> Signed-off-by: Noor Azura Ahmad Tarmizi <noor.azura.ahmad.tarmizi@intel.com>
> Signed-off-by: Voon Weifeng <weifeng.voon@intel.com>
> Signed-off-by: Muhammad Husaini Zulkifli <muhammad.husaini.zulkifli@intel.com>

Applied, thanks. Are these needed in the 5.10 LTS branch?
