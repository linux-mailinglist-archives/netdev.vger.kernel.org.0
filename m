Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13BE620B5CC
	for <lists+netdev@lfdr.de>; Fri, 26 Jun 2020 18:21:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726509AbgFZQVm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jun 2020 12:21:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:39410 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725780AbgFZQVm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 26 Jun 2020 12:21:42 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0E83920791;
        Fri, 26 Jun 2020 16:21:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593188502;
        bh=2hL4QLUad9NYuzgKzPblxdfwObzUOA6DuaHqDN+Y+cA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=SRPID1z2qtys9fTWWm+FkDAoDUx40gWU+G+Se1cEfWSMCj2jiIHMzeKJCVqI/iLjm
         k1yJYMYXMhhXFupYs3OlAHa9oiDRVeNqtMYEF+fpOrVm0+UC1JSdBMJY6dffqMFBmt
         Er22liExBki4bXrt/ONjCRPIIVUwjwRicwYhis2A=
Date:   Fri, 26 Jun 2020 09:21:40 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Shannon Nelson <snelson@pensando.io>
Cc:     netdev@vger.kernel.org, davem@davemloft.net
Subject: Re: [PATCH v2 net] ionic: update the queue count on open
Message-ID: <20200626092140.0a7582af@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200626055837.3304-1-snelson@pensando.io>
References: <20200626055837.3304-1-snelson@pensando.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 25 Jun 2020 22:58:37 -0700 Shannon Nelson wrote:
> Let the network stack know the real number of queues that
> we are using.
> 
> v2: added error checking
> 
> Fixes: 49d3b493673a ("ionic: disable the queues on link down")
> Signed-off-by: Shannon Nelson <snelson@pensando.io>

Reviewed-by: Jakub Kicinski <kuba@kernel.org>
