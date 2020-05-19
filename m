Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C04151DA49C
	for <lists+netdev@lfdr.de>; Wed, 20 May 2020 00:34:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727989AbgESWeH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 May 2020 18:34:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726064AbgESWeH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 May 2020 18:34:07 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EEDFC061A0E
        for <netdev@vger.kernel.org>; Tue, 19 May 2020 15:34:07 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 14344128EC8C9;
        Tue, 19 May 2020 15:34:06 -0700 (PDT)
Date:   Tue, 19 May 2020 15:34:06 -0700 (PDT)
Message-Id: <20200519.153406.544013162115691784.davem@davemloft.net>
To:     vfedorenko@novek.ru
Cc:     kuznet@ms2.inr.ac.ru, kuba@kernel.org, netdev@vger.kernel.org
Subject: Re: [net-next 0/5] ip6_tunnel: add MPLS support
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1589834028-9929-1-git-send-email-vfedorenko@novek.ru>
References: <1589834028-9929-1-git-send-email-vfedorenko@novek.ru>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 19 May 2020 15:34:07 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vadim Fedorenko <vfedorenko@novek.ru>
Date: Mon, 18 May 2020 23:33:43 +0300

> The support for MPLS-in-IPv4 was added earlier. This patchset adds
> support for MPLS-in-IPv6.

This adds way too many ifdefs into the C code, please find another way
to abstract this such that you don't need to add ifdefs all over the
place.

Thank you.
