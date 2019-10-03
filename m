Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 92775CA157
	for <lists+netdev@lfdr.de>; Thu,  3 Oct 2019 17:49:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729528AbfJCPty (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Oct 2019 11:49:54 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:45196 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727024AbfJCPty (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Oct 2019 11:49:54 -0400
Received: from localhost (unknown [IPv6:2603:3023:50c:85e1:b5c5:ae11:3e54:6a07])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id C15121433FC57;
        Thu,  3 Oct 2019 08:49:53 -0700 (PDT)
Date:   Thu, 03 Oct 2019 11:49:52 -0400 (EDT)
Message-Id: <20191003.114952.2201613708507386478.davem@davemloft.net>
To:     johunt@akamai.com
Cc:     netdev@vger.kernel.org, edumazet@google.com, willemb@google.com,
        alexander.h.duyck@intel.com
Subject: Re: [PATCH net v2 1/2] udp: fix gso_segs calculations
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1570037363-12485-1-git-send-email-johunt@akamai.com>
References: <1570037363-12485-1-git-send-email-johunt@akamai.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 03 Oct 2019 08:49:54 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Josh Hunt <johunt@akamai.com>
Date: Wed,  2 Oct 2019 13:29:22 -0400

> Commit dfec0ee22c0a ("udp: Record gso_segs when supporting UDP segmentation offload")
> added gso_segs calculation, but incorrectly got sizeof() the pointer and
> not the underlying data type. In addition let's fix the v6 case.
> 
> Fixes: bec1f6f69736 ("udp: generate gso with UDP_SEGMENT")
> Fixes: dfec0ee22c0a ("udp: Record gso_segs when supporting UDP segmentation offload")
> Signed-off-by: Josh Hunt <johunt@akamai.com>
> Reviewed-by: Alexander Duyck <alexander.h.duyck@linux.intel.com>
> Acked-by: Willem de Bruijn <willemb@google.com>

Applied and queued up for -stable.
