Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6A107E3F4D
	for <lists+netdev@lfdr.de>; Fri, 25 Oct 2019 00:22:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730877AbfJXWWQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Oct 2019 18:22:16 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:52660 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730365AbfJXWWQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Oct 2019 18:22:16 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 17B2A14B79ECA;
        Thu, 24 Oct 2019 15:22:16 -0700 (PDT)
Date:   Thu, 24 Oct 2019 15:22:15 -0700 (PDT)
Message-Id: <20191024.152215.1751400322512229208.davem@davemloft.net>
To:     madalin.bucur@nxp.com
Cc:     netdev@vger.kernel.org, roy.pledge@nxp.com,
        laurentiu.tudor@nxp.com, jakub.kicinski@netronome.com
Subject: Re: [PATCH net-next v3 0/7] DPAA Ethernet changes
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1571821726-6624-1-git-send-email-madalin.bucur@nxp.com>
References: <1571821726-6624-1-git-send-email-madalin.bucur@nxp.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 24 Oct 2019 15:22:16 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Madalin Bucur <madalin.bucur@nxp.com>
Date: Wed, 23 Oct 2019 12:08:39 +0300

> v3: add newline at the end of error messages
> v2: resending with From: field matching signed-off-by
> 
> Here's a series of changes for the DPAA Ethernet, addressing minor
> or unapparent issues in the codebase, adding probe ordering based on
> a recently added DPAA QMan API, removing some redundant code.

Series applied, thank you.
