Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B52A31C2A7
	for <lists+netdev@lfdr.de>; Mon, 15 Feb 2021 20:52:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230000AbhBOTv4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Feb 2021 14:51:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:48460 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229866AbhBOTvz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Feb 2021 14:51:55 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E4F0760234;
        Mon, 15 Feb 2021 19:51:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1613418675;
        bh=+LdueIs8Q3kjUdsIWPW/XVdLy7MIH3G1Ht/JMuPuRkM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=o4BWq5FAnJntgWgE4K4TR/1ulaoX/TZaOA2xvvpumm6aFl55wa3oq8J03W48y+xUU
         doRvRG24M4T/M3G5CtDPNJiuIaqcm3ronbQabLLiwgmUmvAeX7vynzLW6z00OkeYMQ
         c4yj6EBMmbagxj5w5GZf7Pvoju6p75JU6ofHyx3s1JdoFJz7ZDiwPPAjlj9aoQjfkv
         dbVGV0BAgjwpVACpeKwTmOqkk6GVtskkfm2NF4Wq1fht1VoM0LffhKObT0yfVhVL+h
         rgvf8VETgDX+wOKlDo53OvZEXyRaB0lcezLsZR5bAn2z6UNbU6RFKIvF0EK+1zhwaH
         uiMuhw49BFqxQ==
Date:   Mon, 15 Feb 2021 11:51:14 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Ayush Sawal <ayush.sawal@chelsio.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, secdev@chelsio.com,
        varun@chelsio.com
Subject: Re: [PATCH net] cxgb4/chtls/cxgbit: Keeping the max ofld immediate
 data size same in cxgb4 and ulds
Message-ID: <20210215115114.1a16ad42@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210215114226.10003-1-ayush.sawal@chelsio.com>
References: <20210215114226.10003-1-ayush.sawal@chelsio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 15 Feb 2021 17:12:26 +0530 Ayush Sawal wrote:
> The Max imm data size in cxgb4 is not similar to the max imm data size
> in the chtls. This caused an mismatch in output of is_ofld_imm() of
> cxgb4 and chtls. So fixed this by keeping the max wreq size of imm data
> same in both chtls and cxgb4 as MAX_IMM_OFLD_TX_DATA_WR_LEN.
> 
> As cxgb4's max imm. data value for ofld packets is changed to
> MAX_IMM_OFLD_TX_DATA_WR_LEN. Using the same in cxgbit also.
> 
> Fixes: 36bedb3f2e5b8 ("crypto: chtls - Inline TLS record Tx")
> Signed-off-by: Ayush Sawal <ayush.sawal@chelsio.com>

Acked-by: Jakub Kicinski <kuba@kernel.org>
