Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F64E1E85F7
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 19:57:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727956AbgE2R5C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 May 2020 13:57:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:47898 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726549AbgE2R5C (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 29 May 2020 13:57:02 -0400
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A21002073B;
        Fri, 29 May 2020 17:57:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590775021;
        bh=6hjkRiGoDWgBwj+tfVkMty4dGqtVTTKH+mMJl6ebRw4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=m2v7LLGjYpRyy5G0GGiUhTpUqTuBYmANXmFtGltlFyf/sGZ6dJl2z3K12bO9YXh/Y
         F42fVWSH1RRw8row7nrZTVBMpxVj024kB6i9rZ7yciQLVFsYrwCOLLxHm0D82iLEdm
         +tpQ2NhK8tDq7nSHbykz14A03QmSvq3mqAg4umzA=
Date:   Fri, 29 May 2020 10:57:00 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Toke =?UTF-8?B?SMO4aWxhbmQtSsO4cmdlbnNlbg==?= <toke@redhat.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        cake@lists.bufferbloat.net
Subject: Re: [PATCH net] sch_cake: Take advantage of skb->hash where
 appropriate
Message-ID: <20200529105700.73a2b017@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20200529124344.355785-1-toke@redhat.com>
References: <20200529124344.355785-1-toke@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 29 May 2020 14:43:44 +0200 Toke H=C3=B8iland-J=C3=B8rgensen wrote:
> +	 * enabled there's another check below after doing the conntrack lookup.
> +	  */

nit: alignment
