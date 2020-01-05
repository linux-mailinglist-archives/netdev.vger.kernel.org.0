Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 13D09130A4E
	for <lists+netdev@lfdr.de>; Sun,  5 Jan 2020 23:47:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727194AbgAEWrr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Jan 2020 17:47:47 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:41558 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726851AbgAEWrr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Jan 2020 17:47:47 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id C020E155566CB;
        Sun,  5 Jan 2020 14:47:46 -0800 (PST)
Date:   Sun, 05 Jan 2020 14:47:46 -0800 (PST)
Message-Id: <20200105.144746.2055568145717937218.davem@davemloft.net>
To:     vikas.gupta@broadcom.com
Cc:     zajec5@gmail.com, sheetal.tigadoli@broadcom.com,
        netdev@vger.kernel.org, linux-mips@vger.kernel.org,
        linux-kernel@vger.kernel.org, sumit.garg@linaro.org,
        vasundhara-v.volam@broadcom.com, vikram.prakash@broadcom.com
Subject: Re: [PATCH INTERNAL v2] firmware: tee_bnxt: Fix multiple call to
 tee_client_close_context
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1578068404-26195-1-git-send-email-vikas.gupta@broadcom.com>
References: <1578068404-26195-1-git-send-email-vikas.gupta@broadcom.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 05 Jan 2020 14:47:47 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


What does "INTERNAL" mean in these patch Subject lines?
