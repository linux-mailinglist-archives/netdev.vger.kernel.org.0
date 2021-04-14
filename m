Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9036B35EC75
	for <lists+netdev@lfdr.de>; Wed, 14 Apr 2021 07:51:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345963AbhDNFvK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Apr 2021 01:51:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:55116 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231321AbhDNFvK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 14 Apr 2021 01:51:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A8DEF611C9;
        Wed, 14 Apr 2021 05:50:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618379448;
        bh=bJW6XiHgI7CexCM+0KjgcDdLA76bJUD9XAmxOqSXzsM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=KEcuBG3/cVH3l60Fks5Sisq+hkxTxqMqraRZFdoBKeQoiR0+UwwG1Em64SCv3+eJh
         GD9v7Ico7mrJxV9bqIo4F1uDRrawn47Mh488yDXL9fUoq1AZqGCSQIieMKOozJSBDG
         lDxXUUMHaf6oZsw7pCJSzpYmYnEpV3Ckeb4BFq1c=
Date:   Wed, 14 Apr 2021 07:50:45 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Nico Pache <npache@redhat.com>
Cc:     linux-kernel@vger.kernel.org, brendanhiggins@google.com,
        linux-ext4@vger.kernel.org, netdev@vger.kernel.org,
        rafael@kernel.org, linux-m68k@lists.linux-m68k.org,
        geert@linux-m68k.org
Subject: Re: [PATCH 1/2] kunit: Fix formatting of KUNIT tests to meet the
 standard
Message-ID: <YHaCtfn2UqKbhB3a@kroah.com>
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
> 
> No functional changes other than CONFIG name changes
> Signed-off-by: Nico Pache <npache@redhat.com>

Please put a blank line before your signed-off-by, as is required by the
tools :(

thanks,

greg k-h
