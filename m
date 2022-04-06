Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB0C54F5E94
	for <lists+netdev@lfdr.de>; Wed,  6 Apr 2022 15:04:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230322AbiDFM7E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Apr 2022 08:59:04 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:49788 "EHLO
        mail.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232873AbiDFM6E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Apr 2022 08:58:04 -0400
Received: from localhost (unknown [149.11.102.75])
        by mail.monkeyblade.net (Postfix) with ESMTPSA id 6CE43841AF19;
        Wed,  6 Apr 2022 05:56:01 -0700 (PDT)
Date:   Wed, 06 Apr 2022 05:55:55 -0700 (PDT)
Message-Id: <20220406.055555.249920175385792988.davem@davemloft.net>
To:     michael.chan@broadcom.com
Cc:     netdev@vger.kernel.org, kuba@kernel.org, gospo@broadcom.com,
        bpf@vger.kernel.org, john.fastabend@gmail.com, toke@redhat.com,
        lorenzo@kernel.org, ast@kernel.org, daniel@iogearbox.net,
        echaudro@redhat.com, pabeni@redhat.com
Subject: Re: [PATCH net-next v3 00/11] bnxt: Support XDP multi buffer
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1649213633-7662-1-git-send-email-michael.chan@broadcom.com>
References: <1649213633-7662-1-git-send-email-michael.chan@broadcom.com>
X-Mailer: Mew version 6.8 on Emacs 27.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.6.2 (mail.monkeyblade.net [0.0.0.0]); Wed, 06 Apr 2022 05:56:04 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Michael Chan <michael.chan@broadcom.com>
Date: Tue,  5 Apr 2022 22:53:42 -0400

> This series adds XDP multi buffer support, allowing MTU to go beyond
> the page size limit.
> 
> v3: Simplify page mode buffer size calculation
>     Check to make sure XDP program supports multipage packets
> v2: Fix uninitialized variable warnings in patch 1 and 10.

Not all the patches made it into patchwork,  please re-post.

Thank you.
