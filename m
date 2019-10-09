Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 438CFD0ABF
	for <lists+netdev@lfdr.de>; Wed,  9 Oct 2019 11:15:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729784AbfJIJPP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Oct 2019 05:15:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48044 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725989AbfJIJPP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 9 Oct 2019 05:15:15 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 15E6B308C1E6;
        Wed,  9 Oct 2019 09:15:15 +0000 (UTC)
Received: from localhost (ovpn-204-237.brq.redhat.com [10.40.204.237])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 4CFC81017E3C;
        Wed,  9 Oct 2019 09:15:13 +0000 (UTC)
Date:   Wed, 9 Oct 2019 11:15:11 +0200
From:   Jiri Benc <jbenc@redhat.com>
To:     Simon Horman <simon.horman@netronome.com>
Cc:     Xin Long <lucien.xin@gmail.com>,
        network dev <netdev@vger.kernel.org>, davem@davemloft.net,
        Thomas Graf <tgraf@suug.ch>, u9012063@gmail.com
Subject: Re: [PATCHv2 net-next 2/6] lwtunnel: add LWTUNNEL_IP_OPTS support
 for lwtunnel_ip
Message-ID: <20191009111511.0e173396@redhat.com>
In-Reply-To: <20191009075526.fcx5wqmotzq5j5bj@netronome.com>
References: <cover.1570547676.git.lucien.xin@gmail.com>
        <f73e560fafd61494146ff8f08bebead4b7ac6782.1570547676.git.lucien.xin@gmail.com>
        <20191009075526.fcx5wqmotzq5j5bj@netronome.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.48]); Wed, 09 Oct 2019 09:15:15 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 9 Oct 2019 09:55:27 +0200, Simon Horman wrote:
> This is the same concerned that was raised by others when I posed a patch
> to allow setting of Geneve options in a similar manner. I think what is
> called for here, as was the case in the Geneve work, is to expose netlink
> attributes for each option that may be set and have the kernel form
> these into the internal format (which appears to also be the wire format).

I agree with Simon.

Thanks,

 Jiri
