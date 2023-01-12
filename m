Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7EDD9666CB4
	for <lists+netdev@lfdr.de>; Thu, 12 Jan 2023 09:44:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236370AbjALIn5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Jan 2023 03:43:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235699AbjALInX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Jan 2023 03:43:23 -0500
Received: from smtp-out-04.comm2000.it (smtp-out-04.comm2000.it [212.97.32.67])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E47CA1BEA8;
        Thu, 12 Jan 2023 00:41:07 -0800 (PST)
Received: from francesco-nb.int.toradex.com (93-49-2-63.ip317.fastwebnet.it [93.49.2.63])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: francesco@dolcini.it)
        by smtp-out-04.comm2000.it (Postfix) with ESMTPSA id 77D0FBC275A;
        Thu, 12 Jan 2023 09:40:51 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=mailserver.it;
        s=mailsrv; t=1673512865;
        bh=q7/QXGC8LvChtABBnwOd3fn/aSfDqv0+mtSb62EsXKM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To;
        b=gU9receeEdVH4ysN9OqHZD4NN3/bNv2mQcvbL4cJB3mQiJGgeSMbD+i/gRQW4VtE+
         1Jmab0g21Geg4Sxi2StPqDBb++JlquFM+rg/i+WvIellwedV0I5p/TTNaQoiuFJigt
         VBZKvSuq+nXyiBfxsdeLtXPqAtaEkEYfOibAjOmuTeNsG/MqzcHsubOaC95G5I/rFV
         HcoEskcyKMVA4qSEn8evTf1IxT9guu4gcYIy+58wvdTOpQXeOBd2EiupJitYMsE0WF
         nO8LIkznyH9gXlWTVZ4CHNrLQ+ip94eSFSG3YuGsKVLUFy6WPha2ujFHXbhTAHYREg
         2fDC3yBBKr+oA==
Date:   Thu, 12 Jan 2023 09:40:47 +0100
From:   Francesco Dolcini <francesco@dolcini.it>
To:     Francesco Dolcini <francesco@dolcini.it>
Cc:     linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org,
        Zhengping Jiang <jiangzp@google.com>,
        Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Marcel Holtmann <marcel@holtmann.org>
Subject: Re: hdev->le_scan_disable - WARNING: possible circular locking
 dependency detected
Message-ID: <Y7/Hj7EXceqp54UU@francesco-nb.int.toradex.com>
References: <Y7SQcdg33X8xTPzs@francesco-nb.int.toradex.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y7SQcdg33X8xTPzs@francesco-nb.int.toradex.com>
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 03, 2023 at 09:31:24PM +0100, Francesco Dolcini wrote:
> Hello all,
> When enabling BT discovery I have this WARNING.
> 
> Linux 6.0.16, ARM, i.MX6ULL, with a Marvell BT device.

Linux 6.1.4 is fine.
I'm not planning to bisect it since I can just move to the new kernel.

> This looks like a regression on Linux 6.0, however I had no way to try
> to bisect this yet. Any suggestion?
> 
> [  493.824758] ======================================================
> [  493.831012] WARNING: possible circular locking dependency detected
> [  493.837261] 6.0.16-6.1.0-devel+git.29e1bc6a55de #1 Not tainted


Francesco

