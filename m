Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CE35221981
	for <lists+netdev@lfdr.de>; Thu, 16 Jul 2020 03:30:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727940AbgGPBad (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jul 2020 21:30:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:47428 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726785AbgGPBad (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Jul 2020 21:30:33 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B393820775;
        Thu, 16 Jul 2020 01:30:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594863033;
        bh=w+5YDpmBV5hsDA41hu/bxWekpuOh9C51n3tOoSOHeAQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Dl9vftBLxwkwkeMdyy2KGb0sqw6oRViawwqSAfR0Tlxnd8piIkXLzJN7yOG29IIs0
         uoNQVHetCxkhkOdxzw57RdSs+kDRsTBk4esMxVi37WoQuSYpOYZ9TVE1F84DBm99vC
         dIkwlpUDvfKGwgkMTF4JxlzDA/tqwf/KAagVWmAQ=
Date:   Wed, 15 Jul 2020 18:30:31 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     George Kennedy <george.kennedy@oracle.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        dan.carpenter@oracle.com, dhaval.giani@oracle.com
Subject: Re: [PATCH v2 1/1] ax88172a: fix ax88172a_unbind() failures
Message-ID: <20200715183031.78c184ef@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1594821571-17833-1-git-send-email-george.kennedy@oracle.com>
References: <1594821571-17833-1-git-send-email-george.kennedy@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 15 Jul 2020 09:59:31 -0400 George Kennedy wrote:
> If ax88172a_unbind() fails, make sure that the return code is
> less than zero so that cleanup is done properly and avoid UAF.
> 
> Signed-off-by: George Kennedy <george.kennedy@oracle.com>
> Reported-by: syzbot+4cd84f527bf4a10fc9c1@syzkaller.appspotmail.com

Fixes: a9a51bd727d1 ("ax88172a: fix information leak on short answers")

Applied, thanks!
