Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 00066184E83
	for <lists+netdev@lfdr.de>; Fri, 13 Mar 2020 19:21:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726901AbgCMSVH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Mar 2020 14:21:07 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:43688 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726480AbgCMSVH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Mar 2020 14:21:07 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 97215159D15A0;
        Fri, 13 Mar 2020 11:21:06 -0700 (PDT)
Date:   Fri, 13 Mar 2020 11:21:05 -0700 (PDT)
Message-Id: <20200313.112105.352870193577036810.davem@davemloft.net>
To:     bay@hackerdom.ru
Cc:     sfr@canb.auug.org.au, netdev@vger.kernel.org,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: build warning after merge of the net-next tree
From:   David Miller <davem@davemloft.net>
In-Reply-To: <CAPomEdz6pVnD39iZHSEd3gwEhgP2g8B5vTvqBP7eEHEAvTvFMg@mail.gmail.com>
References: <20200313205415.021b7875@canb.auug.org.au>
        <CAPomEdz6pVnD39iZHSEd3gwEhgP2g8B5vTvqBP7eEHEAvTvFMg@mail.gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 13 Mar 2020 11:21:06 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Please submit this formally, inline and not as an attachment, to netdev.
Otherwise patchwork will not pick it up and it will thus not get tracked
properly.

Thank you.
