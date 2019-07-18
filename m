Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E77CC6D74A
	for <lists+netdev@lfdr.de>; Fri, 19 Jul 2019 01:32:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726147AbfGRXcK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jul 2019 19:32:10 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:57218 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725992AbfGRXcK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Jul 2019 19:32:10 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 8A45A1528C8C4;
        Thu, 18 Jul 2019 16:32:09 -0700 (PDT)
Date:   Thu, 18 Jul 2019 16:32:07 -0700 (PDT)
Message-Id: <20190718.163207.289099133864098969.davem@davemloft.net>
To:     chuhongyuan@outlook.com
Cc:     csully@google.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] gve: replace kfree with kvfree
From:   David Miller <davem@davemloft.net>
In-Reply-To: <MWHPR11MB1757F23147F85B59BCF1628BAFC90@MWHPR11MB1757.namprd11.prod.outlook.com>
References: <MWHPR11MB1757F23147F85B59BCF1628BAFC90@MWHPR11MB1757.namprd11.prod.outlook.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 18 Jul 2019 16:32:09 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Chuhong YUAN <chuhongyuan@outlook.com>
Date: Wed, 17 Jul 2019 00:59:02 +0000

> Variables allocated by kvzalloc should not be freed by kfree.
> Because they may be allocated by vmalloc.
> So we replace kfree with kvfree here.
> 
> Signed-off-by: Chuhong Yuan <chuhongyuan@outlook.com>

Applied, thanks Chuhong.

GVE maintainers, you are upstream now and have to stay on top of review
of changes like this.  Otherwise I'll just review it myself and apply
it unless I find problems, and that may not be what you want :)
