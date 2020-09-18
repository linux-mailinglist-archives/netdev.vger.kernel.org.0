Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 805CD2707F8
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 23:15:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726368AbgIRVP5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Sep 2020 17:15:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726118AbgIRVP5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Sep 2020 17:15:57 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03AABC0613CE;
        Fri, 18 Sep 2020 14:15:57 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 931311595B401;
        Fri, 18 Sep 2020 13:59:09 -0700 (PDT)
Date:   Fri, 18 Sep 2020 14:15:56 -0700 (PDT)
Message-Id: <20200918.141556.1367737647918813478.davem@davemloft.net>
To:     hankinsea@gmail.com
Cc:     richardcochran@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] ptp: mark symbols static where possible
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200918061013.2034-1-hankinsea@gmail.com>
References: <20200918061013.2034-1-hankinsea@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Fri, 18 Sep 2020 13:59:09 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Herrington <hankinsea@gmail.com>
Date: Fri, 18 Sep 2020 14:10:13 +0800

> +void pch_ch_control_write(struct pci_dev *pdev, u32 val);
>  void pch_ch_control_write(struct pci_dev *pdev, u32 val)

Prototypes belong in a header file not in the C file where they
are defined.

If these functions are accessed in other foo.c files, they are
getting the prototype from some header file.

Otherwise they aren't, and the functions should be marked
static.
