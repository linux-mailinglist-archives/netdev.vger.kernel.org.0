Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81D7735EC81
	for <lists+netdev@lfdr.de>; Wed, 14 Apr 2021 07:51:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347626AbhDNFwK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Apr 2021 01:52:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:56218 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347576AbhDNFwG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 14 Apr 2021 01:52:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D63A6608FC;
        Wed, 14 Apr 2021 05:51:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618379505;
        bh=VHNEZKd5mSrU+q+QpM/cxwyQJ4+1svxalTBviaeRaBs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=B4BIMzMMduzMjtvzXY1t7ZDiinZBo3MLhw8LTz4EAFJmzNNYrNiZMOkABCROL0J4N
         j+xffx7JFH3tS88eU2cF05qpF8+1LPN49Iq2njY3OoPSK3fnUF4QdNsSZ+KYRnIV1H
         TNU76QIO2jW6ilBhYFiEzEBJ56auODMTmfLpvFAk=
Date:   Wed, 14 Apr 2021 07:51:43 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Nico Pache <npache@redhat.com>
Cc:     linux-kernel@vger.kernel.org, brendanhiggins@google.com,
        linux-ext4@vger.kernel.org, netdev@vger.kernel.org,
        rafael@kernel.org, linux-m68k@lists.linux-m68k.org,
        geert@linux-m68k.org
Subject: Re: [PATCH 1/2] kunit: Fix formatting of KUNIT tests to meet the
 standard
Message-ID: <YHaC74uSAJg/ZO7x@kroah.com>
References: <20210414043303.1072552-1-npache@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210414043303.1072552-1-npache@redhat.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 14, 2021 at 12:33:02AM -0400, Nico Pache wrote:
> There are few instances of KUNIT tests that are not properly defined.
> This commit focuses on correcting these issues to match the standard
> defined in the Documentation.
> 
>     Issues Fixed:
>  - Tests should default to KUNIT_ALL_TESTS
>  - Tests configs tristate should have `if !KUNIT_ALL_TESTS`
>  - Tests should end in KUNIT_TEST, some fixes have been applied to
>     correct issues were KUNIT_TESTS is used or KUNIT is not mentioned.

You are changing lots of different things all in one patch, please break
this up into "one config option change per patch" to make it easier to
review and get merged through the proper subsystem.

thanks,

greg k-h
