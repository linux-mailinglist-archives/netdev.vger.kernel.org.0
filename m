Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F7F7281EFC
	for <lists+netdev@lfdr.de>; Sat,  3 Oct 2020 01:17:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725747AbgJBXRp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Oct 2020 19:17:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:58708 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725379AbgJBXRp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 2 Oct 2020 19:17:45 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9CABF206FA;
        Fri,  2 Oct 2020 23:17:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601680664;
        bh=02LX712tC3DtsWH9a3lMs8HzUH//EGxhN/uE4xunPUU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=kDsfuMT0QuHjjF5rngDpNzkKCiYzckqdZhbWkgqFxvN62dk+pQXQ/2XaxOLM1Vgcf
         C1/efCFl+uuN3TU2ojP2CcC5yXWDgOH2Ovq6N75bW/QPFMdaYFPSERc8yPlz6WMkf6
         zEedrQIbc3XCE3EvrypCtQfCRC5FNfjKL+mPk5mo=
Date:   Fri, 2 Oct 2020 19:17:43 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Vishnu Rangayyan <vishnu.rangayyan@apple.com>
Cc:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        Sebastien Boeuf <sebastien.boeuf@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Andrew Forgue <andrewf@apple.com>
Subject: Re: vsock fix backport to 5.4 stable
Message-ID: <20201002231743.GI2415204@sasha-vm>
References: <0c41f301-bedf-50be-d233-25d0d98b64ca@apple.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <0c41f301-bedf-50be-d233-25d0d98b64ca@apple.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 30, 2020 at 10:55:37AM -0700, Vishnu Rangayyan wrote:
>Hi,
>
>Can we have this backport applied to 5.4 stable, its a useful fix.
>
>commit df12eb6d6cd920ab2f0e0a43cd6e1c23a05cea91 upstream
>
>The call has a minor api change in 5.4 vs higher, only the pkt arg is 
>required.

Queued up. I took the dependencies instead.

-- 
Thanks,
Sasha
