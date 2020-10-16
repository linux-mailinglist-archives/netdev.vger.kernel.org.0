Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0DA5290D2B
	for <lists+netdev@lfdr.de>; Fri, 16 Oct 2020 23:18:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2411127AbgJPVSf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Oct 2020 17:18:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:47714 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2411094AbgJPVSf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 16 Oct 2020 17:18:35 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 718DF214DB;
        Fri, 16 Oct 2020 21:18:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602883114;
        bh=XcsU3KYYUEf3RHfIF6F28LVWZtTJo4TThgBxMY/B+Yc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=c+1ZF5UckhzqDbNo9ThnCP0/jdzG24klZ5VLmSaMjPysdNUH2NaT3ipqCRN8ZtZYo
         C+gCnJOBtpKj8L3PnnfRk3nXBOqZWTK7zUPicltVlEjEz2DFANSXpsiPxKF+xmdbs+
         W7UZCkLae2GGu6MasK53egvXVEd+GkwV1X7kwiNY=
Date:   Fri, 16 Oct 2020 14:18:32 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Hoang Huu Le <hoang.h.le@dektech.com.au>
Cc:     jmaloy@redhat.com, ying.xue@windriver.com, netdev@vger.kernel.org
Subject: Re: [net 1/2] tipc: re-configure queue limit for broadcast link
Message-ID: <20201016141832.6d574ddf@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201016023119.5833-1-hoang.h.le@dektech.com.au>
References: <20201016023119.5833-1-hoang.h.le@dektech.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 16 Oct 2020 09:31:18 +0700 Hoang Huu Le wrote:
> The queue limit of the broadcast link is being calculated base on initial
> MTU. However, when MTU value changed (e.g manual changing MTU on NIC
> device, MTU negotiation etc.,) we do not re-calculate queue limit.
> This gives throughput does not reflect with the change.
> 
> So fix it by calling the function to re-calculate queue limit of the
> broadcast link.
> 
> Acked-by: Jon Maloy <jmaloy@redhat.com>
> Signed-off-by: Hoang Huu Le <hoang.h.le@dektech.com.au>

Applied both, thanks!
