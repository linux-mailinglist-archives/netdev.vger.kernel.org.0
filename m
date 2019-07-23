Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EBFB372141
	for <lists+netdev@lfdr.de>; Tue, 23 Jul 2019 23:06:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391948AbfGWVGs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jul 2019 17:06:48 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:36780 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729542AbfGWVGr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jul 2019 17:06:47 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id D3B69153BF123;
        Tue, 23 Jul 2019 14:06:46 -0700 (PDT)
Date:   Tue, 23 Jul 2019 14:06:46 -0700 (PDT)
Message-Id: <20190723.140646.505566792140054611.davem@davemloft.net>
To:     skunberg.kelsey@gmail.com
Cc:     iyappan@os.amperecomputing.com, keyur@os.amperecomputing.com,
        quan@os.amperecomputing.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bjorn@helgaas.com,
        skhan@linuxfoundation.org,
        linux-kernel-mentees@lists.linuxfoundation.org
Subject: Re: [PATCH v2] drivers: net: xgene: Remove acpi_has_method() calls
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190723185811.8548-1-skunberg.kelsey@gmail.com>
References: <20190722030401.69563-1-skunberg.kelsey@gmail.com>
        <20190723185811.8548-1-skunberg.kelsey@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 23 Jul 2019 14:06:47 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Kelsey Skunberg <skunberg.kelsey@gmail.com>
Date: Tue, 23 Jul 2019 12:58:11 -0600

> acpi_evaluate_object will already return an error if the needed method
> does not exist. Remove unnecessary acpi_has_method() calls and check the
> returned acpi_status for failure instead.
> 
> Signed-off-by: Kelsey Skunberg <skunberg.kelsey@gmail.com>
> ---
> Changes in v2:
> 	- Fixed white space warnings and errors

Applied to net-next.
