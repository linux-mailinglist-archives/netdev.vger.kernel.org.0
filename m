Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 908F0251D20
	for <lists+netdev@lfdr.de>; Tue, 25 Aug 2020 18:23:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726788AbgHYQXa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Aug 2020 12:23:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725805AbgHYQXN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Aug 2020 12:23:13 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A2C6C061574;
        Tue, 25 Aug 2020 09:23:13 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 97E661349BAC2;
        Tue, 25 Aug 2020 09:06:25 -0700 (PDT)
Date:   Tue, 25 Aug 2020 09:23:08 -0700 (PDT)
Message-Id: <20200825.092308.1226928074491426275.davem@davemloft.net>
To:     ahabdels@gmail.com
Cc:     kuba@kernel.org, corbet@lwn.net, netdev@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        andrea.mayer@uniroma2.it
Subject: Re: [net-next v5 2/2] seg6: Add documentation for
 seg6_inherit_inner_ipv4_dscp sysctl
From:   David Miller <davem@davemloft.net>
In-Reply-To: <ad5dfe4a-da8e-aed2-4a32-cd617ad795b2@gmail.com>
References: <20200825121844.1576-1-ahabdels@gmail.com>
        <20200825085127.50ba9c82@kicinski-fedora-PC1C0HJN>
        <ad5dfe4a-da8e-aed2-4a32-cd617ad795b2@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 25 Aug 2020 09:06:25 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ahmed Abdelsalam <ahabdels@gmail.com>
Date: Tue, 25 Aug 2020 18:01:01 +0200

> patch fixed and resent.

You must resubmit the entire patch series when you update any
patch in the series.

You should also provide a proper header "[PATCH 0/N]" posting
for your series which explains what the series does, how does
it do it, and why does it do it that way.

Thank you.
