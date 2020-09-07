Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 523A8260208
	for <lists+netdev@lfdr.de>; Mon,  7 Sep 2020 19:16:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729637AbgIGRQj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Sep 2020 13:16:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:41236 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729802AbgIGRQc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Sep 2020 13:16:32 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6089C206B8;
        Mon,  7 Sep 2020 17:16:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599498992;
        bh=OUtYkVCr75IRPJkWZfDwnPuYZJ7Rl3K+S5YcaVGkW/w=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=rkXeVFc7rXZgAS705njHmMKlcDtdVcVLkBru7UEn69l+4Vp/I0y1f6JE3QAuvxAed
         VM+80BVI6LeLY3TkslrI2v4cjhptCdRirZN1jAJMxhI2RcBqXoGYk5T8uiRuMSlbfO
         GnO8Jxo2hO2nfZf4510IIhSc4ouykTshKTqiTegc=
Date:   Mon, 7 Sep 2020 10:16:30 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Michael Chan <michael.chan@broadcom.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: Re: [PATCH net 0/2] bnxt_en: Two bug fixes.
Message-ID: <20200907101630.3fcdd829@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1599360937-26197-1-git-send-email-michael.chan@broadcom.com>
References: <1599360937-26197-1-git-send-email-michael.chan@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat,  5 Sep 2020 22:55:35 -0400 Michael Chan wrote:
> The first patch fixes AER recovery by reducing the time from several
> minutes to a more reasonable 20 - 30 seconds.  The second patch fixes
> a possible NULL pointer crash during firmware reset.
> 
> Please queue for -stable also.  Thanks.

Applied & queued.
