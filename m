Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AC25AC23BE
	for <lists+netdev@lfdr.de>; Mon, 30 Sep 2019 16:57:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731902AbfI3O5J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Sep 2019 10:57:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37492 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730780AbfI3O5J (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 30 Sep 2019 10:57:09 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 09FCA8980E0;
        Mon, 30 Sep 2019 14:57:09 +0000 (UTC)
Received: from cera.brq.redhat.com (unknown [10.43.2.69])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DD5595C219;
        Mon, 30 Sep 2019 14:57:07 +0000 (UTC)
Date:   Mon, 30 Sep 2019 16:57:06 +0200
From:   Ivan Vecera <ivecera@redhat.com>
To:     Roopa Prabhu <roopa@cumulusnetworks.com>
Cc:     dsahern@gmail.com, netdev@vger.kernel.org,
        nikolay@cumulusnetworks.com, stephen@networkplumber.org
Subject: Re: [PATCH iproute2 net-next v2 0/2] support for bridge fdb and
 neigh get
Message-ID: <20190930165706.1650087c@cera.brq.redhat.com>
In-Reply-To: <1569702130-46433-1-git-send-email-roopa@cumulusnetworks.com>
References: <1569702130-46433-1-git-send-email-roopa@cumulusnetworks.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.6.2 (mx1.redhat.com [10.5.110.67]); Mon, 30 Sep 2019 14:57:09 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 28 Sep 2019 13:22:08 -0700
Roopa Prabhu <roopa@cumulusnetworks.com> wrote:

> From: Roopa Prabhu <roopa@cumulusnetworks.com>
> 
> This series adds iproute2 support to lookup a bridge fdb and
> neigh entry.
> example:
> $bridge fdb get 02:02:00:00:00:03 dev test-dummy0 vlan 1002
> 02:02:00:00:00:03 dev test-dummy0 vlan 1002 master bridge
> 
> $ip neigh get 10.0.2.4 dev test-dummy0
> 10.0.2.4 dev test-dummy0 lladdr de:ad:be:ef:13:37 PERMANENT
> 
> 
> v2 - remove cast around stdout in print_fdb as pointed out by stephen
> 
> 
> Roopa Prabhu (2):
>   bridge: fdb get support
>   ipneigh: neigh get support
> 
>  bridge/fdb.c            | 113 +++++++++++++++++++++++++++++++++++++++++++++++-
>  ip/ipneigh.c            |  72 ++++++++++++++++++++++++++++--
>  man/man8/bridge.8       |  35 +++++++++++++++
>  man/man8/ip-neighbour.8 |  25 +++++++++++
>  4 files changed, 240 insertions(+), 5 deletions(-)
> 

Works great. Thanks, Roopa.

Tested-by: Ivan Vecera <ivecera@redhat.com>
