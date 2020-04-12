Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (unknown [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4C4A51A5FA4
	for <lists+netdev@lfdr.de>; Sun, 12 Apr 2020 20:00:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727451AbgDLSAG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Apr 2020 14:00:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.18]:39004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727442AbgDLSAF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Apr 2020 14:00:05 -0400
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F021C0A3BF1
        for <netdev@vger.kernel.org>; Sun, 12 Apr 2020 10:50:56 -0700 (PDT)
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (c-67-180-217-166.hsd1.ca.comcast.net [67.180.217.166])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 87AC520673;
        Sun, 12 Apr 2020 17:50:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586713855;
        bh=Im23iqLBF8sNNREMWlhXPLIGck7J0YBkLnEr2g6ptSQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=AN/wBGg7O8HpjNDfOXxf+cKt6sMasQm0j5/v5a9x0d24iqXm+naWV0hjZWXbKrjPz
         UXXI1g7frsxRmwhDIuE4sfEMNiz+71PXQZaZk33Cge/W+m+Qi79iRnJ5fvTZ4i9YLQ
         GPsXSPNxz6EgULZepDYTTB5dTQvBn+K7TQvYjOYg=
Date:   Sun, 12 Apr 2020 10:50:53 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Fernando Gont <fgont@si6networks.com>
Cc:     netdev@vger.kernel.org, David Miller <davem@davemloft.net>
Subject: Re: [PATCH net-next] Implement draft-ietf-6man-rfc4941bis
Message-ID: <20200412105053.42f5228b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200408104458.GA15473@archlinux-current.localdomain>
References: <20200408104458.GA15473@archlinux-current.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 8 Apr 2020 07:44:58 -0300 Fernando Gont wrote:
> Implement the upcoming rev of RFC4941 (IPv6 temporary addresses):
> https://tools.ietf.org/html/draft-ietf-6man-rfc4941bis-09
> 
> * Reduces the default Valid Lifetime to 2 days
>   This reduces stress on network elements, among other things
> 
> * Employs different IIDs for different prefixes
>   To avoid network activity correlation among addresses configured
>   for different prefixes
> 
> * Uses a simpler algorithm for IID generation
>   No need to store "history" anywhere
> 
> Signed-off-by: Fernando Gont <fgont@si6networks.com>

net-next is currently closed:

https://www.kernel.org/doc/html/latest/networking/netdev-FAQ.html#q-how-often-do-changes-from-these-trees-make-it-to-the-mainline-linus-tree
http://vger.kernel.org/~davem/net-next.html

You'll have to resend your change when it opens back up.

Thanks!
