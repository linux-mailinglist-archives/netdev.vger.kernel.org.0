Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 43F4B83BE0
	for <lists+netdev@lfdr.de>; Tue,  6 Aug 2019 23:39:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728259AbfHFVie (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Aug 2019 17:38:34 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:50248 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726085AbfHFVid (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Aug 2019 17:38:33 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 693D31423AA7D;
        Tue,  6 Aug 2019 14:38:33 -0700 (PDT)
Date:   Tue, 06 Aug 2019 14:38:32 -0700 (PDT)
Message-Id: <20190806.143832.528331834164499899.davem@davemloft.net>
To:     pkusunyifeng@gmail.com
Cc:     netdev@vger.kernel.org, pshelar@ovn.org, gvrose8192@gmail.com
Subject: Re: [PATCH net-next v2] openvswitch: Print error when
 ovs_execute_actions() fails
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1564973771-22542-1-git-send-email-pkusunyifeng@gmail.com>
References: <1564973771-22542-1-git-send-email-pkusunyifeng@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 06 Aug 2019 14:38:33 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yifeng Sun <pkusunyifeng@gmail.com>
Date: Sun,  4 Aug 2019 19:56:11 -0700

> Currently in function ovs_dp_process_packet(), return values of
> ovs_execute_actions() are silently discarded. This patch prints out
> an debug message when error happens so as to provide helpful hints
> for debugging.
> ---
> v1->v2: Fixed according to Pravin's review.

Applied.
