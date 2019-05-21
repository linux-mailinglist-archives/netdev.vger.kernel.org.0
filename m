Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 14D3024541
	for <lists+netdev@lfdr.de>; Tue, 21 May 2019 02:55:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727257AbfEUAzP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 May 2019 20:55:15 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:60242 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726586AbfEUAzP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 May 2019 20:55:15 -0400
Received: from localhost (50-78-161-185-static.hfc.comcastbusiness.net [50.78.161.185])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 20E5F140F8462;
        Mon, 20 May 2019 17:55:14 -0700 (PDT)
Date:   Mon, 20 May 2019 20:55:13 -0400 (EDT)
Message-Id: <20190520.205513.1314405241609671077.davem@davemloft.net>
To:     weifeng.voon@intel.com
Cc:     mcoquelin.stm32@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, joabreu@synopsys.com,
        peppe.cavallaro@st.com, alexandre.torgue@st.com,
        boon.leong.ong@intel.com, tee.min.tan@intel.com
Subject: Re: [PATCH net] net: stmmac: fix ethtool flow control not able to
 get/set
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1558414542-28550-1-git-send-email-weifeng.voon@intel.com>
References: <1558414542-28550-1-git-send-email-weifeng.voon@intel.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-2022-jp
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 20 May 2019 17:55:14 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Weifeng Voon <weifeng.voon@intel.com>
Date: Tue, 21 May 2019 12:55:42 +0800

> From: "Tan, Tee Min" <tee.min.tan@intel.com>
> 
> Currently ethtool was not able to get/set the flow control due to a
> missing "!". It will always return -EOPNOTSUPP even the device is
> flow control supported.
> 
> This patch fixes the condition check for ethtool flow control get/set
> function for ETHTOOL_LINK_MODE_Asym_Pause_BIT.
> 
> Fixes: 3c1bcc8614db (“net: ethernet: Convert phydev advertize and supported from u32 to link mode”)
> Signed-off-by: Tan, Tee Min <tee.min.tan@intel.com>
> Reviewed-by: Ong Boon Leong <boon.leong.ong@intel.com>
> Signed-off-by: Voon, Weifeng <weifeng.voon@intel.com@intel.com>

Applied and queued up for -stable.
