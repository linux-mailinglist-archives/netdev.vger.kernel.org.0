Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1EA0A2FFA9C
	for <lists+netdev@lfdr.de>; Fri, 22 Jan 2021 03:46:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726269AbhAVCph (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jan 2021 21:45:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:36796 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725984AbhAVCpg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 21 Jan 2021 21:45:36 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7DEC023136;
        Fri, 22 Jan 2021 02:44:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611283495;
        bh=1+iDcfqtBcTNqOY4A7bFO7VMboMrTkn8TFPvwa9LNEE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=SA8fy9RheamLDoE4GasVWMpSgWTKjlLSxWz5qQPJZvfQVzF/mcw3xgVlsbAKQ5TjB
         qJVPSU2l7NBE0vLLtu2XgkQ0OtuO7idXY3hNqKckXIHD/WnGFt3CN4pfUgZWSMms3R
         g9HKptB3ind+w7/oGEBs7rWc65veiDimkbTza4t/aKTcaTB/UQfDJjO3XLdWurO67J
         mWtRdGWd3F1rSiGCpvXMm8C5v8g358fb1Fie29wh9V3I9Qc8yEVPay+Cup1mo50b9D
         YVgGKTfaOcM84ahT7tCsOIkXCZJObw6Lom71EallPY9iSdHZOcQVOLwJ81WclPNSNs
         jCgmCfwEyU8qQ==
Date:   Thu, 21 Jan 2021 18:44:54 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Alexey Dobriyan <adobriyan@gmail.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, drt@linux.ibm.com,
        ljp@linux.ibm.com, sukadev@linux.ibm.com
Subject: Re: [PATCH v2 net-next] ibmvnic: workaround QT Creator/libCPlusPlus
 segfault
Message-ID: <20210121184454.0ef91be3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210121220739.GA1486367@localhost.localdomain>
References: <20210121220150.GA1485603@localhost.localdomain>
        <20210121220739.GA1486367@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 22 Jan 2021 01:07:39 +0300 Alexey Dobriyan wrote:
> My name is Alexey and I've tried to use IDE for kernel development.
> 
> QT Creator segfaults while parsing ibmvnic.c which is annoying as it
> will start parsing after restart only to crash again.
> 
> The workaround is to either exclude ibmvnic.c from list of project files
> or to apply dummy ifdef to hide the offending code.
> 
> https://bugzilla.redhat.com/show_bug.cgi?id=1886548
> 
> Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>

That's a bug in QT Creator and whatever parsing it does/uses.

Sorry we can't take this patch, there is no indication that the kernel
code is actually wrong here.
