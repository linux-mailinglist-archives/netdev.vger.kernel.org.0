Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 14C9714A178
	for <lists+netdev@lfdr.de>; Mon, 27 Jan 2020 11:08:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727166AbgA0KIE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jan 2020 05:08:04 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:36958 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726179AbgA0KIE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jan 2020 05:08:04 -0500
Received: from localhost (unknown [213.175.37.12])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 3F720151283CB;
        Mon, 27 Jan 2020 02:08:02 -0800 (PST)
Date:   Mon, 27 Jan 2020 11:08:00 +0100 (CET)
Message-Id: <20200127.110800.881477223959301599.davem@davemloft.net>
To:     lorenzo@kernel.org
Cc:     netdev@vger.kernel.org, ilias.apalodimas@linaro.org,
        lorenzo.bianconi@redhat.com, brouer@redhat.com
Subject: Re: [PATCH net 0/2] XDP fixes for socionext driver
From:   David Miller <davem@davemloft.net>
In-Reply-To: <cover.1579952387.git.lorenzo@kernel.org>
References: <cover.1579952387.git.lorenzo@kernel.org>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 27 Jan 2020 02:08:03 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Lorenzo Bianconi <lorenzo@kernel.org>
Date: Sat, 25 Jan 2020 12:48:49 +0100

> Fix possible user-after-in XDP rx path
> Fix rx statistics accounting if no bpf program is attached

Series applied and queued up for -stable, thank you.
