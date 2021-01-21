Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83D452FF7FF
	for <lists+netdev@lfdr.de>; Thu, 21 Jan 2021 23:33:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726182AbhAUWc5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jan 2021 17:32:57 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:53364 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726431AbhAUWcn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 21 Jan 2021 17:32:43 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1l2iUd-001utd-BJ; Thu, 21 Jan 2021 23:31:55 +0100
Date:   Thu, 21 Jan 2021 23:31:55 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Alexey Dobriyan <adobriyan@gmail.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, drt@linux.ibm.com,
        ljp@linux.ibm.com, sukadev@linux.ibm.com
Subject: Re: [PATCH net-next] ibmvnic: workaround QT Creator/libCPlusPlus
 segfault
Message-ID: <YAoA29y7zre2rKIT@lunn.ch>
References: <20210121220150.GA1485603@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210121220150.GA1485603@localhost.localdomain>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 22, 2021 at 01:01:50AM +0300, Alexey Dobriyan wrote:
> My name is Alexey and I've tried to use IDE for kernel development.
> 
> QT Creator segfaults while parsing ibmvnic.c which is annoying as it
> will start parsing after restart only to crash again.
> 
> The workaround is to either exclude ibmvnic.c from list of project files
> or to apply dummy ifdef to hide the offending code.
> 
> https://bugzilla.redhat.com/show_bug.cgi?id=1886548

Sorry, but this is not going to be accepted.

Can you narrow it down further. In bugzilla, you say the includes are
wrong. How exactly?

       Andrew
