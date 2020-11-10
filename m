Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9F7B2ACA2B
	for <lists+netdev@lfdr.de>; Tue, 10 Nov 2020 02:14:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731720AbgKJBOD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Nov 2020 20:14:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:57496 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731095AbgKJBOB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 9 Nov 2020 20:14:01 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 20DB120789;
        Tue, 10 Nov 2020 01:14:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604970840;
        bh=gJrO70BiOjIyEyYRFuf1WWNEeBH39jY02zyp8kmvhUM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Bl94jHj+GhIgcXWWFTDODKn5R80sTLcXczNEqTQlf/du9RiBosAjbMJroHnS1FSLV
         35JIj8RpeivPccavXD2ivVV/ZbCtzneB8lHB2z3ERQ2xmxEtxlWOPywIa+xWIAEixp
         PCPlIebSu596OxzsGXfXJcxgtuaPsD0T4A1GcUTE=
Date:   Mon, 9 Nov 2020 17:13:59 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     menglong8.dong@gmail.com
Cc:     davem@davemloft.net, kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Menglong Dong <dong.menglong@zte.com.cn>
Subject: Re: [PATCH] net: udp: remove redundant initialization in
 udp_dump_one
Message-ID: <20201109171359.3aed485c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1604644960-48378-2-git-send-email-dong.menglong@zte.com.cn>
References: <1604644960-48378-1-git-send-email-dong.menglong@zte.com.cn>
        <1604644960-48378-2-git-send-email-dong.menglong@zte.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri,  6 Nov 2020 01:42:38 -0500 menglong8.dong@gmail.com wrote:
> From: Menglong Dong <dong.menglong@zte.com.cn>
> 
> The initialization for 'err' with '-EINVAL' is redundant and
> can be removed, as it is updated soon and not used.
> 
> Signed-off-by: Menglong Dong <dong.menglong@zte.com.cn>

Applied, thanks.
