Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 26C5864295E
	for <lists+netdev@lfdr.de>; Mon,  5 Dec 2022 14:27:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232255AbiLEN1v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Dec 2022 08:27:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231599AbiLEN1u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Dec 2022 08:27:50 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEA4C55A0
        for <netdev@vger.kernel.org>; Mon,  5 Dec 2022 05:27:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=2GffJDF1p4ZG5hhl7Fo2CMRBKqsxKuTMJz21zYeEt+8=; b=rcIwBKDocjSf7QnnikZQjqjfrR
        hEGk8fi19hgWcnD5Nt+4vCpuIyW7HqawYSqlqu1coGyXvyg276E6cByhYDeOoxapncIuEQOLoL5O9
        R4AbbQJXQmCuPwFvpBwQRyFWPya07QG9xRUQuqqZKnOq4B0Y89EGuuNX1P7WqIuVhv0c=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1p2BVP-004PJT-FI; Mon, 05 Dec 2022 14:27:35 +0100
Date:   Mon, 5 Dec 2022 14:27:35 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     qiyong@sosdg.org
Cc:     qiangqing.zhang@nxp.com, netdev@vger.kernel.org,
        yong.qi@i-soft.com.cn
Subject: Re: fec_restart fix
Message-ID: <Y43xx2GQrwILnAZV@lunn.ch>
References: <Y43FGyItmu/0Rxst@cinnabar.sosdg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y43FGyItmu/0Rxst@cinnabar.sosdg.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 05, 2022 at 06:16:59PM +0800, qiyong@sosdg.org wrote:
> fec_restart fix. fec would not recevie packets without this fix. Tested with s32v234.

Please read

https://docs.kernel.org/process/submitting-patches.html
and
https://www.kernel.org/doc/html/latest/process/maintainer-netdev.html?highlight=netdev+faq

There are a number of process things you need to do. Please add a
better description of the problem and how the change fixes is. Which
kernel version did the problem appear in? You need a Signed-off-by,
etc.

Thanks
	Andrew
