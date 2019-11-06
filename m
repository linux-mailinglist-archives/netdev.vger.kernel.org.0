Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8468BF1E36
	for <lists+netdev@lfdr.de>; Wed,  6 Nov 2019 20:05:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729036AbfKFTFe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Nov 2019 14:05:34 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:53536 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727463AbfKFTFe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Nov 2019 14:05:34 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 29CFC14B79F89;
        Wed,  6 Nov 2019 11:05:34 -0800 (PST)
Date:   Wed, 06 Nov 2019 11:05:31 -0800 (PST)
Message-Id: <20191106.110531.121174417334607448.davem@davemloft.net>
To:     opendmb@gmail.com
Cc:     f.fainelli@gmail.com, bcm-kernel-feedback-list@broadcom.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net 0/3] net: bcmgenet: restore internal EPHY support
 (part 2)
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1572980846-37707-1-git-send-email-opendmb@gmail.com>
References: <1572980846-37707-1-git-send-email-opendmb@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 06 Nov 2019 11:05:34 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Doug Berger <opendmb@gmail.com>
Date: Tue,  5 Nov 2019 11:07:23 -0800

> This is a follow up to my previous submission (see [1]).

Series applied.
