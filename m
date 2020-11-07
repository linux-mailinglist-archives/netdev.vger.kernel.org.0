Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA0D22AA7E2
	for <lists+netdev@lfdr.de>; Sat,  7 Nov 2020 21:20:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728669AbgKGUUf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Nov 2020 15:20:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:52498 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725836AbgKGUUf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 7 Nov 2020 15:20:35 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 22CF420885;
        Sat,  7 Nov 2020 20:20:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604780435;
        bh=vOyP3KUR834aETkN9bxWCDTxVQzO1OujYPpYSapMXF0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=sBo8msQcUxlRETRwa92h33b0ovMq172zDMenfb7GM6+kLhOwnoJ9C8IQK9Idp3bBp
         PKL+2/xtNrlq1oZ8ovI5KlQWeMq5ceQzjK/CCBxiHRl/mB6hOCZMMHMHnByYoTbkcG
         HtzQDSkHJaLT42zHBPR9VBwt3EHQ92vVC2mAQJ24=
Date:   Sat, 7 Nov 2020 12:20:34 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     menglong8.dong@gmail.com
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, dingtianhong@huawei.com,
        Menglong Dong <dong.menglong@zte.com.cn>
Subject: Re: [PATCH v2] net: macvlan: remove redundant initialization in
 macvlan_dev_netpoll_setup
Message-ID: <20201107122034.55d527a7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1604541244-3241-1-git-send-email-dong.menglong@zte.com.cn>
References: <1604541244-3241-1-git-send-email-dong.menglong@zte.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed,  4 Nov 2020 20:54:04 -0500 menglong8.dong@gmail.com wrote:
> From: Menglong Dong <dong.menglong@zte.com.cn>
> 
> The initialization for err with 0 seems useless, as it is soon updated
> with -ENOMEM. So, we can remove it.
> 
> Changes since v1:
> -Keep -ENOMEM still.
> 
> Signed-off-by: Menglong Dong <dong.menglong@zte.com.cn>

Applied.
