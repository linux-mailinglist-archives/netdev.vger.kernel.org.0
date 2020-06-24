Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED5CC20693F
	for <lists+netdev@lfdr.de>; Wed, 24 Jun 2020 02:59:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388048AbgFXA7Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jun 2020 20:59:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:55798 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387586AbgFXA7P (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Jun 2020 20:59:15 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0FA7F20C09;
        Wed, 24 Jun 2020 00:59:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592960355;
        bh=8AAf63aM4s8ptvsojXKZliXh/4PS+PdUWJr5y2riHqc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=VQ5hr88ry2zJPDCTK+Y1WklN23YhEA0ZtoD7dUkAUH9oui8lYKoQjkaU1u9zvxedX
         Avg+nKMjWxYUgzCmcPGRt8NHqK+3NHs5CrRO1AxVzSJtDX8BbbTKhDO1lSHumCFPT+
         UfdOapUK5GmrLjMVayIFSD/RsYfKbP+Rl7UiKfn4=
Date:   Tue, 23 Jun 2020 17:59:13 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Cc:     davem@davemloft.net,
        Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
        netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>,
        Andrew Bowers <andrewx.bowers@intel.com>
Subject: Re: [net-next v2 8/8] i40e: Remove scheduling while atomic
 possibility
Message-ID: <20200623175913.529619f0@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200624002252.942257-9-jeffrey.t.kirsher@intel.com>
References: <20200624002252.942257-1-jeffrey.t.kirsher@intel.com>
        <20200624002252.942257-9-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 23 Jun 2020 17:22:52 -0700 Jeff Kirsher wrote:
> From: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
> 
> In some occasions task held spinlock, 

Which spin lock?

> while being rescheduled due to mutex_lock. 

Which mutex?

> Moved function call outside of atomic context.

What function?

> Without this patch there is a race condition, which might result in
> scheduling while atomic.

What is the race condition?
