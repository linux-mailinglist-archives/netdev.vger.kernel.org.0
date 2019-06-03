Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7412233A5C
	for <lists+netdev@lfdr.de>; Mon,  3 Jun 2019 23:56:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726241AbfFCV4s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jun 2019 17:56:48 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:35856 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726049AbfFCV4s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Jun 2019 17:56:48 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 3DD1C133E97B7;
        Mon,  3 Jun 2019 14:56:48 -0700 (PDT)
Date:   Mon, 03 Jun 2019 14:56:47 -0700 (PDT)
Message-Id: <20190603.145647.1088936261142438459.davem@davemloft.net>
To:     sdf@google.com
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH net-next] flow_dissector: remove unused
 FLOW_DISSECTOR_F_STOP_AT_L3 flag
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190531210506.55260-1-sdf@google.com>
References: <20190531210506.55260-1-sdf@google.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 03 Jun 2019 14:56:48 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Stanislav Fomichev <sdf@google.com>
Date: Fri, 31 May 2019 14:05:06 -0700

> This flag is not used by any caller, remove it.
> 
> Signed-off-by: Stanislav Fomichev <sdf@google.com>

Applied.
