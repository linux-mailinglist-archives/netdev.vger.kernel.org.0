Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 850EC36BE1
	for <lists+netdev@lfdr.de>; Thu,  6 Jun 2019 07:51:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726519AbfFFFvU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jun 2019 01:51:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40772 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725784AbfFFFvU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 6 Jun 2019 01:51:20 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 8F82C308FEE2;
        Thu,  6 Jun 2019 05:51:20 +0000 (UTC)
Received: from elisabeth (ovpn-200-18.brq.redhat.com [10.40.200.18])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 1B1241059581;
        Thu,  6 Jun 2019 05:51:14 +0000 (UTC)
Date:   Thu, 6 Jun 2019 07:51:08 +0200
From:   Stefano Brivio <sbrivio@redhat.com>
To:     David Ahern <dsahern@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, idosch@mellanox.com,
        kafai@fb.com, weiwan@google.com, David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH net-next 15/19] selftests: pmtu: Move running of test
 into a new function
Message-ID: <20190606075108.42da0f6b@elisabeth>
In-Reply-To: <20190605231523.18424-16-dsahern@kernel.org>
References: <20190605231523.18424-1-dsahern@kernel.org>
        <20190605231523.18424-16-dsahern@kernel.org>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.49]); Thu, 06 Jun 2019 05:51:20 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed,  5 Jun 2019 16:15:19 -0700
David Ahern <dsahern@kernel.org> wrote:

> From: David Ahern <dsahern@gmail.com>
> 
> Move the block of code that runs a test and prints the verdict to a
> new function, run_test.
> 
> Signed-off-by: David Ahern <dsahern@gmail.com>

Reviewed-by: Stefano Brivio <sbrivio@redhat.com>
