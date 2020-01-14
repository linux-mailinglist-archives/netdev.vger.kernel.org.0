Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 77B75139F3E
	for <lists+netdev@lfdr.de>; Tue, 14 Jan 2020 02:59:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729410AbgANB7E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jan 2020 20:59:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:53104 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728838AbgANB7D (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 Jan 2020 20:59:03 -0500
Received: from cakuba (c-73-93-4-247.hsd1.ca.comcast.net [73.93.4.247])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C756B20CC7;
        Tue, 14 Jan 2020 01:59:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578967143;
        bh=gqYHHLS/aWfy+hfVzwouBr11jL7rn3btXpeGgfdzwBU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=XKdAydoo5i9u2EJ2sJ9j/Gz/tXAF+eKNeXDXfwS+U7g2OnV+hleqdEukz0cqs1H2y
         c+stNJDHj45dMT0hPSr9SNOWfdOzWknA2irAI/hOMfojdFiSuw6iMyBBJIcy/kyL82
         Xd0X9MSaNMYBiuo4fvLsmwTviBlTSbB54xVSiCsc=
Date:   Mon, 13 Jan 2020 17:59:00 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Niu Xilei <niu_xilei@163.com>
Cc:     davem@davemloft.net, tglx@linutronix.de, fw@strlen.de,
        peterz@infradead.org, steffen.klassert@secunet.com,
        bigeasy@linutronix.de, jonathan.lemon@gmail.com, pabeni@redhat.com,
        anshuman.khandual@arm.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [v3] pktgen: Allow configuration of IPv6 source address range
Message-ID: <20200113175900.05094fac@cakuba>
In-Reply-To: <20200114010122.5327-1-niu_xilei@163.com>
References: <20200114010122.5327-1-niu_xilei@163.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 14 Jan 2020 09:01:22 +0800, Niu Xilei wrote:
> Pktgen can use only one IPv6 source address from output device or src6
> command setting. In pressure test we need create lots of sessions more than
> 65535. So add src6_min and src6_max command to set the range.
> 
> Signed-off-by: Niu Xilei <niu_xilei@163.com>
> 
> Changes since v2:
>  - reword subject line

Seems you have missed the inline feedback on v2. There were two other
issues I raised within the quoted patch. Please take a look again.

> Changes since v1:
>  - only create IPv6 source address over least significant 64 bit range
