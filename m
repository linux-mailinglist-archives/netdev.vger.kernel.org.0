Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4DCCA28AB9
	for <lists+netdev@lfdr.de>; Thu, 23 May 2019 21:58:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388921AbfEWTqH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 May 2019 15:46:07 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:51128 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387468AbfEWTOj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 May 2019 15:14:39 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d8])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 4A25913F619CD;
        Thu, 23 May 2019 12:14:38 -0700 (PDT)
Date:   Thu, 23 May 2019 12:14:35 -0700 (PDT)
Message-Id: <20190523.121435.1508515031987363334.davem@davemloft.net>
To:     jbaron@akamai.com
Cc:     edumazet@google.com, ycheng@google.com, ilubashe@akamai.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next 0/6] add TFO backup key
From:   David Miller <davem@davemloft.net>
In-Reply-To: <cover.1558557001.git.jbaron@akamai.com>
References: <cover.1558557001.git.jbaron@akamai.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 23 May 2019 12:14:38 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jason Baron <jbaron@akamai.com>
Date: Wed, 22 May 2019 16:39:32 -0400

> Christoph, Igor, and I have worked on an API that facilitates TFO key 
> rotation. This is a follow up to the series that Christoph previously
> posted, with an API that meets both of our use-cases. Here's a
> link to the previous work:
> https://patchwork.ozlabs.org/cover/1013753/

I have no objections.

Yuchung and Eric, please review.

And anyways there will be another spin of this to fix the typo in the documentation
patch #5.

Thanks.
