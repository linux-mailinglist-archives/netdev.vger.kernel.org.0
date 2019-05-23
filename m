Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D182427396
	for <lists+netdev@lfdr.de>; Thu, 23 May 2019 02:56:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729616AbfEWAz7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 May 2019 20:55:59 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:37100 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727305AbfEWAz6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 May 2019 20:55:58 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d8])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 5DAC01457787E;
        Wed, 22 May 2019 17:55:58 -0700 (PDT)
Date:   Wed, 22 May 2019 17:55:57 -0700 (PDT)
Message-Id: <20190522.175557.501018548229100498.davem@davemloft.net>
To:     dsahern@kernel.org
Cc:     netdev@vger.kernel.org, sbrivio@redhat.com, dsahern@gmail.com
Subject: Re: [PATCH net-next] selftests: pmtu: Simplify cleanup and
 namespace names
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190522191106.15789-1-dsahern@kernel.org>
References: <20190522191106.15789-1-dsahern@kernel.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 22 May 2019 17:55:58 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Ahern <dsahern@kernel.org>
Date: Wed, 22 May 2019 12:11:06 -0700

> From: David Ahern <dsahern@gmail.com>
> 
> The point of the pause-on-fail argument is to leave the setup as is after
> a test fails to allow a user to debug why it failed. Move the cleanup
> after posting the result to the user to make it so.
> 
> Random names for the namespaces are not user friendly when trying to
> debug a failure. Make them simpler and more direct for the tests. Run
> cleanup at the beginning to ensure they are cleaned up if they already
> exist.
> 
> Remove cleanup_done. There is no harm in doing cleanup twice; just
> ignore any errors related to not existing - which is already done.
> 
> Signed-off-by: David Ahern <dsahern@gmail.com>

Applied.
