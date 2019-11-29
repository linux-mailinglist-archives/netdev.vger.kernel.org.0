Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 60C3910D1B6
	for <lists+netdev@lfdr.de>; Fri, 29 Nov 2019 08:09:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726741AbfK2HJf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Nov 2019 02:09:35 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:53758 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726360AbfK2HJe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Nov 2019 02:09:34 -0500
Received: from localhost (c-73-35-209-67.hsd1.wa.comcast.net [73.35.209.67])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 7B14E146CFEDC;
        Thu, 28 Nov 2019 23:09:34 -0800 (PST)
Date:   Thu, 28 Nov 2019 23:09:33 -0800 (PST)
Message-Id: <20191128.230933.1076539903838048166.davem@davemloft.net>
To:     tung.q.nguyen@dektech.com.au
Cc:     netdev@vger.kernel.org, tipc-discussion@lists.sourceforge.net
Subject: Re: [tipc-discussion] [net v1 0/4] Fix some bugs at socket layer
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191128031008.2045-1-tung.q.nguyen@dektech.com.au>
References: <20191128031008.2045-1-tung.q.nguyen@dektech.com.au>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 28 Nov 2019 23:09:34 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tung Nguyen <tung.q.nguyen@dektech.com.au>
Date: Thu, 28 Nov 2019 10:10:04 +0700

> This series fixes some bugs at socket layer.

Series applied, thanks.
