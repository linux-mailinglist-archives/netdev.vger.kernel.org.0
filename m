Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0FEA514AE92
	for <lists+netdev@lfdr.de>; Tue, 28 Jan 2020 05:05:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726569AbgA1EFC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jan 2020 23:05:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:56872 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726191AbgA1EFC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Jan 2020 23:05:02 -0500
Received: from cakuba (c-73-93-4-247.hsd1.ca.comcast.net [73.93.4.247])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 655712173E;
        Tue, 28 Jan 2020 04:05:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580184301;
        bh=o0poSFVGQgF/vW625GidFp6x9nUefcoPZOEy5TNYTv0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=bEbL1EtysCByn8CysVYhGePuVfyVz8FfZAciZczVPUYzaWoHRK5N7z4XpT97okxzf
         P2ThIO3oweKhKMBI4VyjPNdg+czv3iPX0Vvbe5fGdaJTNdKAN4sqwGNefMsoQ4W+70
         4mCDzsJ7d8Nb8Og/1MgQpgUastKHS6bz3F9nzqGA=
Date:   Mon, 27 Jan 2020 20:05:00 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Taehee Yoo <ap420073@gmail.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: Re: [PATCH net v2 4/6] netdevsim: use IS_ERR instead of
 IS_ERR_OR_NULL for debugfs
Message-ID: <20200127200500.09df903c@cakuba>
In-Reply-To: <20200127143044.1468-1-ap420073@gmail.com>
References: <20200127143044.1468-1-ap420073@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 27 Jan 2020 14:30:44 +0000, Taehee Yoo wrote:
> Debugfs APIs return valid pointer or error pointer. it doesn't return NULL.
> So, using IS_ERR is enough, not using IS_ERR_OR_NULL.
> 
> Reported-by: kbuild test robot <lkp@intel.com>
> Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
> Signed-off-by: Taehee Yoo <ap420073@gmail.com>

Reviewed-by: Jakub Kicinski <kuba@kernel.org>
