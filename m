Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1A05816B5A3
	for <lists+netdev@lfdr.de>; Tue, 25 Feb 2020 00:33:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728294AbgBXXcz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Feb 2020 18:32:55 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:40112 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727976AbgBXXcy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Feb 2020 18:32:54 -0500
Received: from localhost (unknown [50.226.181.18])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 83DB0124CE3F0;
        Mon, 24 Feb 2020 15:32:54 -0800 (PST)
Date:   Mon, 24 Feb 2020 15:32:54 -0800 (PST)
Message-Id: <20200224.153254.1115312677901381309.davem@davemloft.net>
To:     jonathan.lemon@gmail.com
Cc:     netdev@vger.kernel.org, michael.chan@broadcom.com,
        kernel-team@fb.com, kuba@kernel.org
Subject: Re: [PATCH] bnxt_en: add newline to netdev_*() format strings
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200224232909.2311486-1-jonathan.lemon@gmail.com>
References: <20200224232909.2311486-1-jonathan.lemon@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 24 Feb 2020 15:32:54 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Jonathan, why did you post three copies of this same patch?
