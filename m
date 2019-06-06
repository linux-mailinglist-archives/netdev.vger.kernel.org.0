Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DCAD936BE4
	for <lists+netdev@lfdr.de>; Thu,  6 Jun 2019 07:51:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726581AbfFFFvr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jun 2019 01:51:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40840 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725766AbfFFFvr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 6 Jun 2019 01:51:47 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 75435308FEC4;
        Thu,  6 Jun 2019 05:51:47 +0000 (UTC)
Received: from elisabeth (ovpn-200-18.brq.redhat.com [10.40.200.18])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id C1CC53ACC;
        Thu,  6 Jun 2019 05:51:44 +0000 (UTC)
Date:   Thu, 6 Jun 2019 07:51:40 +0200
From:   Stefano Brivio <sbrivio@redhat.com>
To:     David Ahern <dsahern@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, idosch@mellanox.com,
        kafai@fb.com, weiwan@google.com, David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH net-next 17/19] selftests: pmtu: Add support for routing
 via nexthop objects
Message-ID: <20190606075140.7cc31bd8@elisabeth>
In-Reply-To: <20190605231523.18424-18-dsahern@kernel.org>
References: <20190605231523.18424-1-dsahern@kernel.org>
        <20190605231523.18424-18-dsahern@kernel.org>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.49]); Thu, 06 Jun 2019 05:51:47 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed,  5 Jun 2019 16:15:21 -0700
David Ahern <dsahern@kernel.org> wrote:

> From: David Ahern <dsahern@gmail.com>
> 
> Add routing setup using nexthop objects and repeat tests with
> old and new routing.
> 
> Signed-off-by: David Ahern <dsahern@gmail.com>

Reviewed-by: Stefano Brivio <sbrivio@redhat.com>
