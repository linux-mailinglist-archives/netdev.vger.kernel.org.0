Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AD4E11877E6
	for <lists+netdev@lfdr.de>; Tue, 17 Mar 2020 03:48:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726674AbgCQCsi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Mar 2020 22:48:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:33744 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726343AbgCQCsi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Mar 2020 22:48:38 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B934820674;
        Tue, 17 Mar 2020 02:48:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584413318;
        bh=LjGzCtL8F0AHBMyvM8BisH9Phr1Ypv36LkUx8oYT6EA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=WTNbOoINd3l8J2d5FvKpQ6RXFgFatZ1I/Z/u1nYiIhv0OuD+sun5djLGryfV0XlEZ
         gkEtrwBlNfbQ+TQc+U/35ik8lOIHcZZmredBLgDpd/+ehK8PyWUc9Pn2lhlVNnHIMp
         ChLwO4058KvnQKh7J5kqgUrHyBFqpAqCwhaa9os8=
Date:   Mon, 16 Mar 2020 19:48:35 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Eric Dumazet <edumazet@google.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [PATCH v2 net-next 0/3] net_sched: allow use of hrtimer slack
Message-ID: <20200316194835.321ca9df@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200317021251.75190-1-edumazet@google.com>
References: <20200317021251.75190-1-edumazet@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 16 Mar 2020 19:12:48 -0700 Eric Dumazet wrote:
> Packet schedulers have used hrtimers with exact expiry times.
> 
> Some of them can afford having a slack, in order to reduce
> the number of timer interrupts and feed bigger batches
> to increase efficiency.
> 
> FQ for example does not care if throttled packets are
> sent with an additional (small) delay.
> 
> Original observation of having maybe too many interrupts
> was made by Willem de Bruijn.
> 
> v2: added strict netlink checking (Jakub Kicinski)

Thanks! I got nothing else to suggest :)
