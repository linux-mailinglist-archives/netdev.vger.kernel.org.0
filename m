Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 448A83CAD6A
	for <lists+netdev@lfdr.de>; Thu, 15 Jul 2021 21:58:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245156AbhGOUBB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Jul 2021 16:01:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:47712 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343870AbhGOT7U (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 15 Jul 2021 15:59:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 79DA561380;
        Thu, 15 Jul 2021 19:56:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626378986;
        bh=T76yrCNjhnwaYdhbkQIAiI6f/v1YJoLSXj58lEgBURM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:From;
        b=Fea5hgn9GZvU4/M0TAsL4hU3+6HZQnCO4RAhvV1z7ZEAnF6fSKS+rwU2rlWv0fJao
         L9+QwaD85aBFp+YRi4AmT/4rOuCHwZr6oslSuA0Mh1Lu2BtOb8GiXGhDcnG7ijRjP3
         l9dhLjo2/NcYl8DQyqvgNf9VXq31VTg7VoGzc//r2/gyl609q0fEmoiNAqyC5ZZcN+
         a5XHAouOjKEigMSolXIDUHdEUgUAAyedSsGbRxBnPhgt0eAI0dGSeSEekssPy0uJyg
         SOTavBglKXEcXUHmPMUP96eJ4tl0CQIHre5x/S1Cv57sv1wMpPqGm1U50sgx3IU7fl
         651o2uVZtK2MQ==
Date:   Thu, 15 Jul 2021 14:56:25 -0500
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     "Billie Alsup (balsup)" <balsup@cisco.com>
Cc:     Paul Menzel <pmenzel@molgen.mpg.de>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Guohan Lu <lguohan@gmail.com>,
        "Madhava Reddy Siddareddygari (msiddare)" <msiddare@cisco.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Sergey Miroshnichenko <s.miroshnichenko@yadro.com>
Subject: Re: [RFC][PATCH] PCI: Reserve address space for powered-off devices
 behind PCIe bridges
Message-ID: <20210715195625.GA1992334@bjorn-Precision-5520>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0480940E-F7B9-4EE3-B666-5AD490788198@cisco.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 15, 2021 at 07:49:56PM +0000, Billie Alsup (balsup) wrote:
>     >On 7/15/21, 11:57 AM, "Bjorn Helgaas" <helgaas@kernel.org> wrote:
> 
>     >Since you've gone to that much trouble already, also note
>     >http://vger.kernel.org/majordomo-info.html and
>     >https://people.kernel.org/tglx/notes-about-netiquette 
> 
> My apologies. I was just cc'd on a thread and blindly responded.  
> I didn't realize my mistake until receiving bounce messages for the html formatted message.
> 
>     >BTW, the attribution in the email you quoted below got corrupted in
>     >such a way that it appears that I wrote the whole thing, instead of 
>     >what actually happened, which is that I wrote a half dozen lines of
>     >response to your email.  Linux uses old skool email conventions ;)
> 
> I will pay closer attention next time.  Again, my apologies.
> Outlook really is a bad client for these types of emails!

Can't speak to Outlook, but so is Gmail :(  Thanks for starting the
conversation!

Bjorn
