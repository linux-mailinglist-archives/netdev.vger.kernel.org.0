Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E6D784FC0A
	for <lists+netdev@lfdr.de>; Sun, 23 Jun 2019 16:22:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726470AbfFWOVl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Jun 2019 10:21:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58774 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726414AbfFWOVk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 23 Jun 2019 10:21:40 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 8D791308AA11;
        Sun, 23 Jun 2019 14:21:40 +0000 (UTC)
Received: from carbon (ovpn-112-18.phx2.redhat.com [10.3.112.18])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0C5C5601A0;
        Sun, 23 Jun 2019 14:21:34 +0000 (UTC)
Date:   Sun, 23 Jun 2019 16:21:33 +0200
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     <sameehj@amazon.com>
Cc:     brouer@redhat.com, <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <dwmw@amazon.com>, "Machulsky, Zorik" <zorik@amazon.com>,
        <matua@amazon.com>, <saeedb@amazon.com>, <msw@amazon.com>,
        <aliguori@amazon.com>, <nafea@amazon.com>, <gtzalik@amazon.com>,
        <netanel@amazon.com>, <alisaidi@amazon.com>, <benh@amazon.com>,
        <akiyano@amazon.com>, Daniel Borkmann <borkmann@iogearbox.net>
Subject: Re: [RFC V1 net-next 1/1] net: ena: implement XDP drop support
Message-ID: <20190623162133.6b7f24e1@carbon>
In-Reply-To: <20190623070649.18447-2-sameehj@amazon.com>
References: <20190623070649.18447-1-sameehj@amazon.com>
        <20190623070649.18447-2-sameehj@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.41]); Sun, 23 Jun 2019 14:21:40 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 23 Jun 2019 10:06:49 +0300 <sameehj@amazon.com> wrote:

> This commit implements the basic functionality of drop/pass logic in the
> ena driver.

Usually we require a driver to implement all the XDP return codes,
before we accept it.  But as Daniel and I discussed with Zorik during
NetConf[1], we are going to make an exception and accept the driver
if you also implement XDP_TX.

As we trust that Zorik/Amazon will follow and implement XDP_REDIRECT
later, given he/you wants AF_XDP support which requires XDP_REDIRECT.

[1] http://vger.kernel.org/netconf2019.html
-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer
