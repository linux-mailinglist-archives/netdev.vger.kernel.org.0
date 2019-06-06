Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AB5CE36BE2
	for <lists+netdev@lfdr.de>; Thu,  6 Jun 2019 07:51:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726541AbfFFFve (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jun 2019 01:51:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44230 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725766AbfFFFve (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 6 Jun 2019 01:51:34 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 628AC85365;
        Thu,  6 Jun 2019 05:51:34 +0000 (UTC)
Received: from elisabeth (ovpn-200-18.brq.redhat.com [10.40.200.18])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id A7C3A620BB;
        Thu,  6 Jun 2019 05:51:31 +0000 (UTC)
Date:   Thu, 6 Jun 2019 07:51:27 +0200
From:   Stefano Brivio <sbrivio@redhat.com>
To:     David Ahern <dsahern@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, idosch@mellanox.com,
        kafai@fb.com, weiwan@google.com, David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH net-next 16/19] selftests: pmtu: Move route installs to
 a new function
Message-ID: <20190606075127.3d24c405@elisabeth>
In-Reply-To: <20190605231523.18424-17-dsahern@kernel.org>
References: <20190605231523.18424-1-dsahern@kernel.org>
        <20190605231523.18424-17-dsahern@kernel.org>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.25]); Thu, 06 Jun 2019 05:51:34 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed,  5 Jun 2019 16:15:20 -0700
David Ahern <dsahern@kernel.org> wrote:

> From: David Ahern <dsahern@gmail.com>
> 
> Move the route add commands to a new function called setup_routing_old.
> The '_old' refers to the classic way of installing routes.
> 
> Signed-off-by: David Ahern <dsahern@gmail.com>

Reviewed-by: Stefano Brivio <sbrivio@redhat.com>
