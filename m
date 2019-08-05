Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 727FE825F5
	for <lists+netdev@lfdr.de>; Mon,  5 Aug 2019 22:19:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730663AbfHEUTE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Aug 2019 16:19:04 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:33658 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727460AbfHEUTD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Aug 2019 16:19:03 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id C80BD154316F3;
        Mon,  5 Aug 2019 13:19:02 -0700 (PDT)
Date:   Mon, 05 Aug 2019 13:19:02 -0700 (PDT)
Message-Id: <20190805.131902.224245258223919215.davem@davemloft.net>
To:     csully@google.com
Cc:     netdev@vger.kernel.org, sagis@google.com
Subject: Re: [PATCH net] gve: Fix case where desc_cnt and data_cnt can get
 out of sync
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190801230731.142536-1-csully@google.com>
References: <20190801230731.142536-1-csully@google.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 05 Aug 2019 13:19:02 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Catherine Sullivan <csully@google.com>
Date: Thu,  1 Aug 2019 16:07:31 -0700

> desc_cnt and data_cnt should always be equal. In the case of a dropped
> packet desc_cnt was still getting updated (correctly), data_cnt
> was not. To eliminate this bug and prevent it from recurring this
> patch combines them into one ring level cnt.
> 
> Signed-off-by: Catherine Sullivan <csully@google.com>
> Reviewed-by: Sagi Shahar <sagis@google.com>

Applied.
