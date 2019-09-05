Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 37F4CA9F0E
	for <lists+netdev@lfdr.de>; Thu,  5 Sep 2019 12:00:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731829AbfIEKAT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Sep 2019 06:00:19 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:43964 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726115AbfIEKAT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Sep 2019 06:00:19 -0400
Received: from localhost (unknown [89.248.140.11])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 895F2153878D5;
        Thu,  5 Sep 2019 03:00:16 -0700 (PDT)
Date:   Thu, 05 Sep 2019 12:00:14 +0200 (CEST)
Message-Id: <20190905.120014.1777922408006333658.davem@davemloft.net>
To:     dsahern@kernel.org
Cc:     netdev@vger.kernel.org, sharpd@cumulusnetworks.com,
        dsahern@gmail.com
Subject: Re: [PATCH net 0/2] nexthops: Fix multipath notifications for IPv6
 and selftests
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190903222213.7029-1-dsahern@kernel.org>
References: <20190903222213.7029-1-dsahern@kernel.org>
X-Mailer: Mew version 6.8 on Emacs 26.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 05 Sep 2019 03:00:18 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Ahern <dsahern@kernel.org>
Date: Tue,  3 Sep 2019 15:22:11 -0700

> From: David Ahern <dsahern@gmail.com>
> 
> A couple of bug fixes noticed while testing Donald's patch.

Series applied.
