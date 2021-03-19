Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5EFA5342593
	for <lists+netdev@lfdr.de>; Fri, 19 Mar 2021 20:00:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230219AbhCSTAC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Mar 2021 15:00:02 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:38876 "EHLO
        mail.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230186AbhCSS7m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Mar 2021 14:59:42 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        by mail.monkeyblade.net (Postfix) with ESMTPSA id 24712500A24B0;
        Fri, 19 Mar 2021 11:59:41 -0700 (PDT)
Date:   Fri, 19 Mar 2021 11:59:30 -0700 (PDT)
Message-Id: <20210319.115930.1974833421358920941.davem@davemloft.net>
To:     stephen@networkplumber.org
Cc:     netdev@vger.kernel.org
Subject: Re: [Bug 212353] New: Requesting IP_RECVTTL via setsockopt returns
 IP_TTL via recvmsg()'s cmsghdr
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20210319115035.11272a9c@hermes.local>
References: <20210319115035.11272a9c@hermes.local>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.6.2 (mail.monkeyblade.net [0.0.0.0]); Fri, 19 Mar 2021 11:59:41 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Although IP_RECVTTL is the socket option used to control the reporting, the value is reported using IP_TTL.

This is intentional, and correct.
