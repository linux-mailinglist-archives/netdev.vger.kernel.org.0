Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 56074CBAD3
	for <lists+netdev@lfdr.de>; Fri,  4 Oct 2019 14:52:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387835AbfJDMwE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Oct 2019 08:52:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58446 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387545AbfJDMwE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 4 Oct 2019 08:52:04 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 6D98F10C092D;
        Fri,  4 Oct 2019 12:52:04 +0000 (UTC)
Received: from carbon (ovpn-200-24.brq.redhat.com [10.40.200.24])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E15435D6A5;
        Fri,  4 Oct 2019 12:51:54 +0000 (UTC)
Date:   Fri, 4 Oct 2019 14:51:53 +0200
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     "Daniel T. Lee" <danieltimlee@gmail.com>
Cc:     Toke =?UTF-8?B?SMO4aWxhbmQtSsO4cmdlbnNlbg==?= <toke@redhat.com>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        brouer@redhat.com
Subject: Re: [v4 1/4] samples: pktgen: make variable consistent with option
Message-ID: <20191004145153.6192fb09@carbon>
In-Reply-To: <20191004013301.8686-1-danieltimlee@gmail.com>
References: <20191004013301.8686-1-danieltimlee@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.6.2 (mx1.redhat.com [10.5.110.66]); Fri, 04 Oct 2019 12:52:04 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On Fri,  4 Oct 2019 10:32:58 +0900 "Daniel T. Lee" <danieltimlee@gmail.com> wrote:

> [...]

A general comment, you forgot a cover letter for your patchset.

And also forgot the "PATCH" part of subj. but patchwork still found it:
https://patchwork.ozlabs.org/project/netdev/list/?series=134102&state=2a


-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer
